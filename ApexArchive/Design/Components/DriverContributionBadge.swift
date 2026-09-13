//
// DriverContributionBadge.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct DriverContributionBadge: View {
    let contribution: DriverContribution

    var body: some View {
        Label {
            switch contribution {
            case .carBuilder:
                Text(String(localized: "driver.badge.car_builder", defaultValue: "Car builder"))
            case .engineering:
                Text(String(localized: "driver.badge.engineering", defaultValue: "Engineering pioneer"))
            }
        } icon: {
            Image(systemName: contribution == .carBuilder ? "car.side" : "gearshape.2")
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(ArchiveStyle.interactive)
        .fixedSize(horizontal: false, vertical: true)
    }
}
