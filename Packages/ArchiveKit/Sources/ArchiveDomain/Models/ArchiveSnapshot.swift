//
// ArchiveSnapshot.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct ArchiveSnapshot: Codable, Equatable, Sendable {
    public let drivers: [Driver]
    public let cars: [PersonalCar]
    public let achievements: [String: DriverAchievements]
    public let featuredDriverID: String?
    public let catalog: RacingCatalog?
    public let careerSeasons: [DriverCareerSeason]?
    public let lifeStories: [DriverLifeStory]?

    public init(
        drivers: [Driver], cars: [PersonalCar], achievements: [String: DriverAchievements],
        featuredDriverID: String? = nil, catalog: RacingCatalog? = nil, lifeStories: [DriverLifeStory]? = nil,
        careerSeasons: [DriverCareerSeason]? = nil
    ) {
        self.drivers = drivers
        self.cars = cars
        self.achievements = achievements
        self.featuredDriverID = featuredDriverID
        self.catalog = catalog
        self.lifeStories = lifeStories
        self.careerSeasons = careerSeasons
    }

    public func validated() throws -> ArchiveSnapshot {
        let driverIDs = Set(drivers.map(\.id))
        guard driverIDs.count == drivers.count else { throw ArchiveValidationError.duplicateDriver }

        let sourceIDs = drivers.compactMap(\.sourceID)
        guard Set(sourceIDs).count == sourceIDs.count else { throw ArchiveValidationError.duplicateSourceIdentifier }
        guard Set(cars.map(\.id)).count == cars.count else { throw ArchiveValidationError.duplicateCar }
        guard
            drivers.allSatisfy({
                !$0.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            })
        else {
            throw ArchiveValidationError.invalidDriver
        }
        guard cars.allSatisfy({ !$0.id.isEmpty && !$0.name.isEmpty && driverIDs.contains($0.driverID) }) else {
            throw ArchiveValidationError.invalidCar
        }
        guard achievements.keys.allSatisfy(driverIDs.contains) else {
            throw ArchiveValidationError.orphanedAchievements
        }
        if let featuredDriverID, !driverIDs.contains(featuredDriverID) {
            throw ArchiveValidationError.invalidFeaturedDriver
        }
        guard cars.allSatisfy({ Self.isHTTPS($0.sourceURL) }) else { throw ArchiveValidationError.invalidSource }
        for value in achievements.values {
            for record in [
                value.wins, value.fastestLaps, value.championships, value.podiums, value.polePositions,
                value.raceStarts,
            ].compactMap({ $0 }) {
                guard record.count >= .zero else { throw ArchiveValidationError.negativeRecord }
                guard Self.isHTTPS(record.source.url) else { throw ArchiveValidationError.invalidSource }
            }
            guard Set(value.favouriteTracks.map(\.id)).count == value.favouriteTracks.count else {
                throw ArchiveValidationError.duplicateTrack
            }
            guard value.favouriteTracks.allSatisfy({ Self.isHTTPS($0.source.url) && !$0.attribution.isEmpty }) else {
                throw ArchiveValidationError.invalidSource
            }
        }
        if let lifeStories {
            guard Set(lifeStories.map(\.id)).count == lifeStories.count,
                lifeStories.allSatisfy({
                    !$0.id.isEmpty && !$0.driverSourceID.isEmpty && !$0.title.isEmpty && !$0.body.isEmpty
                        && Self.isHTTPS($0.source.url)
                })
            else { throw ArchiveValidationError.invalidLifeStory }
        }
        if let careerSeasons {
            guard Set(careerSeasons.map(\.id)).count == careerSeasons.count,
                careerSeasons.allSatisfy({
                    !$0.driverSourceID.isEmpty && $0.year >= 1950
                        && $0.starts >= 0 && $0.wins >= 0 && $0.podiums >= 0
                        && ($0.position.map { $0 > 0 } ?? true) && Self.isHTTPS($0.source.url)
                })
            else { throw ArchiveValidationError.invalidCareerSeason }
        }
        _ = try catalog?.validated()
        return self
    }

    private static func isHTTPS(_ url: URL) -> Bool { url.scheme == "https" && url.host?.isEmpty == false }

    public static let empty = ArchiveSnapshot(drivers: [], cars: [], achievements: [:])
}

extension ArchiveSnapshot {
    public func contribution(for driver: Driver) -> DriverContribution? {
        (lifeStories ?? []).first {
            $0.driverSourceID == (driver.sourceID ?? driver.id) && $0.contribution != nil
        }?.contribution
    }
}
