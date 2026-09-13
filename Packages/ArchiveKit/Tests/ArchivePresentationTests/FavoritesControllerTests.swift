//
// FavoritesControllerTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchivePresentation
import XCTest

@MainActor final class FavoritesControllerTests: XCTestCase {
    func testFailedWriteDoesNotPublishUnpersistedFavorite() {
        let store = TestFavoritesStore()
        store.failSave = true
        let model = FavoritesController(store: store)
        model.toggle("senna")
        XCTAssertFalse(model.contains("senna"))
        XCTAssertNotNil(model.errorMessage)
        store.failSave = false
        model.toggle("senna")
        XCTAssertTrue(model.contains("senna"))
        XCTAssertNil(model.errorMessage)
    }

    func testFailedReadBlocksDestructiveOverwriteUntilRetry() {
        let store = TestFavoritesStore()
        store.identifiers = ["norris"]
        store.failLoad = true
        let model = FavoritesController(store: store)
        model.toggle("senna")
        XCTAssertEqual(store.identifiers, ["norris"])
        store.failLoad = false
        model.reload()
        model.toggle("senna")
        XCTAssertEqual(store.identifiers, ["norris", "senna"])
    }

    func testUnknownIDsSurviveUntilTheirDriverIsFetched() {
        let store = TestFavoritesStore()
        store.identifiers = ["future-driver"]
        let model = FavoritesController(store: store)
        model.toggle("senna")
        XCTAssertEqual(store.identifiers, ["future-driver", "senna"])
    }
}
