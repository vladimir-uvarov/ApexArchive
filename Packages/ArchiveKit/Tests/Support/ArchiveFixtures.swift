//
// ArchiveFixtures.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

public enum ArchiveFixtures {
    public static func driver(id: String = "senna", name: String = "Ayrton Senna", category: DriverCategory = .legends)
        -> Driver
    {
        Driver(
            id: id, name: name, country: "Brazil", category: category, subtitle: "Racer", biography: "Biography",
            sourceID: id, wikipediaTitle: name)
    }

    public static func source(scheme: String = "https") -> EditorialSource {
        var components = URLComponents()
        components.scheme = scheme
        components.host = "example.com"
        return EditorialSource(
            title: "Source", url: components.url ?? URL(fileURLWithPath: "/"), checkedOn: "14 September 2026")
    }

    public static func car(id: String = "nsx", driverID: String = "senna", source: URL? = nil) -> PersonalCar {
        PersonalCar(
            id: id, driverID: driverID, name: "Honda NSX", relationship: "Manufacturer-provided",
            description: "Documented use", sourceTitle: "Source", sourceURL: source ?? self.source().url,
            evidenceDate: "1991")
    }

    public static func circuit(
        id: String = "nurburgring", name: String = "Nürburgring", place: String = "Nürburg",
        country: String = "Germany", countryCode: String = "DE"
    ) -> Circuit {
        Circuit(
            id: id, name: name, place: place, country: country, countryCode: countryCode, layoutID: nil, length: nil,
            turns: nil, firstYear: nil, lastYear: nil, raceCount: 0, record: nil, outline: nil, source: source())
    }

    public static func team(
        id: String = "ferrari", name: String = "Ferrari", firstYear: Int = 1950, lastYear: Int = 2026
    ) -> RacingTeam {
        RacingTeam(
            id: id, name: name, country: "Italy", countryCode: "IT", firstYear: firstYear, lastYear: lastYear,
            wins: 0, championships: 0, firstWinYear: nil, firstTitleYear: nil, source: source())
    }

    public static func snapshot(name: String = "Ayrton Senna") -> ArchiveSnapshot {
        ArchiveSnapshot(drivers: [driver(name: name)], cars: [car()], achievements: [:], featuredDriverID: "senna")
    }
}
