//
// ArchiveStyle.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI
import UIKit

/// White and racing green by day; deep navy and gold by night.
enum ArchiveStyle {
    static let accent = adaptive(light: 0x17634B, dark: 0xF6D64A)
    static let background = Color("LaunchBackground")
    static let card = adaptive(light: 0xFFFFFF, dark: 0x142239)
    static let interactive = accent
    static let gold = adaptive(light: 0x816000, dark: 0xF6D64A)
    private static let channelMask: UInt32 = 0xFF
    private static let redShift: UInt32 = 16
    private static let greenShift: UInt32 = 8
    private static func adaptive(light: UInt32, dark: UInt32) -> Color {
        Color(
            uiColor: UIColor { traits in
                let hex = traits.userInterfaceStyle == .dark ? dark : light
                return UIColor(
                    red: CGFloat((hex >> redShift) & channelMask) / CGFloat(channelMask),
                    green: CGFloat((hex >> greenShift) & channelMask) / CGFloat(channelMask),
                    blue: CGFloat(hex & channelMask) / CGFloat(channelMask), alpha: 1)
            })
    }

    static func tint(for driver: Driver) -> Color { driver.category == .legends ? gold : accent }
}
