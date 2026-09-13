//
// BundledArchiveRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

public actor BundledArchiveRepository: ArchiveRepository {
    private let fileURL: URL?
    private let decoder: ArchiveDecoder
    public init(fileURL: URL?, decoder: ArchiveDecoder) {
        self.fileURL = fileURL
        self.decoder = decoder
    }

    public static func bundled() -> BundledArchiveRepository {
        let bundle = Bundle.module
        return BundledArchiveRepository(
            fileURL: bundle.url(forResource: "archive", withExtension: "json"), decoder: ArchiveDecoder())
    }

    public func load() async throws -> ArchiveSnapshot {
        guard let fileURL else { throw ArchiveDataError.missingBundledArchive }
        try Task.checkCancellation()
        let snapshot = try decoder.decode(Data(contentsOf: fileURL))
        try Task.checkCancellation()
        return snapshot
    }
}
