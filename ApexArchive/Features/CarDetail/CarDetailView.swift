//
// CarDetailView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct CarDetailView: View {
    let car: PersonalCar
    let driverName: String
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingSection) {
                PhotoView(
                    wikipediaTitle: car.wikipediaTitle,
                    accessibilityLabel: String.localizedStringWithFormat(
                        String(
                            localized: "car_detail_view.representative.photo.of",
                            defaultValue: "Representative photo of %@"), String(describing: car.name))
                ) {
                    Image(systemName: "car.side.fill").font(.system(size: DesignTokens.carHeroSymbolSize))
                        .foregroundStyle(ArchiveStyle.gold)
                }.frame(height: DesignTokens.carImageHeight).clipShape(
                    RoundedRectangle(cornerRadius: DesignTokens.heroCornerRadius))
                Eyebrow(
                    text: String.localizedStringWithFormat(
                        String(localized: "car_detail_view.personal.garage", defaultValue: "%@ / Personal garage"),
                        String(describing: driverName)))
                Text(car.name).font(.largeTitle.bold())
                Label(
                    EditorialText.value(car.relationship, key: "car.\(car.id).relationship"),
                    systemImage: "doc.text.magnifyingglass"
                ).font(.subheadline.weight(.semibold))
                Text(EditorialText.value(car.description, key: "car.\(car.id).description")).lineSpacing(
                    DesignTokens.spacingSmall)
                if let facts = car.facts, !facts.isEmpty {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                        Eyebrow(
                            text: String(
                                localized: "car_detail_view.documented.details", defaultValue: "Documented details"))
                        ForEach(Array(facts.enumerated()), id: \.offset) { index, fact in
                            LabeledContent(
                                EditorialText.value(fact.label, key: "car.\(car.id).fact.\(index).label"),
                                value: EditorialText.value(fact.value, key: "car.\(car.id).fact.\(index).value")
                            )
                            .font(.subheadline)
                        }
                    }.padding(DesignTokens.spacingLarge)
                        .background(
                            ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                }
                VStack(alignment: .leading, spacing: DesignTokens.gridSpacing) {
                    Eyebrow(text: String(localized: "car_detail_view.the.evidence", defaultValue: "The evidence"))
                    Text(
                        String.localizedStringWithFormat(
                            String(localized: "car_detail_view.source.date", defaultValue: "Source date: %@"),
                            EditorialText.value(car.evidenceDate, key: "car.\(car.id).evidenceDate"))
                    ).font(.subheadline)
                    Link(destination: car.sourceURL) {
                        Label(
                            EditorialText.value(car.sourceTitle, key: "car.\(car.id).sourceTitle"),
                            systemImage: "arrow.up.right.square")
                    }
                    .font(.subheadline.weight(.semibold))
                    Text(
                        String(
                            localized: "car_detail_view.this.evidence.describes.a.historical.connection.it",
                            defaultValue:
                                "This evidence describes a historical connection. It does not establish current ownership."
                        )
                    )
                    .font(.footnote).foregroundStyle(.secondary)
                }.padding(DesignTokens.spacingLarge).frame(maxWidth: .infinity, alignment: .leading).background(
                    ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                Text(
                    String(
                        localized: "car_detail_view.representative.model.photo.it.does.not.establish",
                        defaultValue:
                            "Representative model photo. It does not establish ownership of the exact photographed vehicle."
                    )
                )
                .font(.caption).foregroundStyle(.secondary)
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                maxWidth: .infinity)
        }.background(ArchiveStyle.background).navigationTitle(
            String(localized: "car_detail_view.the.car", defaultValue: "The car")
        ).navigationBarTitleDisplayMode(.inline)
    }
}
