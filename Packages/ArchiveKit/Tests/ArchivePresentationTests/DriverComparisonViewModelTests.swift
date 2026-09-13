//
// DriverComparisonViewModelTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

@MainActor final class DriverComparisonViewModelTests: XCTestCase {
    func testDefaultsToTwoHighestRecordedWinTotals() {
        let model = DriverComparisonViewModel(snapshot: ActivityFixtures.snapshot())
        XCTAssertEqual(model.firstID, "driver-11")
        XCTAssertEqual(model.secondID, "driver-10")
    }

    func testSelectionRejectsOtherSideAndUnknownDrivers() throws {
        let snapshot = ActivityFixtures.snapshot()
        let model = DriverComparisonViewModel(snapshot: snapshot)
        let initial = model.firstID
        model.select(try XCTUnwrap(model.second), forFirst: true)
        model.select(ArchiveFixtures.driver(id: "unknown"), forFirst: true)
        XCTAssertEqual(model.firstID, initial)
        model.select(snapshot.drivers[0], forFirst: true)
        XCTAssertEqual(model.firstID, snapshot.drivers[0].id)
        model.select(snapshot.drivers[0], forFirst: false)
        XCTAssertNotEqual(model.firstID, model.secondID)
    }

    func testCandidatesExcludeTheOtherSideAndIgnoreDiacritics() {
        let snapshot = ArchiveSnapshot(
            drivers: [
                ArchiveFixtures.driver(id: "raikkonen", name: "Kimi Räikkönen"),
                ArchiveFixtures.driver(id: "senna", name: "Ayrton Senna"),
            ], cars: [], achievements: [:])
        let model = DriverComparisonViewModel(snapshot: snapshot)
        XCTAssertEqual(model.candidates(excluding: "senna", matching: "").map(\.id), ["raikkonen"])
        XCTAssertEqual(model.candidates(excluding: nil, matching: "raikkonen").map(\.id), ["raikkonen"])
        XCTAssertEqual(
            model.candidates(excluding: nil, matching: "").map(\.name), ["Ayrton Senna", "Kimi Räikkönen"])
        XCTAssertTrue(model.candidates(excluding: "raikkonen", matching: "raikkonen").isEmpty)
    }

    func testSwapPreservesPairAndDoesNotInventMissingRecords() {
        let model = DriverComparisonViewModel(snapshot: ActivityFixtures.snapshot())
        let first = model.firstID
        let second = model.secondID
        model.swap()
        XCTAssertEqual(model.firstID, second)
        XCTAssertEqual(model.secondID, first)
        let incomplete = DriverComparisonViewModel(snapshot: ArchiveFixtures.snapshot())
        XCTAssertNotNil(incomplete.first)
        XCTAssertNil(incomplete.second)
        XCTAssertTrue(incomplete.snapshot.achievements.isEmpty)
        let empty = DriverComparisonViewModel(snapshot: .empty)
        XCTAssertNil(empty.first)
        XCTAssertNil(empty.second)
    }
}
