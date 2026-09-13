//
// WikimediaImageInfo.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

struct WikimediaImageInfo: Decodable {
    let url: URL
    let thumbnailURL: URL?
    let descriptionURL: URL
    let metadata: WikimediaImageMetadata?

    private enum CodingKeys: String, CodingKey {
        case url
        case thumbnailURL = "thumburl"
        case descriptionURL = "descriptionurl"
        case metadata = "extmetadata"
    }
}
