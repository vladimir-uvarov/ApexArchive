//
// RacingPlacesView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import SwiftUI

struct RacingPlacesView: View {
    private var sections: [(kind: PlaceKind, places: [RacingPlace])] {
        PlaceKind.allCases.compactMap { kind in
            let places = RacingPlaceCatalog.places.filter { $0.kind == kind }
            return places.isEmpty ? nil : (kind, places)
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
                Text(
                    String(
                        localized: "places.intro",
                        defaultValue:
                            "Collections to walk through, and the circuits themselves. Opening arrangements vary, so confirm before travelling."
                    )
                )
                .foregroundStyle(.secondary)
                ForEach(sections, id: \.kind.id) { section in
                    Label(section.kind.title, systemImage: section.kind.symbol)
                        .font(.headline).foregroundStyle(ArchiveStyle.interactive)
                        .padding(.top, DesignTokens.spacingMedium)
                    ForEach(section.places) { place in
                        NavigationLink {
                            RacingPlaceDetailView(place: place)
                        } label: {
                            card(for: place)
                        }.buttonStyle(.plain)
                    }
                }
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                maxWidth: .infinity)
        }.background(ArchiveStyle.background)
            .navigationTitle(String(localized: "places.title", defaultValue: "Places to visit"))
    }

    private func card(for place: RacingPlace) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMedium) {
            Text(CountryFlag.symbol(for: place.countryCode) + " " + place.location)
                .font(.subheadline).foregroundStyle(.secondary)
            Text(place.name).font(.title2.bold())
            Text(place.summary).font(.subheadline).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Label(
                String(localized: "museums.plan", defaultValue: "Explore & plan a visit"), systemImage: "map"
            )
            .font(.subheadline.weight(.semibold)).foregroundStyle(ArchiveStyle.interactive)
        }.padding(DesignTokens.spacingLarge).frame(maxWidth: .infinity, alignment: .leading)
            .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
    }
}
