//
// F1DBRaceLap.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct F1DBRaceLap: Decodable {
    let raceId: Int
    let year: Int
    let driverId: String
    let time: String?
    let timeMillis: Int?
}
