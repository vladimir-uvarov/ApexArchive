//
// DriverDetailSection.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public enum DriverDetailSection: String, CaseIterable {
    case story
    case engineering
    case beyondRacing
    case wins
    case fastestLaps
    case tracks
    case garage

    public var title: String {
        switch self {
        case .engineering: return String(localized: "profile_section.engineering", defaultValue: "Cars & engineering")
        case .beyondRacing: return String(localized: "profile_section.beyond", defaultValue: "Beyond racing")
        case .story: return String(localized: "profile_section.story", defaultValue: "Story")
        case .wins: return String(localized: "profile_section.wins", defaultValue: "Wins")
        case .fastestLaps: return String(localized: "profile_section.fastest.laps", defaultValue: "Fastest laps")
        case .tracks: return String(localized: "profile_section.favourite.tracks", defaultValue: "Favourite tracks")
        case .garage: return String(localized: "profile_section.personal.garage", defaultValue: "Personal garage")
        }
    }
}
