//
// WikimediaImageMetadata.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct WikimediaImageMetadata: Decodable {
    let attribution: WikimediaMetadataValue?
    let credit: WikimediaMetadataValue?
    let copyright: WikimediaMetadataValue?
    let restrictions: WikimediaMetadataValue?
    let artist: WikimediaMetadataValue?
    let licenseName: WikimediaMetadataValue?
    let licenseURL: WikimediaMetadataValue?

    private enum CodingKeys: String, CodingKey {
        case attribution = "Attribution"
        case credit = "Credit"
        case copyright = "Copyright"
        case restrictions = "Restrictions"
        case artist = "Artist"
        case licenseName = "LicenseShortName"
        case licenseURL = "LicenseUrl"
    }
}
