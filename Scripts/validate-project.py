#!/usr/bin/env python3
# Copyright © 2026 Vladimir Uvarov. All rights reserved.
"""Check Xcode file references and local package wiring before invoking a build."""
from pathlib import Path
import json
import plistlib
import struct
import subprocess

root = Path(__file__).resolve().parent.parent
project = json.loads(subprocess.check_output(["plutil", "-convert", "json", "-o", "-", str(root / "ApexArchive.xcodeproj/project.pbxproj")]))
objects = project["objects"]
errors = []

def visit(identifier, parent):
    item = objects[identifier]
    if item.get("sourceTree") == "BUILT_PRODUCTS_DIR":
        return
    path = parent / item.get("path", "")
    if item["isa"] == "PBXFileReference" and not path.exists():
        errors.append(f"Missing Xcode input: {path.relative_to(root)}")
    for child in item.get("children", []):
        visit(child, path)

visit(objects[project["rootObject"]]["mainGroup"], root)
for item in objects.values():
    if item["isa"] == "XCSwiftPackageProductDependency":
        reference = objects.get(item.get("package"), {})
        if reference.get("isa") not in {"XCLocalSwiftPackageReference", "XCRemoteSwiftPackageReference"}:
            errors.append(f"Package product has no package reference: {item.get('productName')}")
    if item["isa"] == "XCLocalSwiftPackageReference":
        manifest = root / item["relativePath"] / "Package.swift"
        if not manifest.is_file():
            errors.append(f"Missing package manifest: {manifest}")
    if item["isa"] == "PBXBuildFile" and "fileRef" in item and item["fileRef"] not in objects:
        errors.append("Build phase points to a missing file reference")
for item in objects.values():
    if item["isa"] == "PBXNativeTarget" and item.get("productType") == "com.apple.product-type.application":
        configuration_list = objects[item["buildConfigurationList"]]
        for identifier in configuration_list["buildConfigurations"]:
            configuration = objects[identifier]
            settings = configuration["buildSettings"]
            if configuration["name"] == "Debug" and "DEBUG" not in settings.get("SWIFT_ACTIVE_COMPILATION_CONDITIONS", "").split():
                errors.append("Debug builds must enable DEBUG diagnostics")
            icon_names = [settings.get("ASSETCATALOG_COMPILER_APPICON_NAME", "")]
            icon_names += settings.get("ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES", "").split()
            if set(icon_names) != {"AppIcon", "AppIconCrimson", "AppIconGlacier", "AppIconPearl"}:
                errors.append("App icon build settings must include all selectable helmets")
            for icon_name in icon_names:
                asset = root / "ApexArchive/Resources/Assets.xcassets" / f"{icon_name}.appiconset"
                manifest = asset / "Contents.json"
                if not manifest.is_file():
                    errors.append(f"Missing app icon: {icon_name}")
                    continue
                for image in json.loads(manifest.read_text())["images"]:
                    image_path = asset / image["filename"]
                    data = image_path.read_bytes()
                    if data[:8] != b"\x89PNG\r\n\x1a\n" or struct.unpack(">II", data[16:24]) != (1024, 1024):
                        errors.append(f"App icon must be a 1024px PNG: {image_path.name}")
            info_path = root / settings.get("INFOPLIST_FILE", "")
            if not info_path.is_file():
                errors.append("App configuration must include the launch Info.plist")
            else:
                with info_path.open("rb") as info_file:
                    launch = plistlib.load(info_file).get("UILaunchScreen", {})
                color = launch.get("UIColorName")
                if not color or not list((root / "ApexArchive").rglob(f"{color}.colorset/Contents.json")):
                    errors.append("System launch background must reference an existing color asset")
            if configuration["name"] == "Debug" and configuration["buildSettings"].get("ONLY_ACTIVE_ARCH") != "YES":
                errors.append("Debug app architecture must match the active Swift package architecture")
privacy = plistlib.loads((root / "ApexArchive/Resources/PrivacyInfo.xcprivacy").read_bytes())
reasons = {item["NSPrivacyAccessedAPIType"]: item["NSPrivacyAccessedAPITypeReasons"] for item in privacy["NSPrivacyAccessedAPITypes"]}
if "C617.1" not in reasons.get("NSPrivacyAccessedAPICategoryFileTimestamp", []):
    errors.append("Cache file timestamp use needs its privacy reason")
for resource in ["Privacy-Information", "App-Information", "Third-Party-Notices", "F1DB-LICENSE", "ZIPFoundation-LICENSE"]:
    if not (root / "ApexArchive/Resources" / f"{resource}.txt").is_file():
        errors.append(f"Missing bundled legal document: {resource}")
if errors:
    raise SystemExit("\n".join(errors))
print("Xcode file references and local package paths are valid")
