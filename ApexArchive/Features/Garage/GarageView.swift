//
// GarageView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct GarageView: View {
    @Environment(PhotoLibrary.self) private var photos
    @Bindable var viewModel: GarageViewModel
    @Namespace private var cardNamespace
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
                    SectionTitle(
                        title: String(
                            localized: "garage_view.a.different.kind.of.drive",
                            defaultValue: "A different kind of drive."),
                        subtitle: String(
                            localized: "garage_view.explore.documented.personal.cars.and.manufacturer.provided",
                            defaultValue:
                                "Explore documented road cars, personal race-car collections and manufacturer-provided cars."
                        ))
                    Eyebrow(
                        text: String.localizedStringWithFormat(
                            String(
                                localized: "garage_view.documented.connections",
                                defaultValue: "%@ documented connections"), String(describing: viewModel.entries.count))
                    )
                    ForEach(viewModel.entries) { car in
                        NavigationLink {
                            CarDetailView(car: car.car, driverName: car.driver.name)
                                .zoomDestination(car.car.id, in: cardNamespace)
                        } label: {
                            CarCard(car: car.car, driverName: car.driver.name)
                        }.buttonStyle(CardPressStyle()).zoomSource(car.car.id, in: cardNamespace)
                    }
                    if viewModel.entries.isEmpty { ContentUnavailableView.search(text: viewModel.query) }
                    Text(
                        String(
                            localized: "garage_view.this.collection.is.intentionally.incomplete.a.photographed",
                            defaultValue:
                                "This collection is intentionally incomplete. A photographed sighting does not establish ownership. Each entry describes what its source supports."
                        )
                    )
                    .font(.footnote).foregroundStyle(.secondary)
                }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                    maxWidth: .infinity)
            }.background(ArchiveStyle.background).navigationTitle(
                String(localized: "garage_view.personal.garage", defaultValue: "Personal garage")
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .searchable(
                text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always),
                prompt: String(localized: "garage_view.search.car.or.driver", defaultValue: "Search car or driver"))
        }
        .task(id: viewModel.entries.prefix(24).map(\.id)) {
            await photos.preload(viewModel.entries.prefix(24).compactMap { $0.car.wikipediaTitle })
        }
    }
}
