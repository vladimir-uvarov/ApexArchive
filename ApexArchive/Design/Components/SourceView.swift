//
// SourceView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct SourceView: View {
    let source: EditorialSource
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
            Divider()
            Link(destination: source.url) {
                Label(
                    EditorialText.value(source.title, key: "editorial.\(source.title)"),
                    systemImage: "arrow.up.right.square")
            }.font(
                .footnote.weight(.semibold))
            Text(
                String.localizedStringWithFormat(
                    String(localized: "source_view.source.checked", defaultValue: "Source checked %@"),
                    String(describing: EditorialText.value(source.checkedOn, key: "editorial.\(source.checkedOn)")))
            ).font(.caption).foregroundStyle(.secondary)
        }
    }
}
