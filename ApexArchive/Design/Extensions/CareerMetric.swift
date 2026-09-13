//
// CareerMetric.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

extension CareerMetric {
    var title: String {
        switch self {
        case .championships: String(localized: "discover.champions", defaultValue: "The championship club")
        case .wins: String(localized: "discover.winners", defaultValue: "Built to win")
        case .podiums: String(localized: "discover.podiums", defaultValue: "A place on the podium")
        case .polePositions: String(localized: "discover.poles", defaultValue: "Masters of one lap")
        case .raceStarts: String(localized: "discover.starts", defaultValue: "The long game")
        }
    }

    var label: String {
        switch self {
        case .championships: String(localized: "records.championships", defaultValue: "World Championships")
        case .wins: String(localized: "driver_detail_view.wins", defaultValue: "Wins")
        case .podiums: String(localized: "records.podiums", defaultValue: "Grand Prix podiums")
        case .polePositions: String(localized: "records.poles", defaultValue: "Pole positions")
        case .raceStarts: String(localized: "records.starts", defaultValue: "Grand Prix starts")
        }
    }

    var explanation: String {
        switch self {
        case .championships:
            String(
                localized: "discover.champions.body",
                defaultValue: "Meet the drivers who turned seasons into world titles.")
        case .wins:
            String(
                localized: "discover.winners.body",
                defaultValue: "The biggest Grand Prix victory totals in the archive.")
        case .podiums:
            String(localized: "discover.podiums.body", defaultValue: "Finishing in the top three, again and again.")
        case .polePositions:
            String(localized: "discover.poles.body", defaultValue: "The careers defined by starting at the front.")
        case .raceStarts:
            String(
                localized: "discover.starts.body",
                defaultValue: "Experience measured in Grand Prix starts, across changing eras.")
        }
    }
}
