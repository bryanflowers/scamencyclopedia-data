---
license: cc-by-nc-4.0
language:
  - en
tags:
  - fraud
  - scams
  - regulator-warnings
  - osint
  - consumer-protection
pretty_name: ScamEncyclopedia Open Data
size_categories:
  - 10K<n<100K
configs:
  - config_name: regulator-warnings
    data_files:
      - split: csv
        path: "regulator-warnings.csv"
      - split: json
        path: "regulator-warnings.json"
  - config_name: scam-taxonomy
    data_files:
      - split: csv
        path: "scam-taxonomy.csv"
  - config_name: scam-statistics
    data_files:
      - split: csv
        path: "scam-statistics.csv"
  - config_name: threat-aggregates
    data_files:
      - split: json
        path: "threat-aggregates.json"
---

# ScamEncyclopedia Open Data

ScamEncyclopedia (https://scamencyclopedia.org) is the world's scam warning library. This dataset
mirrors the open data published at https://scamencyclopedia.org/data, refreshed weekly.

## Dataset summary

| File | Rows | Licence |
|---|---|---|
| `regulator-warnings.csv` / `.json` | 11,041 (2026-09-07 snapshot) | CC-BY-NC 4.0 |
| `scam-taxonomy.csv` | ~960 scam sub-types + category/cross-cutting nodes | CC-BY 4.0 |
| `scam-statistics.csv` | one row per cited statistic | CC-BY 4.0 |
| `threat-aggregates.json` | aggregate counts, no blocklist contents | CC-BY 4.0 |

### `regulator-warnings.csv` / `.json`

11,041 rows from 8 official regulator warning lists — US SEC PAUSE list; Swiss FINMA warning list;
Securities Commission Malaysia Investor Alert List; France AMF unauthorised financial services;
Philippines SEC advisories; Malaysia Financial Consumer Alert List; Lithuania illegal financial
services; Lithuania Gaming Control Authority illegal gambling operators — structured via
OpenSanctions (https://www.opensanctions.org/).

Columns: `name, alias, category, framing, country, regulator_key, regulator, jurisdiction,
regulator_source_url, method, license, firm_slug, firm_page_url, snapshot_date`.

**Framing note (read before use):** `framing` is one of `impersonation`, `fictitious-regulator`, or
`unauthorised`. When `framing` is `impersonation`, the `name` column is the GENUINE firm whose
identity was cloned by a scammer — that genuine firm is NOT the subject of the warning. Treating an
`impersonation` row as if the named firm itself were sanctioned is a misrepresentation of the
source data.

### `scam-taxonomy.csv`

Columns: `node_slug, parent_slug, node_type, label, description, scam_slug, category_slug,
risk_level, url, last_reviewed, sort_order`.

### `scam-statistics.csv`

Columns: `page_slug, page_title, scope, label, value, source, source_url, year, page_url,
last_reviewed`.

### `threat-aggregates.json`

Aggregate counts only from abuse.ch URLhaus, MetaMask eth-phishing-detect, FishFish, and Have I
Been Pwned, with per-source licence strings preserved in `sources[].license`.

## Licence

This dataset is dual-licensed and the `cc-by-nc-4.0` tag above governs the bundle as distributed
here because it includes the regulator-warnings files:

- `regulator-warnings.csv` / `.json` — **CC-BY-NC 4.0** (OpenSanctions-derived; non-commercial use
  only without separate permission).
- All other files — **CC-BY 4.0**.

See https://github.com/bryanflowers/scamencyclopedia-data/blob/main/LICENSE.md for the full
statement.

## Citation

```bibtex
@misc{scamencyclopedia_data,
  author = {{ScamEncyclopedia}},
  title = {ScamEncyclopedia open data: regulator warning lists, scam taxonomy, fraud statistics},
  year = {2026},
  url = {https://scamencyclopedia.org/data},
  note = {Snapshot 2026-09-07}
}
```

Attribution line: "Data: ScamEncyclopedia (https://scamencyclopedia.org/data); regulator rows via
OpenSanctions (CC-BY-NC 4.0) from official regulator warning lists."
