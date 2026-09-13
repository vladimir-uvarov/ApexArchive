//
// DriverLifeStoriesTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

@MainActor final class DriverLifeStoriesTests: XCTestCase {
    func testTabAppearsOnlyForMatchingDriverAndDisappearsAfterRefresh() async {
        let driver = ArchiveFixtures.driver()
        let story = DriverLifeStory(
            id: "life", driverSourceID: driver.sourceID ?? driver.id,
            title: "A sourced story", body: "Verified context", source: ArchiveFixtures.source())
        let unrelated = DriverLifeStory(
            id: "other", driverSourceID: "another-driver",
            title: "Another story", body: "Other context", source: ArchiveFixtures.source())
        let full = ArchiveSnapshot(drivers: [driver], cars: [], achievements: [:], lifeStories: [story, unrelated])
        let empty = ArchiveSnapshot(drivers: [driver], cars: [], achievements: [:])
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(full), .success(empty)]))
        let model = DriverDetailViewModel(
            driverID: driver.id, archive: store,
            favorites: FavoritesController(store: TestFavoritesStore()))
        await store.reload()
        XCTAssertEqual(model.lifeStories, [story])
        XCTAssertTrue(model.sections.contains(.beyondRacing))
        await store.reload()
        XCTAssertTrue(model.lifeStories.isEmpty)
        XCTAssertFalse(model.sections.contains(.beyondRacing))
    }

    func testEngineeringStoriesHaveTheirOwnSectionAndBadge() async {
        let driver = ArchiveFixtures.driver()
        let story = DriverLifeStory(
            id: "engineering", driverSourceID: driver.sourceID ?? driver.id,
            title: "A constructor", body: "Sourced contribution", source: ArchiveFixtures.source(),
            contribution: .carBuilder)
        let snapshot = ArchiveSnapshot(drivers: [driver], cars: [], achievements: [:], lifeStories: [story])
        let store = ArchiveStore(
            repository: ScriptedArchiveRepository([.success(snapshot), .success(ArchiveFixtures.snapshot())]))
        let model = DriverDetailViewModel(
            driverID: driver.id, archive: store, favorites: FavoritesController(store: TestFavoritesStore()))
        await store.reload()
        XCTAssertEqual(model.engineeringStories, [story])
        XCTAssertTrue(model.lifeStories.isEmpty)
        XCTAssertTrue(model.sections.contains(.engineering))
        XCTAssertFalse(model.sections.contains(.beyondRacing))
        XCTAssertEqual(DriversViewModel(archive: store).contribution(for: driver), .carBuilder)
        await store.reload()
        XCTAssertTrue(model.engineeringStories.isEmpty)
        XCTAssertFalse(model.sections.contains(.engineering))
        XCTAssertNil(DriversViewModel(archive: store).contribution(for: driver))
    }

    func testMissingDriverNeverReceivesStories() {
        let model = DriverDetailViewModel(
            driverID: "missing", archive: ArchiveStore(repository: ScriptedArchiveRepository([])),
            favorites: FavoritesController(store: TestFavoritesStore()))
        XCTAssertTrue(model.lifeStories.isEmpty)
        XCTAssertFalse(model.sections.contains(.beyondRacing))
    }

    func testCareerHistoryMatchesSourceIdentifierAndSortsNewestFirst() async {
        let driver = ArchiveFixtures.driver()
        let seasons = [1990, 1991].map {
            DriverCareerSeason(
                driverSourceID: driver.sourceID ?? driver.id, year: $0,
                starts: 10, wins: 1, podiums: 2, position: 3, source: ArchiveFixtures.source())
        }

        let snapshot = ArchiveSnapshot(drivers: [driver], cars: [], achievements: [:], careerSeasons: seasons)
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(snapshot)]))
        let model = DriverDetailViewModel(
            driverID: driver.id, archive: store,
            favorites: FavoritesController(store: TestFavoritesStore()))
        await store.reload()
        XCTAssertEqual(model.careerSeasons.map(\.year), [1991, 1990])
    }

}
