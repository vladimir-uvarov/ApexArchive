//
// IconOptionView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct IconOptionView: View {
    let icon: AppIcon
    let isSelected: Bool

    var body: some View {
        HStack(spacing: DesignTokens.spacingLarge) {
            Image(icon.previewName)
                .resizable().scaledToFit()
                .frame(width: SettingsStyle.iconPreviewSize, height: SettingsStyle.iconPreviewSize)
                .clipShape(RoundedRectangle(cornerRadius: SettingsStyle.iconCornerRadius, style: .continuous))
                .accessibilityHidden(true)
            Text(icon.title).font(.headline).foregroundStyle(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(ArchiveStyle.interactive)
            }
        }
        .padding(.vertical, DesignTokens.spacingSmall)
        .contentShape(Rectangle())
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
