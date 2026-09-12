# ScamEncyclopedia Open Data

ScamEncyclopedia (https://scamencyclopedia.org) is the world's scam warning library. This repository
mirrors the open datasets published at https://scamencyclopedia.org/data — official regulator warning
lists, a scam taxonomy, cited fraud statistics, and public threat-feed aggregates — refreshed weekly by
an automated sync from the live site. No named individual is associated with this project or repository;
ScamEncyclopedia is published and maintained as an organisation.

## Datasets

Row counts, byte sizes, and fetch timestamps are authoritative in [`data/manifest.json`](data/manifest.json),
which the sync script regenerates on every run. The table below is a static index; see `manifest.json`
for current numbers.

| File | Rows (see manifest.json) | Updated | Licence |
|---|---|---|---|
| `data/regulator-warnings.csv` | see manifest.json | weekly (Monday) | CC-BY-NC 4.0 |
| `data/regulator-warnings.json` | see manifest.json | weekly (Monday) | CC-BY-NC 4.0 |
| `data/scam-taxonomy.csv` | see manifest.json | as taxonomy changes | CC-BY 4.0 |
| `data/scam-statistics.csv` | see manifest.json | as statistics pages change | CC-BY 4.0 |
| `data/threat-aggregates.json` | see manifest.json | weekly | CC-BY 4.0 (per-source terms preserved) |

## Datasets in detail

### `regulator-warnings.csv` / `regulator-warnings.json`

11,041 rows as of the 2026-09-07 snapshot, drawn from 8 official regulator warning lists — US SEC PAUSE
list; Swiss FINMA warning list; Securities Commission Malaysia Investor Alert List; France AMF
unauthorised financial services list; Philippines SEC advisories; Malaysia Financial Consumer Alert
List; Lithuania illegal financial services list; Lithuania Gaming Control Authority illegal gambling
operators list — with rows structured via OpenSanctions (https://www.opensanctions.org/). This dataset
is licensed **CC-BY-NC 4.0**; attribution to ScamEncyclopedia, OpenSanctions, and the issuing regulator
is required for any use. It is refreshed weekly by a Monday host cron on the live site.

**CSV columns, in order:**

| Column | Description |
|---|---|
| `name` | Name as listed by the regulator |
| `alias` | Known alias(es), if any |
| `category` | Scam/entity category |
| `framing` | `impersonation` \| `fictitious-regulator` \| `unauthorised` |
| `country` | Country associated with the listing |
| `regulator_key` | Short internal key for the issuing regulator |
| `regulator` | Full name of the issuing regulator |
| `jurisdiction` | Jurisdiction of the issuing regulator |
| `regulator_source_url` | URL of the regulator's own listing |
| `method` | Ingestion method (currently always `opensanctions-csv`) |
| `license` | Per-row licence string |
| `firm_slug` | ScamEncyclopedia internal slug for the firm/entity |
| `firm_page_url` | ScamEncyclopedia page for the firm/entity |
| `snapshot_date` | Date of the feed snapshot this row was captured from |

There is no per-row listing date or entry URL in this dataset — the source rows do not carry them.
`snapshot_date` is the date of the feed snapshot, not the regulator's own listing date.

**Important — defamation-safe framing:** when `framing` is `impersonation`, the `name` column identifies
the GENUINE firm whose identity was cloned by a scammer. **The genuine firm is NOT the subject of the
regulatory warning** — the warning is about the impersonator, not the real firm. Any downstream use of
this dataset must preserve this distinction; presenting an `impersonation` row as if the named firm
itself were sanctioned or warned-against is a misrepresentation of the source data and a defamation risk.

The JSON file (`regulator-warnings.json`) is the merged per-firm view of the same data:

```
{
  dataset, snapshotDate, generatedFrom, license, licenseUrl, attribution,
  regulators: [ ... ],
  firms: [
    {
      slug, name, aliases: [...], framing, url,
      citations: [
        { regulatorKey, regulator, jurisdiction, category, country, sourceUrl }
      ]
    }
  ]
}
```

### `scam-taxonomy.csv`

Every node of the ScamEncyclopedia scam taxonomy: category roots, roughly 960 scam sub-types (959 at the September 2026 snapshot), and
cross-cutting channel / victim-profile / payment-method / red-flag / response-step / reporting-agency
nodes. This is ScamEncyclopedia's own compilation, licensed **CC-BY 4.0**.

**Columns:** `node_slug, parent_slug, node_type, label, description, scam_slug, category_slug, risk_level, url, last_reviewed, sort_order`

### `scam-statistics.csv`

One row per cited statistic appearing across the statistics pages (global, by country, by scam type),
each with its named source and source URL. The compilation is licensed **CC-BY 4.0**; the underlying
figures are facts drawn from the named official reports and remain attributable to those reports.

**Columns:** `page_slug, page_title, scope, label, value, source, source_url, year, page_url, last_reviewed`

### `threat-aggregates.json`

Aggregate counts only — no blocklist contents — from public threat databases: abuse.ch URLhaus,
MetaMask eth-phishing-detect, FishFish, and Have I Been Pwned. Per-source licence/attribution strings
must be preserved in any downstream use. The compilation is licensed CC-BY 4.0.

```
{
  dataset, snapshotDate, generatedFrom, license, licenseUrl, note,
  sources: [ { name, metric, value, url, license } ],
  breaches: { total, updatedAt, source, note }
}
```

## Attribution

Copy-paste attribution line for any use of the regulator-warnings dataset:

> Data: ScamEncyclopedia (https://scamencyclopedia.org/data); regulator rows via OpenSanctions
> (CC-BY-NC 4.0) from official regulator warning lists.

## How to cite

**APA-style:**

> ScamEncyclopedia. (2026). ScamEncyclopedia open data: regulator warning lists, scam taxonomy,
> fraud statistics [Data set]. Snapshot 2026-09-07. https://scamencyclopedia.org/data

**BibTeX:**

```bibtex
@misc{scamencyclopedia_data,
  author = {{ScamEncyclopedia}},
  title = {ScamEncyclopedia open data: regulator warning lists, scam taxonomy, fraud statistics},
  year = {2026},
  url = {https://scamencyclopedia.org/data},
  note = {Snapshot 2026-09-07}
}
```

## API & embed

- Firm-check API: `GET https://scamencyclopedia.org/api/v1/firm-check?q=<name>` — JSON, CORS `*`,
  60 requests/minute per IP, up to 20 matches per query. **No match is not a clean bill of health.**
- Human tool: https://scamencyclopedia.org/tools/firm-check
- Embed (div + script): `<div data-scamenc-firm-check></div>` plus
  `https://scamencyclopedia.org/embed/firm-check.js`
- Embed (iframe): https://scamencyclopedia.org/embed/firm-check.html
- Data hub with citation guidance: https://scamencyclopedia.org/data

## Update cadence

All datasets are refreshed weekly. Regulator warning data is refreshed by a Monday host cron on the
live site; this repository is synced the following day (Tuesday) by `scripts/sync-data-repo.sh`.
`data/manifest.json` records, per file: `sha256`, `bytes`, `rows` (CSVs only), `fetchedAt` (UTC ISO
timestamp), and `sourceUrl`.

## Corrections

- **A firm believes it is wrongly listed:** the listing belongs to the issuing regulator, not to
  ScamEncyclopedia. Contact the regulator named in the `regulator` / `regulator_source_url` column —
  they are the authority who can amend or withdraw their own listing.
- **You believe there is a data error in how ScamEncyclopedia structured or presented a row:** email
  hello@scamencyclopedia.org.

## Licence

This repository is dual-licensed:

- `data/regulator-warnings.csv` and `data/regulator-warnings.json` — **CC-BY-NC 4.0**
  (https://creativecommons.org/licenses/by-nc/4.0/legalcode), because they carry OpenSanctions-structured
  rows under OpenSanctions' own CC-BY-NC 4.0 terms.
- `data/scam-taxonomy.csv`, `data/scam-statistics.csv`, `data/threat-aggregates.json`, and all other
  files in this repository — **CC-BY 4.0** (https://creativecommons.org/licenses/by/4.0/legalcode).

See LICENSE.md for the full statement.

## Non-goals

This project deliberately does not publish:

- Sanctions lists (OFAC, EU, UN, etc.) — out of scope; use OpenSanctions or the official sanctions
  bodies directly.
- Enforcement-action dumps (fines, court filings, consent orders) beyond what a regulator's own
  warning-list entry already states.
- Fuzzy/approximate name matching in the API or datasets — matches are close-literal only, to avoid
  false accusations.
- Badges, seals, or "verified safe" marks of any kind. Absence from these datasets is not a clean
  bill of health.
