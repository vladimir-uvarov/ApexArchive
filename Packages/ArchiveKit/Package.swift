// swift-tools-version: 6.0
//
// Package.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "ArchiveKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ArchiveDomain", targets: ["ArchiveDomain"]),
        .library(name: "ArchiveData", targets: ["ArchiveData"]),
        .library(name: "ArchivePresentation", targets: ["ArchivePresentation"]),
    ],
    dependencies: [.package(url: "https://github.com/weichsel/ZIPFoundation.git", exact: "0.9.20")],
    targets: [
        .executableTarget(
            name: "ArchiveIntegrationCheck", dependencies: ["ArchiveData", "ArchiveDomain"],
            path: "Tools/IntegrationCheck"),
        .target(name: "ArchiveDomain"),
        .target(
            name: "ArchiveData",
            dependencies: ["ArchiveDomain", .product(name: "ZIPFoundation", package: "ZIPFoundation")],
            resources: [.process("Resources")]),
        .target(name: "ArchivePresentation", dependencies: ["ArchiveDomain"]),
        .target(name: "ArchiveTestSupport", dependencies: ["ArchiveDomain"], path: "Tests/Support"),
        .testTarget(name: "ArchiveDomainTests", dependencies: ["ArchiveDomain", "ArchiveTestSupport"]),
        .testTarget(
            name: "ArchiveDataTests", dependencies: ["ArchiveData", "ArchiveDomain", "ArchiveTestSupport"],
            resources: [.copy("Fixtures")]),
        .testTarget(
            name: "ArchivePresentationTests",
            dependencies: ["ArchivePresentation", "ArchiveDomain", "ArchiveTestSupport"]),
    ]
)
