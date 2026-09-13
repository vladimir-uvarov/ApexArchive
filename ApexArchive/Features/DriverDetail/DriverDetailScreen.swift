//
// DriverDetailScreen.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchivePresentation
import SwiftUI

struct DriverDetailScreen: View {
    private var initialSection: DriverDetailSection = .story
    @State private var viewModel: DriverDetailViewModel
    init(viewModel: @autoclosure @escaping () -> DriverDetailViewModel) {
        _viewModel = State(initialValue: viewModel())
    }

    func opening(_ section: DriverDetailSection) -> Self {
        var screen = self
        screen.initialSection = section
        return screen
    }

    var body: some View { DriverDetailView(viewModel: viewModel, initialSection: initialSection) }
}
