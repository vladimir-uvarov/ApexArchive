//
// DriverSortingTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

@MainActor final class DriverSortingTests: XCTestCase {
    func testSortingComposesWithSearchAndPutsMissingDataLast() async {
        let drivers = [
            driver("modern", country: "Australia", debut: 2020),
            driver("classic", country: "Brazil", debut: 1984),
            driver("unknown", country: "Australia", debut: nil),
        ]
        let wins = CareerRecord(count: 41, scope: "Career", note: "Test", source: ArchiveFixtures.source())
        let snapshot = ArchiveSnapshot(
            drivers: drivers, cars: [], achievements: ["classic": DriverAchievements(wins: wins)])
        let archive = ArchiveStore(repository: ScriptedArchiveRepository([.success(snapshot)]))
        await archive.reload()
        let model = DriversViewModel(archive: archive)
        model.sort = .era
        XCTAssertEqual(model.drivers.map(\.id), ["classic", "modern", "unknown"])
        model.sort = .country
        XCTAssertEqual(model.drivers.map(\.id), ["modern", "unknown", "classic"])
        model.sort = .wins
        XCTAssertEqual(model.drivers.first?.id, "classic")
        model.query = "Australia"
        XCTAssertEqual(model.drivers.map(\.id), ["modern", "unknown"])
        model.query = ""
        model.sort = .featured
        XCTAssertEqual(model.drivers.map(\.id), drivers.map(\.id))
    }

    private func driver(_ name: String, country: String, debut: Int?) -> Driver {
        Driver(
            id: name, name: name, country: country, category: .archive, subtitle: "", biography: "", firstSeason: debut)
    }
}
