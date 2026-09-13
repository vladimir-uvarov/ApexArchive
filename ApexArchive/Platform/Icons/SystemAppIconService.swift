//
// SystemAppIconService.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import OSLog
import UIKit

@MainActor final class SystemAppIconService: AppIconService {
    var supportsAlternateIcons: Bool { UIApplication.shared.supportsAlternateIcons }

    var currentIcon: AppIcon { AppIcon(alternateName: UIApplication.shared.alternateIconName) }

    private let logger = Logger(subsystem: "com.example.apexarchive", category: "AppIcon")

    func setIcon(_ icon: AppIcon) async throws {
        do {
            try await UIApplication.shared.setAlternateIconName(icon.alternateName)
        } catch {
            let failure = error as NSError
            logger.error("Icon change failed: \(failure.domain, privacy: .public) code \(failure.code)")
            throw error
        }
    }
}
