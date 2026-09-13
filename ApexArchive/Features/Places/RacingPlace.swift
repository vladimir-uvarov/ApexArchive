//
// RacingPlace.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

struct RacingPlace: Identifiable {
    let id: String
    let kind: PlaceKind
    let name: String
    let location: String
    let countryCode: String
    let address: String
    let summary: String
    let website: String

    var mapsURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "maps.apple.com"
        components.queryItems = [URLQueryItem(name: "q", value: name + ", " + address)]
        return components.url
    }
}
