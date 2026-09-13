//
// SuspendedArchiveRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

/// Explicit continuations make race tests deterministic without sleep-based ordering.
actor SuspendedArchiveRepository: ArchiveRepository {
    private var continuation: CheckedContinuation<ArchiveSnapshot, any Error>?
    private var started: CheckedContinuation<Void, Never>?

    func load() async throws -> ArchiveSnapshot {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            started?.resume()
            started = nil
        }
    }

    func waitUntilStarted() async {
        if continuation != nil { return }
        await withCheckedContinuation { started = $0 }
    }

    func complete(with snapshot: ArchiveSnapshot) {
        continuation?.resume(returning: snapshot)
        continuation = nil
    }
}
