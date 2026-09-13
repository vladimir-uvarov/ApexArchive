//
// CircuitsScreen.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct CircuitsScreen: View {
    @State private var model: CircuitsViewModel

    init(circuits: [Circuit]) { _model = State(initialValue: CircuitsViewModel(circuits: circuits)) }

    var body: some View {
        let circuits = model.visibleCircuits
        return ScrollView {
            LazyVStack(spacing: DesignTokens.spacingLarge) {
                Text(
                    String(
                        localized: "circuits.intro",
                        defaultValue: "Current and historic World Championship venues around the world.")
                )
                .font(.subheadline).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .leading)
                ForEach(circuits) { circuit in
                    NavigationLink {
                        CircuitDetailView(circuit: circuit)
                    } label: {
                        CircuitCard(circuit: circuit)
                    }
                    .buttonStyle(.plain)
                }
                if circuits.isEmpty {
                    ContentUnavailableView.search(text: model.query)
                }
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth)
                .frame(maxWidth: .infinity)
        }.background(ArchiveStyle.background)
            .navigationTitle(String(localized: "circuits.title", defaultValue: "Circuits"))
            .searchable(
                text: $model.query, prompt: String(localized: "circuits.search", defaultValue: "Circuit or country"))
    }
}
