//
// CircuitOutlineView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct CircuitOutlineView: View {
    let outline: CircuitOutline?
    /// Names the venue for VoiceOver. `nil` hides the shape, which the circuit quiz needs so the
    /// label cannot give away the answer.
    var venueName: String?

    var body: some View {
        GeometryReader { geometry in
            if let outline, !outline.points.isEmpty {
                let inset = DesignTokens.spacingLarge
                let side = max(0, min(geometry.size.width, geometry.size.height) - inset * 2)
                let maxX = outline.points.map(\.x).max() ?? 1
                let maxY = outline.points.map(\.y).max() ?? 1
                Path { path in
                    for (index, point) in outline.points.enumerated() {
                        let position = CGPoint(
                            x: (geometry.size.width - side * CGFloat(maxX)) / 2 + CGFloat(point.x) * side,
                            y: (geometry.size.height - side * CGFloat(maxY)) / 2 + CGFloat(point.y) * side)
                        if index == 0 { path.move(to: position) } else { path.addLine(to: position) }
                    }
                }.stroke(
                    ArchiveStyle.interactive,
                    style: StrokeStyle(lineWidth: DesignTokens.circuitLineWidth, lineCap: .round, lineJoin: .round))
            } else {
                ContentUnavailableView(
                    String(localized: "circuits.outline.missing", defaultValue: "Outline unavailable"),
                    systemImage: "point.topleft.down.to.point.bottomright.curvepath")
            }
        }
        .accessibilityElement()
        .accessibilityLabel(accessibilityDescription)
        .accessibilityHidden(venueName == nil)
    }

    private var accessibilityDescription: String {
        guard let venueName else { return "" }
        guard let outline, !outline.points.isEmpty else {
            return String(localized: "circuits.outline.missing", defaultValue: "Outline unavailable")
        }

        return String.localizedStringWithFormat(
            String(localized: "circuits.outline.label", defaultValue: "Track outline of %@"), venueName)
    }
}
