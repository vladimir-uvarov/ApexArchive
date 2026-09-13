//
// F1DBDriverSeason.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct F1DBDriverSeason: Decodable {
    let year: Int
    let driverId: String
    var totalRaceStarts: Int?
    var totalRaceWins: Int?
    var totalPodiums: Int?
    var positionNumber: Int?
}
