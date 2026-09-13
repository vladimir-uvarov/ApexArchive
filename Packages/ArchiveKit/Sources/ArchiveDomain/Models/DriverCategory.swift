//
// DriverCategory.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum DriverCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case modern
    case risingStars
    case legends
    case archive
    public var id: String { rawValue }
}
