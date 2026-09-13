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
    var body: some View {
        let drivers = viewModel.drivers
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
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
                        }
                    }
                    .scrollClipDisabled()
                    Picker(String(localized: "drivers.sort", defaultValue: "Sort drivers"), selection: $viewModel.sort)
                    {
                        ForEach(DriverSort.allCases) { order in
                            Text(order.title).tag(order)
                        }
                    }
                    .pickerStyle(.menu)
                    Eyebrow(
                        text: String.localizedStringWithFormat(
                            String(
                                localized: "drivers_view.profiles.curated.archive",
                                defaultValue: "%@ driver profiles"),
                            String(describing: drivers.count)))
                    if drivers.isEmpty {
                        ContentUnavailableView.search(text: viewModel.query)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(
                                    .adaptive(minimum: DesignTokens.gridMinWidth), spacing: DesignTokens.gridSpacing)
                            ], spacing: DesignTokens.gridSpacing
                        ) {
                            ForEach(drivers) { driver in
                                NavigationLink {
                                    driverDestination(driver)
                                } label: {
                                    DriverCard(driver: driver, contribution: viewModel.contribution(for: driver))
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    Text(
                        String(
                            localized: "drivers_view.collections.are.editorial.selections.not.current.standings",
                            defaultValue:
                                "Collections are editorial selections, not current standings or active-grid lists.")
                    ).font(
                        .caption
                    ).foregroundStyle(.secondary)
                }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.gridMaxWidth).frame(
                    maxWidth: .infinity)
            }.background(ArchiveStyle.background).navigationTitle(
                String(localized: "drivers_view.the.drivers", defaultValue: "The drivers")
            )
            .searchable(
                text: $viewModel.query,
                prompt: String(
                    localized: "drivers_view.search.driver.or.country", defaultValue: "Search driver or country"))
        }
        .task(id: drivers.prefix(8).map(\.id)) {
            await photos.preload(drivers.prefix(8).compactMap(\.wikipediaTitle))
        }
    }
}
