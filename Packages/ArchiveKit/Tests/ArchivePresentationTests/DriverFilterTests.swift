//
// DriverFilterTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

final class DriverFilterTests: XCTestCase {
    func testRisingStarsAreIncludedOnlyInTheirCollectionAndAllDrivers() {
        for category in [DriverCategory.modern, .legends, .risingStars, .archive] {
            let driver = Driver(
                id: "driver", name: "Driver", country: "Country", category: category,
                subtitle: "", biography: "")
            XCTAssertEqual(DriverFilter.risingStars.includes(driver), category == .risingStars)
            XCTAssertTrue(DriverFilter.all.includes(driver))
            if category == .risingStars {
                XCTAssertFalse(DriverFilter.modern.includes(driver))
                XCTAssertFalse(DriverFilter.legends.includes(driver))
            }
        }
    }
    @MainActor func testEngineeringFilterCombinesWithSearchAndRefresh() async {
        let driver = ArchiveFixtures.driver()
        let story = DriverLifeStory(
            id: "engineering", driverSourceID: driver.sourceID ?? driver.id,
            title: "Contribution", body: "Sourced context", source: ArchiveFixtures.source(),
            contribution: .engineering)
        let snapshot = ArchiveSnapshot(drivers: [driver], cars: [], achievements: [:], lifeStories: [story])
        let archive = ArchiveStore(
            repository: ScriptedArchiveRepository([
                .success(snapshot), .success(ArchiveFixtures.snapshot()),
            ]))
        let model = DriversViewModel(archive: archive)
        model.show(.engineering)
        await archive.reload()
        XCTAssertEqual(model.drivers.map(\.id), [driver.id])
        model.query = "No matching person"
        XCTAssertTrue(model.drivers.isEmpty)
        model.query = ""
        await archive.reload()
        XCTAssertTrue(model.drivers.isEmpty)
    }

    func testEngineeringFilterIncludesBuildersAndEngineersOnly() {
        let driver = ArchiveFixtures.driver()
        XCTAssertTrue(DriverFilter.engineering.includes(driver, contribution: .carBuilder))
        XCTAssertTrue(DriverFilter.engineering.includes(driver, contribution: .engineering))
        XCTAssertFalse(DriverFilter.engineering.includes(driver))
    }

}
