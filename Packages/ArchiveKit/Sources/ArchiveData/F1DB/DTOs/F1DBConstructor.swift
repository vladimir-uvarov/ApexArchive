//
// F1DBConstructor.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct F1DBConstructor: Decodable {
    let id: String
    let name: String
    let countryId: String
    let totalRaceWins: Int
    let totalChampionshipWins: Int
}
