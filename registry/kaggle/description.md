# ScamEncyclopedia Open Data

ScamEncyclopedia (https://scamencyclopedia.org) is the world's scam warning library. This dataset
mirrors the open data published at https://scamencyclopedia.org/data, refreshed weekly.

## Licence (important — read before use)

Kaggle's licence picker does not offer plain CC-BY-NC-4.0, so `dataset-metadata.json` declares
`"other"`. The actual, binding licence terms are:

- `regulator-warnings.csv` — **CC-BY-NC 4.0**
  (https://creativecommons.org/licenses/by-nc/4.0/legalcode). This file carries
  OpenSanctions-structured rows under OpenSanctions' own CC-BY-NC 4.0 terms — attribution
  required, non-commercial use only without separate permission.
- `scam-taxonomy.csv` — **CC-BY 4.0**
  (https://creativecommons.org/licenses/by/4.0/legalcode).

Required attribution line for any use:

> Data: ScamEncyclopedia (https://scamencyclopedia.org/data); regulator rows via OpenSanctions
> (CC-BY-NC 4.0) from official regulator warning lists.

## What's in this dataset

- **`regulator-warnings.csv`** — 11,041 rows (2026-09-07 snapshot) from 8 official regulator
  warning lists (US SEC PAUSE list; Swiss FINMA warning list; Securities Commission Malaysia
  Investor Alert List; France AMF unauthorised financial services; Philippines SEC advisories;
  Malaysia Financial Consumer Alert List; Lithuania illegal financial services; Lithuania Gaming
  Control Authority illegal gambling operators), structured via OpenSanctions
  (https://www.opensanctions.org/).
- **`scam-taxonomy.csv`** — every node of the ScamEncyclopedia scam taxonomy: category roots,
  roughly 940 scam sub-types, and cross-cutting channel / victim-profile / payment-method /
  red-flag / response-step / reporting-agency nodes.

## Framing note — read before use

`regulator-warnings.csv`'s `framing` column is one of `impersonation`, `fictitious-regulator`, or
`unauthorised`. When `framing` is `impersonation`, the `name` column identifies the GENUINE firm
whose identity was cloned by a scammer — **that genuine firm is NOT the subject of the regulatory
warning**. Presenting an `impersonation` row as if the named firm itself were sanctioned or
warned-against is a misrepresentation of the source data.

## Corrections

A firm wrongly listed should contact the issuing regulator named in the `regulator` /
`regulator_source_url` columns — the listing is theirs, not ScamEncyclopedia's. Data-structuring
errors: hello@scamencyclopedia.org.

## Full data hub

https://scamencyclopedia.org/data — includes the remaining `scam-statistics.csv` and
`threat-aggregates.json` files, a firm-check API, and citation guidance.
