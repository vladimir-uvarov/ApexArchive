//
// AppIcon.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

extension AppIcon {
    var title: String {
        switch self {
        case .original: String(localized: "settings.icon.original", defaultValue: "Original")
        case .crimson: String(localized: "settings.icon.crimson", defaultValue: "Crimson")
        case .glacier: String(localized: "settings.icon.glacier", defaultValue: "Glacier")
        case .pearl: String(localized: "settings.icon.pearl", defaultValue: "Pearl")
        }
    }

    var splashArtworkName: String {
        self == .original ? "LaunchArtwork" : "LaunchArtwork-" + rawValue
    }

    var previewName: String { "IconPreview-" + rawValue }
}
