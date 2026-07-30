# Changelog

All notable changes to this Docker packaging project are documented here.
Each entry tracks the upstream [SRBMiner-Multi](https://github.com/doktor83/SRBMiner-Multi) version used and any packaging changes made in this repository.

## [Unreleased]

### CI/CD & Repo Hygiene
- Replaced `docker-image.yml` with new `docker-build.yml` featuring validate + push jobs, SLSA provenance attestation, SBOM generation, and GitHub Release creation via `actions/github-script`
- Added release automation workflow (`release-from-version.yml`)
- Pinned all GitHub Actions to commit SHAs in `snyk-container-analysis.yml`:
  - `snyk/actions/docker@master` → `9adf32b1121593767fc3c057af55b55db032dc04` (v1.0.0)
  - `actions/checkout@v4` → `de0fac2e4500dabe0009e67214ff5f5447ce83dd` (v6)
  - `github/codeql-action/upload-sarif@v3` → `e46ed2cbd01164d986452f91f178727624ae40d7` (v4)
- Added `build-only` argument support to `build.sh`
- Added agent workspace guide (`AGENTS.md`)
- Added `CHANGELOG.md` with release history
- Added `pull_request_template.md` for consistent PR submissions
- Added `CODEOWNERS` with `@cniweb` as default owner
- Added `dependabot.yml` for Docker and GitHub Actions updates
- Added `security-check.sh` for container security validation

### Security & bug fixes
- Removed `--no-check-certificate` from wget fallback in Dockerfile
- Added SHA256 checksum verification for SRBMiner-Multi tarball download
- Added HEALTHCHECK to Dockerfile
- Improved `set -eu` usage in RUN commands
- Cleaned up curl/wget if not needed at runtime
- Fixed `start_zergpool.sh`: added `set -eu`, quoted all variable expansions, uses `exec` for final command

## [3.0.2] - 2026-07-30

### Upstream SRBMiner-Multi changes
- See [SRBMiner-Multi v3.0.2 release](https://github.com/doktor83/SRBMiner-Multi/releases/tag/3.0.2)

## [2.5.3] - 2024-04-08

### Upstream SRBMiner-Multi changes
- See [SRBMiner-Multi v2.5.3 release](https://github.com/doktor83/SRBMiner-Multi/releases/tag/2.5.3)

## [2.4.7] - 2023-10-04

### Upstream SRBMiner-Multi changes
- See [SRBMiner-Multi v2.4.7 release](https://github.com/doktor83/SRBMiner-Multi/releases/tag/2.4.7)
