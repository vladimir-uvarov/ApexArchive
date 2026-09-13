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
        let model = DiscoverViewModel(archive: store, date: Date(timeIntervalSince1970: 0))
        // Which of the two is shown depends on the day; the orphan must never be, and a shuffle
        // must move to the other one.
        let shown = model.featuredLifeStory?.id
        XCTAssertTrue(["first", "second"].contains(shown ?? ""), "the orphan story has no driver to open")
        XCTAssertEqual(model.featuredStoryDriver?.id, driver.id)
        model.nextSelection()
        XCTAssertNotEqual(model.featuredLifeStory?.id, shown)
        XCTAssertTrue(["first", "second"].contains(model.featuredLifeStory?.id ?? ""))
    }

    func testContentRotatesWithTheDayWithoutAShuffle() async {
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(ActivityFixtures.snapshot())]))
        await store.reload()
        let day = TimeInterval(86_400)
        let today = DiscoverViewModel(archive: store, date: Date(timeIntervalSince1970: 0))
        let tomorrow = DiscoverViewModel(archive: store, date: Date(timeIntervalSince1970: day))
        XCTAssertNotEqual(today.featuredDriver?.id, tomorrow.featuredDriver?.id)
    }

    func testTheSameDayAlwaysGivesTheSameSelection() async {
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(ActivityFixtures.snapshot())]))
        await store.reload()
        let morning = DiscoverViewModel(archive: store, date: Date(timeIntervalSince1970: 1_000))
        let evening = DiscoverViewModel(archive: store, date: Date(timeIntervalSince1970: 80_000))
        XCTAssertEqual(morning.featuredDriver?.id, evening.featuredDriver?.id)
        XCTAssertEqual(morning.featuredCar?.car.id, evening.featuredCar?.car.id)
    }

    /// Without per-collection salts every spotlight stepped to the same offset, so a shuffle only
    /// ever produced one pairing of driver, car and story.
    func testSpotlightsDoNotAdvanceInLockstep() async {
        let drivers = (0..<4).map { ArchiveFixtures.driver(id: "driver-\($0)", name: "Driver \($0)") }

        let cars = (0..<4).map { ArchiveFixtures.car(id: "car-\($0)", driverID: "driver-\($0)") }

        let snapshot = ArchiveSnapshot(drivers: drivers, cars: cars, achievements: [:])
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(snapshot)]))
        await store.reload()
        let model = DiscoverViewModel(archive: store, date: Date(timeIntervalSince1970: 0))
        let driverIndex = try? XCTUnwrap(drivers.firstIndex { $0.id == model.featuredDriver?.id })
        let carIndex = try? XCTUnwrap(cars.firstIndex { $0.id == model.featuredCar?.car.id })
        XCTAssertNotEqual(driverIndex, carIndex, "the driver and car salts must not resolve to one offset")
    }
}
