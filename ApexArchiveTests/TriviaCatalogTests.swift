//
// TriviaCatalogTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import XCTest

@testable import ApexArchive

final class TriviaCatalogTests: XCTestCase {
    func testEveryQuestionHasFourDistinctOptionsIncludingTheAnswer() {
        for question in TriviaCatalog.questions {
            XCTAssertEqual(question.options.count, 4, question.id)
            XCTAssertEqual(Set(question.options).count, 4, "\(question.id) repeats an option")
            XCTAssertTrue(question.options.contains(question.correctAnswer), question.id)
        }
    }

    func testEveryQuestionCitesAnHTTPSSource() {
        for question in TriviaCatalog.questions {
            XCTAssertEqual(question.source.url.scheme, "https", question.id)
            XCTAssertFalse(question.explanation.isEmpty, question.id)
        }
    }

    func testQuestionIdentifiersAreUnique() {
        let ids = TriviaCatalog.questions.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
    }
}
