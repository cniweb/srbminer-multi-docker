# Agent Workspace Guide

Primary instruction source: `.github/copilot-instructions.md` (canonical when it conflicts with this file).

## Repo shape

- This repo packages prebuilt SRBMiner-Multi release tarballs; it does not build SRBMiner-Multi from source.
- `Dockerfile` downloads the prebuilt binary from GitHub releases (`doktor83/SRBMiner-Multi`).
- Default `docker run` uses `start_zergpool.sh` as the entrypoint.
- The image runs as non-root `srbminer` user by default.

## Verification

- Primary checks are Docker-based:
  - `docker build . -t cniweb/srbminer-multi:test`
  - `docker run --rm cniweb/srbminer-multi:test` (will try to connect to pool and exit)
  - `docker run --rm --entrypoint="" cniweb/srbminer-multi:test ./SRBMiner-MULTI --version`
  - `docker run --rm cniweb/srbminer-multi:test --version` (via entrypoint passthrough)
- `./build.sh build-only` is the same build path CI uses on `main`; it exits before security checks or pushes.
- `./security-check.sh` defaults to image `cniweb/srbminer-multi:test`; build that tag first or pass a different image name.

## Shell and runtime constraints

- `start_zergpool.sh` is a POSIX `sh` script with `set -eu`; keep it POSIX-compatible.
- Port `8080` is the expected HTTP/API port across Dockerfile, docs, and checks.
- The image runs as non-root `srbminer` by default.
- The installed paths are `/opt/SRBMiner-Multi/SRBMiner-MULTI` and `/opt/SRBMiner-Multi/start_zergpool.sh`.

## Release/versioning

- SRBMiner-Multi version bumps must stay synchronized across all files: `Dockerfile`, `build.sh`, `README.md`, and `CHANGELOG.md`.
- The release workflow (`.github/workflows/release-from-version.yml`) handles all four automatically: it updates version refs in the first three, and promotes `CHANGELOG.md`'s `## [Unreleased]` heading to `## [<version>] - <date>`. **The workflow fails fast if `CHANGELOG.md` has no `## [Unreleased]` section** — add one with the release notes before triggering it.
- Prefer that workflow for releases: it updates version refs, commits, tags `vX.Y.Z`, and creates the GitHub release.
- When checking for a new upstream version, compare `Dockerfile`'s `ARG VERSION_TAG` against `gh release list --repo doktor83/SRBMiner-Multi --limit 5`, then fetch notes with `gh release view ${VERSION} --repo doktor83/SRBMiner-Multi --json body -q .body`.

## Small gotchas

- SRBMiner-Multi version tags on GitHub use dots (e.g. `3.4.7`) but the tarball name uses hyphens (e.g. `SRBMiner-Multi-3-4-7-Linux.tar.gz`). The `tr '.' '-'` transformation in the Dockerfile handles this.
- The default `WALLET_USER` is a placeholder — override it at runtime.
- The entrypoint prepends `LTC:` and appends `.$(hostname)#Jumper` to `WALLET_USER`; it also logs wallet and password values. Treat plain startup as a network/pool run, not an offline smoke test.
- Prefer `docker run --rm --entrypoint="" image ./SRBMiner-MULTI --version` for offline binary validation. `EXTRAS` is a space-separated flag string and is intentionally shell-expanded.
- `EXPECTED_SHA256` should be supplied for release builds; an empty value disables checksum verification.
- `.dockerignore` excludes `.github`, `build.sh`, and other dev files; changes there do not affect image build context.

## CI

- `.github/workflows/docker-build.yml` runs on push and PR to `main`:
  - `validate` job: builds with `./build.sh build-only`, then runs `--version`, entrypoint-bypass validation, and `security-check.sh` against it. Never pushes.
  - `docker` job (push events only, gated on `validate` passing): rebuilds, re-validates, then tags and pushes to Docker Hub and GHCR, generates SLSA provenance attestation and SBOM, and creates a GitHub Release.
- Snyk container scanning runs on push/PR to `main` and weekly via `snyk-container-analysis.yml`.
- Dependabot monitors Docker base images and GitHub Actions versions.
