//
// PlaceKind.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

/// Separates collections you visit indoors from the circuits and landmarks themselves.
enum PlaceKind: String, CaseIterable, Identifiable {
    case museum
    case landmark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .museum: String(localized: "places.kind.museum", defaultValue: "Museums and collections")
        case .landmark: String(localized: "places.kind.landmark", defaultValue: "Circuits and landmarks")
        }
    }

    var symbol: String {
        switch self {
        case .museum: "building.columns"
        case .landmark: "flag.checkered"
        }
    }
}
