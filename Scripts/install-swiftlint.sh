#!/bin/bash
# Copyright © 2026 Vladimir Uvarov. All rights reserved.
set -euo pipefail
version=0.65.1
checksum=c1e429b0599cf1b516f369a2d9ec04eaf0e436f3c12b637df8851fa52ff694d0
destination="${1:?Pass a directory for SwiftLint}"
archive_directory="$(mktemp -d)"
trap 'rm -rf "$archive_directory"' EXIT
curl --fail --location --retry 2 "https://github.com/realm/SwiftLint/releases/download/$version/portable_swiftlint.zip" --output "$archive_directory/swiftlint.zip"
printf '%s  %s\n' "$checksum" "$archive_directory/swiftlint.zip" | shasum -a 256 --check
mkdir -p "$destination"
ditto -x -k "$archive_directory/swiftlint.zip" "$destination"
"$destination/swiftlint" version
