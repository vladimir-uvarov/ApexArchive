//
// CachingPhotoRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

public actor CachingPhotoRepository: PhotoRepository {
    private let remote: any PhotoRepository
    private let cache: FilePhotoCache
    private var downloads: [URL: Task<Data, Error>] = [:]

    public init(remote: any PhotoRepository, cache: FilePhotoCache) {
        self.remote = remote
        self.cache = cache
    }

    public func cachedPhoto(wikipediaTitle: String) async -> PhotoAsset? {
        await cache.asset(for: wikipediaTitle)
    }

    public func cachedImageData(for asset: PhotoAsset) async -> Data? {
        await cache.image(for: asset.imageURL)
    }

    public func photo(wikipediaTitle: String) async throws -> PhotoAsset? {
        let asset = try await remote.photo(wikipediaTitle: wikipediaTitle)
        if let asset {
            await cache.store(asset, for: wikipediaTitle)
        } else {
            // A successful lookup that no longer has eligible media invalidates old attribution.
            await cache.removeAsset(for: wikipediaTitle)
        }
        return asset
    }

    public func imageData(for asset: PhotoAsset) async throws -> Data {
        if let pending = downloads[asset.imageURL] { return try await pending.value }

        let task = Task {
            if let data = await cache.image(for: asset.imageURL) { return data }

            let data = try await remote.imageData(for: asset)
            await cache.store(data, for: asset.imageURL)
            return data
        }
        downloads[asset.imageURL] = task
        defer { downloads[asset.imageURL] = nil }
        return try await task.value
    }
}
