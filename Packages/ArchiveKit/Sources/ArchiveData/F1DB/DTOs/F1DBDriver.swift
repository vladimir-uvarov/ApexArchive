//
// F1DBDriver.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

struct F1DBDriver: Decodable {
    let id: String
    let name: String
    let nationalityCountryId: String
    let totalRaceWins: Int
    let totalFastestLaps: Int
    var totalChampionshipWins: Int?
    var totalPodiums: Int?
    var totalPolePositions: Int?
    var totalRaceStarts: Int?
}
