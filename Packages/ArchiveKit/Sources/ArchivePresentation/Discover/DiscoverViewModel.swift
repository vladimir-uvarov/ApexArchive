//
// DiscoverViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class DiscoverViewModel {
    private let archive: ArchiveStore
    private let selectionChanged: (Int) -> Void
    public private(set) var selectionIndex: Int

    private let dayIndex: Int

    public init(
        archive: ArchiveStore, visitIndex: Int = 0, date: Date = Date(),
        selectionChanged: @escaping (Int) -> Void = { _ in }
    ) {
        self.selectionChanged = selectionChanged
        self.archive = archive
        selectionIndex = max(0, visitIndex)
        dayIndex = Self.day(for: date)
    }

    /// Whole UTC days since the epoch, so the screen presents different content tomorrow without a
    /// timer and without storing anything. The same day and the same archive give the same picks.
    private static func day(for date: Date) -> Int {
        Int((date.timeIntervalSince1970 / 86_400).rounded(.down))
    }

    public var snapshot: ArchiveSnapshot { archive.snapshot }

    public var featuredDriver: Driver? {
        let curated = snapshot.drivers.filter { $0.category != .archive }.sorted { $0.id < $1.id }
        return select(curated.isEmpty ? snapshot.drivers : curated, salt: 0)
    }

    public var featuredCar: GarageEntry? {
        guard let car = select(snapshot.cars.sorted { $0.id < $1.id }, salt: 1),
            let driver = snapshot.drivers.first(where: { $0.id == car.driverID })
        else { return nil }
        return GarageEntry(car: car, driver: driver)
    }

    public var featuredCircuit: Circuit? {
        select((snapshot.catalog?.circuits ?? []).filter { $0.outline != nil }.sorted { $0.id < $1.id }, salt: 2)
    }

    public var featuredLifeStory: DriverLifeStory? {
        let identifiers = Set(snapshot.drivers.map { $0.sourceID ?? $0.id })
        return select(
            (snapshot.lifeStories ?? []).filter { identifiers.contains($0.driverSourceID) }.sorted { $0.id < $1.id },
            salt: 3)
    }

    public var featuredStoryDriver: Driver? {
        guard let story = featuredLifeStory else { return nil }
        return snapshot.drivers.first { ($0.sourceID ?? $0.id) == story.driverSourceID }
    }

    public var featuredTeam: RacingTeam? {
        select((snapshot.catalog?.teams ?? []).sorted { $0.id < $1.id }, salt: 4)
    }

    public var storyMetrics: [CareerMetric] {
        let available = CareerMetric.allCases.filter { !CareerLeaderboard.entries(in: snapshot, metric: $0).isEmpty }
        guard !available.isEmpty else { return [] }

        let offset = Self.rotation(selectionIndex &+ dayIndex, count: available.count)
        return Array(available[offset...] + available[..<offset])
    }

    public func nextSelection() {
        selectionIndex = selectionIndex == Int.max ? 0 : selectionIndex + 1
        selectionChanged(selectionIndex)
    }

    /// `salt` keeps the spotlights from advancing in lockstep, so a shuffle changes the combination
    /// rather than stepping every collection to the same offset.
    private func select<Item>(_ items: [Item], salt: Int) -> Item? {
        guard !items.isEmpty else { return nil }

        return items[Self.rotation(selectionIndex &+ dayIndex &+ salt, count: items.count)]
    }

    private static func rotation(_ value: Int, count: Int) -> Int {
        count <= 0 ? 0 : ((value % count) + count) % count
    }
}
