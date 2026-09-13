//
// ArchiveStoreTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

@MainActor final class ArchiveStoreTests: XCTestCase {
    func testLateBootstrapCannotReplaceAnExplicitRefresh() async {
        let bootstrap = SuspendedArchiveRepository()
        let fresh = ArchiveFixtures.snapshot(name: "Fresh")
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.success(fresh)]), bootstrap: bootstrap)
        let initialLoad = Task { await store.loadIfNeeded() }
        await bootstrap.waitUntilStarted()
        await store.reload()
        await bootstrap.complete(with: ArchiveFixtures.snapshot(name: "Stale"))
        await initialLoad.value
        XCTAssertEqual(store.snapshot, fresh)
    }

    func testLoadsOnlyOnceUntilExplicitRefresh() async {
        let repository = ScriptedArchiveRepository([.success(ArchiveFixtures.snapshot())])
        let store = ArchiveStore(repository: repository)
        await store.loadIfNeeded()
        await store.loadIfNeeded()
        let calls = await repository.calls
        XCTAssertEqual(calls, 1)
        XCTAssertEqual(store.state, .loaded(ArchiveFixtures.snapshot()))
    }

    func testFailedRefreshKeepsPreviousContentAndRetryRecovers() async {
        let repository = ScriptedArchiveRepository([
            .success(ArchiveFixtures.snapshot()), .failure(ArchiveValidationError.invalidDriver),
            .success(ArchiveFixtures.snapshot(name: "Updated name")),
        ])
        let store = ArchiveStore(repository: repository)
        await store.reload()
        await store.reload()
        XCTAssertNotNil(store.state.errorMessage)
        XCTAssertEqual(store.snapshot.drivers.first?.name, "Ayrton Senna")
        await store.reload()
        XCTAssertNil(store.state.errorMessage)
        XCTAssertEqual(store.snapshot.drivers.first?.name, "Updated name")
    }

    func testCancellationDoesNotBecomeUserFacingFailure() async {
        let store = ArchiveStore(repository: ScriptedArchiveRepository([.failure(CancellationError())]))
        await store.reload()
        XCTAssertEqual(store.state, .idle)
    }

    func testInvalidSnapshotIsNeverPublished() async {
        let driver = ArchiveFixtures.driver()
        let store = ArchiveStore(
            repository: ScriptedArchiveRepository([
                .success(ArchiveSnapshot(drivers: [driver, driver], cars: [], achievements: [:]))
            ]))
        await store.reload()
        XCTAssertTrue(store.snapshot.drivers.isEmpty)
        XCTAssertNotNil(store.state.errorMessage)
    }

    func testOfflineBootstrapSurvivesNetworkFailure() async {
        let store = ArchiveStore(
            repository: ScriptedArchiveRepository([.failure(ArchiveValidationError.invalidDriver)]),
            bootstrap: ScriptedArchiveRepository([.success(ArchiveFixtures.snapshot())]))
        await store.loadIfNeeded()
        XCTAssertEqual(store.snapshot, ArchiveFixtures.snapshot())
        XCTAssertNotNil(store.state.errorMessage)
    }
}
