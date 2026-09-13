//
// CountryFlag.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

/// Unicode regional indicators; the country name is displayed alongside the flag.
enum CountryFlag {
    static func symbol(for code: String) -> String {
        let scalars = code.uppercased().unicodeScalars
        guard scalars.count == 2, scalars.allSatisfy({ (65...90).contains($0.value) }) else { return "" }
        return scalars.compactMap { UnicodeScalar(127397 + $0.value) }.map(String.init).joined()
    }
}
