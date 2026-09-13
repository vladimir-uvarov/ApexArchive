//
// RacingPlaceCatalogTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import XCTest

@testable import ApexArchive

/// Hand-written catalog rows are the kind of data a typo silently breaks: a duplicate id collapses
/// two rows in a `ForEach`, an `http` link fails App Transport Security, an empty kind hides a section.
final class RacingPlaceCatalogTests: XCTestCase {
    func testIdentifiersAreUnique() {
        let ids = RacingPlaceCatalog.places.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
    }

    func testEveryWebsiteIsAnHTTPSURL() {
        for place in RacingPlaceCatalog.places {
            let url = URL(string: place.website)
            XCTAssertEqual(url?.scheme, "https", "\(place.id) links to \(place.website)")
            XCTAssertNotNil(url?.host, place.id)
        }
    }

    func testEveryPlaceCanOpenInMaps() {
        for place in RacingPlaceCatalog.places {
            XCTAssertNotNil(place.mapsURL, place.id)
            XCTAssertFalse(place.address.isEmpty, place.id)
            XCTAssertEqual(place.countryCode.count, 2, place.id)
        }
    }

    func testEveryKindHasSomewhereToVisit() {
        for kind in PlaceKind.allCases {
            XCTAssertTrue(RacingPlaceCatalog.places.contains { $0.kind == kind }, "no places of kind \(kind)")
        }
    }
}
