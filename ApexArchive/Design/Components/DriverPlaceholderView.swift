//
// DriverPlaceholderView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct DriverPlaceholderView: View {
    let driver: Driver
    var large = false
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    ArchiveStyle.tint(for: driver).opacity(DesignTokens.artworkOpacity),
                    Color.black.opacity(DesignTokens.mutedOpacity),
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
            GeometryReader { geometry in
                ZStack {
                    Circle().stroke(
                        ArchiveStyle.tint(for: driver).opacity(DesignTokens.artworkOpacity),
                        lineWidth: DesignTokens.strokeWidth)
                    Circle().inset(by: DesignTokens.spacingLarge).stroke(
                        ArchiveStyle.tint(for: driver).opacity(DesignTokens.mutedOpacity),
                        lineWidth: DesignTokens.strokeWidth)
                    Circle().inset(by: DesignTokens.carSymbolSize).stroke(
                        ArchiveStyle.tint(for: driver).opacity(DesignTokens.borderOpacity),
                        lineWidth: DesignTokens.strokeWidth)
                }.frame(
                    width: geometry.size.width * DesignTokens.artworkScale,
                    height: geometry.size.width * DesignTokens.artworkScale
                )
                .offset(x: geometry.size.width * DesignTokens.artworkOffset, y: -DesignTokens.spacingLarge)
            }
            Text(driver.initials).font(
                .system(
                    size: large ? DesignTokens.largeInitialsSize : DesignTokens.initialsSize, weight: .black,
                    design: .rounded)
            ).italic()
                .foregroundStyle(ArchiveStyle.tint(for: driver)).minimumScaleFactor(DesignTokens.artworkTextScale)
                .lineLimit(DesignTokens.singleLine).padding(DesignTokens.spacingLarge)
        }.clipped().accessibilityHidden(true)
    }
}
