//
// FeatureViewModelTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import Observation
import XCTest

@MainActor final class FeatureViewModelTests: XCTestCase {
    func testOptionalDetailSectionsFollowAvailableContent() async {
        let empty = ArchiveSnapshot(drivers: [ArchiveFixtures.driver()], cars: [], achievements: [:])
        let track = FavouriteTrack(
            id: "spa", name: "Spa", country: "Belgium", attribution: "Attributed preference",
            source: ArchiveFixtures.source())
        let populated = ArchiveSnapshot(
            drivers: empty.drivers, cars: [ArchiveFixtures.car()],
            achievements: ["senna": DriverAchievements(favouriteTracks: [track])])
        let archive = ArchiveStore(
            repository: ScriptedArchiveRepository([.success(empty), .success(populated), .success(empty)]))
        let model = DriverDetailViewModel(
            driverID: "senna", archive: archive, favorites: FavoritesController(store: TestFavoritesStore()))
        await archive.reload()
        XCTAssertEqual(model.sections, [.story, .wins, .fastestLaps])
        await archive.reload()
        XCTAssertEqual(
            model.sections, DriverDetailSection.allCases.filter { $0 != .beyondRacing && $0 != .engineering })
        await archive.reload()
        XCTAssertEqual(model.sections, [.story, .wins, .fastestLaps])
    }

    func testOpenDetailUsesNewRecordsAfterArchiveRefresh() async {
        let driver = ArchiveFixtures.driver()
        let record = CareerRecord(count: 41, scope: "Career", note: "Test", source: ArchiveFixtures.source())
        let updated = ArchiveSnapshot(
            drivers: [driver], cars: [], achievements: [driver.id: DriverAchievements(wins: record)])
        let archive = ArchiveStore(
            repository: ScriptedArchiveRepository([.success(ArchiveFixtures.snapshot()), .success(updated)]))
        await archive.reload()
        let model = DriverDetailViewModel(
            driverID: driver.id, archive: archive, favorites: FavoritesController(store: TestFavoritesStore()))
        XCTAssertNil(model.achievements.wins)
        await archive.reload()
        XCTAssertEqual(model.achievements.wins?.count, 41)
    }

    func testSearchAndCategoryComposeWithoutChangingGarageSearch() async {
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(ArchiveFixtures.snapshot())]))
        await store.reload()
        let drivers = DriversViewModel(archive: store)
        let garage = GarageViewModel(archive: store)
        drivers.query = "senna brazil"
        drivers.filter = .modern
        XCTAssertTrue(drivers.drivers.isEmpty)
        drivers.filter = .legends
        XCTAssertEqual(drivers.drivers.count, 1)
        XCTAssertEqual(garage.query, "")
        garage.query = "nsx"
        XCTAssertEqual(garage.entries.first?.driver.id, "senna")
        garage.query = "unknown"
        XCTAssertTrue(garage.entries.isEmpty)
    }

    func testCollectionNavigationResetsOldSearch() {
        let model = DriversViewModel(archive: ArchiveStore(repository: ScriptedArchiveRepository([])))
        model.query = "old"
        model.show(.legends)
        XCTAssertEqual(model.query, "")
        XCTAssertEqual(model.filter, .legends)
    }

    func testFavoritesSynchronizeAcrossDetailAndSaved() async {
        let archive = ArchiveStore(repository: ScriptedArchiveRepository([.success(ArchiveFixtures.snapshot())]))
        await archive.reload()
        let persistence = TestFavoritesStore()
        let favorites = FavoritesController(store: persistence)
        let saved = SavedDriversViewModel(archive: archive, favorites: favorites)
        let detail = DriverDetailViewModel(
            driverID: "senna", archive: archive, favorites: favorites)
        detail.toggleFavorite()
        XCTAssertTrue(detail.isFavorite)
        XCTAssertEqual(persistence.identifiers, ["senna"])
        XCTAssertEqual(saved.drivers.map(\.id), ["senna"])
        detail.toggleFavorite()
        XCTAssertTrue(saved.drivers.isEmpty)
        XCTAssertTrue(persistence.identifiers.isEmpty)
    }

    func testViewModelPublishesWhenArchiveChanges() async {
        let archive = ArchiveStore(repository: ScriptedArchiveRepository([.success(ArchiveFixtures.snapshot())]))
        let model = DriversViewModel(archive: archive)
        let changed = expectation(description: "Nested archive read is observed")
        withObservationTracking {
            _ = model.drivers
        } onChange: {
            changed.fulfill()
        }
        await archive.reload()
        await fulfillment(of: [changed], timeout: 1)
        XCTAssertEqual(model.drivers.count, 1)
    }

    func testDetailPreservesCompleteHistoricalFastestLapTotal() async {
        let record = CareerRecord(
            count: 19, scope: "Career", note: "Complete historical total", source: ArchiveFixtures.source())
        let snapshot = ArchiveSnapshot(
            drivers: [ArchiveFixtures.driver()], cars: [],
            achievements: ["senna": DriverAchievements(fastestLaps: record)])
        let archive = ArchiveStore(repository: ScriptedArchiveRepository([.success(snapshot)]))
        await archive.reload()
        let model = DriverDetailViewModel(
            driverID: "senna", archive: archive, favorites: FavoritesController(store: TestFavoritesStore()))
        XCTAssertEqual(model.achievements.fastestLaps?.count, 19)
        XCTAssertTrue(model.achievements.favouriteTracks.isEmpty)
    }

    func testMissingDriverHasNoInventedProfile() {
        let model = DriverDetailViewModel(
            driverID: "missing", archive: ArchiveStore(repository: ScriptedArchiveRepository([])),
            favorites: FavoritesController(store: TestFavoritesStore()))
        XCTAssertNil(model.driver)
        XCTAssertNil(model.achievements.wins)
        model.toggleFavorite()
        XCTAssertFalse(model.isFavorite)
    }

    func testDetailUsesAttributedFavouriteTracks() async {
        let track = FavouriteTrack(
            id: "spa", name: "Spa", country: "Belgium", attribution: "Documented preference",
            source: ArchiveFixtures.source())
        let snapshot = ArchiveSnapshot(
            drivers: [ArchiveFixtures.driver()], cars: [],
            achievements: ["senna": DriverAchievements(favouriteTracks: [track])])
        let archive = ArchiveStore(repository: ScriptedArchiveRepository([.success(snapshot)]))
        await archive.reload()
        let model = DriverDetailViewModel(
            driverID: "senna", archive: archive, favorites: FavoritesController(store: TestFavoritesStore()))
        XCTAssertEqual(model.achievements.favouriteTracks, [track])
    }

}
