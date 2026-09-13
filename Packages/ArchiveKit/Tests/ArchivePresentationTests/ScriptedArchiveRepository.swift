//
// ScriptedArchiveRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

actor ScriptedArchiveRepository: ArchiveRepository {
    private var results: [Result<ArchiveSnapshot, Error>]
    private(set) var calls = 0
    init(_ results: [Result<ArchiveSnapshot, Error>]) { self.results = results }

    func load() async throws -> ArchiveSnapshot {
        calls += 1
        guard !results.isEmpty else { throw ArchiveValidationError.invalidDriver }
        return try results.removeFirst().get()
    }
}
