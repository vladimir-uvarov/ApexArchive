//
// PhotoRemoteStub.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

actor PhotoRemoteStub: PhotoRepository {
    private(set) var downloads = 0
    var asset: PhotoAsset?
    let data: Data

    init(asset: PhotoAsset?, data: Data) {
        self.asset = asset
        self.data = data
    }

    func photo(wikipediaTitle: String) -> PhotoAsset? { asset }

    func imageData(for asset: PhotoAsset) async -> Data {
        downloads += 1
        await Task.yield()
        return data
    }
}
