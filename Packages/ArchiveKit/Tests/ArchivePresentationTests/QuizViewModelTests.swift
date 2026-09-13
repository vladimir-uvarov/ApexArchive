//
// QuizViewModelTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

@MainActor final class QuizViewModelTests: XCTestCase {
    func testAnswersAreLockedAndCannotScoreTwice() throws {
        let model = QuizViewModel(snapshot: ActivityFixtures.snapshot())
        let question = try XCTUnwrap(model.currentQuestion)
        model.next()
        XCTAssertEqual(model.index, 0)
        model.answer("invalid answer")
        XCTAssertNil(model.selectedAnswer)
        model.answer(question.correctAnswer)
        model.answer(question.correctAnswer)
        XCTAssertEqual(model.score, 1)
        model.next()
        XCTAssertEqual(model.index, 1)
        XCTAssertNil(model.selectedAnswer)
    }

    func testWrongAnswerCannotBeChangedAfterReveal() throws {
        let model = QuizViewModel(snapshot: ActivityFixtures.snapshot())
        let question = try XCTUnwrap(model.currentQuestion)
        let wrong = try XCTUnwrap(question.options.first { $0 != question.correctAnswer })
        model.answer(wrong)
        model.answer(question.correctAnswer)
        XCTAssertEqual(model.score, 0)
        XCTAssertEqual(model.selectedAnswer, wrong)
    }

    func testCompletionAndRestartResetRoundState() throws {
        let model = QuizViewModel(snapshot: ActivityFixtures.snapshot())
        for _ in model.questions {
            let question = try XCTUnwrap(model.currentQuestion)
            model.answer(question.correctAnswer)
            model.next()
        }
        XCTAssertTrue(model.isComplete)
        XCTAssertEqual(model.score, QuizGenerator.roundLength)
        XCTAssertNil(model.currentQuestion)
        model.next()
        XCTAssertEqual(model.index, QuizGenerator.roundLength)
        model.restart()
        XCTAssertEqual(model.score, 0)
        XCTAssertEqual(model.index, 0)
        XCTAssertNil(model.selectedAnswer)
        XCTAssertFalse(model.isComplete)
    }

    func testEmptyArchiveIsNotACompletedRound() {
        let model = QuizViewModel(snapshot: .empty)
        model.answer("invalid answer")
        model.next()
        XCTAssertNil(model.currentQuestion)
        XCTAssertFalse(model.isComplete)
        XCTAssertEqual(model.score, 0)
    }
}
