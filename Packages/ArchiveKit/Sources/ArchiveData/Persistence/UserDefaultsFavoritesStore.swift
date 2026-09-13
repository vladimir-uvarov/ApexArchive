//
// UserDefaultsFavoritesStore.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

@MainActor public final class UserDefaultsFavoritesStore: FavoritesStore {
    // Preserve the prototype's key so existing favorites survive the refactor.
    public static let storageKey = "favoriteDrivers"
    public static let schemaVersionKey = "favoriteDriversSchemaVersion"
    private static let currentSchemaVersion = 1
    private static let legacyIdentifiers = [
        "verstappen": "max_verstappen", "schumacher": "michael_schumacher", "fittipaldi": "emerson_fittipaldi",
        "gilles": "gilles_villeneuve",
    ]
    private let defaults: UserDefaults
    public init(defaults: UserDefaults) { self.defaults = defaults }

    public func load() throws -> Set<String> {
        guard let stored = defaults.object(forKey: Self.storageKey) else { return [] }
        guard let identifiers = stored as? [String] else { throw ArchiveDataError.invalidFavoritesFormat }
        if defaults.integer(forKey: Self.schemaVersionKey) < Self.currentSchemaVersion {
            let migrated = Set(identifiers.map { Self.legacyIdentifiers[$0] ?? $0 })
            try save(migrated)
            return migrated
        }
        return Set(identifiers)
    }

    public func save(_ identifiers: Set<String>) throws {
        defaults.set(identifiers.sorted(), forKey: Self.storageKey)
        defaults.set(Self.currentSchemaVersion, forKey: Self.schemaVersionKey)
    }
}
