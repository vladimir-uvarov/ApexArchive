//
// SettingsViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class SettingsViewModel {
    public private(set) var selectedIcon: AppIcon
    public private(set) var isChangingIcon = false
    public private(set) var iconErrorDetails: String?
    public var hasIconError: Bool { iconErrorDetails != nil }

    public var supportsAlternateIcons: Bool { service.supportsAlternateIcons }

    private let service: any AppIconService

    public init(service: any AppIconService) {
        self.service = service
        selectedIcon = service.currentIcon
    }

    public func refresh() {
        selectedIcon = service.currentIcon
    }

    public func select(_ icon: AppIcon) async {
        guard supportsAlternateIcons, !isChangingIcon, icon != selectedIcon else { return }
        isChangingIcon = true
        iconErrorDetails = nil
        defer { isChangingIcon = false }
        do {
            try await service.setIcon(icon)
            refresh()
        } catch {
            refresh()
            // The system can update its selection before reporting a presentation failure.
            guard selectedIcon != icon else { return }

            let failure = error as NSError
            iconErrorDetails = "\(failure.localizedDescription) (\(failure.domain), \(failure.code))"
        }
    }

    public func dismissError() {
        iconErrorDetails = nil
    }
}
