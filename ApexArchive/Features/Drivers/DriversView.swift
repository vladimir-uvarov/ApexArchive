//
// DriversView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct DriversView: View {
    @Environment(PhotoLibrary.self) private var photos
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable var viewModel: DriversViewModel
    let driverDestination: (Driver) -> DriverDetailScreen
    @Namespace private var cardNamespace
    private static let topAnchor = "drivers.top"

    var body: some View {
        let drivers = viewModel.drivers
        NavigationStack {
            ScrollViewReader { proxy in
                // The controls sit above the scroll view, not in its safe-area inset: an inset is
                // still displaced by pull-to-refresh, which pushed the chips down over the sort
                // control whenever a drag on the rail carried any downward movement.
                VStack(spacing: .zero) {
                    controls
                    ScrollView {
                        results(drivers).frame(maxWidth: DesignTokens.gridMaxWidth).frame(maxWidth: .infinity)
                    }
                    .onChange(of: viewModel.filter) { _, _ in returnToTop(proxy) }
                    .onChange(of: viewModel.sort) { _, _ in returnToTop(proxy) }
                    .onChange(of: viewModel.query) { _, _ in returnToTop(proxy) }
                }
            }.background(ArchiveStyle.background).navigationTitle(
                String(localized: "drivers_view.the.drivers", defaultValue: "The drivers")
            )
            // Pinned controls occupy the space a large title would collapse through, so the mode is
            // stated rather than inferred: left to itself the title was dropped entirely.
            .navigationBarTitleDisplayMode(.inline)
            // Content scrolls under the bar, so the drawer needs its own ground or the grid shows
            // through behind the search field.
            .toolbarBackground(.visible, for: .navigationBar)
            // Keep the field on screen: a long grid otherwise scrolls the search out of reach.
            .searchable(
                text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always),
                prompt: String(
                    localized: "drivers_view.search.driver.or.country", defaultValue: "Search driver or country"))
        }
        .task(id: drivers.prefix(24).map(\.id)) {
            await photos.preload(drivers.prefix(24).compactMap(\.wikipediaTitle))
        }
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMedium) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(DriverFilter.allCases) { category in
                        Button {
                            viewModel.filter = category
                        } label: {
                            Text(category.title).font(.subheadline.weight(.semibold)).padding(
                                .horizontal, DesignTokens.spacingRegular
                            ).padding(.vertical, DesignTokens.spacingMedium)
                                .background(
                                    viewModel.filter == category
                                        ? ArchiveStyle.interactive.opacity(DesignTokens.selectionOpacity)
                                        : ArchiveStyle.card, in: Capsule())
                        }.foregroundStyle(viewModel.filter == category ? ArchiveStyle.interactive : .primary)
                            .animation(reduceMotion ? nil : MotionTokens.selection, value: viewModel.filter)
                            .accessibilityAddTraits(viewModel.filter == category ? .isSelected : [])
                    }
                }.padding(.horizontal, DesignTokens.spacingLarge)
            }
            // The inset padding lives on the row itself, so the rail already spans the full width and
            // does not need its clipping disabled to reach the screen edges. Keeping the clip is what
            // stops the chips travelling vertically and painting over the sort control below.
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            Picker(String(localized: "drivers.sort", defaultValue: "Sort drivers"), selection: $viewModel.sort) {
                ForEach(DriverSort.allCases) { order in
                    Text(order.title).tag(order)
                }
            }
            .pickerStyle(.menu).padding(.horizontal, DesignTokens.spacingLarge)
        }.padding(.vertical, DesignTokens.spacingMedium)
            .frame(maxWidth: .infinity, alignment: .leading).background(ArchiveStyle.background)
    }

    private func returnToTop(_ proxy: ScrollViewProxy) {
        withAnimation(reduceMotion ? nil : MotionTokens.selection) {
            proxy.scrollTo(Self.topAnchor, anchor: .top)
        }
    }

    private func results(_ drivers: [Driver]) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
            // The anchor rides a real, always-present view: a zero-height spacer is not something a
            // lazy stack reliably builds, so the proxy could not find it to scroll back.
            Eyebrow(
                text: String.localizedStringWithFormat(
                    String(
                        localized: "drivers_view.profiles.curated.archive", defaultValue: "%@ driver profiles"),
                    String(describing: drivers.count))
            ).id(Self.topAnchor)
            if drivers.isEmpty {
                ContentUnavailableView.search(text: viewModel.query)
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: DesignTokens.gridMinWidth), spacing: DesignTokens.gridSpacing)
                    ], spacing: DesignTokens.gridSpacing
                ) {
                    ForEach(drivers) { driver in
                        NavigationLink {
                            driverDestination(driver).zoomDestination(driver.id, in: cardNamespace)
                        } label: {
                            DriverCard(driver: driver, contribution: viewModel.contribution(for: driver))
                        }.buttonStyle(CardPressStyle()).zoomSource(driver.id, in: cardNamespace)
                    }
                }
            }
            Text(
                String(
                    localized: "drivers_view.collections.are.editorial.selections.not.current.standings",
                    defaultValue:
                        "Collections are editorial selections, not current standings or active-grid lists.")
            ).font(.caption).foregroundStyle(.secondary)
        }.padding(.horizontal, DesignTokens.spacingLarge).padding(.bottom, DesignTokens.spacingLarge)
    }
}
