#!/bin/bash
# Copyright © 2026 Vladimir Uvarov. All rights reserved.
set -euo pipefail
cd "$(dirname "$0")/.."
swift test --package-path Packages/ArchiveKit --enable-code-coverage "$@"
