//
// PhotoAssetTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchiveTestSupport
import Foundation
import XCTest

final class PhotoAssetTests: XCTestCase {
    func testAttributionRoundTripsAndOlderMetadataStillDecodes() throws {
        let url = ArchiveFixtures.source().url
        let asset = PhotoAsset(
            imageURL: url, pageURL: url, author: "Author", license: "CC BY 4.0", licenseURL: url,
            attribution: "Required credit")
        let data = try JSONEncoder().encode(asset)
        XCTAssertEqual(try JSONDecoder().decode(PhotoAsset.self, from: data), asset)
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        object.removeValue(forKey: "attribution")
        let old = try JSONDecoder().decode(PhotoAsset.self, from: JSONSerialization.data(withJSONObject: object))
        XCTAssertNil(old.attribution)
        XCTAssertEqual(old.author, asset.author)
    }
}
