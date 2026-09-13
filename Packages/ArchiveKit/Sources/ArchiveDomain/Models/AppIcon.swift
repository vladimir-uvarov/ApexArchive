//
// AppIcon.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum AppIcon: String, CaseIterable, Identifiable, Sendable {
    case original, crimson, glacier, pearl

    public var id: String { rawValue }

    public var alternateName: String? {
        switch self {
        case .original: nil
        case .crimson: "AppIconCrimson"
        case .glacier: "AppIconGlacier"
        case .pearl: "AppIconPearl"
        }
    }

    public init(alternateName: String?) {
        self = Self.allCases.first { $0.alternateName == alternateName } ?? .original
    }
}
