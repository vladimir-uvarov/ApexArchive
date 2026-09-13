//
// LegalDocument.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

enum LegalDocument: String, CaseIterable, Identifiable {
    case privacy, appInformation, thirdParty, databaseLicense, dependencyLicense

    var id: String { rawValue }

    var title: String {
        switch self {
        case .privacy: String(localized: "legal.privacy", defaultValue: "Privacy information")
        case .appInformation: String(localized: "legal.app", defaultValue: "App and content information")
        case .thirdParty: String(localized: "legal.notices", defaultValue: "Third-party notices")
        case .databaseLicense: String(localized: "legal.database", defaultValue: "F1DB licence")
        case .dependencyLicense: String(localized: "legal.dependency", defaultValue: "ZIPFoundation licence")
        }
    }

    var resource: String {
        switch self {
        case .privacy: "Privacy-Information"
        case .appInformation: "App-Information"
        case .thirdParty: "Third-Party-Notices"
        case .databaseLicense: "F1DB-LICENSE"
        case .dependencyLicense: "ZIPFoundation-LICENSE"
        }
    }
}
