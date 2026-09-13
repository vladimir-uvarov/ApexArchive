//
// RacingCatalogTeamOrderTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchiveTestSupport
import XCTest

final class RacingCatalogTeamOrderTests: XCTestCase {
    func testTeamsAreOrderedByDebutThenName() {
        let catalog = RacingCatalog(
            circuits: [],
            teams: [
                ArchiveFixtures.team(id: "williams", name: "Williams", firstYear: 1977),
                ArchiveFixtures.team(id: "maserati", name: "Maserati", firstYear: 1950),
                ArchiveFixtures.team(id: "alfa", name: "Alfa Romeo", firstYear: 1950),
            ])
        XCTAssertEqual(catalog.teamsByDebut.map(\.id), ["alfa", "maserati", "williams"])
        XCTAssertEqual(catalog.teams.map(\.id), ["williams", "maserati", "alfa"], "source order is preserved")
    }
}
