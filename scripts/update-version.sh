#!/usr/bin/env bash
# Usage: ./scripts/update-version.sh <version> <pubspec-path>
# Example: ./scripts/update-version.sh 1.2.3 phoenix_app/pubspec.yaml

set -euo pipefail

VERSION="${1:?Usage: update-version.sh <version> <pubspec-path>}"
PUBSPEC="${2:?Usage: update-version.sh <version> <pubspec-path>}"

# Build number = total number of version tags
BUILD_NUMBER=$(git tag -l 'v*' | wc -l | tr -d ' ')
# Ensure at least 1
BUILD_NUMBER=$((BUILD_NUMBER > 0 ? BUILD_NUMBER : 1))

echo "Version: ${VERSION}+${BUILD_NUMBER}"

sed -i "s/^version: .*/version: ${VERSION}+${BUILD_NUMBER}/" "$PUBSPEC"

grep "^version:" "$PUBSPEC"
