//
// CareerLeaderboard.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum CareerLeaderboard {
    public static func entries(in snapshot: ArchiveSnapshot, metric: CareerMetric) -> [CareerLeader] {
        snapshot.drivers.compactMap { driver in
            guard let record = metric.record(in: snapshot.achievements[driver.id]), record.count > 0 else { return nil }
            return CareerLeader(driver: driver, record: record)
        }.sorted {
            $0.record.count == $1.record.count ? $0.driver.name < $1.driver.name : $0.record.count > $1.record.count
        }
    }
}
