//
// QuizGeneratorTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchiveTestSupport
import XCTest

final class QuizGeneratorTests: XCTestCase {
    func testRoundUsesDistinctDriversAndOneCorrectOptionPerQuestion() {
        var random = SystemRandomNumberGenerator()
        let snapshot = ActivityFixtures.snapshot()
        let questions = QuizGenerator.questions(from: snapshot, using: &random)
        XCTAssertEqual(questions.count, QuizGenerator.roundLength)
        XCTAssertEqual(Set(questions.map(\.id)).count, questions.count)
        for question in questions {
            XCTAssertEqual(Set(question.options).count, QuizGenerator.optionCount)
            XCTAssertTrue(question.options.contains(question.correctAnswer))
            XCTAssertTrue(question.options.allSatisfy { !$0.isEmpty })
            if case .driver(let driver, _, let record) = question.subject {
                XCTAssertNotEqual(driver.category, .archive)
                XCTAssertEqual(record, snapshot.achievements[driver.id]?.wins)
            } else {
                XCTFail("Expected driver question")
            }
        }
    }

    func testInsufficientDistinctTotalsCannotProduceAmbiguousOptions() {
        let original = ActivityFixtures.snapshot()
        let record = CareerRecord(count: 0, scope: "Wins", note: "Verified", source: ArchiveFixtures.source())
        let snapshot = ArchiveSnapshot(
            drivers: original.drivers, cars: [],
            achievements:
                Dictionary(uniqueKeysWithValues: original.drivers.map { ($0.id, DriverAchievements(wins: record)) }))
        var random = SystemRandomNumberGenerator()
        XCTAssertTrue(QuizGenerator.questions(from: snapshot, using: &random).isEmpty)
    }

    func testMissingRecordsAndShortRoundsAreNotInvented() {
        var random = SystemRandomNumberGenerator()
        XCTAssertTrue(QuizGenerator.questions(from: ArchiveFixtures.snapshot(), using: &random).isEmpty)
        let original = ActivityFixtures.snapshot()
        let short = ArchiveSnapshot(
            drivers: Array(original.drivers.prefix(3)), cars: [], achievements: original.achievements)
        XCTAssertTrue(QuizGenerator.questions(from: short, using: &random).isEmpty)
    }
}
