//
// ArchiveDecoder.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

public struct ArchiveDecoder: Sendable {
    public init() {}

    public func decode(_ data: Data) throws -> ArchiveSnapshot {
        try JSONDecoder().decode(ArchiveSnapshot.self, from: data).validated()
    }
}
