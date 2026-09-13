//
// ActivityFixtures.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

public enum ActivityFixtures {
    public static func snapshot() -> ArchiveSnapshot {
        let countries = ["Brazil", "United Kingdom", "Germany", "France"]
        let drivers = (0..<12).map { index in
            Driver(
                id: "driver-\(index)", name: "Driver \(index)", country: countries[index % countries.count],
                category: .legends, subtitle: "Racer", biography: "", firstSeason: 1960 + index * 5)
        }

        let achievements = Dictionary(
            uniqueKeysWithValues: drivers.enumerated().map { index, driver in
                (
                    driver.id,
                    DriverAchievements(
                        wins: CareerRecord(
                            count: index, scope: "Career wins", note: "Verified record",
                            source: ArchiveFixtures.source()),
                        fastestLaps: CareerRecord(
                            count: index * 2, scope: "Career fastest laps", note: "Verified record",
                            source: ArchiveFixtures.source()))
                )
            })
        return ArchiveSnapshot(drivers: drivers, cars: [], achievements: achievements)
    }
}
