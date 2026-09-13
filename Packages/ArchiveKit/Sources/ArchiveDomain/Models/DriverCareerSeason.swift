//
// DriverCareerSeason.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public struct DriverCareerSeason: Codable, Equatable, Identifiable, Sendable {
    public let driverSourceID: String
    public let year: Int
    public let starts: Int
    public let wins: Int
    public let podiums: Int
    public let position: Int?
    public let source: EditorialSource
    public var id: String { "\(driverSourceID).\(year)" }

    public init(
        driverSourceID: String, year: Int, starts: Int, wins: Int, podiums: Int,
        position: Int?, source: EditorialSource
    ) {
        self.driverSourceID = driverSourceID
        self.year = year
        self.starts = starts
        self.wins = wins
        self.podiums = podiums
        self.position = position
        self.source = source
    }
}
