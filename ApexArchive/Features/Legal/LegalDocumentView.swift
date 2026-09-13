//
// LegalDocumentView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import SwiftUI

struct LegalDocumentView: View {
    let document: LegalDocument
    @State private var content: String?
    @State private var isLoaded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                Text(
                    String(
                        localized: "legal.language", defaultValue: "Legal documents are currently provided in English.")
                )
                .font(.caption).foregroundStyle(.secondary)
                if let content {
                    Text(verbatim: content).textSelection(.enabled)
                } else if isLoaded {
                    ContentUnavailableView(
                        String(localized: "legal.unavailable", defaultValue: "Document unavailable"),
                        systemImage: "doc.text")
                } else {
                    ProgressView().frame(maxWidth: .infinity)
                }
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                maxWidth: .infinity)
        }.navigationTitle(document.title).navigationBarTitleDisplayMode(.inline)
            // Read once off the main actor: these documents are up to ~18 KB and a computed
            // property would re-read them on every rotation, Dynamic Type change and invalidation.
            .task(id: document.resource) {
                let resource = document.resource
                content = await Task.detached {
                    Bundle.main.url(forResource: resource, withExtension: "txt")
                        .flatMap { try? String(contentsOf: $0, encoding: .utf8) }
                }.value
                isLoaded = true
            }
    }
}
