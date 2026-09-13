//
// CareerOverviewView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct CareerOverviewView: View {
    let achievements: DriverAchievements

    var body: some View {
        let available = CareerMetric.allCases.filter { $0.record(in: achievements) != nil }
        if !available.isEmpty {
            VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                Text(String(localized: "driver.career.overview", defaultValue: "Career at a glance")).font(
                    .title2.bold())
                ForEach(available) { metric in
                    if let record = metric.record(in: achievements) {
                        LabeledContent(metric.label, value: record.count.formatted())
                    }
                }
                if let source = available.first?.record(in: achievements)?.source { SourceView(source: source) }
            }.padding(DesignTokens.spacingLarge)
                .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
        }
    }
}
