//
// SearchQueryTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import XCTest

final class SearchQueryTests: XCTestCase {
    func testMatchesDiacriticsAndCase() { XCTAssertTrue(SearchQuery("RAIKKONEN").matches("Kimi Räikkönen")) }

    func testTrimsWhitespace() { XCTAssertTrue(SearchQuery("  Senna \n").matches("Ayrton Senna")) }

    func testMatchesTermsAcrossNameAndCountry() {
        XCTAssertTrue(SearchQuery("brazil senna").matches("Ayrton Senna Brazil"))
    }

    func testRequiresEveryTerm() { XCTAssertFalse(SearchQuery("Senna France").matches("Ayrton Senna Brazil")) }

    func testEmptyQueryIncludesAll() { XCTAssertTrue(SearchQuery(" ").matches("anything")) }
}
