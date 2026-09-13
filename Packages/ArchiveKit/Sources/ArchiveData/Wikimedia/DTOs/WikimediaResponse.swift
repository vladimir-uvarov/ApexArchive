//
// WikimediaResponse.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct WikimediaResponse: Decodable {
    let query: WikimediaQuery?
    let error: WikimediaAPIError?
}
