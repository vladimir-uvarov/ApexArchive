//
// CareerLeaderboardTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchiveTestSupport
import XCTest

final class CareerLeaderboardTests: XCTestCase {
    func testMissingAndZeroValuesAreNotInventedAsRecords() {
        let snapshot = ActivityFixtures.snapshot()
        XCTAssertTrue(CareerLeaderboard.entries(in: snapshot, metric: .championships).isEmpty)
        XCTAssertTrue(CareerLeaderboard.entries(in: snapshot, metric: .wins).allSatisfy { $0.record.count > 0 })
    }

    func testLeaderboardOrdersByTotalAndPreservesEvidence() {
        let snapshot = ActivityFixtures.snapshot()
        let entries = CareerLeaderboard.entries(in: snapshot, metric: .wins)
        XCTAssertEqual(entries.map(\.record.count), entries.map(\.record.count).sorted(by: >))
        XCTAssertEqual(
            entries.first?.record.source, snapshot.achievements[entries.first?.driver.id ?? ""]?.wins?.source)
    }

    func testNegativeNewStatisticsAreRejected() {
        let driver = ArchiveFixtures.driver()
        let record = CareerRecord(count: -1, scope: "Podiums", note: "Test", source: ArchiveFixtures.source())
        let snapshot = ArchiveSnapshot(
            drivers: [driver], cars: [], achievements: [driver.id: DriverAchievements(podiums: record)])
        XCTAssertThrowsError(try snapshot.validated())
    }
}
