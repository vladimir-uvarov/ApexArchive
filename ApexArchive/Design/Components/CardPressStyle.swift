//
// CardPressStyle.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import SwiftUI

/// Gives a card a small amount of give under the finger, so tapping feels answered before the
/// navigation begins. Reduce Motion removes the scale rather than shortening it.
struct CardPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? MotionTokens.pressScale : 1)
            .animation(reduceMotion ? nil : MotionTokens.press, value: configuration.isPressed)
    }
}
