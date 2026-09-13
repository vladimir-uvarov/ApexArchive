//
// MotionTokens.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import SwiftUI

/// Short, purposeful motion; all call sites honor Reduce Motion.
enum MotionTokens {
    static let launchBackground = Color("LaunchBackground")
    static let launchShadowOpacity = 0.4
    static let launchLightShadowOpacity = 0.12
    static let photoReveal = Animation.easeOut(duration: 0.2)
    static let selection = Animation.easeInOut(duration: 0.18)
    static let launchReveal = Animation.easeOut(duration: 0.55)
    static let launchDismiss = Animation.easeInOut(duration: 0.25)
    static let launchDuration: Duration = .milliseconds(550)
    static let launchIconSize: CGFloat = 144
    static let launchInitialScale: CGFloat = 0.92
    static let launchCornerRadius: CGFloat = 32
    static let launchShadowRadius: CGFloat = 24
    static let launchShadowOffset: CGFloat = 12
    static let accentWidth: CGFloat = 44
    static let accentHeight: CGFloat = 3
}
