//
// FavoritesStore.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

@MainActor public protocol FavoritesStore {
    func load() throws -> Set<String>
    func save(_ identifiers: Set<String>) throws
}
