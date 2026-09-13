//
// HistoricalDriverFactsTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import XCTest

final class HistoricalDriverFactsTests: XCTestCase {
    private func facts(
        first: Int?, last: Int?, starts: Int? = nil, wins: Int? = nil, podiums: Int? = nil, poles: Int? = nil,
        championships: Int? = nil, bestPosition: Int? = nil, bestYear: Int? = nil
    ) -> HistoricalDriverFacts {
        HistoricalDriverFacts(
            firstSeason: first, lastSeason: last, starts: starts, wins: wins, podiums: podiums,
            polePositions: poles, championships: championships, bestChampionshipPosition: bestPosition,
            bestChampionshipYear: bestYear)
    }

    func testSpanSubtitleUsesPlainYears() {
        XCTAssertEqual(facts(first: 1950, last: 1958).subtitle, "Grand Prix driver · 1950–1958")
    }

    func testSingleSeasonReadsWithoutARange() {
        let single = facts(first: 1952, last: 1952)
        XCTAssertEqual(single.subtitle, "Grand Prix driver · 1952")
        XCTAssertTrue(single.biography.contains("the 1952 season"), single.biography)
        XCTAssertFalse(single.biography.contains("1952 to 1952"))
    }

    func testUnknownCareerFallsBackToTheGenericDescription() {
        let unknown = facts(first: nil, last: nil)
        XCTAssertEqual(unknown.subtitle, "Historical racing driver")
        XCTAssertTrue(unknown.biography.contains("historical archive"), unknown.biography)
    }

    func testTotalsDropCategoriesTheDriverNeverRecorded() {
        let partial = facts(first: 1950, last: 1953, starts: 12, wins: 0, podiums: 0, poles: 0, championships: 0)
        XCTAssertTrue(partial.biography.contains("starts 12"), partial.biography)
        // A row of zeroes describes nothing, so only participation survives.
        XCTAssertFalse(partial.biography.contains("wins"), partial.biography)
        XCTAssertFalse(partial.biography.contains("poles"), partial.biography)
        XCTAssertFalse(partial.biography.contains("titles"), partial.biography)
    }

    func testSingleValuesNeverReadAsAPluralMismatch() {
        let champion = facts(first: 1980, last: 1980, starts: 14, wins: 1, podiums: 1, poles: 1, championships: 1)
        XCTAssertFalse(champion.biography.contains("1 wins"), champion.biography)
        XCTAssertFalse(champion.biography.contains("1 titles"), champion.biography)
        XCTAssertTrue(champion.biography.contains("wins 1"), champion.biography)
        XCTAssertTrue(champion.biography.contains("titles 1"), champion.biography)
    }

    func testBestChampionshipPositionIsReportedAsAnOrdinalWithItsYear() {
        let ranked = facts(first: 1950, last: 1953, starts: 20, bestPosition: 4, bestYear: 1952)
        XCTAssertTrue(ranked.biography.contains("Best championship position: 4th in 1952."), ranked.biography)
        let champion = facts(first: 1980, last: 1980, starts: 14, bestPosition: 1, bestYear: 1980)
        XCTAssertTrue(champion.biography.contains("1st in 1980"), champion.biography)
    }

    func testNoTotalsAndNoRankingStillProducesASourcedSentence() {
        let bare = facts(first: 1950, last: 1951)
        XCTAssertTrue(bare.biography.contains("1950 to 1951"), bare.biography)
        XCTAssertTrue(bare.biography.contains("cited F1DB release"), bare.biography)
    }
}
