//
// ArchiveStorageTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import ArchiveDomain
import ArchiveTestSupport
import XCTest

final class ArchiveStorageTests: XCTestCase {
    func testBundledArchiveLoadsAndValidates() async throws {
        let snapshot = try await BundledArchiveRepository.bundled().load()
        XCTAssertFalse(snapshot.drivers.isEmpty)
        XCTAssertTrue(snapshot.cars.count >= 10)
        XCTAssertEqual(try snapshot.validated(), snapshot)
    }

    func testRisingStarsSurviveExistingCacheBootstrap() async throws {
        let cache = MemoryArchiveCache()
        try await cache.write(ArchiveFixtures.snapshot())
        let result = try await CachedArchiveRepository(cache: cache, fallback: BundledArchiveRepository.bundled())
            .load()
        let stars = result.drivers.filter { $0.category == .risingStars }
        XCTAssertEqual(
            Set(stars.compactMap(\.sourceID)),
            [
                "kimi-antonelli", "oliver-bearman", "gabriel-bortoleto", "isack-hadjar",
                "liam-lawson", "franco-colapinto", "arvid-lindblad",
            ])
        XCTAssertEqual(stars.count, 7)
    }

    func testLifeStoriesSurviveOldCacheBootstrap() async throws {
        let cache = MemoryArchiveCache()
        try await cache.write(ArchiveFixtures.snapshot())
        let result = try await CachedArchiveRepository(cache: cache, fallback: BundledArchiveRepository.bundled())
            .load()
        XCTAssertEqual(result.lifeStories?.filter { $0.contribution == nil }.count, 8)
        XCTAssertTrue(result.lifeStories?.contains { $0.driverSourceID == "jacques-villeneuve" } == true)
    }

    func testEngineeringProfilesAreAvailableOfflineAndHaveSources() async throws {
        let snapshot = try await BundledArchiveRepository.bundled().load()
        let stories = (snapshot.lifeStories ?? []).filter { $0.contribution != nil }
        XCTAssertEqual(stories.count, 6)
        for story in stories {
            let driver = try XCTUnwrap(snapshot.drivers.first { $0.sourceID == story.driverSourceID })
            XCTAssertEqual(snapshot.contribution(for: driver), story.contribution)
            XCTAssertFalse(try XCTUnwrap(story.impact).isEmpty)
            XCTAssertTrue(story.source.url.absoluteString.hasPrefix("https://"))
        }

        let restored = try JSONDecoder().decode(ArchiveSnapshot.self, from: JSONEncoder().encode(snapshot))
        XCTAssertEqual(restored.lifeStories, snapshot.lifeStories)
    }

    func testMalformedJSONThrows() { XCTAssertThrowsError(try ArchiveDecoder().decode(Data("broken".utf8))) }

    func testMissingResourceThrows() async {
        do {
            _ = try await BundledArchiveRepository(fileURL: nil, decoder: ArchiveDecoder()).load()
            XCTFail("Expected missing file")
        } catch { XCTAssertEqual(error as? ArchiveDataError, .missingBundledArchive) }
    }

    func testFileCacheRoundTrip() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }

        let cache = FileArchiveCache(url: directory.appendingPathComponent("archive.json"))
        let absent = try await cache.read()
        XCTAssertNil(absent)
        try await cache.write(ArchiveFixtures.snapshot())
        let restored = try await cache.read()
        XCTAssertEqual(restored, ArchiveFixtures.snapshot())
    }

    func testCorruptCacheFallsBackToBundleRepository() async throws {
        let cache = MemoryArchiveCache(shouldFail: true)
        let result = try await CachedArchiveRepository(
            cache: cache, fallback: StaticArchiveRepository(snapshot: ArchiveFixtures.snapshot())
        ).load()
        XCTAssertEqual(result, ArchiveFixtures.snapshot())
    }

    func testDiskWriteFailureDoesNotDiscardRemoteContent() async throws {
        let repository = CachingArchiveRepository(
            remote: StaticArchiveRepository(snapshot: ArchiveFixtures.snapshot()),
            cache: MemoryArchiveCache(shouldFail: true))
        let result = try await repository.load()
        XCTAssertEqual(result, ArchiveFixtures.snapshot())
    }
    @MainActor func testUserDefaultsFavoritesPreserveExistingKey() throws {
        let suite = UUID().uuidString
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(["senna"], forKey: "favoriteDrivers")
        let store = UserDefaultsFavoritesStore(defaults: defaults)
        XCTAssertEqual(try store.load(), ["senna"])
        try store.save(["norris"])
        XCTAssertEqual(try UserDefaultsFavoritesStore(defaults: defaults).load(), ["norris"])
    }
    @MainActor func testCorruptFavoritesAreNotSilentlyErased() throws {
        let suite = UUID().uuidString
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(42, forKey: UserDefaultsFavoritesStore.storageKey)
        XCTAssertThrowsError(try UserDefaultsFavoritesStore(defaults: defaults).load())
        XCTAssertEqual(defaults.integer(forKey: UserDefaultsFavoritesStore.storageKey), 42)
    }
    @MainActor func testLegacyFavoriteMigrationRunsOnlyOnce() throws {
        let suite = UUID().uuidString
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(["verstappen", "fittipaldi"], forKey: UserDefaultsFavoritesStore.storageKey)
        let store = UserDefaultsFavoritesStore(defaults: defaults)
        XCTAssertEqual(try store.load(), ["max_verstappen", "emerson_fittipaldi"])
        try store.save(["verstappen"])
        XCTAssertEqual(try store.load(), ["verstappen"], "Jos's canonical ID must not migrate again")
    }

    func testCachedDriverListUsesUpdatedBundledEditorialContent() async throws {
        let cache = MemoryArchiveCache()
        try await cache.write(ArchiveSnapshot(drivers: [ArchiveFixtures.driver()], cars: [], achievements: [:]))
        let updated = ArchiveFixtures.snapshot()
        let loaded = try await CachedArchiveRepository(
            cache: cache, fallback: StaticArchiveRepository(snapshot: updated)
        ).load()
        XCTAssertEqual(loaded.cars, updated.cars)
        XCTAssertEqual(loaded.achievements, updated.achievements)
    }

}
