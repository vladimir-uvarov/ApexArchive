//
// DriverSort.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public enum DriverSort: String, CaseIterable, Identifiable {
    case featured, era, country, wins

    public var id: Self { self }

    public var title: String {
        switch self {
        case .featured: String(localized: "driver_sort.featured", defaultValue: "Featured")
        case .era: String(localized: "driver_sort.era", defaultValue: "Era · earliest debut first")
        case .country: String(localized: "driver_sort.country", defaultValue: "Country · A–Z")
        case .wins: String(localized: "driver_sort.wins", defaultValue: "Wins · highest first")
        }
    }
}
