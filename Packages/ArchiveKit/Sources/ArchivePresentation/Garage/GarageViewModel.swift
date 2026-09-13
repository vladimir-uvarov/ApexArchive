//
// GarageViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Observation

@Observable @MainActor public final class GarageViewModel {
    public var query = ""
    private let archive: ArchiveStore
    public init(archive: ArchiveStore) {
        self.archive = archive
    }

    public var entries: [GarageEntry] {
        let search = SearchQuery(query)
        let drivers = Dictionary(uniqueKeysWithValues: archive.snapshot.drivers.map { ($0.id, $0) })
        return archive.snapshot.cars.compactMap { car in
            guard let driver = drivers[car.driverID], search.matches("\(car.name) \(driver.name)") else { return nil }
            return GarageEntry(car: car, driver: driver)
        }
    }
}
