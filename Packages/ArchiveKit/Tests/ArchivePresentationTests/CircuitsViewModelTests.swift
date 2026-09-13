//
// CircuitsViewModelTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import ArchiveTestSupport
import XCTest

@MainActor final class CircuitsViewModelTests: XCTestCase {
    private func model() -> CircuitsViewModel {
        CircuitsViewModel(circuits: [
            ArchiveFixtures.circuit(id: "nurburgring", name: "Nürburgring", place: "Nürburg"),
            ArchiveFixtures.circuit(
                id: "monaco", name: "Circuit de Monaco", place: "Monte Carlo", country: "Monaco", countryCode: "MC"),
            ArchiveFixtures.circuit(
                id: "catalunya", name: "Circuit de Barcelona-Catalunya", place: "Montmeló", country: "Spain",
                countryCode: "ES"),
        ])
    }

    func testSearchIgnoresDiacritics() {
        let subject = model()
        subject.query = "nurburgring"
        XCTAssertEqual(subject.visibleCircuits.map(\.id), ["nurburgring"])
        subject.query = "montmelo"
        XCTAssertEqual(subject.visibleCircuits.map(\.id), ["catalunya"])
    }

    func testSearchMatchesEveryTermAcrossFields() {
        let subject = model()
        subject.query = "monaco carlo"
        XCTAssertEqual(subject.visibleCircuits.map(\.id), ["monaco"])
        subject.query = "monaco germany"
        XCTAssertTrue(subject.visibleCircuits.isEmpty)
    }

    func testEmptyQueryReturnsEveryCircuitSortedByName() {
        let subject = model()
        XCTAssertEqual(subject.visibleCircuits.map(\.id), ["catalunya", "monaco", "nurburgring"])
        subject.query = "   "
        XCTAssertEqual(subject.visibleCircuits.count, 3)
    }
}
