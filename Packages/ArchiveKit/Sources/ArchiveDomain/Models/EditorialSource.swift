//
// EditorialSource.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct EditorialSource: Codable, Hashable, Sendable {
    public let title: String
    public let url: URL
    public let checkedOn: String

    public init(title: String, url: URL, checkedOn: String) {
        self.title = title
        self.url = url
        self.checkedOn = checkedOn
    }
}
