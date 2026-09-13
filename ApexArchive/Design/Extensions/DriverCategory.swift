//
// DriverCategory.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

extension DriverCategory {
    var title: String {
        switch self {
        case .risingStars: return String(localized: "driver_category.rising", defaultValue: "Rising stars")
        case .modern: return String(localized: "driver_category.modern.icons", defaultValue: "Modern icons")
        case .legends: return String(localized: "driver_category.legends", defaultValue: "Legends")
        case .archive:
            return String(localized: "driver_category.historical.archive", defaultValue: "Historical archive")
        }
    }
}
