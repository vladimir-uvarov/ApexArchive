//
// TestAppIconService.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

@MainActor final class TestAppIconService: AppIconService {
    var supportsAlternateIcons = true
    var currentIcon: AppIcon = .original
    var shouldFail = false
    var changesBeforeFailure = false
    var shouldSuspend = false
    var requestedIcons: [AppIcon] = []
    var continuation: CheckedContinuation<Void, Never>?

    func setIcon(_ icon: AppIcon) async throws {
        requestedIcons.append(icon)
        if shouldSuspend {
            await withCheckedContinuation { continuation = $0 }
        }
        if changesBeforeFailure { currentIcon = icon }
        if shouldFail { throw CocoaError(.featureUnsupported) }
        currentIcon = icon
    }
}
