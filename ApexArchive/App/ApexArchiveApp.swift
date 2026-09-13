//
// ApexArchiveApp.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import SwiftUI

@main struct ApexArchiveApp: App {
    @State private var dependencies = AppDependencies()
    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies, archive: dependencies.archive)
                .environment(dependencies.photos)
                .tint(ArchiveStyle.interactive)
        }
    }
}
