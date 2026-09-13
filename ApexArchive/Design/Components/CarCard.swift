//
// CarCard.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct CarCard: View {
    @Environment(PhotoLibrary.self) private var photos
    let car: PersonalCar
    let driverName: String
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if !imageUnavailable {
                PhotoView(
                    wikipediaTitle: car.wikipediaTitle,
                    accessibilityLabel: String.localizedStringWithFormat(
                        String(
                            localized: "car_card.representative.photo.of", defaultValue: "Representative photo of %@"),
                        String(describing: car.name))
                ) {
                    Image(systemName: "car.side.fill").font(.system(size: DesignTokens.carSymbolSize)).foregroundStyle(
                        ArchiveStyle.gold)
                }.frame(height: DesignTokens.carImageHeight).clipped()
            }
            VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                Eyebrow(text: driverName)
                Text(car.name).font(.title3.bold()).foregroundStyle(.primary)
                Label(
                    EditorialText.value(car.relationship, key: "car.\(car.id).relationship"),
                    systemImage: "doc.text.magnifyingglass"
                ).font(.caption).foregroundStyle(
                    .secondary)
            }.padding(DesignTokens.spacingLarge)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius).stroke(
                    .primary.opacity(DesignTokens.borderOpacity))
            )
            .accessibilityElement(children: .combine)
    }

    private var imageUnavailable: Bool {
        guard let title = car.wikipediaTitle else { return true }

        // Only a confirmed absence hides the image area. A transient failure keeps the frame (and
        // therefore PhotoView) in the tree, so the photo can still load on a later appearance.
        return photos.photo(for: title).unavailable
    }

}
