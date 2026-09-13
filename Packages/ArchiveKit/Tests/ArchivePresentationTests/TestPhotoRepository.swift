//
// TestPhotoRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

actor TestPhotoRepository: PhotoRepository {
    private(set) var requests = 0
    var missing: Bool
    private let failuresBeforeSuccess: Int

    init(missing: Bool = false, failuresBeforeSuccess: Int = 0) {
        self.missing = missing
        self.failuresBeforeSuccess = failuresBeforeSuccess
    }

    func photo(wikipediaTitle: String) async throws -> PhotoAsset? {
        requests += 1
        if requests <= failuresBeforeSuccess { throw URLError(.timedOut) }
        await Task.yield()
        guard !missing, let url = URL(string: "https://example.com/photo") else { return nil }
        return PhotoAsset(imageURL: url, pageURL: url, author: "Author", license: "CC BY 4.0", licenseURL: url)
    }

    func imageData(for asset: PhotoAsset) async throws -> Data { Data([1]) }
}
