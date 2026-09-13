//
// ComparisonRecordView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct ComparisonRecordView: View {
    let title: String
    let firstName: String
    let secondName: String
    let first: CareerRecord?
    let second: CareerRecord?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
            Text(title).font(.title2.bold())
            entry(name: firstName, record: first)
            Divider()
            entry(name: secondName, record: second)
        }.padding(DesignTokens.spacingLarge)
            .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
    }

    private func entry(name: String, record: CareerRecord?) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
            HStack(alignment: .firstTextBaseline) {
                Text(name).font(.headline)
                Spacer()
                Text(record.map { $0.count.formatted() } ?? "—").font(.title.bold().monospacedDigit())
            }
            if let record {
                Text(EditorialText.value(record.scope, key: "editorial.\(record.scope)"))
                    .font(.caption).foregroundStyle(.secondary)
                SourceView(source: record.source)
            } else {
                Text(String(localized: "comparison.missing", defaultValue: "No verified record available"))
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
