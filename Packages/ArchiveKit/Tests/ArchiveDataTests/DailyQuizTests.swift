//
// DailyQuizTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import ArchiveDomain
import XCTest

final class DailyQuizTests: XCTestCase {
    func testSameUTCDayProducesIdenticalQuestionsAndAnswers() async throws {
        let snapshot = try await BundledArchiveRepository.bundled().load()
        let date = Date(timeIntervalSince1970: 1_728_000_000)
        let first = DailyQuizGenerator.questions(from: snapshot, trivia: [], date: date)
        let later = DailyQuizGenerator.questions(from: snapshot, trivia: [], date: date.addingTimeInterval(60))
        XCTAssertEqual(first.count, 5)
        XCTAssertEqual(first.map(\.id), later.map(\.id))
        XCTAssertEqual(first.map(\.options), later.map(\.options))
        XCTAssertEqual(Set(first.map(\.id)).count, 5)
        XCTAssertTrue(
            first.contains {
                if case .circuit = $0.subject { return true }
                return false
            })
        XCTAssertTrue(
            first.contains {
                if case .team = $0.subject { return true }
                return false
            })
        let tomorrow = DailyQuizGenerator.questions(from: snapshot, trivia: [], date: date.addingTimeInterval(86_400))
        XCTAssertNotEqual(first.map(\.id), tomorrow.map(\.id))
    }

    func testEmptySnapshotProducesNoInvalidQuestions() {
        XCTAssertTrue(DailyQuizGenerator.questions(from: .empty, trivia: [], date: Date()).isEmpty)
    }

    func testBundledSeasonHistorySurvivesOldCacheAndRoundTrip() async throws {
        let cache = MemoryArchiveCache()
        try await cache.write(.empty)
        let snapshot = try await CachedArchiveRepository(cache: cache, fallback: BundledArchiveRepository.bundled())
            .load()
        let seasons = try XCTUnwrap(snapshot.careerSeasons)
        XCTAssertTrue(seasons.contains { $0.driverSourceID == "ayrton-senna" && $0.year == 1991 && $0.position == 1 })
        let decoded = try JSONDecoder().decode(ArchiveSnapshot.self, from: JSONEncoder().encode(snapshot))
        XCTAssertEqual(decoded.careerSeasons, seasons)
    }
}
