//
// SettingsView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    let savedViewModel: SavedDriversViewModel
    let driverDestination: (Driver) -> DriverDetailScreen
    @Environment(\.scenePhase) private var scenePhase
    @State private var showingAbout = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        SavedDriversView(viewModel: savedViewModel, driverDestination: driverDestination)
                    } label: {
                        Label(String(localized: "root_view.saved", defaultValue: "Saved"), systemImage: "bookmark")
                    }
                }
                Section {
                    ForEach(AppIcon.allCases) { icon in
                        Button {
                            Task { await viewModel.select(icon) }
                        } label: {
                            IconOptionView(icon: icon, isSelected: viewModel.selectedIcon == icon)
                        }
                        .disabled(viewModel.isChangingIcon || !viewModel.supportsAlternateIcons)
                    }
                } header: {
                    HStack {
                        Text(String(localized: "settings.icon.title", defaultValue: "App icon"))
                        if viewModel.isChangingIcon { ProgressView() }
                    }
                } footer: {
                    Text(
                        viewModel.supportsAlternateIcons
                            ? String(
                                localized: "settings.icon.description",
                                defaultValue: "Choose a painted helmet for your Home Screen.")
                            : String(
                                localized: "settings.icon.unsupported",
                                defaultValue: "Changing the app icon is unavailable on this device."))
                }
                Section(String(localized: "legal.section", defaultValue: "Privacy and licences")) {
                    ForEach(LegalDocument.allCases) { document in
                        NavigationLink(document.title) { LegalDocumentView(document: document) }
                    }
                    if let url = URL(string: "https://github.com/vladimir-uvarov/ApexArchive/issues") {
                        Link(
                            String(localized: "legal.support", defaultValue: "Support and corrections"),
                            destination: url)
                    }
                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                        Link(
                            String(localized: "legal.eula", defaultValue: "Apple standard app licence"),
                            destination: url)
                    }
                }
                Section {
                    Button {
                        showingAbout = true
                    } label: {
                        Label(String(localized: "about.title"), systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle(String(localized: "settings.title", defaultValue: "Settings"))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAbout) { AboutView() }
            .alert(
                String(localized: "settings.icon.error.title", defaultValue: "Couldn’t change icon"),
                isPresented: Binding(get: { viewModel.hasIconError }, set: { if !$0 { viewModel.dismissError() } })
            ) {
                Button(String(localized: "common.done")) { viewModel.dismissError() }
            } message: {
                Text(verbatim: iconErrorMessage)
            }
        }
        .onAppear { viewModel.refresh() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { viewModel.refresh() }
        }
    }

    private var iconErrorMessage: String {
        let message = String(
            localized: "settings.icon.error.body",
            defaultValue: "Your current icon is unchanged. Please try again.")
        #if DEBUG
            if let details = viewModel.iconErrorDetails {
                return message + "\n\n" + details
            }
        #endif
        return message
    }
}
