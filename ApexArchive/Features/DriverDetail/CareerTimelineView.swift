//
// CareerTimelineView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct CareerTimelineView: View {
    let seasons: [DriverCareerSeason]

    var body: some View {
        if !seasons.isEmpty {
            DisclosureGroup {
                VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                    Text(
                        String(
                            localized: "career.timeline.note",
                            defaultValue:
                                "Season records from the cited release. An ongoing season’s standing is provisional.")
                    )
                    .font(.caption).foregroundStyle(.secondary)
                    ForEach(seasons) { season in
                        HStack(alignment: .top, spacing: DesignTokens.spacingRegular) {
                            Text(season.year.formatted(.number.grouping(.never))).font(.headline).monospacedDigit()
                            VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                                if let position = season.position {
                                    Text(
                                        String.localizedStringWithFormat(
                                            String(
                                                localized: "career.timeline.position",
                                                defaultValue: "Championship position: %lld"), position)
                                    )
                                    .font(.subheadline.weight(.semibold))
                                }
                                Text(
                                    String.localizedStringWithFormat(
                                        String(
                                            localized: "career.timeline.results",
                                            defaultValue: "%lld starts · %lld wins · %lld podiums"), season.starts,
                                        season.wins, season.podiums)
                                )
                                .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                        Divider()
                    }
                    if let source = seasons.first?.source { SourceView(source: source) }
                }.padding(.top, DesignTokens.spacingRegular)
            } label: {
                Label(
                    String(localized: "career.timeline.title", defaultValue: "Career by season"),
                    systemImage: "point.3.connected.trianglepath.dotted"
                )
                .font(.headline)
            }.padding(DesignTokens.spacingLarge)
                .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
        }
    }
}
