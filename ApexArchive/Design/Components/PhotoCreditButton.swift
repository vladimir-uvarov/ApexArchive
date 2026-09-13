//
// PhotoCreditButton.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct PhotoCreditButton: View {
    let asset: PhotoAsset
    @State private var showingCredit = false

    var body: some View {
        Button {
            showingCredit = true
        } label: {
            Image(systemName: "info")
                .font(.caption.weight(.semibold))
                .frame(width: DesignTokens.photoCreditIconSize, height: DesignTokens.photoCreditIconSize)
                .background(.ultraThinMaterial, in: Circle())
                .frame(width: DesignTokens.minimumTouchTarget, height: DesignTokens.minimumTouchTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            String(localized: "photo_view.photo.credit.and.license", defaultValue: "Photo credit and license")
        )
        .popover(isPresented: $showingCredit, attachmentAnchor: .rect(.bounds), arrowEdge: .bottom) {
            PhotoCreditView(asset: asset)
                .presentationCompactAdaptation(.popover)
        }
    }
}
