//
// FavoritesController.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class FavoritesController {
    public private(set) var identifiers: Set<String> = []
    public private(set) var errorMessage: String?
    private let store: any FavoritesStore
    private var hasLoaded = false
    public init(store: any FavoritesStore) {
        self.store = store
        reload()
    }

    public func reload() {
        do {
            identifiers = try store.load()
            hasLoaded = true
            errorMessage = nil
        } catch {
            hasLoaded = false
            errorMessage = String(
                localized: "favorites_controller.saved.drivers.could.not.be.read.retry",
                defaultValue: "Saved drivers could not be read. Retry before changing your collection.")
        }
    }

    public func contains(_ driverID: String) -> Bool { identifiers.contains(driverID) }

    public func toggle(_ driverID: String) {
        guard hasLoaded else { return }

        var updated = identifiers
        if !updated.insert(driverID).inserted { updated.remove(driverID) }
        do {
            try store.save(updated)
            identifiers = updated
            errorMessage = nil
        } catch {
            errorMessage = String(
                localized: "favorites_controller.your.change.could.not.be.saved.please",
                defaultValue: "Your change could not be saved. Please try again.")
        }
    }
}
