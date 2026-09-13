//
// ComparisonDriverPicker.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct ComparisonDriverPicker: View {
    let model: DriverComparisonViewModel
    let excludedID: String?
    let select: (Driver) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var body: some View {
        let matches = model.candidates(excluding: excludedID, matching: query)
        return NavigationStack {
            List(matches) { driver in
                Button {
                    select(driver)
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                        Text(driver.name).font(.headline).foregroundStyle(.primary)
                        Text(driver.country).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .overlay { if matches.isEmpty { ContentUnavailableView.search(text: query) } }
            .searchable(
                text: $query, prompt: String(localized: "comparison.search", defaultValue: "Search driver or country")
            )
            .navigationTitle(String(localized: "comparison.choose", defaultValue: "Choose driver"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "common.done")) { dismiss() }
                }
            }
        }
    }
}
