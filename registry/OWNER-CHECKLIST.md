# Owner checklist — registry distribution

Everything in `registry/` is prepared and drafted, but nothing has been submitted, published, or
opened anywhere. These are manual, owner-decision steps. Do them in order; each one is independent
of the others except where noted.

## 1. Zenodo (DOI minting)

1. Create a Zenodo account at https://zenodo.org using GitHub login.
2. Enable the GitHub–Zenodo integration for the `scamencyclopedia-data` repository
   (https://zenodo.org/account/settings/github/).
3. Create a GitHub release tagged `v2026-09-12` on `bryanflowers/scamencyclopedia-data`. Zenodo
   will automatically archive it and mint a DOI.
4. Once the DOI is minted, paste it into:
   - `CITATION.cff` — add a `doi:` field.
   - The live site's `/data` page — add the DOI to the page's `sameAs` metadata.
   - `registry/zenodo/zenodo.json` and `.zenodo.json` — update `related_identifiers` if desired.

## 2. Hugging Face

1. Create a Hugging Face account/organisation (no personal name — use "ScamEncyclopedia" as the
   org display name).
2. `huggingface-cli login`, then:
   `huggingface-cli repo create scamencyclopedia-data --type dataset`
3. Push `registry/huggingface/README.md` (renamed to `README.md` at the repo root) together with
   the current contents of `data/` (the CSV/JSON files, not `manifest.json` unless desired).

## 3. Kaggle

1. Copy the current data files into `registry/kaggle/` alongside the prepared
   `dataset-metadata.json` and `description.md`.
2. From `registry/kaggle/`, run: `kaggle datasets create -p .`
3. Review the `id` field in `dataset-metadata.json` first — it is currently
   `bryanflowers/scamencyclopedia-open-data`; rename if you'd prefer a different Kaggle handle.

## 4. Awesome-list PRs

`registry/awesome-lists/` contains one drafted entry per target list, each marked
`DRAFT — HELD FOR OWNER APPROVAL`. Review `registry/awesome-lists/README.md` for the full list of
six targets, then approve or reject each individually. **No PR will be opened without your written
yes for that specific list.** For each approved list: verify the section name against the list's
current live README (lists get reorganised), open the PR with the drafted title/body/line, and
mark it approved in the README table.

## 5. GASA (Global Anti-Scam Alliance) membership

Decide whether ScamEncyclopedia should apply for GASA membership (https://www.gasa.org/). This is
a standing-relationship decision, not a one-off submission, and is not automated here — evaluate
independently and decide.

## 6. Google Dataset Search

No separate submission is needed. The `/data` page already carries indexable JSON-LD dataset
markup. To surface it in Google Dataset Search, simply verify `https://scamencyclopedia.org/data`
is indexed in Google Search Console (it should already be, as part of normal site indexing) — no
additional registration step is required.
