//
// HistoricalDriverFacts.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

/// Career facts for a driver the archive carries without hand-written editorial copy.
///
/// Every value comes from the cited provider release, so the generated text states what was
/// recorded and never characterises the driver. Wording avoids counted nouns so a single season
/// reads correctly without a separate plural catalog.
public struct HistoricalDriverFacts: Equatable, Sendable {
    public let firstSeason: Int?
    public let lastSeason: Int?
    public let starts: Int?
    public let wins: Int?
    public let podiums: Int?
    public let polePositions: Int?
    public let championships: Int?
    public let bestChampionshipPosition: Int?
    public let bestChampionshipYear: Int?

    public init(
        firstSeason: Int?, lastSeason: Int?, starts: Int?, wins: Int?, podiums: Int?, polePositions: Int?,
        championships: Int?, bestChampionshipPosition: Int?, bestChampionshipYear: Int?
    ) {
        self.firstSeason = firstSeason
        self.lastSeason = lastSeason
        self.starts = starts
        self.wins = wins
        self.podiums = podiums
        self.polePositions = polePositions
        self.championships = championships
        self.bestChampionshipPosition = bestChampionshipPosition
        self.bestChampionshipYear = bestChampionshipYear
    }

    /// A span rather than a characterisation: "Grand Prix driver · 1950–1958".
    public var subtitle: String {
        guard let firstSeason else {
            return String(localized: "driver.historical.subtitle", defaultValue: "Historical racing driver")
        }
        guard let lastSeason, lastSeason != firstSeason else {
            return String.localizedStringWithFormat(
                String(localized: "driver.historical.subtitle.season", defaultValue: "Grand Prix driver · %@"),
                Self.year(firstSeason))
        }

        return String.localizedStringWithFormat(
            String(localized: "driver.historical.subtitle.span", defaultValue: "Grand Prix driver · %1$@–%2$@"),
            Self.year(firstSeason), Self.year(lastSeason))
    }

    public var biography: String {
        var sentences: [String] = [span]
        if let totals { sentences.append(totals) }
        if let best { sentences.append(best) }
        sentences.append(
            String(
                localized: "driver.historical.biography.note",
                defaultValue:
                    "These figures are the totals recorded in the cited F1DB release. Open the linked biography for the fuller story."
            ))
        return sentences.joined(separator: " ")
    }

    private var span: String {
        guard let firstSeason else {
            return String(
                localized: "driver.historical.biography",
                defaultValue:
                    "This driver is included in F1DB’s historical archive. Explore the race records and linked biography for more detail."
            )
        }
        guard let lastSeason, lastSeason != firstSeason else {
            return String.localizedStringWithFormat(
                String(
                    localized: "driver.historical.biography.season",
                    defaultValue: "Recorded in the World Championship for the %@ season."),
                Self.year(firstSeason))
        }

        return String.localizedStringWithFormat(
            String(
                localized: "driver.historical.biography.span",
                defaultValue: "Recorded in the World Championship from %1$@ to %2$@."),
            Self.year(firstSeason), Self.year(lastSeason))
    }

    /// A stat line rather than a sentence: label-then-value agrees with any number, so one win
    /// does not read as "1 wins" and no plural catalog is needed. Categories the driver never
    /// recorded are dropped, because a row of zeroes describes nothing.
    private var totals: String? {
        var parts: [String] = []
        if let starts {
            parts.append(entry(String(localized: "facts.starts", defaultValue: "starts"), starts))
        }

        let optional: [(String, Int?)] = [
            (String(localized: "facts.wins", defaultValue: "wins"), wins),
            (String(localized: "facts.podiums", defaultValue: "podiums"), podiums),
            (String(localized: "facts.poles", defaultValue: "poles"), polePositions),
            (String(localized: "facts.titles", defaultValue: "titles"), championships),
        ]
        for (label, value) in optional where (value ?? 0) > 0 {
            parts.append(entry(label, value ?? 0))
        }
        guard !parts.isEmpty else { return nil }

        return String.localizedStringWithFormat(
            String(localized: "driver.historical.biography.totals", defaultValue: "Recorded totals — %@."),
            parts.joined(separator: " · "))
    }

    private func entry(_ label: String, _ value: Int) -> String {
        String.localizedStringWithFormat("%1$@ %2$@", label, Self.count(value))
    }

    private var best: String? {
        guard let bestChampionshipPosition, let bestChampionshipYear else { return nil }

        return String.localizedStringWithFormat(
            String(
                localized: "driver.historical.biography.best",
                defaultValue: "Best championship position: %1$@ in %2$@."),
            Self.ordinal(bestChampionshipPosition), Self.year(bestChampionshipYear))
    }

    private static func ordinal(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }

    /// Years are identifiers, not quantities, so they never carry grouping separators.
    private static func year(_ value: Int) -> String { String(value) }

    private static func count(_ value: Int) -> String {
        NumberFormatter.localizedString(from: NSNumber(value: value), number: .decimal)
    }
}
