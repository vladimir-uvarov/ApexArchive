//
// RacingPlaceDetailView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import MapKit
import SwiftUI

struct RacingPlaceDetailView: View {
    let place: RacingPlace
    @State private var mapModel = RacingPlaceMapViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
                Text(place.location).font(.subheadline).foregroundStyle(.secondary)
                Text(place.summary).font(.title3)
                Group {
                    if let item = mapModel.mapItem {
                        Map(initialPosition: .item(item)) { Marker(item: item) }
                    } else if mapModel.isLoading {
                        ProgressView(String(localized: "museums.map.loading", defaultValue: "Finding the museum…"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ContentUnavailableView(
                            String(localized: "museums.map.unavailable", defaultValue: "Map unavailable"),
                            systemImage: "map",
                            description: Text(
                                String(
                                    localized: "museums.map.fallback",
                                    defaultValue: "You can still search for the museum in Apple Maps below.")))
                    }
                }.frame(height: DesignTokens.featuredImageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                Text(place.address).textSelection(.enabled)
                if let url = place.mapsURL {
                    Link(destination: url) {
                        Label(String(localized: "museums.maps", defaultValue: "Open in Apple Maps"), systemImage: "map")
                    }.buttonStyle(.borderedProminent)
                }
                if let url = URL(string: place.website) {
                    Link(destination: url) {
                        Label(
                            String(localized: "museums.official", defaultValue: "Official visitor information"),
                            systemImage: "arrow.up.right.square")
                    }
                }
                Text(
                    String(
                        localized: "museums.visit.note",
                        defaultValue:
                            "Check the official site before travelling for opening hours, tickets, accessibility and current exhibitions. Map results come from Apple Maps."
                    )
                )
                .font(.footnote).foregroundStyle(.secondary)
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth)
                .frame(maxWidth: .infinity)
        }.background(ArchiveStyle.background).navigationTitle(place.name)
            .navigationBarTitleDisplayMode(.inline)
            .task(id: place.id) { await mapModel.load(place) }
    }
}
