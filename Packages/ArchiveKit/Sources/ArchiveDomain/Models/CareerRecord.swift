//
// CareerRecord.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct CareerRecord: Codable, Hashable, Sendable {
    public let count: Int
    public let scope: String
    public let note: String
    public let source: EditorialSource

    public init(count: Int, scope: String, note: String, source: EditorialSource) {
        self.count = count
        self.scope = scope
        self.note = note
        self.source = source
    }
}
