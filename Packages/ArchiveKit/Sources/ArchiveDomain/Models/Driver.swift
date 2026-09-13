//
// Driver.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct Driver: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let country: String
    public let category: DriverCategory
    public let subtitle: String
    public let biography: String
    public let sourceID: String?
    public let wikipediaTitle: String?
    public let firstSeason: Int?

    public var initials: String {
        name.split(separator: " ").compactMap(\.first).map(String.init).joined()
    }

    public init(
        id: String, name: String, country: String, category: DriverCategory,
        subtitle: String, biography: String, sourceID: String? = nil, wikipediaTitle: String? = nil,
        firstSeason: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.category = category
        self.subtitle = subtitle
        self.biography = biography
        self.sourceID = sourceID
        self.wikipediaTitle = wikipediaTitle
        self.firstSeason = firstSeason
    }
}
