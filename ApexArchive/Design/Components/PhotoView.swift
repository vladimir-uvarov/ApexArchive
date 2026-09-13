//
// PhotoView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchivePresentation
import Foundation
import SwiftUI

struct PhotoView<Placeholder: View>: View {
    let wikipediaTitle: String?
    let accessibilityLabel: String
    var showsCredit = true
    @ViewBuilder let placeholder: () -> Placeholder
    @Environment(PhotoLibrary.self) private var library
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var image: UIImage?
    @State private var hasDisplayedImage = false

    var body: some View {
        let data = wikipediaTitle.flatMap { library.photo(for: $0).data }
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                if let title = wikipediaTitle, let asset = library.photo(for: title).asset, let image {
                    Image(uiImage: image).resizable().scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped().accessibilityLabel(accessibilityLabel)
                        .transition(.opacity)
                    if showsCredit {
                        PhotoCreditButton(asset: asset)
                            .padding([.leading, .bottom], DesignTokens.photoCreditTouchInset)
                    }
                } else {
                    placeholder().frame(maxWidth: .infinity, maxHeight: .infinity)

                }
            }.frame(width: geometry.size.width, height: geometry.size.height).clipped()
        }
        .contentShape(Rectangle())
        .onDisappear { image = nil }
        .task(id: data) {
            guard let data, let decoded = UIImage(data: data) else {
                image = nil
                // The bounded cache can evict a photo while its card is still on screen. Only a card
                // that already showed one asks again, so first appearances keep their load delay.
                if hasDisplayedImage, let wikipediaTitle { await library.load(wikipediaTitle) }
                return
            }

            hasDisplayedImage = true

            let prepared = await decoded.byPreparingForDisplay() ?? decoded
            guard !Task.isCancelled else { return }
            withAnimation(reduceMotion ? nil : MotionTokens.photoReveal) { image = prepared }
        }
        .task(id: wikipediaTitle) {
            guard let wikipediaTitle else { return }
            // Avoid starting requests for cards that pass quickly through the viewport.
            do { try await Task.sleep(for: DesignTokens.photoLoadDelay) } catch { return }
            await library.load(wikipediaTitle)
        }
    }

}
