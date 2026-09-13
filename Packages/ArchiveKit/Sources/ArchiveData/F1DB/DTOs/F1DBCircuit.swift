//
// F1DBCircuit.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct F1DBCircuit: Decodable {
    let id: String
    let fullName: String
    let placeName: String
    let countryId: String
    let length: Double?
    let turns: Int?
}
