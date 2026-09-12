#!/usr/bin/env bash
#
# sync-data-repo.sh — pulls the 5 published ScamEncyclopedia datasets from the live site,
# checks them for CSV header drift and JSON validity, regenerates data/manifest.json, and
# commits + pushes the result to the scamencyclopedia-data GitHub repo.
#
# Intended to run as a weekly Hetzner host cron, the day after the Monday regulator-data
# refresh on the live site (~19-minute deploy lag). Install with:
#
#   17 6 * * 2 root /root/gha-migrated/scamencyclopedia/sync-data-repo.sh >> /var/log/scamencyclopedia-data-sync.log 2>&1
#
# No secrets are read or stored by this script. It relies on the host's existing git
# credential helper (or GIT_ASKPASS) already being configured to authenticate pushes to
# GIT_REMOTE — set that up once, outside this script.
#
# Env vars (all optional, defaults shown):
#   GIT_REMOTE     https://github.com/bryanflowers/scamencyclopedia-data.git
#   DATA_REPO_DIR  /root/gha-migrated/scamencyclopedia-data
#   SITE           https://scamencyclopedia.org

set -euo pipefail

GIT_REMOTE="${GIT_REMOTE:-https://github.com/bryanflowers/scamencyclopedia-data.git}"
DATA_REPO_DIR="${DATA_REPO_DIR:-/root/gha-migrated/scamencyclopedia-data}"
SITE="${SITE:-https://scamencyclopedia.org}"

fail() {
  echo "SYNC FAILED: $1" >&2
  exit "${2:-1}"
}

# --- 1. clone or fast-forward the data repo -------------------------------------------------

if [ ! -d "$DATA_REPO_DIR/.git" ]; then
  git clone "$GIT_REMOTE" "$DATA_REPO_DIR" || fail "git clone of $GIT_REMOTE failed"
else
  git -C "$DATA_REPO_DIR" pull --ff-only || fail "git pull --ff-only failed in $DATA_REPO_DIR"
fi

cd "$DATA_REPO_DIR" || fail "cannot cd into $DATA_REPO_DIR"
mkdir -p data

# --- 2. fetch the 5 published files into .tmp files ----------------------------------------

FILES="regulator-warnings.csv regulator-warnings.json scam-taxonomy.csv scam-statistics.csv threat-aggregates.json"
UA="scamencyclopedia-data-sync/1.0 (+https://scamencyclopedia.org)"

for f in $FILES; do
  curl -fsSL --retry 3 --retry-delay 10 -A "$UA" -o "data/${f}.tmp" "$SITE/data/${f}" \
    || fail "curl fetch of $f failed"
done

# --- 3. CSV header-drift check ---------------------------------------------------------------
# Expected column headers, exactly as published. If a live file's first line does not match
# byte-for-byte (after stripping a trailing \r), the site's schema has drifted out from under
# this script — abort without committing rather than silently ingest a reshaped file.

EXPECTED_HEADER_regulator_warnings_csv="name,alias,category,framing,country,regulator_key,regulator,jurisdiction,regulator_source_url,method,license,firm_slug,firm_page_url,snapshot_date"
EXPECTED_HEADER_scam_taxonomy_csv="node_slug,parent_slug,node_type,label,description,scam_slug,category_slug,risk_level,url,last_reviewed,sort_order"
EXPECTED_HEADER_scam_statistics_csv="page_slug,page_title,scope,label,value,source,source_url,year,page_url,last_reviewed"

check_csv_header() {
  local file="$1" expected="$2"
  local actual
  actual="$(head -n 1 "data/${file}.tmp" | tr -d '\r')"
  if [ "$actual" != "$expected" ]; then
    echo "DRIFT ${file}"
    return 1
  fi
  return 0
}

drift=0
check_csv_header "regulator-warnings.csv" "$EXPECTED_HEADER_regulator_warnings_csv" || drift=1
check_csv_header "scam-taxonomy.csv" "$EXPECTED_HEADER_scam_taxonomy_csv" || drift=1
check_csv_header "scam-statistics.csv" "$EXPECTED_HEADER_scam_statistics_csv" || drift=1

if [ "$drift" -ne 0 ]; then
  rm -f data/*.tmp
  fail "CSV header drift detected — see DRIFT lines above; aborting without committing" 3
fi

# --- 4. JSON validity check ------------------------------------------------------------------

for f in regulator-warnings.json threat-aggregates.json; do
  python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "data/${f}.tmp" \
    || { rm -f data/*.tmp; fail "invalid JSON in $f" 3; }
done

SNAPSHOT="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("snapshotDate",""))' "data/regulator-warnings.json.tmp")"
if [ -z "$SNAPSHOT" ]; then
  rm -f data/*.tmp
  fail "regulator-warnings.json.tmp has no snapshotDate" 3
fi

# --- 5. promote tmp files to final names ------------------------------------------------------

for f in $FILES; do
  mv "data/${f}.tmp" "data/${f}" || fail "mv of $f failed"
done

# --- 6. regenerate data/manifest.json ----------------------------------------------------------
# NOTE on "rows": for CSVs this is computed as (newline count - 1), i.e. line count minus the
# header line. This is an approximation — a field value that itself contains an embedded newline
# would inflate this count. The live site's own reported row count (shown on /data) is the
# authoritative figure if the two ever disagree.

python3 - "$SITE" << 'PYEOF'
import hashlib, json, os, sys
from datetime import datetime, timezone

site = sys.argv[1]
files = [
    "regulator-warnings.csv",
    "regulator-warnings.json",
    "scam-taxonomy.csv",
    "scam-statistics.csv",
    "threat-aggregates.json",
]
now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

manifest = {}
for f in files:
    path = os.path.join("data", f)
    with open(path, "rb") as fh:
        data = fh.read()
    entry = {
        "bytes": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
        "fetchedAt": now,
        "sourceUrl": f"{site}/data/{f}",
    }
    if f.endswith(".csv"):
        newline_count = data.count(b"\n")
        entry["rows"] = max(newline_count - 1, 0)
    manifest[f] = entry

with open("data/manifest.json", "w") as fh:
    json.dump(manifest, fh, indent=2, sort_keys=True)
    fh.write("\n")
PYEOF
[ $? -eq 0 ] || fail "manifest.json generation failed"

# --- 7. commit and push, only if something changed --------------------------------------------

git add data/
if git diff --cached --quiet; then
  echo "No changes to commit (snapshot $SNAPSHOT already up to date)."
else
  git commit -m "data: snapshot $SNAPSHOT" || fail "git commit failed"
  git push origin HEAD || fail "git push failed"
  echo "Synced and pushed snapshot $SNAPSHOT."
fi
