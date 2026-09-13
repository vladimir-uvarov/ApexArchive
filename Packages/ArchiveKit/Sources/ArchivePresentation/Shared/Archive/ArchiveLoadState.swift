//
// ArchiveLoadState.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

public enum ArchiveLoadState: Equatable {
    case idle
    case loading(previous: ArchiveSnapshot?)
    case loaded(ArchiveSnapshot)
    case failed(message: String, previous: ArchiveSnapshot?)

    public var snapshot: ArchiveSnapshot? {
        switch self {
        case .idle: return nil
        case .loading(let previous), .failed(_, let previous): return previous
        case .loaded(let snapshot): return snapshot
        }
    }

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    public var errorMessage: String? {
        if case .failed(let message, _) = self { return message }
        return nil
    }
}
