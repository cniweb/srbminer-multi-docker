---
mode: "agent"
description: "Create a new SRBMiner-Multi release: optionally check for new upstream SRBMiner-Multi versions, bump versions, update CHANGELOG.md with upstream changes, then tag and publish a GitHub release."
---

Create a release for this repository.

## Workflow

1. **Version input.** If no version is provided in the request, ask for it (format `3.0.2` or `v3.0.2`).
2. **Normalize** to `VERSION` (without `v`) and `TAG` (`v${VERSION}`).
3. **Fetch upstream SRBMiner-Multi release notes** from `https://github.com/doktor83/SRBMiner-Multi/releases/tag/${VERSION}` using `gh release view ${VERSION} --repo doktor83/SRBMiner-Multi --json body -q .body`. Extract the changelog items (bug fixes, features, improvements) — ignore SHA256 checksums and GPG signatures.
4. **Update `CHANGELOG.md`**: add a new section at the top (below the header) with:
   - `## [${VERSION}] - ${YYYY-MM-DD}` (today's date)
   - `### Upstream SRBMiner-Multi changes` — list items from step 3
   - `### Packaging changes` — list any packaging changes made in this release (if any)
5. **Update version references** in these files:
   - `Dockerfile` → `ARG VERSION_TAG=${VERSION}`
   - `build.sh` → `version="${VERSION}"`
   - `README.md` — update version references in documentation text
6. **Validate** with:
   - `docker build . -t cniweb/srbminer-multi:test`
   - `docker run --rm --entrypoint="" cniweb/srbminer-multi:test ./SRBMiner-MULTI --version`
7. **Commit** using message: `chore(release): ${TAG}`
8. **Create and push** Git tag `${TAG}`.
9. **Create a GitHub release** with title/body based on the latest previous release text, replacing old tag/version with the new one. Include a summary of upstream changes in the release body.
10. **Report** exactly which files changed and final tag/release URL.

Prefer using the workflow `Create Release From Version` (`.github/workflows/release-from-version.yml`) when possible. The workflow handles steps 5, 7, 8, and 9 automatically but does **not** update `CHANGELOG.md` — that must be done manually or by the agent before running the workflow.

## Checking for new upstream versions

When asked to check for a new SRBMiner-Multi version:

1. Run `gh release list --repo doktor83/SRBMiner-Multi --limit 5` to find the latest release.
2. Compare with the current version in `Dockerfile` (`ARG VERSION_TAG=...`).
3. If a newer version exists, report it and ask whether to proceed with the release workflow above.
