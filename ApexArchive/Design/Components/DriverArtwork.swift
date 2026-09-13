//
// DriverArtwork.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct DriverArtwork: View {
    let driver: Driver
    var large = false
    var showsPhotoCredit = true
    var body: some View {
        PhotoView(
            wikipediaTitle: driver.wikipediaTitle, accessibilityLabel: driver.name,
            showsCredit: showsPhotoCredit
        ) {
            DriverPlaceholderView(driver: driver, large: large)
        }
    }
}
