//
// RecordSection.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct RecordSection: View {
    let title: String
    let icon: String
    let record: CareerRecord?
    let emptyDescription: String
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
            Text(title).font(.title2.bold())
            if let record {
                VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                    Image(systemName: icon).font(.title).foregroundStyle(ArchiveStyle.interactive)
                    Text(record.count, format: .number).font(
                        .system(size: DesignTokens.recordFontSize, weight: .heavy, design: .rounded)
                    ).minimumScaleFactor(DesignTokens.minimumTextScale).lineLimit(DesignTokens.singleLine)
                    Eyebrow(text: EditorialText.value(record.scope, key: "editorial.\(record.scope)"))
                    Text(EditorialText.value(record.note, key: "editorial.\(record.note)")).lineSpacing(
                        DesignTokens.spacingSmall)
                    SourceView(source: record.source)
                }.padding(DesignTokens.spacingSection).frame(maxWidth: .infinity, alignment: .leading).background(
                    ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.heroCornerRadius))
            } else {
                ContentUnavailableView(
                    String(
                        localized: "record_section.record.awaiting.verification",
                        defaultValue: "Record awaiting verification"), systemImage: icon,
                    description: Text(emptyDescription))
            }
        }
    }
}
