#!/usr/bin/env python3
# validate-localization.py
# ApexArchive
# Copyright © 2026 Vladimir Uvarov. All rights reserved.

"""Check explicit Swift localization keys and bundled garage editorial content."""
import json
import re
from pathlib import Path

root = Path(__file__).resolve().parents[1]
catalog = json.loads((root / "ApexArchive/Resources/Localizable.xcstrings").read_text())["strings"]
required = set()
for folder in (root / "ApexArchive", root / "Packages/ArchiveKit/Sources"):
    for path in folder.rglob("*.swift"):
        required.update(re.findall(r'localized:\s*"([^"\\]+)"', path.read_text()))
archive = json.loads((root / "Packages/ArchiveKit/Sources/ArchiveData/Resources/archive.json").read_text())
for car in archive["cars"]:
    for field in ("relationship", "description", "sourceTitle", "evidenceDate"):
        required.add(f"car.{car['id']}.{field}")
    for index, _ in enumerate(car.get("facts") or []):
        for field in ("label", "value"):
            required.add(f"car.{car['id']}.fact.{index}.{field}")
for story in archive.get("lifeStories") or []:
    required.add(f"life.{story['id']}.title")
    required.add(f"life.{story['id']}.body")
    if story.get("impact"):
        required.add(f"life.{story['id']}.impact")
pair_pattern = re.compile(r'localized:\s*"([^"\\]+)"\s*,\s*defaultValue:\s*"((?:[^"\\]|\\.)*)"')
defaults = {}
for folder in (root / "ApexArchive", root / "Packages/ArchiveKit/Sources"):
    for path in folder.rglob("*.swift"):
        for key, value in pair_pattern.findall(path.read_text()):
            defaults.setdefault(key, set()).add(value.replace('\\"', '"').replace("\\\\", "\\"))
# The catalog entry is what ships. A default edited in Swift without the catalog silently keeps the old copy.
drift = []
for key, values in sorted(defaults.items()):
    if len(values) > 1:
        drift.append(f"{key}: conflicting defaults in source {sorted(values)}")
        continue
    shipped = catalog.get(key, {}).get("localizations", {}).get("en", {}).get("stringUnit", {}).get("value")
    if shipped is not None and shipped != next(iter(values)):
        drift.append(f"{key}: catalog says {shipped!r}, source default says {next(iter(values))!r}")
if drift:
    raise SystemExit("Localization value drift:\n" + "\n".join(drift))
missing = sorted(key for key in required if key not in catalog)
if missing:
    raise SystemExit("Missing localization keys: " + ", ".join(missing))
print(f"Validated {len(required)} localization keys")
