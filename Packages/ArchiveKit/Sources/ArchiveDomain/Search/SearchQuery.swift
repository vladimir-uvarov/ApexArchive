//
// SearchQuery.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct SearchQuery: Equatable, Sendable {
    private let terms: [String]
    public init(_ text: String) {
        terms = Self.normalize(text).split(whereSeparator: \.isWhitespace).map(String.init)
    }

    public func matches(_ text: String) -> Bool {
        let normalized = Self.normalize(text)
        return terms.allSatisfy { normalized.contains($0) }
    }

    private static func normalize(_ text: String) -> String {
        text.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "en_US_POSIX"))
    }
}
