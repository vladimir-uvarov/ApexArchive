//
// PhotoLibraryTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Observation
import XCTest

@MainActor final class PhotoLibraryTests: XCTestCase {
    func testTransportFailureCanBeExplicitlyRetried() async {
        let repository = TestPhotoRepository(failuresBeforeSuccess: 1)
        let library = PhotoLibrary(repository: repository, maximumAutomaticRetries: 0)
        await library.load("Driver")
        XCTAssertTrue(library.photo(for: "Driver").failed)
        XCTAssertFalse(library.photo(for: "Driver").unavailable)
        await library.load("Driver", retry: true)
        XCTAssertFalse(library.photo(for: "Driver").failed)
        XCTAssertNotNil(library.photo(for: "Driver").data)
    }

    /// A card hides its image area only for a confirmed absence, so a transient failure must stay
    /// loadable: otherwise one network blip drops the photo for the rest of the process.
    func testTransportFailureIsRetriedOnTheNextLoadWithoutAnExplicitRetry() async {
        let repository = TestPhotoRepository(failuresBeforeSuccess: 1)
        let library = PhotoLibrary(repository: repository, maximumAutomaticRetries: 0)
        await library.load("Driver")
        XCTAssertTrue(library.photo(for: "Driver").failed)
        await library.load("Driver")
        XCTAssertFalse(library.photo(for: "Driver").failed)
        XCTAssertNotNil(library.photo(for: "Driver").data)
    }

    func testMissingPhotoDoesNotBecomeRetryErrorOrRepeatedRequest() async {
        let repository = TestPhotoRepository(missing: true)
        let library = PhotoLibrary(repository: repository)
        await library.load("Missing")
        await library.load("Missing")
        XCTAssertTrue(library.photo(for: "Missing").unavailable)
        XCTAssertFalse(library.photo(for: "Missing").failed)
        let requests = await repository.requests
        XCTAssertEqual(requests, 1)
    }

    func testMissingPhotoCanBeExplicitlyRetried() async {
        let repository = TestPhotoRepository(missing: true)
        let library = PhotoLibrary(repository: repository)
        await library.load("Missing")
        await library.load("Missing", retry: true)
        let requests = await repository.requests
        XCTAssertEqual(requests, 2)
        XCTAssertTrue(library.photo(for: "Missing").unavailable)
    }

    func testConcurrentViewsShareRequest() async {
        let repository = TestPhotoRepository()
        let library = PhotoLibrary(repository: repository)
        async let first: Void = library.load("Driver")
        async let second: Void = library.load("Driver")
        _ = await (first, second)
        let requests = await repository.requests
        XCTAssertEqual(requests, 1)
        XCTAssertNotNil(library.photo(for: "Driver").data)
    }

    func testUnrelatedPhotoDoesNotInvalidateObservedCard() async {
        let library = PhotoLibrary(repository: TestPhotoRepository())
        let unrelatedUpdate = expectation(description: "Unrelated card update")
        unrelatedUpdate.isInverted = true
        withObservationTracking {
            _ = library.photo(for: "First").data
        } onChange: {
            unrelatedUpdate.fulfill()
        }
        await library.load("Second")
        await fulfillment(of: [unrelatedUpdate], timeout: 0.05)
    }

    func testEvictedPhotoCanBeLoadedAgain() async {
        let library = PhotoLibrary(repository: TestPhotoRepository(), maximumImageCount: 1)
        await library.load("First")
        await library.load("Second")
        XCTAssertNil(library.photo(for: "First").data)
        XCTAssertNotNil(library.photo(for: "Second").data)
        await library.load("First")
        XCTAssertNotNil(library.photo(for: "First").data)
    }

    func testCachedImageAppearsBeforeRefreshAndSurvivesOfflineFailure() async throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/photo"))
        let asset = PhotoAsset(imageURL: url, pageURL: url, author: "Author", license: "CC BY 4.0", licenseURL: url)
        let repository = RefreshingPhotoRepository(asset: asset)
        let library = PhotoLibrary(repository: repository)
        let loading = Task { await library.load("Driver") }
        await repository.waitUntilRefreshing()
        XCTAssertEqual(library.photo(for: "Driver").data, Data([1]))
        await repository.finish(with: .failure(URLError(.notConnectedToInternet)))
        await loading.value
        XCTAssertEqual(library.photo(for: "Driver").asset, asset)
        XCTAssertFalse(library.photo(for: "Driver").failed)
    }

    func testSuccessfulRemovalClearsVisibleCachedPhoto() async throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/photo"))
        let asset = PhotoAsset(imageURL: url, pageURL: url, author: "Author", license: "CC BY 4.0", licenseURL: url)
        let repository = RefreshingPhotoRepository(asset: asset)
        let library = PhotoLibrary(repository: repository)
        let loading = Task { await library.load("Driver") }
        await repository.waitUntilRefreshing()
        await repository.finish(with: .success(nil))
        await loading.value
        XCTAssertNil(library.photo(for: "Driver").data)
        XCTAssertTrue(library.photo(for: "Driver").unavailable)
    }

    func testPreloadDeduplicatesAndHonorsBatchLimit() async {
        let repository = TestPhotoRepository()
        let library = PhotoLibrary(repository: repository)
        await library.preload(["One", "One", "Two", "Three"], maximumCount: 2)
        let requests = await repository.requests
        XCTAssertEqual(requests, 2)
        XCTAssertNotNil(library.photo(for: "One").data)
        XCTAssertNotNil(library.photo(for: "Two").data)
        XCTAssertNil(library.photo(for: "Three").data)
    }

    func testTransientFailureRecoversWithoutUserAction() async {
        let repository = TestPhotoRepository(failuresBeforeSuccess: 1)
        let library = PhotoLibrary(repository: repository, automaticRetryDelay: .zero)
        await library.load("Driver")
        XCTAssertNotNil(library.photo(for: "Driver").data)
        XCTAssertFalse(library.photo(for: "Driver").failed)
        let requests = await repository.requests
        XCTAssertEqual(requests, 2)
    }

    func testAutomaticRetriesAreBounded() async {
        let repository = TestPhotoRepository(failuresBeforeSuccess: 10)
        let library = PhotoLibrary(repository: repository, automaticRetryDelay: .zero)
        await library.load("Driver")
        XCTAssertTrue(library.photo(for: "Driver").failed)
        let requests = await repository.requests
        XCTAssertEqual(requests, 2)
    }

}
