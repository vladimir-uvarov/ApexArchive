//
// PhotoRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public protocol PhotoRepository: Sendable {
    /// Returns previously stored metadata without contacting the network.
    func cachedPhoto(wikipediaTitle: String) async -> PhotoAsset?

    /// Returns stored bytes only; a cache miss must not trigger a download.
    func cachedImageData(for asset: PhotoAsset) async -> Data?

    func imageData(for asset: PhotoAsset) async throws -> Data

    func photo(wikipediaTitle: String) async throws -> PhotoAsset?
}

extension PhotoRepository {
    public func cachedPhoto(wikipediaTitle: String) async -> PhotoAsset? { nil }

    public func cachedImageData(for asset: PhotoAsset) async -> Data? { nil }
}
