//
// ArchiveStore.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class ArchiveStore {
    public private(set) var state: ArchiveLoadState = .idle
    private let repository: any ArchiveRepository
    private let bootstrap: (any ArchiveRepository)?
    private var requestID: UUID?
    public init(repository: any ArchiveRepository, bootstrap: (any ArchiveRepository)? = nil) {
        self.repository = repository
        self.bootstrap = bootstrap
    }

    public var snapshot: ArchiveSnapshot { state.snapshot ?? .empty }

    public func loadIfNeeded() async {
        guard case .idle = state else { return }

        let request = UUID()
        requestID = request
        if let bootstrap {
            state = .loading(previous: nil)
            let snapshot = try? await bootstrap.load().validated()
            guard requestID == request, !Task.isCancelled else {
                if requestID == request { state = .idle }
                return
            }
            if let snapshot { state = .loaded(snapshot) }
        }
        await reload()
    }

    public func reload() async {
        let request = UUID()
        requestID = request
        let previous = state.snapshot
        state = .loading(previous: previous)
        do {
            let snapshot = try await repository.load().validated()
            try Task.checkCancellation()
            guard requestID == request else { return }
            state = .loaded(snapshot)
        } catch is CancellationError {
            guard requestID == request else { return }
            state = previous.map(ArchiveLoadState.loaded) ?? .idle
        } catch {
            guard requestID == request else { return }
            state = .failed(
                message: String(
                    localized: "archive_store.the.archive.could.not.be.loaded.please",
                    defaultValue: "The archive could not be loaded. Please try again."), previous: previous)
        }
    }
}
