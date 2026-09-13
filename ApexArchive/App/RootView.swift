//
// RootView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies
    let archive: ArchiveStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showingLaunch = true
    @State private var selectedTab: AppTab = .discover
    var body: some View {
        Group {
            if archive.state.snapshot != nil {
                TabView(selection: $selectedTab) {
                    DiscoverView(
                        viewModel: dependencies.discover,
                        driverDestination: destination,
                        openCategory: { filter in
                            dependencies.drivers.show(filter)
                            selectedTab = .drivers
                        }
                    ).tabItem {
                        Label(
                            String(localized: "root_view.discover", defaultValue: "Discover"),
                            systemImage: "square.grid.2x2")
                    }.tag(AppTab.discover)
                    DriversView(viewModel: dependencies.drivers, driverDestination: destination)
                        .tabItem {
                            Label(
                                String(localized: "root_view.drivers", defaultValue: "Drivers"), systemImage: "person.2"
                            )
                        }.tag(AppTab.drivers)
                    GarageView(viewModel: dependencies.garage)
                        .tabItem {
                            Label(
                                String(localized: "root_view.garage", defaultValue: "Garage"), systemImage: "car.side")
                        }.tag(AppTab.garage)
                    SettingsView(
                        viewModel: dependencies.settings, savedViewModel: dependencies.saved,
                        driverDestination: destination
                    )
                    .tabItem {
                        Label(String(localized: "settings.title", defaultValue: "Settings"), systemImage: "gearshape")
                    }.tag(AppTab.settings)
                }
                .safeAreaInset(edge: .top, spacing: .zero) {
                    if let message = archive.state.errorMessage {
                        HStack {
                            Text(
                                String.localizedStringWithFormat(
                                    String(
                                        localized: "root_view.showing.saved.content",
                                        defaultValue: "%@ Showing saved content."), String(describing: message))
                            ).font(.caption)
                            Button(String(localized: "root_view.retry", defaultValue: "Retry")) {
                                Task { await archive.reload() }
                            }
                        }.padding(DesignTokens.spacingMedium).background(ArchiveStyle.card)
                    }
                }
                .refreshable { await archive.reload() }
            } else if let message = archive.state.errorMessage {
                ContentUnavailableView {
                    Label(
                        String(localized: "root_view.archive.unavailable", defaultValue: "Archive unavailable"),
                        systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button(String(localized: "root_view.retry", defaultValue: "Retry")) {
                        Task { await archive.reload() }
                    }
                }
            } else {
                ProgressView(String(localized: "root_view.opening.the.archive", defaultValue: "Opening the archive…"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ArchiveStyle.background)
        .overlay {
            if showingLaunch { LaunchScreenView(icon: dependencies.settings.installedIcon).transition(.opacity) }
        }
        .task(id: isInitialContentReady) {
            guard isInitialContentReady, showingLaunch else { return }
            if !reduceMotion {
                do { try await Task.sleep(for: MotionTokens.launchDuration) } catch { return }
            }
            withAnimation(reduceMotion ? nil : MotionTokens.launchDismiss) { showingLaunch = false }
        }
        .task {
            dependencies.settings.refresh()
            await archive.loadIfNeeded()
        }
        .task(id: archive.snapshot.drivers.isEmpty) {
            let snapshot = archive.snapshot
            let featured = dependencies.discover.featuredDriver?.wikipediaTitle
            let titles =
                [featured].compactMap { $0 } + snapshot.cars.prefix(4).compactMap(\.wikipediaTitle)
                + snapshot.drivers.prefix(12).compactMap(\.wikipediaTitle)
            await dependencies.photos.preload(titles)
        }
    }

    private var isInitialContentReady: Bool {
        archive.state.snapshot != nil || archive.state.errorMessage != nil
    }

    private func destination(_ driver: Driver) -> DriverDetailScreen {
        DriverDetailScreen(viewModel: dependencies.makeDriverDetail(for: driver))
    }
}
