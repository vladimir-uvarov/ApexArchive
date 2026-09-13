//
// F1DBRelease.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

struct F1DBRelease: Decodable {
    let version: String
    let pageURL: URL
    let assets: [F1DBReleaseAsset]

    private enum CodingKeys: String, CodingKey {
        case version = "tag_name"
        case pageURL = "html_url"
        case assets
    }
}
