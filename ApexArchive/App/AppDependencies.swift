//
// AppDependencies.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import ArchiveDomain
import ArchivePresentation
import Foundation

@MainActor final class AppDependencies {
    let archive: ArchiveStore
    let favorites: FavoritesController
    let photos: PhotoLibrary
    let discover: DiscoverViewModel
    let drivers: DriversViewModel
    let garage: GarageViewModel
    let settings: SettingsViewModel
    let saved: SavedDriversViewModel

    init() {
        settings = SettingsViewModel(service: SystemAppIconService())
        let session = URLSession(configuration: .default)
        let api = URLSessionHTTPClient(session: session, configuration: .f1db)
        let media = URLSessionHTTPClient(session: session, configuration: .wikimedia)
        let bundled = BundledArchiveRepository.bundled()
        let cacheDirectory = URL.cachesDirectory.appending(path: "ApexArchive", directoryHint: .isDirectory)
        let cache = FileArchiveCache(url: cacheDirectory.appending(path: "f1db-archive.json"))
        let remote = F1DBRepository(client: api, editorial: bundled)
        archive = ArchiveStore(
            repository: CachingArchiveRepository(remote: remote, cache: cache),
            bootstrap: CachedArchiveRepository(cache: cache, fallback: bundled))
        favorites = FavoritesController(store: UserDefaultsFavoritesStore(defaults: .standard))
        photos = PhotoLibrary(
            repository: CachingPhotoRepository(
                remote: WikimediaPhotoRepository(client: media),
                cache: FilePhotoCache(
                    directory: cacheDirectory.appending(path: "Photos-v2", directoryHint: .isDirectory)))
        )
        let discoveryStore = UserDefaultsDiscoveryStore(defaults: .standard)
        discover = DiscoverViewModel(
            archive: archive, visitIndex: discoveryStore.nextVisit(),
            selectionChanged: { discoveryStore.saveNextVisit(after: $0) })
        drivers = DriversViewModel(archive: archive)
        garage = GarageViewModel(archive: archive)
        saved = SavedDriversViewModel(archive: archive, favorites: favorites)
    }

    func makeDriverDetail(for driver: Driver) -> DriverDetailViewModel {
        DriverDetailViewModel(driverID: driver.id, archive: archive, favorites: favorites)
    }
}
