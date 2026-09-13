//
// TestFavoritesStore.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

@MainActor final class TestFavoritesStore: FavoritesStore {
    var identifiers: Set<String> = []
    var failLoad = false
    var failSave = false
    func load() throws -> Set<String> {
        if failLoad { throw ArchiveValidationError.invalidDriver }
        return identifiers
    }

    func save(_ identifiers: Set<String>) throws {
        if failSave { throw ArchiveValidationError.invalidDriver }
        self.identifiers = identifiers
    }
}
