//
// AppIconArtworkTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import UIKit
import XCTest

@testable import ApexArchive

/// The splash and the icon picker name assets by convention. A helmet without matching artwork
/// would only surface as a blank square at launch, so every selectable icon is checked here.
final class AppIconArtworkTests: XCTestCase {
    func testEverySelectableIconHasSplashArtwork() {
        for icon in AppIcon.allCases {
            XCTAssertNotNil(UIImage(named: icon.splashArtworkName), "missing \(icon.splashArtworkName)")
        }
    }

    func testEverySelectableIconHasAPreviewImage() {
        for icon in AppIcon.allCases {
            XCTAssertNotNil(UIImage(named: icon.previewName), "missing \(icon.previewName)")
        }
    }

    func testSplashArtworkIsDistinctPerIcon() {
        let names = Set(AppIcon.allCases.map(\.splashArtworkName))
        XCTAssertEqual(names.count, AppIcon.allCases.count, "two icons share splash artwork")
    }
}
