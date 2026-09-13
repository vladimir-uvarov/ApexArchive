//
// DiscoverViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Observation

@Observable @MainActor public final class DiscoverViewModel {
    private let archive: ArchiveStore
    private let selectionChanged: (Int) -> Void
    public private(set) var selectionIndex: Int

    public init(archive: ArchiveStore, visitIndex: Int = 0, selectionChanged: @escaping (Int) -> Void = { _ in }) {
        self.selectionChanged = selectionChanged
        self.archive = archive
        selectionIndex = max(0, visitIndex)
    }

    public var snapshot: ArchiveSnapshot { archive.snapshot }

    public var featuredDriver: Driver? {
        let curated = snapshot.drivers.filter { $0.category != .archive }.sorted { $0.id < $1.id }
        return select(curated.isEmpty ? snapshot.drivers : curated)
    }

    public var featuredCar: GarageEntry? {
        guard let car = select(snapshot.cars.sorted { $0.id < $1.id }),
            let driver = snapshot.drivers.first(where: { $0.id == car.driverID })
        else { return nil }
        return GarageEntry(car: car, driver: driver)
    }

    public var featuredCircuit: Circuit? {
        select((snapshot.catalog?.circuits ?? []).filter { $0.outline != nil }.sorted { $0.id < $1.id })
    }

    public var featuredLifeStory: DriverLifeStory? {
        let identifiers = Set(snapshot.drivers.map { $0.sourceID ?? $0.id })
        return select(
            (snapshot.lifeStories ?? []).filter { identifiers.contains($0.driverSourceID) }.sorted { $0.id < $1.id })
    }

    public var featuredStoryDriver: Driver? {
        guard let story = featuredLifeStory else { return nil }
        return snapshot.drivers.first { ($0.sourceID ?? $0.id) == story.driverSourceID }
    }

    public var featuredTeam: RacingTeam? {
        select((snapshot.catalog?.teams ?? []).sorted { $0.id < $1.id })
    }

    public var storyMetrics: [CareerMetric] {
        let available = CareerMetric.allCases.filter { !CareerLeaderboard.entries(in: snapshot, metric: $0).isEmpty }
        guard !available.isEmpty else { return [] }

        let offset = selectionIndex % available.count
        return Array(available[offset...] + available[..<offset])
    }

    public func nextSelection() {
        selectionIndex = selectionIndex == Int.max ? 0 : selectionIndex + 1
        selectionChanged(selectionIndex)
    }

    private func select<Item>(_ items: [Item]) -> Item? {
        items.isEmpty ? nil : items[selectionIndex % items.count]
    }
}
