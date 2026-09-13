//
// F1DBSnapshotMapper.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

/// Converts provider rows into one validated domain snapshot without performing I/O.
struct F1DBSnapshotMapper {
    func snapshot(
        drivers rows: [F1DBDriver], countries: [F1DBCountry], seasons: [F1DBDriverSeason],
        editorial curated: ArchiveSnapshot, source: EditorialSource, catalog: RacingCatalog? = nil
    ) throws -> ArchiveSnapshot {
        let debutYears = Dictionary(grouping: seasons, by: \.driverId).compactMapValues { $0.map(\.year).min() }
        guard !rows.isEmpty, Set(rows.map(\.id)).count == rows.count,
            Set(countries.map(\.id)).count == countries.count
        else { throw HTTPError.invalidResponse }

        let countryNames = Dictionary(uniqueKeysWithValues: countries.map { ($0.id, $0.name) })
        let editorialByID = Dictionary(
            uniqueKeysWithValues: curated.drivers.compactMap { driver in
                driver.sourceID.map { ($0, driver) }
            })
        var drivers: [Driver] = []
        var achievements = curated.achievements
        for row in rows {
            try Task.checkCancellation()
            guard row.totalRaceWins >= .zero, row.totalFastestLaps >= .zero,
                [row.totalChampionshipWins, row.totalPodiums, row.totalPolePositions, row.totalRaceStarts].compactMap({
                    $0
                }).allSatisfy({ $0 >= 0 }),
                let country = countryNames[row.nationalityCountryId]
            else { throw HTTPError.invalidResponse }

            let original = editorialByID[row.id]
            let id = original?.id ?? row.id
            let record = DriverAchievements(
                wins: CareerRecord(
                    count: row.totalRaceWins,
                    scope: String(localized: "records.wins.scope", defaultValue: "Career Grand Prix wins"),
                    note: String(
                        localized: "records.wins.note",
                        defaultValue: "Grand Prix wins recorded by F1DB in the cited release. Sprint wins are excluded."
                    ), source: source),
                fastestLaps: CareerRecord(
                    count: row.totalFastestLaps,
                    scope: String(localized: "records.fastest.scope", defaultValue: "Career fastest race laps"),
                    note: String(
                        localized: "records.fastest.note",
                        defaultValue:
                            "Fastest race laps recorded by F1DB in the cited release. Qualifying laps and circuit records are separate measures."
                    ), source: source),
                favouriteTracks: curated.achievements[id]?.favouriteTracks ?? [],
                championships: careerRecord(
                    row.totalChampionshipWins,
                    scope: String(localized: "records.championships", defaultValue: "World Championships"),
                    source: source),
                podiums: careerRecord(
                    row.totalPodiums, scope: String(localized: "records.podiums", defaultValue: "Grand Prix podiums"),
                    source: source),
                polePositions: careerRecord(
                    row.totalPolePositions, scope: String(localized: "records.poles", defaultValue: "Pole positions"),
                    source: source),
                raceStarts: careerRecord(
                    row.totalRaceStarts, scope: String(localized: "records.starts", defaultValue: "Grand Prix starts"),
                    source: source))
            achievements[id] = record
            drivers.append(
                Driver(
                    id: id, name: original?.name ?? row.name,
                    country: original?.country ?? country, category: original?.category ?? .archive,
                    subtitle: original?.subtitle
                        ?? String(localized: "driver.historical.subtitle", defaultValue: "Historical racing driver"),
                    biography: original?.biography
                        ?? String(
                            localized: "driver.historical.biography",
                            defaultValue:
                                "This driver is included in F1DB’s historical archive. Explore the race records and linked biography for more detail."
                        ),
                    sourceID: row.id,
                    wikipediaTitle: original?.wikipediaTitle ?? row.name.replacingOccurrences(of: " ", with: "_"),
                    firstSeason: debutYears[row.id]))
        }

        let order = Dictionary(uniqueKeysWithValues: curated.drivers.enumerated().map { ($0.element.id, $0.offset) })
        drivers.sort {
            let left = order[$0.id] ?? Int.max
            let right = order[$1.id] ?? Int.max
            return left == right ? $0.name < $1.name : left < right
        }

        // Keep only seasons belonging to a driver the snapshot actually shows: F1DB ships every
        // driver in history, and the rest would be cached and re-decoded on every launch for nothing.
        // Duplicate (driver, year) rows are dropped rather than failing the entire refresh.
        let shownSourceIDs = Set(drivers.map { $0.sourceID ?? $0.id })
        var seenSeasonIDs: Set<String> = []
        let careerSeasons = seasons.compactMap { season -> DriverCareerSeason? in
            guard shownSourceIDs.contains(season.driverId), let starts = season.totalRaceStarts,
                let wins = season.totalRaceWins, let podiums = season.totalPodiums
            else { return nil }

            let entry = DriverCareerSeason(
                driverSourceID: season.driverId, year: season.year,
                starts: starts, wins: wins, podiums: podiums,
                position: season.positionNumber, source: source)
            return seenSeasonIDs.insert(entry.id).inserted ? entry : nil
        }

        let snapshot = try ArchiveSnapshot(
            drivers: drivers, cars: curated.cars, achievements: achievements,
            featuredDriverID: curated.featuredDriverID, catalog: catalog ?? curated.catalog,
            lifeStories: curated.lifeStories, careerSeasons: careerSeasons
        ).validated()
        return snapshot
    }

    private func careerRecord(_ count: Int?, scope: String, source: EditorialSource) -> CareerRecord? {
        count.map {
            CareerRecord(
                count: $0, scope: scope,
                note: String(
                    localized: "records.career.note",
                    defaultValue:
                        "Career total recorded in the cited F1DB release. These figures span different eras and racing calendars."
                ), source: source)
        }
    }

}
