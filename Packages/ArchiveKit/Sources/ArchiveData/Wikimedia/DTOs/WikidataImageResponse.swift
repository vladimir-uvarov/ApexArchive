//
// WikidataImageResponse.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct WikidataImageResponse: Decodable {
    let claims: [String: [WikidataImageClaim]]?
    let error: WikimediaAPIError?

    var filenames: [String] {
        (claims?["P18"] ?? []).filter { $0.rank != "deprecated" }
            .sorted { ($0.rank == "preferred" ? 0 : 1) < ($1.rank == "preferred" ? 0 : 1) }
            .compactMap(\.filename)
    }
}
