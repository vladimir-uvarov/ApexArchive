#!/bin/bash
# Copyright © 2026 Vladimir Uvarov. All rights reserved.
set -euo pipefail
cd "$(dirname "$0")/.."
xcrun swift-format lint --strict --recursive --configuration .swift-format ApexArchive Packages/ArchiveKit/Sources Packages/ArchiveKit/Tests Packages/ArchiveKit/Tools
xcrun swift-format lint --strict --configuration .swift-format Packages/ArchiveKit/Package.swift
python3 Scripts/enforce-source-style.py
python3 Scripts/validate-localization.py
"${SWIFTLINT_BIN:-swiftlint}" lint --no-cache --strict --config .swiftlint.yml
