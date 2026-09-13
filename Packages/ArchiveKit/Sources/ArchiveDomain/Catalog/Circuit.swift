//
// Circuit.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct Circuit: Codable, Equatable, Sendable, Identifiable {
    public let id: String
    public let name: String
    public let place: String
    public let country: String
    public let countryCode: String
    public let layoutID: String?
    public let length: Double?
    public let turns: Int?
    public let firstYear: Int?
    public let lastYear: Int?
    public let raceCount: Int
    public let record: CircuitLapRecord?
    public let outline: CircuitOutline?
    public let source: EditorialSource

    public init(
        id: String, name: String, place: String, country: String, countryCode: String, layoutID: String?,
        length: Double?, turns: Int?, firstYear: Int?, lastYear: Int?, raceCount: Int, record: CircuitLapRecord?,
        outline: CircuitOutline?, source: EditorialSource
    ) {
        self.id = id
        self.name = name
        self.place = place
        self.country = country
        self.countryCode = countryCode
        self.layoutID = layoutID
        self.length = length
        self.turns = turns
        self.firstYear = firstYear
        self.lastYear = lastYear
        self.raceCount = raceCount
        self.record = record
        self.outline = outline
        self.source = source
    }
}
