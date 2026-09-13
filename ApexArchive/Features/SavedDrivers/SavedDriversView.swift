//
// SavedDriversView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct SavedDriversView: View {
    @Bindable var viewModel: SavedDriversViewModel
    let driverDestination: (Driver) -> DriverDetailScreen
    var body: some View {
        ScrollView {
            if let error = viewModel.errorMessage {
                Text(error)
                Button(
                    String(localized: "saved_drivers_view.retry.saved.drivers", defaultValue: "Retry saved drivers")
                ) { viewModel.retry() }
            }
            if viewModel.drivers.isEmpty {
                ContentUnavailableView(
                    String(
                        localized: "saved_drivers_view.your.own.starting.grid",
                        defaultValue: "Your own starting grid"), systemImage: "bookmark",
                    description: Text(
                        String(
                            localized: "saved_drivers_view.save.a.driver.from.their.profile.to",
                            defaultValue:
                                "Save a driver from their profile to build your collection. Favorites stay on this device."
                        ))
                )
                .padding(.top, DesignTokens.emptyStateTopInset)
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: DesignTokens.gridMinWidth), spacing: DesignTokens.gridSpacing)
                    ], spacing: DesignTokens.gridSpacing
                ) {
                    ForEach(viewModel.drivers) { driver in
                        NavigationLink {
                            driverDestination(driver)
                        } label: {
                            DriverCard(driver: driver, contribution: viewModel.contribution(for: driver))
                        }.buttonStyle(CardPressStyle())
                    }
                }.padding(DesignTokens.spacingLarge)
            }
        }.background(ArchiveStyle.background).navigationTitle(
            String(localized: "saved_drivers_view.your.collection", defaultValue: "Your collection"))
    }
}
