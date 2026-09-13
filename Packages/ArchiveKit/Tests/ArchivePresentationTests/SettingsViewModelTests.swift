//
// SettingsViewModelTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import XCTest

@MainActor final class SettingsViewModelTests: XCTestCase {
    func testRestoresInstalledIconAndCanReturnToOriginal() async {
        let service = TestAppIconService()
        service.currentIcon = .pearl
        let model = SettingsViewModel(service: service)
        XCTAssertEqual(model.selectedIcon, .pearl)
        await model.select(.original)
        XCTAssertEqual(model.selectedIcon, .original)
        XCTAssertNil(model.selectedIcon.alternateName)
        XCTAssertFalse(model.isChangingIcon)
    }

    func testFailurePreservesInstalledIconAndRetryClearsError() async {
        let service = TestAppIconService()
        service.shouldFail = true
        let model = SettingsViewModel(service: service)
        await model.select(.crimson)
        XCTAssertEqual(model.selectedIcon, .original)
        XCTAssertTrue(model.hasIconError)
        XCTAssertTrue(model.iconErrorDetails?.contains("NSCocoaErrorDomain") == true)
        XCTAssertFalse(model.isChangingIcon)
        service.shouldFail = false
        await model.select(.crimson)
        XCTAssertEqual(model.selectedIcon, .crimson)
        XCTAssertFalse(model.hasIconError)
        XCTAssertNil(model.iconErrorDetails)
    }

    func testUnsupportedAndAlreadySelectedIconsDoNotCallSystem() async {
        let service = TestAppIconService()
        let model = SettingsViewModel(service: service)
        await model.select(.original)
        service.supportsAlternateIcons = false
        await model.select(.glacier)
        XCTAssertTrue(service.requestedIcons.isEmpty)
    }

    func testConcurrentSelectionDoesNotOverlapSystemRequests() async {
        let service = TestAppIconService()
        service.shouldSuspend = true
        let model = SettingsViewModel(service: service)
        let first = Task { await model.select(.crimson) }
        while service.continuation == nil { await Task.yield() }
        XCTAssertTrue(model.isChangingIcon)
        XCTAssertEqual(model.selectedIcon, .original)
        await model.select(.pearl)
        XCTAssertEqual(service.requestedIcons, [.crimson])
        service.continuation?.resume()
        await first.value
        XCTAssertEqual(model.selectedIcon, .crimson)
        XCTAssertFalse(model.isChangingIcon)
    }

    func testSystemErrorAfterApplyingRequestedIconDoesNotShowFalseFailure() async {
        let service = TestAppIconService()
        service.shouldFail = true
        service.changesBeforeFailure = true
        let model = SettingsViewModel(service: service)
        await model.select(.crimson)
        XCTAssertEqual(model.selectedIcon, .crimson)
        XCTAssertFalse(model.hasIconError)
        XCTAssertFalse(model.isChangingIcon)
    }

    func testRefreshUsesSystemSelection() {
        let service = TestAppIconService()
        let model = SettingsViewModel(service: service)
        service.currentIcon = .glacier
        model.refresh()
        XCTAssertEqual(model.selectedIcon, .glacier)
    }

    /// The object graph is built before UIKit reports an installed alternate icon, so the value
    /// captured at init can be wrong on the first frame. The launch treatment reads the system.
    func testInstalledIconReflectsTheSystemEvenWhenTheCachedSelectionIsStale() {
        let service = TestAppIconService()
        let model = SettingsViewModel(service: service)
        XCTAssertEqual(model.selectedIcon, .original)

        service.currentIcon = .crimson
        XCTAssertEqual(model.installedIcon, .crimson, "the splash must ask the system")
        XCTAssertEqual(model.selectedIcon, .original, "the cached selection is still the old value")

        model.refresh()
        XCTAssertEqual(model.selectedIcon, .crimson)
    }
}
