# Tag-driven Release & Versioning System

**Date:** 2026-03-18
**Status:** Approved

## Overview

Automated release system triggered by git tags. Pushing a semver tag (`v*.*.*`) builds APK + Linux bundle and creates a GitHub Release with both artifacts attached.

## Trigger

- **Event:** Push of a tag matching `v[0-9]+.[0-9]+.[0-9]+`
- **Example:** `git tag v1.1.0 && git push --tags`

## Versioning Scheme

- **Format:** Semantic Versioning — `vMAJOR.MINOR.PATCH`
  - PATCH: bug fixes
  - MINOR: new features
  - MAJOR: breaking changes
- **pubspec.yaml:** `version: X.Y.Z+N` where N = build number (auto-incremented from tag count)
- **Single source of truth:** The git tag. The workflow syncs pubspec.yaml from the tag.

## Workflow: `.github/workflows/release.yml`

### Jobs

**1. validate**
- Check tag format is valid semver
- Extract version components (major, minor, patch)

**2. build-apk**
- Runs on: `ubuntu-latest`
- Setup: Java 17, Flutter 3.29+
- Command: `flutter build apk --debug` (debug signing for now)
- Output artifact: `phoenix-v{VERSION}.apk`
- Future: switch to `--release` when keystore is configured via GitHub Secrets

**3. build-linux**
- Runs on: `ubuntu-latest`
- Setup: Flutter 3.29+, apt dependencies (clang, cmake, ninja, libgtk-3-dev, etc.)
- Command: `flutter build linux --release`
- Package: tar.gz of the bundle directory
- Output artifact: `phoenix-v{VERSION}-linux-x64.tar.gz`

**4. release**
- Depends on: build-apk, build-linux
- Creates GitHub Release using the tag
- Attaches both artifacts
- Auto-generates changelog from commits since previous tag

### Version Sync Script: `scripts/update-version.sh`

- Input: git tag (e.g., `v1.2.3`)
- Extracts version string, strips `v` prefix
- Computes build number from `git tag -l 'v*' | wc -l`
- Updates `pubspec.yaml` version field via sed
- Called by workflow before build steps

## Files to Create

| File | Purpose |
|------|---------|
| `.github/workflows/release.yml` | CI/CD workflow |
| `scripts/update-version.sh` | Version extraction and pubspec update |

## Files Modified

| File | Change |
|------|--------|
| `pubspec.yaml` | Version updated by workflow (not committed back) |

## Signing Strategy

- **Now:** Debug signing (no keystore needed)
- **Later:** Add `KEYSTORE_BASE64`, `KEY_ALIAS`, `KEY_PASSWORD`, `STORE_PASSWORD` as GitHub Secrets, switch build to `--release`, decode keystore in workflow

## How to Release

```bash
# Tag and push
git tag v1.1.0
git push --tags
```

GitHub Actions builds both artifacts and publishes the release automatically.

## How to Check

- Go to repository > Actions tab > see workflow run
- Go to repository > Releases > see release with APK + Linux tar.gz
- Download and verify artifacts

## Dependencies

- GitHub Actions runners with Flutter support
- `subosybern/flutter-action` for Flutter setup
- Java 17 for Android build
- Linux build dependencies: clang, cmake, ninja-build, pkg-config, libgtk-3-dev, liblzma-dev
