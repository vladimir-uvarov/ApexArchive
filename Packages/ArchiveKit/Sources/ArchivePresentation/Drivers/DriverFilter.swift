//
// DriverFilter.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

public enum DriverFilter: CaseIterable, Identifiable {
    case all, modern, legends, risingStars, engineering
    public var id: Self { self }

    public var title: String {
        switch self {
        case .risingStars: return String(localized: "driver_category.rising", defaultValue: "Rising stars")
        case .engineering: return String(localized: "profile_section.engineering", defaultValue: "Cars & engineering")
        case .all: return String(localized: "driver_filter.all.drivers", defaultValue: "All drivers")
        case .modern: return String(localized: "driver_filter.modern.icons", defaultValue: "Modern icons")
        case .legends: return String(localized: "driver_filter.legends", defaultValue: "Legends")
        }
    }

    public func includes(_ driver: Driver, contribution: DriverContribution? = nil) -> Bool {
        switch self {
        case .risingStars: return driver.category == .risingStars
        case .engineering: return contribution != nil
        case .all: return true
        case .modern: return driver.category == .modern
        case .legends: return driver.category == .legends
        }
    }
}
