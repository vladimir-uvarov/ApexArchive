//
// RacingTeam.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct RacingTeam: Codable, Equatable, Sendable, Identifiable {
    public let id: String
    public let name: String
    public let country: String
    public let countryCode: String
    public let firstYear: Int
    public let lastYear: Int
    public let wins: Int
    public let championships: Int
    public let firstWinYear: Int?
    public let firstTitleYear: Int?
    public let source: EditorialSource

    public init(
        id: String, name: String, country: String, countryCode: String, firstYear: Int, lastYear: Int, wins: Int,
        championships: Int, firstWinYear: Int?, firstTitleYear: Int?, source: EditorialSource
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.countryCode = countryCode
        self.firstYear = firstYear
        self.lastYear = lastYear
        self.wins = wins
        self.championships = championships
        self.firstWinYear = firstWinYear
        self.firstTitleYear = firstTitleYear
        self.source = source
    }
}
