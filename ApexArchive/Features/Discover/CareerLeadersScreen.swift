//
// CareerLeadersScreen.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct CareerLeadersScreen: View {
    let snapshot: ArchiveSnapshot
    let metric: CareerMetric
    let driverDestination: (Driver) -> DriverDetailScreen

    var body: some View {
        let entries = CareerLeaderboard.entries(in: snapshot, metric: metric)
        return List {
            Section {
                Text(metric.explanation)
                Text(
                    String(
                        localized: "discover.era.context",
                        defaultValue:
                            "Career totals span different eras and calendar lengths. They describe records, not a definitive ranking of ability."
                    )
                )
                .font(.footnote).foregroundStyle(.secondary)
            }
            ForEach(entries) { entry in
                NavigationLink {
                    driverDestination(entry.driver)
                } label: {
                    CareerLeaderRow(entry: entry)
                }
            }
            if let source = entries.first?.record.source {
                Section { SourceView(source: source) }
            }
        }.navigationTitle(metric.title).navigationBarTitleDisplayMode(.inline)
    }
}
