//
// DriverDetailViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class DriverDetailViewModel {
    private let driverID: String
    private let archive: ArchiveStore
    private let favorites: FavoritesController
    public init(
        driverID: String, archive: ArchiveStore, favorites: FavoritesController
    ) {
        self.driverID = driverID
        self.archive = archive
        self.favorites = favorites
    }

    public var biographyURL: URL? {
        guard let title = driver?.wikipediaTitle else { return nil }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "en.wikipedia.org"
        components.path = "/wiki/" + title
        return components.url
    }

    public var driver: Driver? { archive.snapshot.drivers.first { $0.id == driverID } }

    public var cars: [PersonalCar] { archive.snapshot.cars.filter { $0.driverID == driverID } }

    public var achievements: DriverAchievements {
        archive.snapshot.achievements[driverID] ?? DriverAchievements()
    }

    public var careerSeasons: [DriverCareerSeason] {
        guard let driver else { return [] }
        return (archive.snapshot.careerSeasons ?? []).filter { $0.driverSourceID == (driver.sourceID ?? driver.id) }
            .sorted { $0.year > $1.year }
    }

    public var lifeStories: [DriverLifeStory] { matchingStories.filter { $0.contribution == nil } }

    public var engineeringStories: [DriverLifeStory] { matchingStories.filter { $0.contribution != nil } }

    private var matchingStories: [DriverLifeStory] {
        guard let driver else { return [] }
        return (archive.snapshot.lifeStories ?? []).filter { $0.driverSourceID == (driver.sourceID ?? driver.id) }
    }

    public var sections: [DriverDetailSection] {
        DriverDetailSection.allCases.filter { section in
            switch section {
            case .engineering: !engineeringStories.isEmpty
            case .beyondRacing: !lifeStories.isEmpty
            case .garage: !cars.isEmpty
            case .tracks: !achievements.favouriteTracks.isEmpty
            case .story, .wins, .fastestLaps: true
            }
        }
    }

    public var isFavorite: Bool { favorites.contains(driverID) }

    public var errorMessage: String? { favorites.errorMessage }

    public func toggleFavorite() {
        guard driver != nil else { return }
        favorites.toggle(driverID)
    }

    public func retryFavorites() { favorites.reload() }
}
