//
// LaunchScreenView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

/// Matches the system launch background while the initial archive becomes available.
struct LaunchScreenView: View {
    let icon: AppIcon
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @State private var appeared = false

    var body: some View {
        ZStack {
            MotionTokens.launchBackground.ignoresSafeArea()
            VStack(spacing: DesignTokens.spacingSection) {
                Image(icon.splashArtworkName)
                    .resizable().scaledToFit()
                    .frame(width: MotionTokens.launchIconSize, height: MotionTokens.launchIconSize)
                    .clipShape(RoundedRectangle(cornerRadius: MotionTokens.launchCornerRadius, style: .continuous))
                    .shadow(
                        color: .black.opacity(
                            colorScheme == .dark
                                ? MotionTokens.launchShadowOpacity : MotionTokens.launchLightShadowOpacity),
                        radius: MotionTokens.launchShadowRadius,
                        y: MotionTokens.launchShadowOffset
                    )
                    .scaleEffect(appeared || reduceMotion ? 1 : MotionTokens.launchInitialScale)
                Text(String(localized: "app.wordmark", defaultValue: "APEX / ARCHIVE"))
                    .font(.headline.weight(.heavy)).tracking(DesignTokens.captionTracking)
                    .foregroundStyle(.primary)
                Capsule().fill(ArchiveStyle.gold)
                    .frame(width: MotionTokens.accentWidth, height: MotionTokens.accentHeight)
                    .scaleEffect(x: appeared || reduceMotion ? 1 : 0, anchor: .leading)
            }
            .opacity(appeared || reduceMotion ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(String(localized: "app.name", defaultValue: "ApexArchive"))
        .onAppear {
            withAnimation(reduceMotion ? nil : MotionTokens.launchReveal) { appeared = true }
        }
    }
}
