//
// PhotoCacheTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import ArchiveDomain
import XCTest

final class PhotoCacheTests: XCTestCase {
    private func asset(_ name: String = "first") throws -> PhotoAsset {
        let url = try XCTUnwrap(URL(string: "https://example.com/\(name).png"))
        return PhotoAsset(imageURL: url, pageURL: url, author: "Photographer", license: "CC BY 4.0", licenseURL: url)
    }

    private func image() throws -> Data {
        try XCTUnwrap(
            Data(
                base64Encoded:
                    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aD1sAAAAASUVORK5CYII="))
    }

    func testRelaunchUsesPersistedBytesAndAttributionWithoutDownload() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }

        let photo = try asset()
        let bytes = try image()
        let first = CachingPhotoRepository(
            remote: PhotoRemoteStub(asset: photo, data: bytes),
            cache: FilePhotoCache(directory: directory))
        _ = try await first.photo(wikipediaTitle: "Driver")
        _ = try await first.imageData(for: photo)
        let remote = PhotoRemoteStub(asset: photo, data: bytes)
        let restarted = CachingPhotoRepository(remote: remote, cache: FilePhotoCache(directory: directory))
        let cached = await restarted.cachedPhoto(wikipediaTitle: "Driver")
        let restored = try await restarted.imageData(for: photo)
        let downloads = await remote.downloads
        XCTAssertEqual(cached, photo)
        XCTAssertEqual(restored, bytes)
        XCTAssertEqual(downloads, 0)
    }

    func testChangedURLFetchesReplacementAndUpdatesAttribution() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }

        let cache = FilePhotoCache(directory: directory)
        let old = try asset()
        let updated = try asset("replacement")
        let bytes = try image()
        await cache.store(old, for: "Driver")
        await cache.store(bytes, for: old.imageURL)
        let remote = PhotoRemoteStub(asset: updated, data: bytes)
        let repository = CachingPhotoRepository(remote: remote, cache: cache)
        let resolved = try await repository.photo(wikipediaTitle: "Driver")
        _ = try await repository.imageData(for: updated)
        let persisted = await cache.asset(for: "Driver")
        let downloads = await remote.downloads
        XCTAssertEqual(resolved, updated)
        XCTAssertEqual(persisted, updated)
        XCTAssertEqual(downloads, 1)
    }

    func testIneligiblePhotoInvalidatesPersistedMetadata() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }

        let cache = FilePhotoCache(directory: directory)
        await cache.store(try asset(), for: "Driver")
        let repository = CachingPhotoRepository(remote: PhotoRemoteStub(asset: nil, data: Data()), cache: cache)
        let resolved = try await repository.photo(wikipediaTitle: "Driver")
        let cached = await repository.cachedPhoto(wikipediaTitle: "Driver")
        XCTAssertNil(resolved)
        XCTAssertNil(cached)
    }

    func testCorruptDiskImageIsDownloadedAgain() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }

        let cache = FilePhotoCache(directory: directory)
        let photo = try asset()
        await cache.store(Data("corrupt".utf8), for: photo.imageURL)
        let bytes = try image()
        let remote = PhotoRemoteStub(asset: photo, data: bytes)
        let repository = CachingPhotoRepository(remote: remote, cache: cache)
        let restored = try await repository.imageData(for: photo)
        let downloads = await remote.downloads
        XCTAssertEqual(restored, bytes)
        XCTAssertEqual(downloads, 1)
    }

    func testByteBudgetEvictsOlderImages() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }

        let bytes = try image()
        let cache = FilePhotoCache(directory: directory, maximumBytes: bytes.count)
        let first = try asset().imageURL
        let second = try asset("second").imageURL
        await cache.store(bytes, for: first)
        await cache.store(bytes, for: second)
        let remaining = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        XCTAssertEqual(remaining.count, 1)
        let restored = await cache.image(for: second)
        XCTAssertEqual(restored, bytes)
    }

    func testConcurrentTitlesSharingURLDownloadOnce() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }

        let photo = try asset()
        let remote = PhotoRemoteStub(asset: photo, data: try image())
        let repository = CachingPhotoRepository(remote: remote, cache: FilePhotoCache(directory: directory))
        async let first = repository.imageData(for: photo)
        async let second = repository.imageData(for: photo)
        _ = try await (first, second)
        let downloads = await remote.downloads
        XCTAssertEqual(downloads, 1)
    }

    func testUnwritableCacheDoesNotHideDownloadedImage() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try Data().write(to: directory)
        defer { try? FileManager.default.removeItem(at: directory) }

        let photo = try asset()
        let bytes = try image()
        let repository = CachingPhotoRepository(
            remote: PhotoRemoteStub(asset: photo, data: bytes),
            cache: FilePhotoCache(directory: directory))
        let metadata = try await repository.photo(wikipediaTitle: "Driver")
        let downloaded = try await repository.imageData(for: photo)
        XCTAssertEqual(metadata, photo)
        XCTAssertEqual(downloaded, bytes)
    }
}
