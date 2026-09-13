//
// ArchiveRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public protocol ArchiveRepository: Sendable {
    /// Returns a complete snapshot. Partial/invalid imports must throw, not replace known-good content.
    func load() async throws -> ArchiveSnapshot
}
