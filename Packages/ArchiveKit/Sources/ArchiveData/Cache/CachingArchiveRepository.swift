//
// CachingArchiveRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

public actor CachingArchiveRepository: ArchiveRepository {
    private let remote: any ArchiveRepository
    private let cache: any ArchiveCache
    public init(remote: any ArchiveRepository, cache: any ArchiveCache) {
        self.remote = remote
        self.cache = cache
    }

    public func load() async throws -> ArchiveSnapshot {
        let snapshot = try await remote.load().validated()
        // Disk caching is best effort. A disk-full error must not discard valid network content.
        try? await cache.write(snapshot)
        return snapshot
    }
}
