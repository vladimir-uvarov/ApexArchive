//
// DriverAchievements.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct DriverAchievements: Codable, Hashable, Sendable {
    public var championships: CareerRecord?
    public var podiums: CareerRecord?
    public var polePositions: CareerRecord?
    public var raceStarts: CareerRecord?
    public var wins: CareerRecord?
    public var fastestLaps: CareerRecord?
    public var favouriteTracks: [FavouriteTrack] = []

    public init(
        wins: CareerRecord? = nil, fastestLaps: CareerRecord? = nil, favouriteTracks: [FavouriteTrack] = [],
        championships: CareerRecord? = nil, podiums: CareerRecord? = nil, polePositions: CareerRecord? = nil,
        raceStarts: CareerRecord? = nil
    ) {
        self.championships = championships
        self.podiums = podiums
        self.polePositions = polePositions
        self.raceStarts = raceStarts
        self.wins = wins
        self.fastestLaps = fastestLaps
        self.favouriteTracks = favouriteTracks
    }
}
