//
// ArchiveCache.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

public protocol ArchiveCache: Sendable {
    func read() async throws -> ArchiveSnapshot?
    func write(_ snapshot: ArchiveSnapshot) async throws
}
