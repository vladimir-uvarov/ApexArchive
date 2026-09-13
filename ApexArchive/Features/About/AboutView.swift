//
// AboutView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section(String(localized: "about.independent")) {
                    Text(String(localized: "about.independent.body"))
                }
                Section(String(localized: "about.data")) {
                    Text(String(localized: "about.data.body"))
                    if let url = URL(string: "https://github.com/f1db/f1db") {
                        Link(String(localized: "about.f1db"), destination: url)
                    }
                    if let url = URL(string: "https://creativecommons.org/licenses/by/4.0/") {
                        Link(String(localized: "about.data.license"), destination: url)
                    }
                }
                Section(String(localized: "about.photos")) {
                    Text(String(localized: "about.photos.body"))
                }
                Section(String(localized: "about.privacy")) {
                    Text(String(localized: "about.privacy.body"))
                }
                Section(String(localized: "about.collections")) {
                    Text(String(localized: "about.collections.body"))
                }
            }.navigationTitle(String(localized: "about.title"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "common.done")) { dismiss() }
                    }
                }
        }
    }
}
