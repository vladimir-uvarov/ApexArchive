//
// F1DBRace.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct F1DBRace: Decodable {
    let id: Int
    let year: Int
    let date: String
    let circuitId: String
    let circuitLayoutId: String?
    let courseLength: Double?
    let turns: Int?
}
