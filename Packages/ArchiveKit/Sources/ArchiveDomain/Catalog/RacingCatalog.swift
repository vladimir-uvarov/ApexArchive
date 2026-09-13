//
// RacingCatalog.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct RacingCatalog: Codable, Equatable, Sendable {
    public let circuits: [Circuit]
    public let teams: [RacingTeam]

    public init(circuits: [Circuit], teams: [RacingTeam]) {
        self.circuits = circuits
        self.teams = teams
    }

    /// Teams ordered by their first archived season, then by name.
    public var teamsByDebut: [RacingTeam] {
        teams.sorted { $0.firstYear == $1.firstYear ? $0.name < $1.name : $0.firstYear < $1.firstYear }
    }

    public func validated() throws -> RacingCatalog {
        guard Set(circuits.map(\.id)).count == circuits.count,
            Set(teams.map(\.id)).count == teams.count
        else { throw ArchiveValidationError.invalidCatalog }
        for circuit in circuits {
            guard !circuit.id.isEmpty, !circuit.name.isEmpty, circuit.raceCount >= 0,
                circuit.source.url.scheme == "https",
                circuit.length.map({ $0.isFinite && $0 > 0 }) ?? true,
                circuit.turns.map({ $0 > 0 }) ?? true
            else { throw ArchiveValidationError.invalidCatalog }
            if let outline = circuit.outline {
                guard circuit.layoutID != nil, outline.source.url.scheme == "https",
                    outline.points.count >= 2, outline.points.count <= 10_000,
                    outline.points.allSatisfy({
                        $0.x.isFinite && $0.y.isFinite && (0...1).contains($0.x) && (0...1).contains($0.y)
                    })
                else { throw ArchiveValidationError.invalidCatalog }
            }
            if let record = circuit.record {
                guard circuit.layoutID != nil, !record.time.isEmpty, !record.driver.isEmpty,
                    record.year >= (circuit.firstYear ?? record.year), record.year <= (circuit.lastYear ?? record.year)
                else { throw ArchiveValidationError.invalidCatalog }
            }
        }
        guard
            teams.allSatisfy({
                !$0.id.isEmpty && !$0.name.isEmpty && $0.wins >= 0 && $0.championships >= 0
                    && $0.firstYear <= $0.lastYear && $0.source.url.scheme == "https"
            })
        else { throw ArchiveValidationError.invalidCatalog }
        return self
    }
}
