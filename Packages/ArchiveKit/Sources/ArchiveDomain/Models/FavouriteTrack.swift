//
// FavouriteTrack.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct FavouriteTrack: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let country: String
    public let attribution: String
    public let source: EditorialSource

    public init(id: String, name: String, country: String, attribution: String, source: EditorialSource) {
        self.id = id
        self.name = name
        self.country = country
        self.attribution = attribution
        self.source = source
    }
}
