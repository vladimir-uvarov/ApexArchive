//
// CareerMetric.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum CareerMetric: String, CaseIterable, Identifiable, Sendable {
    case championships, wins, podiums, polePositions, raceStarts

    public var id: String { rawValue }

    public func record(in achievements: DriverAchievements?) -> CareerRecord? {
        switch self {
        case .championships: achievements?.championships
        case .wins: achievements?.wins
        case .podiums: achievements?.podiums
        case .polePositions: achievements?.polePositions
        case .raceStarts: achievements?.raceStarts
        }
    }
}
