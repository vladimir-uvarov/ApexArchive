//
// RacingCatalogTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchiveTestSupport
import Foundation
import XCTest

@testable import ArchiveData

final class RacingCatalogTests: XCTestCase {
    func testBundledCatalogContainsWorldwideVenuesAndHeritageTeams() async throws {
        let snapshot = try await BundledArchiveRepository.bundled().load()
        let catalog = try XCTUnwrap(snapshot.catalog)
        XCTAssertGreaterThanOrEqual(catalog.circuits.count, 75)
        XCTAssertTrue(catalog.circuits.allSatisfy { $0.outline != nil })
        XCTAssertEqual(catalog.teams.first { $0.id == "alfa-romeo" }?.firstYear, 1950)
        XCTAssertGreaterThanOrEqual(snapshot.cars.count, 50)
        XCTAssertEqual(try catalog.validated(), catalog)
    }

    func testOldCacheStillGetsNewCatalogAndGarageEntries() async throws {
        let cache = MemoryArchiveCache()
        try await cache.write(ArchiveFixtures.snapshot())
        let result = try await CachedArchiveRepository(cache: cache, fallback: BundledArchiveRepository.bundled())
            .load()
        XCTAssertNotNil(result.catalog)
        XCTAssertGreaterThanOrEqual(result.cars.count, 50)
    }

    func testBestLapNeverCrossesLayoutsOrIncludesFutureRaces() async throws {
        let curated = try await BundledArchiveRepository.bundled().load()
        let url = try XCTUnwrap(
            Bundle.module.url(forResource: "catalog", withExtension: "zip", subdirectory: "Fixtures"))
        let catalog = try F1DBCatalogMapper().catalog(
            from: Data(contentsOf: url), curated: XCTUnwrap(curated.catalog),
            countries: [F1DBCountry(id: "italy", name: "Italy", alpha2Code: "IT")],
            drivers: [
                F1DBDriver(
                    id: "driver", name: "Driver", nationalityCountryId: "italy", totalRaceWins: 1, totalFastestLaps: 1)
            ],
            source: ArchiveFixtures.source(), today: "2026-09-15")
        let circuit = try XCTUnwrap(catalog.circuits.first)
        XCTAssertEqual(circuit.layoutID, "monza-7")
        XCTAssertEqual(circuit.record?.time, "1:20.000")
        XCTAssertEqual(circuit.raceCount, 2)
        XCTAssertEqual(circuit.lastYear, 2025)
        XCTAssertNotNil(circuit.outline)
    }

    func testDuplicateCatalogIdentifiersAreRejected() async throws {
        let snapshot = try await BundledArchiveRepository.bundled().load()
        let circuit = try XCTUnwrap(snapshot.catalog?.circuits.first)
        XCTAssertThrowsError(try RacingCatalog(circuits: [circuit, circuit], teams: []).validated())
    }

    func testCircuitAndTeamQuizzesHaveOneUnambiguousAnswer() async throws {
        let snapshot = try await BundledArchiveRepository.bundled().load()
        var random = SystemRandomNumberGenerator()
        for mode in [QuizMode.circuits, .teams] {
            for _ in 0..<20 {
                let questions = CatalogQuizGenerator.questions(
                    catalog: snapshot.catalog, mode: mode, trivia: [], using: &random)
                XCTAssertEqual(questions.count, QuizGenerator.roundLength)
                XCTAssertEqual(Set(questions.map(\.id)).count, questions.count)
                for question in questions {
                    XCTAssertEqual(Set(question.options).count, QuizGenerator.optionCount)
                    XCTAssertEqual(question.options.filter { $0 == question.correctAnswer }.count, 1)
                    if case .team(let team) = question.subject {
                        let matching = snapshot.catalog?.teams.filter {
                            question.options.contains($0.name) && $0.firstWinYear == team.firstWinYear
                        }
                        XCTAssertEqual(matching?.count, 1)
                    }
                }
            }
        }
    }
}
