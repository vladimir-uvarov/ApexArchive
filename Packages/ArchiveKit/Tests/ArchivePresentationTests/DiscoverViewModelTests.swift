//
// DiscoverViewModelTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

@MainActor final class DiscoverViewModelTests: XCTestCase {
    func testConsecutiveVisitsSelectDifferentDrivers() async {
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(ActivityFixtures.snapshot())]))
        await store.reload()
        let first = DiscoverViewModel(archive: store, visitIndex: 0)
        let next = DiscoverViewModel(archive: store, visitIndex: 1)
        XCTAssertNotNil(first.featuredDriver)
        XCTAssertNotEqual(first.featuredDriver?.id, next.featuredDriver?.id)
        XCTAssertEqual(first.featuredDriver?.id, first.featuredDriver?.id, "Reading must not reshuffle content")
    }

    func testShuffleAdvancesSelectionAndNotifiesPersistence() async {
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(ActivityFixtures.snapshot())]))
        await store.reload()
        var persisted: [Int] = []
        let model = DiscoverViewModel(archive: store, selectionChanged: { persisted.append($0) })
        let original = model.featuredDriver?.id
        model.nextSelection()
        XCTAssertNotEqual(original, model.featuredDriver?.id)
        XCTAssertEqual(persisted, [1])
    }

    func testEmptyCatalogAndCounterOverflowAreSafe() {
        let model = DiscoverViewModel(
            archive: ArchiveStore(repository: ScriptedArchiveRepository([])), visitIndex: Int.max)
        XCTAssertNil(model.featuredDriver)
        XCTAssertNil(model.featuredCar)
        XCTAssertNil(model.featuredCircuit)
        XCTAssertNil(model.featuredTeam)
        model.nextSelection()
        XCTAssertEqual(model.selectionIndex, 0)
    }

    func testDriverOrderChangesDoNotReshuffleCurrentSelection() async {
        let first = ActivityFixtures.snapshot()
        let reversed = ArchiveSnapshot(
            drivers: first.drivers.reversed(), cars: first.cars, achievements: first.achievements)
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(first), .success(reversed)]))
        await store.reload()
        let model = DiscoverViewModel(archive: store, visitIndex: 3)
        let original = model.featuredDriver?.id
        await store.reload()
        XCTAssertEqual(model.featuredDriver?.id, original)
    }

    func testStorySelectionSkipsMissingDriversAndRotates() async {
        let driver = ArchiveFixtures.driver()
        let stories = ["first", "second"].map {
            DriverLifeStory(
                id: $0, driverSourceID: driver.sourceID ?? driver.id,
                title: $0, body: "Story", source: ArchiveFixtures.source())
        }

        let orphan = DriverLifeStory(
            id: "absent", driverSourceID: "missing", title: "Absent",
            body: "Story", source: ArchiveFixtures.source())
        let snapshot = ArchiveSnapshot(drivers: [driver], cars: [], achievements: [:], lifeStories: stories + [orphan])
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(snapshot)]))
        await store.reload()
        let model = DiscoverViewModel(archive: store)
        XCTAssertEqual(model.featuredLifeStory?.id, "first")
        XCTAssertEqual(model.featuredStoryDriver?.id, driver.id)
        model.nextSelection()
        XCTAssertEqual(model.featuredLifeStory?.id, "second")
    }

}
