//
// CachedArchiveRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

public actor CachedArchiveRepository: ArchiveRepository {
    private let cache: any ArchiveCache
    private let fallback: any ArchiveRepository
    public init(cache: any ArchiveCache, fallback: any ArchiveRepository) {
        self.cache = cache
        self.fallback = fallback
    }

    public func load() async throws -> ArchiveSnapshot {
        let editorial = try await fallback.load()
        guard let cached = try? await cache.read() else { return editorial }

        let editorialIDs = Set(editorial.drivers.map(\.id))
        var achievements = cached.achievements
        for (id, value) in editorial.achievements {
            let old = achievements[id]
            achievements[id] = DriverAchievements(
                wins: old?.wins ?? value.wins,
                fastestLaps: old?.fastestLaps ?? value.fastestLaps, favouriteTracks: value.favouriteTracks,
                championships: old?.championships ?? value.championships, podiums: old?.podiums ?? value.podiums,
                polePositions: old?.polePositions ?? value.polePositions,
                raceStarts: old?.raceStarts ?? value.raceStarts)
        }
        return try ArchiveSnapshot(
            drivers: editorial.drivers + cached.drivers.filter { !editorialIDs.contains($0.id) },
            cars: editorial.cars, achievements: achievements,
            featuredDriverID: editorial.featuredDriverID, catalog: cached.catalog ?? editorial.catalog,
            lifeStories: editorial.lifeStories, careerSeasons: cached.careerSeasons ?? editorial.careerSeasons
        ).validated()
    }
}
