//
// CircuitDetailView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct CircuitDetailView: View {
    let circuit: Circuit

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
                CircuitOutlineView(outline: circuit.outline, venueName: circuit.name).frame(
                    height: DesignTokens.featuredImageHeight)
                Text(circuit.name).font(.largeTitle.bold())
                Text(CountryFlag.symbol(for: circuit.countryCode) + " " + circuit.country).font(.title3)
                Text(String(localized: "circuits.history", defaultValue: "A place in racing history")).font(
                    .title2.bold())
                if let first = circuit.firstYear, let last = circuit.lastYear {
                    Text(
                        String.localizedStringWithFormat(
                            String(
                                localized: "circuits.history.body",
                                defaultValue:
                                    "%@ first appears in the World Championship archive in %@. Across its different layouts, it has hosted %@ recorded Grands Prix, with its latest recorded race in %@."
                            ), circuit.name, String(first), circuit.raceCount.formatted(), String(last)))
                } else {
                    Text(
                        String(
                            localized: "circuits.history.upcoming",
                            defaultValue:
                                "This venue is listed in the archive but has no completed World Championship race recorded yet."
                        ))
                }
                if let length = circuit.length {
                    LabeledContent(
                        String(localized: "circuits.length", defaultValue: "Layout length"),
                        value: String.localizedStringWithFormat(
                            String(localized: "circuits.kilometres", defaultValue: "%@ km"),
                            length.formatted(.number.precision(.fractionLength(3)))))
                }
                if let turns = circuit.turns {
                    LabeledContent(
                        String(localized: "circuits.turns", defaultValue: "Corners"), value: turns.formatted())
                }
                if let year = circuit.lastYear {
                    LabeledContent(
                        String(localized: "circuits.layout.latest", defaultValue: "Latest race on the shown layout"),
                        value: String(year))
                }
                if let record = circuit.record {
                    Text(record.time).font(.largeTitle.monospacedDigit().bold())
                    Text(
                        String.localizedStringWithFormat(
                            String(localized: "circuits.record.driver", defaultValue: "%@ · %@"), record.driver,
                            String(record.year)))
                }
                Text(
                    String(
                        localized: "circuits.record.note",
                        defaultValue:
                            "The best race lap available in F1DB for the most recently raced layout is shown. Qualifying and testing laps are excluded. Historical timing coverage may be incomplete; this is not an absolute all-time speed record."
                    )
                )
                .font(.footnote).foregroundStyle(.secondary)
                SourceView(source: circuit.source)
                if let outline = circuit.outline { SourceView(source: outline.source) }
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth)
                .frame(maxWidth: .infinity)
        }.background(ArchiveStyle.background).navigationBarTitleDisplayMode(.inline)
    }
}
