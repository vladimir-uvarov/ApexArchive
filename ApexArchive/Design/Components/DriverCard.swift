//
// DriverCard.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct DriverCard: View {
    @Environment(PhotoLibrary.self) private var photos
    let driver: Driver
    var contribution: DriverContribution? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if !imageUnavailable {
                DriverArtwork(driver: driver).frame(height: DesignTokens.driverThumbnailHeight)
                    .overlay(alignment: .bottomLeading) {
                        if driver.category == .legends {
                            Label(
                                String(localized: "driver.legend.badge", defaultValue: "Legend"),
                                systemImage: "laurel.leading"
                            )
                            .font(.caption.bold()).padding(DesignTokens.spacingSmall)
                            .background(.regularMaterial, in: Capsule()).padding(DesignTokens.spacingMedium)
                        }
                    }
            }
            VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                if imageUnavailable && driver.category == .legends {
                    Label(
                        String(localized: "driver.legend.badge", defaultValue: "Legend"), systemImage: "laurel.leading"
                    )
                    .font(.caption.bold()).foregroundStyle(ArchiveStyle.gold)
                }
                Eyebrow(text: EditorialText.value(driver.country, key: "driver.\(driver.id).country"))
                if let contribution { DriverContributionBadge(contribution: contribution) }
                Text(driver.name).font(.headline).foregroundStyle(.primary)
                Text(EditorialText.value(driver.subtitle, key: "driver.\(driver.id).subtitle")).font(.caption)
                    .foregroundStyle(.secondary).fixedSize(
                        horizontal: false, vertical: true)
            }.padding(DesignTokens.spacingRegular).frame(maxWidth: .infinity, alignment: .leading)
        }.background(ArchiveStyle.card).clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius).stroke(
                    .primary.opacity(DesignTokens.borderOpacity))
            )
            .accessibilityElement(children: .combine)
    }

    private var imageUnavailable: Bool {
        guard let title = driver.wikipediaTitle else { return true }

        // Only a confirmed absence hides the image area. A transient failure keeps the frame (and
        // therefore PhotoView) in the tree, so the photo can still load on a later appearance.
        return photos.photo(for: title).unavailable
    }

}
