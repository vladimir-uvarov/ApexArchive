//
// RefreshingPhotoRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

actor RefreshingPhotoRepository: PhotoRepository {
    let asset: PhotoAsset
    private var continuation: CheckedContinuation<PhotoAsset?, Error>?
    private var started = false

    init(asset: PhotoAsset) { self.asset = asset }

    func cachedPhoto(wikipediaTitle: String) -> PhotoAsset? { asset }

    func cachedImageData(for asset: PhotoAsset) -> Data? { Data([1]) }

    func imageData(for asset: PhotoAsset) -> Data { Data([2]) }

    func photo(wikipediaTitle: String) async throws -> PhotoAsset? {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            started = true
        }
    }

    func waitUntilRefreshing() async {
        while !started { await Task.yield() }
    }

    func finish(with result: Result<PhotoAsset?, Error>) {
        continuation?.resume(with: result)
        continuation = nil
    }
}
