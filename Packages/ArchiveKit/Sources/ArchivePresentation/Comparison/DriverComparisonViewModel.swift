//
// DriverComparisonViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class DriverComparisonViewModel {
    public let snapshot: ArchiveSnapshot
    public private(set) var firstID: String?
    public private(set) var secondID: String?

    public var first: Driver? { snapshot.drivers.first { $0.id == firstID } }

    public var second: Driver? { snapshot.drivers.first { $0.id == secondID } }

    public init(snapshot: ArchiveSnapshot) {
        self.snapshot = snapshot
        let ordered = snapshot.drivers.sorted {
            let left = snapshot.achievements[$0.id]?.wins?.count ?? -1
            let right = snapshot.achievements[$1.id]?.wins?.count ?? -1
            return left == right ? $0.id < $1.id : left > right
        }
        firstID = ordered.first?.id
        secondID = ordered.dropFirst().first?.id
    }

    public func select(_ driver: Driver, forFirst: Bool) {
        guard snapshot.drivers.contains(where: { $0.id == driver.id }) else { return }
        if forFirst {
            guard driver.id != secondID else { return }
            firstID = driver.id
        } else {
            guard driver.id != firstID else { return }
            secondID = driver.id
        }
    }

    /// Selectable drivers for one side of the comparison, excluding the driver already chosen
    /// on the other side, filtered by `query` and ordered by name.
    public func candidates(excluding excludedID: String?, matching query: String) -> [Driver] {
        let search = SearchQuery(query)
        return snapshot.drivers.filter {
            $0.id != excludedID && search.matches("\($0.name) \($0.country)")
        }.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    public func swap() {
        let previous = firstID
        firstID = secondID
        secondID = previous
    }
}
