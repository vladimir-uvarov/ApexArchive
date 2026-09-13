//
// WikidataImageClaim.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct WikidataImageClaim: Decodable {
    let filename: String?
    let rank: String?

    private enum CodingKeys: String, CodingKey {
        case mainsnak, datavalue, value, rank
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rank = try container.decodeIfPresent(String.self, forKey: .rank)
        let snak = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .mainsnak)
        if snak.contains(.datavalue) {
            let value = try snak.nestedContainer(keyedBy: CodingKeys.self, forKey: .datavalue)
            filename = try value.decodeIfPresent(String.self, forKey: .value)
        } else {
            filename = nil
        }
    }
}
