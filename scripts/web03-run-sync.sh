#!/bin/bash
# Host wrapper for sync-data-repo.sh on web03 (installed at /root/gha-migrated/scamencyclopedia-data/).
# Layout on the host:
#   /root/gha-migrated/scamencyclopedia-data/deploy_key       — RW deploy key scoped to the data repo
#   /root/gha-migrated/scamencyclopedia-data/sync-data-repo.sh
#   /root/gha-migrated/scamencyclopedia-data/web03-run-sync.sh (this file)
#   /root/gha-migrated/scamencyclopedia-data/repo/            — the clone (created on first run)
# Cron (/etc/cron.d/gha-migrated-scamencyclopedia-data):
#   17 6 * * 2 root /root/gha-migrated/scamencyclopedia-data/web03-run-sync.sh >/dev/null 2>&1
# Tuesday 06:17 UTC = the day after the Monday 06:06 UTC regulator refresh + ~19 min deploy.
set -u
BASE=/root/gha-migrated/scamencyclopedia-data
LOG=$BASE/last-run.log
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export GIT_REMOTE="git@github.com:bryanflowers/scamencyclopedia-data.git"
export DATA_REPO_DIR="$BASE/repo"
export SITE="https://scamencyclopedia.org"
export GIT_SSH_COMMAND="ssh -i $BASE/deploy_key -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"
export GIT_AUTHOR_NAME="scamencyclopedia-data-sync" GIT_AUTHOR_EMAIL="hello@scamencyclopedia.org"
export GIT_COMMITTER_NAME="scamencyclopedia-data-sync" GIT_COMMITTER_EMAIL="hello@scamencyclopedia.org"
{
  echo "=== scamencyclopedia-data sync $(date -u +%FT%TZ) ==="
  bash "$BASE/sync-data-repo.sh"
  rc=$?
  echo "=== exit $rc $(date -u +%FT%TZ) ==="
  exit $rc
} >"$LOG" 2>&1
