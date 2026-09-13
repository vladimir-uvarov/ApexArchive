//
// ArchiveSnapshotTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchiveTestSupport
import XCTest

final class ArchiveSnapshotTests: XCTestCase {
    func testValidArchiveRoundTripsWithoutInventingRecords() throws {
        let snapshot = ArchiveFixtures.snapshot()
        let decoded = try JSONDecoder().decode(ArchiveSnapshot.self, from: JSONEncoder().encode(snapshot))
        XCTAssertEqual(try decoded.validated(), snapshot)
        XCTAssertNil(decoded.achievements["senna"]?.wins)
    }

    func testRejectsDuplicateProviderIdentifiersBeforeMapping() {
        let first = Driver(
            id: "first", name: "First", country: "Brazil", category: .archive,
            subtitle: "", biography: "", sourceID: "same-source")
        let second = Driver(
            id: "second", name: "Second", country: "Brazil", category: .archive,
            subtitle: "", biography: "", sourceID: "same-source")
        XCTAssertThrowsError(try ArchiveSnapshot(drivers: [first, second], cars: [], achievements: [:]).validated()) {
            XCTAssertEqual($0 as? ArchiveValidationError, .duplicateSourceIdentifier)
        }
    }

    func testRejectsDuplicateDrivers() {
        let driver = ArchiveFixtures.driver()
        XCTAssertThrowsError(try ArchiveSnapshot(drivers: [driver, driver], cars: [], achievements: [:]).validated()) {
            XCTAssertEqual($0 as? ArchiveValidationError, .duplicateDriver)
        }
    }

    func testRejectsOrphanedCar() {
        XCTAssertThrowsError(
            try ArchiveSnapshot(drivers: [], cars: [ArchiveFixtures.car()], achievements: [:]).validated())
    }

    func testRejectsDuplicateCar() {
        XCTAssertThrowsError(
            try ArchiveSnapshot(
                drivers: [ArchiveFixtures.driver()], cars: [ArchiveFixtures.car(), ArchiveFixtures.car()],
                achievements: [:]
            ).validated())
    }

    func testRejectsUnknownFeaturedDriver() {
        XCTAssertThrowsError(
            try ArchiveSnapshot(drivers: [], cars: [], achievements: [:], featuredDriverID: "missing").validated())
    }

    func testRejectsInsecureSource() {
        let car = ArchiveFixtures.car(source: ArchiveFixtures.source(scheme: "http").url)
        XCTAssertThrowsError(
            try ArchiveSnapshot(drivers: [ArchiveFixtures.driver()], cars: [car], achievements: [:]).validated())
    }

    func testRejectsNegativeRecord() {
        let record = CareerRecord(count: -1, scope: "Wins", note: "", source: ArchiveFixtures.source())
        XCTAssertThrowsError(
            try ArchiveSnapshot(
                drivers: [ArchiveFixtures.driver()], cars: [], achievements: ["senna": DriverAchievements(wins: record)]
            ).validated())
    }

    func testAcceptsZeroWinsAsKnownValue() throws {
        let record = CareerRecord(count: 0, scope: "Wins", note: "", source: ArchiveFixtures.source())
        let snapshot = try ArchiveSnapshot(
            drivers: [ArchiveFixtures.driver()], cars: [], achievements: ["senna": DriverAchievements(wins: record)]
        ).validated()
        XCTAssertEqual(snapshot.achievements["senna"]?.wins?.count, 0)
    }

    func testRejectsOrphanedAchievements() {
        XCTAssertThrowsError(
            try ArchiveSnapshot(drivers: [], cars: [], achievements: ["missing": DriverAchievements()]).validated())
    }

    func testRejectsBlankDriverName() {
        XCTAssertThrowsError(
            try ArchiveSnapshot(drivers: [ArchiveFixtures.driver(name: "  ")], cars: [], achievements: [:]).validated())
    }
}
