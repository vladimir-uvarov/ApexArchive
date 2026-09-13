//
// FileArchiveCache.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

public actor FileArchiveCache: ArchiveCache {
    private let url: URL
    public init(url: URL) { self.url = url }

    public func read() throws -> ArchiveSnapshot? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try ArchiveDecoder().decode(Data(contentsOf: url))
    }

    public func write(_ snapshot: ArchiveSnapshot) throws {
        let validated = try snapshot.validated()
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try JSONEncoder().encode(validated).write(to: url, options: .atomic)
    }
}
