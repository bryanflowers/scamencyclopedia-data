# Licence

This repository is dual-licensed. Different files carry different terms — check which group a file
falls into before reusing it.

## 1. Regulator warning data — CC-BY-NC 4.0

`data/regulator-warnings.csv` and `data/regulator-warnings.json` are licensed under the
**Creative Commons Attribution-NonCommercial 4.0 International licence (CC-BY-NC 4.0)**:

https://creativecommons.org/licenses/by-nc/4.0/legalcode

These files carry rows structured via OpenSanctions (https://www.opensanctions.org/), and are
distributed here under OpenSanctions' own CC-BY-NC 4.0 terms. Any use — commercial or otherwise —
must give attribution; **commercial use of these two files is not permitted** under this licence
without separate permission.

Required attribution line:

> Data: ScamEncyclopedia (https://scamencyclopedia.org/data); regulator rows via OpenSanctions
> (CC-BY-NC 4.0) from official regulator warning lists.

## 2. Everything else — CC-BY 4.0

`data/scam-taxonomy.csv`, `data/scam-statistics.csv`, `data/threat-aggregates.json`, this README,
and all other files in this repository (excluding the two files above) are licensed under the
**Creative Commons Attribution 4.0 International licence (CC-BY 4.0)**:

https://creativecommons.org/licenses/by/4.0/legalcode

Commercial and non-commercial use is permitted with attribution to ScamEncyclopedia
(https://scamencyclopedia.org).

## OpenSanctions notice

Rows in `regulator-warnings.csv` / `regulator-warnings.json` are structured with the help of
OpenSanctions (https://www.opensanctions.org/), whose own data is licensed CC-BY-NC 4.0.
OpenSanctions must be credited alongside ScamEncyclopedia whenever this data is reused.

## The regulators' listings remain the regulators' own

ScamEncyclopedia does not create, amend, or own the underlying facts in the regulator-warnings
dataset. Each row reflects a listing published by the named official regulator (`regulator` /
`regulator_source_url` columns), and that listing remains the regulator's own work product.
ScamEncyclopedia's contribution is structuring and republishing these public listings; it has no
authority to add, remove, or correct a regulator's own listing. Corrections to a listing itself
must go to the issuing regulator.

## Threat-feed sources

`data/threat-aggregates.json` aggregates counts from abuse.ch URLhaus, MetaMask
eth-phishing-detect, FishFish, and Have I Been Pwned. Each source's own licence/attribution string
is preserved in the `sources[].license` field of that file and must be carried forward in any
downstream use.
