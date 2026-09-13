//
// CircuitsViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class CircuitsViewModel {
    public var query = ""
    private let circuits: [Circuit]

    public init(circuits: [Circuit]) { self.circuits = circuits }

    public var visibleCircuits: [Circuit] {
        let search = SearchQuery(query)
        return circuits.filter { search.matches("\($0.name) \($0.place) \($0.country)") }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
}
