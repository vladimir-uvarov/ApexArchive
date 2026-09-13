//
// WikimediaFixtures.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

enum WikimediaFixtures {
    static var page: Data { Data(#"{"query":{"pages":{"1":{"pageimage":"Portrait.jpg"}}}}"#.utf8) }

    static func photo(
        license: String = "CC BY-SA 4.0", licenseURL: String = "https://creativecommons.org/licenses/by-sa/4.0/"
    ) throws -> Data {
        try JSONSerialization.data(withJSONObject: [
            "query": [
                "pages": [
                    "1": [
                        "imageinfo": [
                            [
                                "url": "https://upload.wikimedia.org/original.jpg",
                                "thumburl": "https://upload.wikimedia.org/thumb.jpg",
                                "descriptionurl": "https://commons.wikimedia.org/wiki/File:Portrait.jpg",
                                "extmetadata": [
                                    "Artist": ["value": "<b>Test Artist</b>"], "LicenseShortName": ["value": license],
                                    "LicenseUrl": ["value": licenseURL],
                                ],
                            ]
                        ]
                    ]
                ]
            ]
        ])
    }
}
