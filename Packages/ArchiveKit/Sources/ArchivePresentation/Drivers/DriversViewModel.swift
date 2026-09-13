//
// DriversViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class DriversViewModel {
    public var query = ""
    public var sort: DriverSort = .featured
    public var filter: DriverFilter = .all
    private let archive: ArchiveStore
    public init(archive: ArchiveStore) {
        self.archive = archive
    }

    public func contribution(for driver: Driver) -> DriverContribution? {
        archive.snapshot.contribution(for: driver)
    }

    public var drivers: [Driver] {
        let search = SearchQuery(query)
        let filtered = archive.snapshot.drivers.filter {
            filter.includes($0, contribution: archive.snapshot.contribution(for: $0))
                && search.matches("\($0.name) \($0.country)")
        }
        guard sort != .featured else { return filtered }
        return filtered.sorted { left, right in
            switch sort {
            case .featured: return false
            case .era:
                if left.firstSeason != right.firstSeason {
                    return (left.firstSeason ?? Int.max) < (right.firstSeason ?? Int.max)
                }
            case .country:
                let comparison = left.country.localizedStandardCompare(right.country)
                if comparison != .orderedSame { return comparison == .orderedAscending }
            case .wins:
                let leftWins = archive.snapshot.achievements[left.id]?.wins?.count ?? -1
                let rightWins = archive.snapshot.achievements[right.id]?.wins?.count ?? -1
                if leftWins != rightWins { return leftWins > rightWins }
            }

            let comparison = left.name.localizedStandardCompare(right.name)
            return comparison == .orderedSame ? left.id < right.id : comparison == .orderedAscending
        }
    }

    public func show(_ filter: DriverFilter) {
        self.filter = filter
        query = ""
    }
}
