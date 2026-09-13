#!/bin/bash
# Copyright © 2026 Vladimir Uvarov. All rights reserved.
set -euo pipefail
cd "$(dirname "$0")/.."
xcrun swift-format format --in-place --recursive --configuration .swift-format ApexArchive ApexArchiveTests Packages/ArchiveKit/Sources Packages/ArchiveKit/Tests Packages/ArchiveKit/Tools
xcrun swift-format format --in-place --configuration .swift-format Packages/ArchiveKit/Package.swift
python3 Scripts/enforce-source-style.py --fix
