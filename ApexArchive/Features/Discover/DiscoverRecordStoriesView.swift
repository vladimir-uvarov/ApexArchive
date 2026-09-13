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
    /// Portrait lets the pager run to the screen edges so a swipe clips there, not at the page
    /// inset; landscape shares the row with the menu and keeps its bounds.
    var edgeToEdge = true

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
                    }.padding(.horizontal, DesignTokens.spacingSmall + (edgeToEdge ? DesignTokens.spacingRegular : 0))
                        .padding(.bottom, DesignTokens.discoveryPagerInset)
                }
            }
        }.tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .padding(.horizontal, edgeToEdge ? -DesignTokens.spacingRegular : 0)
            .id(model.selectionIndex)
    }

    private func visibleCount(for height: CGFloat) -> Int {
        let available = height - DesignTokens.discoveryStoryTextAllowance
        return max(1, min(3, Int(available / DesignTokens.discoveryPortraitRowHeight)))
    }

}
