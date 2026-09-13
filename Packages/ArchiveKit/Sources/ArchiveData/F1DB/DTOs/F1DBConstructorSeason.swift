//
// F1DBConstructorSeason.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct F1DBConstructorSeason: Decodable {
    let constructorId: String
    let year: Int
    let positionNumber: Int?
    let totalRaceWins: Int
}
