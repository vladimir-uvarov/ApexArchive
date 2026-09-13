//
// DiscoverView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct DiscoverView: View {
    @Bindable var viewModel: DiscoverViewModel
    let driverDestination: (Driver) -> DriverDetailScreen
    let openCategory: (DriverFilter) -> Void
    @Environment(PhotoLibrary.self) private var photos
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let compact = geometry.size.height < DesignTokens.discoveryCompactHeight
                Group {
                    if geometry.size.width > geometry.size.height {
                        HStack(spacing: DesignTokens.spacingRegular) {
                            VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                                options(compact: true)
                                selectionHeader
                            }.frame(width: geometry.size.width * DesignTokens.discoveryLandscapeMenuFraction)
                            spotlights(edgeToEdge: false)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                            if !compact {
                                Text(String(localized: "root_view.discover", defaultValue: "Discover"))
                                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            }
                            options(compact: compact)
                            selectionHeader
                            spotlights(edgeToEdge: true)
                        }
                    }
                }.padding(DesignTokens.spacingRegular).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .frame(maxWidth: .infinity)
            }.background(ArchiveStyle.background).toolbar(.hidden, for: .navigationBar)
        }
        .task(id: preloadTitles) { await photos.preload(preloadTitles) }
    }

    private func options(compact: Bool) -> some View {
        ArchiveActivitiesView(snapshot: viewModel.snapshot, openCategory: openCategory, compact: compact)
            .frame(height: compact ? DesignTokens.discoveryCompactOptionHeight : DesignTokens.discoveryOptionHeight)
    }

    private enum Spotlight {
        case highlights
        case records
        case heritage
    }

    /// Only presentations that actually have content take a turn, so a sparse or offline archive
    /// never shuffles onto an empty panel.
    private var availableSpotlights: [Spotlight] {
        var result: [Spotlight] = [.highlights]
        if !viewModel.storyMetrics.isEmpty { result.append(.records) }
        if viewModel.featuredTeam != nil { result.append(.heritage) }
        return result
    }

    /// The shuffle cycles the presentations, so the career records and the heritage files are
    /// reachable from Discover rather than only from a driver's own detail screen.
    private func spotlights(edgeToEdge: Bool) -> some View {
        let choices = availableSpotlights
        let choice = choices[((viewModel.selectionIndex % choices.count) + choices.count) % choices.count]
        return Group {
            switch choice {
            case .highlights: DiscoverHighlightsView(model: viewModel, driverDestination: driverDestination)
            case .records:
                DiscoverRecordStoriesView(
                    model: viewModel, driverDestination: driverDestination, edgeToEdge: edgeToEdge)
            case .heritage: DiscoverTeamSpotlightView(model: viewModel)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var selectionHeader: some View {
        HStack {
            Text(String(localized: "discover.mix.title", defaultValue: "Take a closer look")).font(.headline)
            Spacer()
            Button {
                withAnimation(reduceMotion ? nil : .easeInOut) { viewModel.nextSelection() }
            } label: {
                Label(
                    String(localized: "discover.shuffle", defaultValue: "Show another selection"),
                    systemImage: "shuffle"
                )
                .labelStyle(.iconOnly)
                .frame(minWidth: DesignTokens.minimumTouchTarget, minHeight: DesignTokens.minimumTouchTarget)
            }
        }
    }

    private var preloadTitles: [String] {
        [viewModel.featuredCar?.car.wikipediaTitle, viewModel.featuredStoryDriver?.wikipediaTitle]
            .compactMap { $0 }
    }
}
