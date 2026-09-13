//
// F1DBCatalogMapper.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

/// Keeps lap records scoped to the most recently raced layout of each venue.
struct F1DBCatalogMapper {
    func catalog(
        from data: Data, curated: RacingCatalog, countries: [F1DBCountry],
        drivers: [F1DBDriver], source: EditorialSource, today: String
    ) throws -> RacingCatalog {
        let reader = F1DBArchiveReader()
        let circuits = try reader.decode([F1DBCircuit].self, entry: "f1db-circuits.json", from: data)
        let races = try reader.decode([F1DBRace].self, entry: "f1db-races.json", from: data).filter { $0.date <= today }

        let laps = try reader.decode([F1DBRaceLap].self, entry: "f1db-races-fastest-laps.json", from: data)
        let constructors = try reader.decode([F1DBConstructor].self, entry: "f1db-constructors.json", from: data)
        let seasons = try reader.decode(
            [F1DBConstructorSeason].self, entry: "f1db-seasons-constructors.json", from: data)
        guard Set(drivers.map(\.id)).count == drivers.count,
            Set(countries.map(\.id)).count == countries.count,
            Set(races.map(\.id)).count == races.count,
            Set(circuits.map(\.id)).count == circuits.count,
            Set(constructors.map(\.id)).count == constructors.count
        else { throw HTTPError.invalidResponse }

        let raceByID = Dictionary(uniqueKeysWithValues: races.map { ($0.id, $0) })
        let countryByID = Dictionary(uniqueKeysWithValues: countries.map { ($0.id, $0) })
        let driverByID = Dictionary(uniqueKeysWithValues: drivers.map { ($0.id, $0.name) })
        let racesByCircuit = Dictionary(grouping: races, by: \.circuitId)
        let lapsByLayout = Dictionary(grouping: laps.filter { ($0.timeMillis ?? 0) > 0 }) {
            raceByID[$0.raceId]?.circuitLayoutId ?? ""
        }

        let venues = circuits.compactMap { row -> Circuit? in
            guard let country = countryByID[row.countryId] else { return nil }

            let events = racesByCircuit[row.id] ?? []
            let last = events.max { $0.date < $1.date }

            let layout = last?.circuitLayoutId
            let best = layout.flatMap { lapsByLayout[$0]?.min { ($0.timeMillis ?? 0) < ($1.timeMillis ?? 0) } }

            let record = best.flatMap { lap -> CircuitLapRecord? in
                guard let time = lap.time, let driver = driverByID[lap.driverId] else { return nil }
                return CircuitLapRecord(time: time, driver: driver, year: lap.year)
            }

            let outline = curated.circuits.first { $0.id == row.id && $0.layoutID == layout }?.outline
            // An out-of-range upstream measurement degrades to "unknown" rather than failing catalog
            // validation, which would abandon the entire refresh over one malformed venue.
            let length = (last?.courseLength ?? row.length).flatMap { $0.isFinite && $0 > 0 ? $0 : nil }

            let turns = (last?.turns ?? row.turns).flatMap { $0 > 0 ? $0 : nil }
            return Circuit(
                id: row.id, name: row.fullName, place: row.placeName, country: country.name,
                countryCode: country.alpha2Code ?? "", layoutID: layout,
                length: length, turns: turns,
                firstYear: events.map(\.year).min(), lastYear: last?.year, raceCount: events.count,
                record: record, outline: outline, source: source)
        }

        let teams = constructors.compactMap { row -> RacingTeam? in
            guard curated.teams.contains(where: { $0.id == row.id }), let country = countryByID[row.countryId],
                row.totalRaceWins >= 0, row.totalChampionshipWins >= 0
            else { return nil }

            let entries = seasons.filter { $0.constructorId == row.id && $0.year <= (Int(today.prefix(4)) ?? 0) }
            guard let first = entries.map(\.year).min(), let last = entries.map(\.year).max() else { return nil }
            return RacingTeam(
                id: row.id, name: row.name, country: country.name, countryCode: country.alpha2Code ?? "",
                firstYear: first, lastYear: last, wins: row.totalRaceWins, championships: row.totalChampionshipWins,
                firstWinYear: entries.filter { $0.totalRaceWins > 0 }.map(\.year).min(),
                firstTitleYear: entries.filter { $0.year >= 1958 && $0.positionNumber == 1 }.map(\.year).min(),
                source: source)
        }
        return RacingCatalog(circuits: venues, teams: teams)
    }
}
