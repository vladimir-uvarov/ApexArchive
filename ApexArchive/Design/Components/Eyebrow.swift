//
// Eyebrow.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct Eyebrow: View {
    let text: String
    var body: some View {
        Text(text.uppercased()).font(.caption2.weight(.bold)).tracking(DesignTokens.eyebrowTracking).foregroundStyle(
            .secondary)
    }
}
