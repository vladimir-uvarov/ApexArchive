//
// AppIconService.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

@MainActor public protocol AppIconService {
    var supportsAlternateIcons: Bool { get }

    var currentIcon: AppIcon { get }

    func setIcon(_ icon: AppIcon) async throws
}
