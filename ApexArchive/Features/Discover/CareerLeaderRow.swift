//
// CareerLeaderRow.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct CareerLeaderRow: View {
    let entry: CareerLeader
    var showsPortrait = false
    var showsDisclosureIndicator = false
    @Environment(PhotoLibrary.self) private var photos

    var body: some View {
        HStack(spacing: DesignTokens.spacingRegular) {
            if showsPortrait {
                DriverArtwork(driver: entry.driver, showsPhotoCredit: false)
                    .frame(width: DesignTokens.discoveryPortraitWidth, height: DesignTokens.discoveryPortraitHeight)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            }
            VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                Text(entry.driver.name).font(.headline)
                Text(entry.driver.country).font(.caption).foregroundStyle(.secondary)
            }
            Spacer(minLength: DesignTokens.spacingSmall)
            VStack(spacing: .zero) {
                Text(entry.record.count.formatted()).font(.title2.monospacedDigit().bold())
                    .foregroundStyle(ArchiveStyle.interactive)
                if showsPortrait, let title = entry.driver.wikipediaTitle, let asset = photos.photo(for: title).asset {
                    PhotoCreditButton(asset: asset)
                }
            }
            if showsDisclosureIndicator {
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
            }
        }.padding(.vertical, DesignTokens.spacingMedium)
            .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
    }
}
