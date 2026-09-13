//
// MemoryArchiveCache.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import ArchiveDomain

actor MemoryArchiveCache: ArchiveCache {
    var snapshot: ArchiveSnapshot?
    var shouldFail = false
    init(snapshot: ArchiveSnapshot? = nil, shouldFail: Bool = false) {
        self.snapshot = snapshot
        self.shouldFail = shouldFail
    }

    func read() async throws -> ArchiveSnapshot? {
        if shouldFail { throw ArchiveValidationError.invalidDriver }
        return snapshot
    }

    func write(_ snapshot: ArchiveSnapshot) async throws {
        if shouldFail { throw ArchiveValidationError.invalidDriver }
        self.snapshot = snapshot
    }
}
