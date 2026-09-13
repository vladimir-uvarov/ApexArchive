#!/usr/bin/env python3
# Copyright © 2026 Vladimir Uvarov. All rights reserved.
"""Check one named top-level type per file, headers, and spacing between members."""
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parent.parent
paths = [*root.joinpath("ApexArchive").rglob("*.swift"), *root.joinpath("ApexArchiveTests").rglob("*.swift"), *root.joinpath("Packages/ArchiveKit/Sources").rglob("*.swift"), *root.joinpath("Packages/ArchiveKit/Tests").rglob("*.swift"), *root.joinpath("Packages/ArchiveKit/Tools").rglob("*.swift")]
pattern = re.compile(r"(\}\n)([ \t]*(?:(?:public|private|internal|fileprivate|static|final|override|class|mutating|nonmutating) +)*(?:func |init\(|deinit\b|var |let ))")
errors = []
for path in paths:
    text = path.read_text()
    forbidden_imports = {
        "ArchiveDomain": {"ArchiveData", "ArchivePresentation", "SwiftUI", "UIKit"},
        "ArchivePresentation": {"ArchiveData", "SwiftUI", "UIKit"},
        "ArchiveData": {"ArchivePresentation", "SwiftUI", "UIKit"},
    }
    for module, forbidden in forbidden_imports.items():
        if f"Sources/{module}/" in str(path):
            imported = set(re.findall(r"^import (\w+)", text, re.M))
            for dependency in imported & forbidden:
                errors.append(f"{path.relative_to(root)}: {module} must not import {dependency}")
    formatted = pattern.sub(r"\1\n\2", text)
    if text != formatted:
        if "--fix" in sys.argv:
            path.write_text(formatted)
        else:
            errors.append(f"{path.relative_to(root)}: missing blank line between members")
    types = re.findall(r"^(?:(?:public|internal|private|final|@MainActor|@Observable|@main) +)*(?:struct|class|enum|actor|protocol) (\w+)", text, re.M)
    if len(types) > 1:
        errors.append(f"{path.relative_to(root)}: more than one top-level type")
    if types and types[0] != path.stem:
        errors.append(f"{path.relative_to(root)}: filename must match {types[0]}")
    if "Copyright © 2026 Vladimir Uvarov. All rights reserved." not in text:
        errors.append(f"{path.relative_to(root)}: missing copyright header")
# A View nothing else names is a feature nobody can reach; two such screens shipped before this check.
app_sources = {p: p.read_text() for p in root.joinpath("ApexArchive").rglob("*.swift")}
for path, text in app_sources.items():
    for view in re.findall(r"^(?:(?:public|internal|private|fileprivate) +)?struct (\w+)(?:<[^>]*>)?\s*:\s*View\b", text, re.M):
        if not any(re.search(rf"\b{view}\b", other) for p, other in app_sources.items() if p != path):
            errors.append(f"{path.relative_to(root)}: {view} is not referenced by any other app source")
if errors:
    print("\n".join(errors))
    sys.exit(1)
print(f"Source structure and headers checked: {len(paths)} Swift files")
