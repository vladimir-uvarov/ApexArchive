//
// SectionTitle.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct SectionTitle: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
            Text(title).font(.title2.bold())
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
