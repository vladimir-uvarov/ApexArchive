//
// SavedDriversViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Observation

@Observable @MainActor public final class SavedDriversViewModel {
    private let archive: ArchiveStore
    private let favorites: FavoritesController
    public init(archive: ArchiveStore, favorites: FavoritesController) {
        self.archive = archive
        self.favorites = favorites
    }

    public func contribution(for driver: Driver) -> DriverContribution? {
        archive.snapshot.contribution(for: driver)
    }

    public var drivers: [Driver] { archive.snapshot.drivers.filter { favorites.contains($0.id) } }

    public var errorMessage: String? { favorites.errorMessage }

    public func retry() { favorites.reload() }
}
