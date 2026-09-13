//
// EditorialText.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

enum EditorialText {
    static func value(_ english: String, key: String) -> String {
        Bundle.main.localizedString(forKey: key, value: english, table: "Localizable")
    }
}
