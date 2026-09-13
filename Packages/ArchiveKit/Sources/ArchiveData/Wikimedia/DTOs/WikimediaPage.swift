//
// WikimediaPage.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct WikimediaPage: Decodable {
    let pageProperties: [String: String]?
    let imageName: String?
    let imageInfo: [WikimediaImageInfo]?

    private enum CodingKeys: String, CodingKey {
        case pageProperties = "pageprops"
        case imageName = "pageimage"
        case imageInfo = "imageinfo"
    }
}
