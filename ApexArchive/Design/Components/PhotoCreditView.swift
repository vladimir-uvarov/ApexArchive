//
// PhotoCreditView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct PhotoCreditView: View {
    let asset: PhotoAsset

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMedium) {
            Text(String(localized: "photo_credit_view.photo.credit", defaultValue: "Photo credit"))
                .font(.headline)
            Text(asset.author).font(.subheadline).fixedSize(horizontal: false, vertical: true)
            if let attribution = asset.attribution, !attribution.isEmpty {
                Text(attribution).font(.caption).fixedSize(horizontal: false, vertical: true)
            }
            Link(asset.license, destination: asset.licenseURL).font(.caption)
            Text(
                String(
                    localized: "photo_credit_view.display.adjustments", defaultValue: "Resized or cropped for display.")
            )
            .font(.caption).foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            Link(
                String(
                    localized: "photo_credit_view.original.file.and.full.attribution",
                    defaultValue: "Original file and full attribution"), destination: asset.pageURL
            )
            .font(.caption)
        }
        .padding(DesignTokens.spacingRegular)
        .frame(width: DesignTokens.photoCreditMaxWidth)
        .fixedSize(horizontal: false, vertical: true)
    }
}
