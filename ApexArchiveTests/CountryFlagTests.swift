//
// CountryFlagTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import XCTest

@testable import ApexArchive

final class CountryFlagTests: XCTestCase {
    func testTwoLetterCodesBecomeRegionalIndicators() {
        XCTAssertEqual(CountryFlag.symbol(for: "GB"), "🇬🇧")
        XCTAssertEqual(CountryFlag.symbol(for: "br"), "🇧🇷", "case is normalised")
    }

    func testAnythingElseRendersNothingRatherThanGarbage() {
        XCTAssertEqual(CountryFlag.symbol(for: ""), "")
        XCTAssertEqual(CountryFlag.symbol(for: "GBR"), "")
        XCTAssertEqual(CountryFlag.symbol(for: "G1"), "")
    }

    func testEveryCatalogCountryCodeProducesAFlag() {
        for place in RacingPlaceCatalog.places {
            XCTAssertFalse(CountryFlag.symbol(for: place.countryCode).isEmpty, place.id)
        }
    }
}
