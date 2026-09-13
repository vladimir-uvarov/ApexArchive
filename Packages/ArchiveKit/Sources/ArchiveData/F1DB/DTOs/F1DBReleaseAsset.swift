//
// F1DBReleaseAsset.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

struct F1DBReleaseAsset: Decodable {
    let name: String
    let downloadURL: URL

    private enum CodingKeys: String, CodingKey {
        case name
        case downloadURL = "browser_download_url"
    }
}
