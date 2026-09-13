//
// DesignTokens.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

/// Shared spacing scale and semantic component dimensions. Change the visual system here.
enum DesignTokens {
    static let photoLoadDelay: Duration = .milliseconds(150)
    static let photoCreditIconSize: CGFloat = 24
    static let minimumTouchTarget: CGFloat = 44
    static let photoCreditInset: CGFloat = 15
    // Keep the visible icon at the requested inset while retaining a 44-point hit target.
    static let photoCreditTouchInset = photoCreditInset - (minimumTouchTarget - photoCreditIconSize) / 2
    static let photoCreditMaxWidth: CGFloat = 280
    static let spacingSmall: CGFloat = 8
    static let spacingCompact: CGFloat = 10
    static let spacingMedium: CGFloat = 12
    static let spacingRegular: CGFloat = 16
    static let spacingLarge: CGFloat = 20
    static let spacingSection: CGFloat = 24
    static let spacingPage: CGFloat = 28
    static let cardCornerRadius: CGFloat = 22
    static let heroCornerRadius: CGFloat = 26
    static let chipCornerRadius: CGFloat = 18
    static let contentMaxWidth: CGFloat = 760
    static let gridMaxWidth: CGFloat = 900
    static let gridMinWidth: CGFloat = 155
    static let gridSpacing: CGFloat = 14
    static let driverThumbnailHeight: CGFloat = 142
    static let featuredImageHeight: CGFloat = 230
    static let portraitHeight: CGFloat = 260
    static let carImageHeight: CGFloat = 210
    static let emptyStateTopInset: CGFloat = 70
    static let carSymbolSize: CGFloat = 44
    static let carHeroSymbolSize: CGFloat = 95
    static let initialsSize: CGFloat = 66
    static let largeInitialsSize: CGFloat = 118
    static let recordFontSize: CGFloat = 76
    static let captionTracking: CGFloat = 2
    static let eyebrowTracking: CGFloat = 2.5
    static let titleTracking: CGFloat = -1.3
    static let minimumTextScale: CGFloat = 0.5
    static let artworkTextScale: CGFloat = 0.4
    static let artworkScale: CGFloat = 1.2
    static let artworkOffset: CGFloat = 0.2
    static let borderOpacity = 0.12
    static let selectionOpacity = 0.18
    static let artworkOpacity = 0.25
    static let mutedOpacity = 0.15
    static let strokeWidth: CGFloat = 1
    static let circuitLineWidth: CGFloat = 3
    static let discoveryOptionWidth: CGFloat = 216
    static let discoveryOptionHeight: CGFloat = 132
    static let discoveryCompactOptionHeight: CGFloat = 88
    static let discoveryCompactHeight: CGFloat = 500
    static let discoveryCompactSpotlightHeight: CGFloat = 240
    static let discoveryArtworkFraction: CGFloat = 0.55
    static let discoveryCompactArtworkFraction: CGFloat = 0.32
    static let discoveryLandscapeMenuFraction: CGFloat = 0.38
    static let discoveryPagerInset: CGFloat = 28
    static let discoveryCompactStoryHeight: CGFloat = 320
    static let discoveryPortraitWidth: CGFloat = 72
    static let discoveryPortraitHeight: CGFloat = 80
    static let discoveryPortraitRowHeight: CGFloat = 108
    static let discoveryStoryTextAllowance: CGFloat = 168
    static let singleLine = 1
}
