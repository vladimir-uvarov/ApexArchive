//
// CircuitCard.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct CircuitCard: View {
    let circuit: Circuit

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
            CircuitOutlineView(outline: circuit.outline, venueName: circuit.name).frame(
                height: DesignTokens.featuredImageHeight
            )
            .background(ArchiveStyle.background)
            VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                Text(circuit.name).font(.headline)
                Text(CountryFlag.symbol(for: circuit.countryCode) + " " + circuit.country).foregroundStyle(.secondary)
                if let record = circuit.record {
                    Label(record.time, systemImage: "stopwatch").font(.title3.monospacedDigit().bold())
                    Text(
                        String(
                            localized: "circuits.record.label", defaultValue: "Fastest recorded race lap · shown layout"
                        )
                    )
                    .font(.caption).foregroundStyle(.secondary)
                } else {
                    Text(
                        String(
                            localized: "circuits.record.missing",
                            defaultValue: "No race lap record available for this layout")
                    )
                    .font(.caption).foregroundStyle(.secondary)
                }
            }.padding([.horizontal, .bottom], DesignTokens.spacingLarge)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            .contentShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
    }
}
