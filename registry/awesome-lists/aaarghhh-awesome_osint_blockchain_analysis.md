# aaarghhh/awesome_osint_blockchain_analysis — DRAFT, held for owner approval

**Target repo:** https://github.com/aaarghhh/awesome_osint_blockchain_analysis

**Likely section:** a general "Resources" or "Scam/Fraud" section — verify the section name in the
live README before opening the PR.

**Line to add:**

```
- [ScamEncyclopedia](https://scamencyclopedia.org/data) - Free regulator warning-list API/datasets (11k+ entries, 8 regulators) plus aggregate threat-feed counts including MetaMask's eth-phishing-detect list. No key. CC-BY-NC (regulator data) / CC-BY (rest).
```

**PR title:** Add ScamEncyclopedia (regulator warnings + crypto-phishing aggregate counts)

**PR body:**

> ScamEncyclopedia's open data includes regulator warning-list entries (some crypto-investment-scam
> categories) and `threat-aggregates.json`, which surfaces an aggregate count from MetaMask's
> eth-phishing-detect list alongside other threat feeds. Submitting for consideration given the
> partial overlap with blockchain-scam analysis, while being upfront that most of the dataset is
> general financial-regulator data rather than blockchain-specific.

**Fit:** Weak-to-moderate, and worth being honest about: this list is specifically about blockchain
analysis tooling, and ScamEncyclopedia's data is general fraud/regulator data with only a thin
blockchain-relevant slice — the crypto-related regulator `category` values in
`regulator-warnings.csv` and the single MetaMask eth-phishing-detect aggregate in
`threat-aggregates.json`. Consider skipping this one, or submitting only if the maintainer's scope
notes indicate adjacent fraud-intel resources are welcome.
