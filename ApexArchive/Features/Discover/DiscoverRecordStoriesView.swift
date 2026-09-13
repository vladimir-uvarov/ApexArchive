//
// DiscoverRecordStoriesView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct DiscoverRecordStoriesView: View {
    let model: DiscoverViewModel
    let driverDestination: (Driver) -> DriverDetailScreen

    var body: some View {
        TabView {
            ForEach(model.storyMetrics) { metric in
                GeometryReader { geometry in
                    let entries = CareerLeaderboard.entries(in: model.snapshot, metric: metric)
                    VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                        Text(metric.title).font(.title2.bold())
                        if geometry.size.height > DesignTokens.discoveryCompactStoryHeight {
                            Text(metric.explanation).font(.subheadline).foregroundStyle(.secondary)
                        }
                        ForEach(
                            Array(
                                entries.prefix(visibleCount(for: geometry.size.height)))
                        ) { entry in
                            NavigationLink {
                                driverDestination(entry.driver)
                            } label: {
                                CareerLeaderRow(entry: entry, showsPortrait: true, showsDisclosureIndicator: true)
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                        NavigationLink {
                            CareerLeadersScreen(
                                snapshot: model.snapshot, metric: metric, driverDestination: driverDestination)
                        } label: {
                            Label(
                                String(localized: "discover.explore.records", defaultValue: "Explore the records"),
                                systemImage: "arrow.right"
                            )
                            .font(.subheadline.weight(.semibold)).padding(.vertical, DesignTokens.spacingMedium)
                        }
                        Spacer(minLength: .zero)
                    }.padding(.horizontal, DesignTokens.spacingSmall)
                        .padding(.bottom, DesignTokens.discoveryPagerInset)
                }
            }
        }.tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .id(model.selectionIndex)
    }

    private func visibleCount(for height: CGFloat) -> Int {
        let available = height - DesignTokens.discoveryStoryTextAllowance
        return max(1, min(3, Int(available / DesignTokens.discoveryPortraitRowHeight)))
    }

}
