//
// F1DBRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

/// F1DB publishes a versioned JSON download, not an Ergast-style REST service.
public actor F1DBRepository: ArchiveRepository {
    private let client: any HTTPClient
    private let editorial: any ArchiveRepository
    private let releasesURL: URL?

    public init(client: any HTTPClient, editorial: any ArchiveRepository, releasesURL: URL? = nil) {
        self.client = client
        self.editorial = editorial
        self.releasesURL = releasesURL
    }

    public func load() async throws -> ArchiveSnapshot {
        guard let releasesURL = releasesURL ?? URL(string: "https://api.github.com/repos/f1db/f1db/releases/latest")
        else { throw HTTPError.invalidURL }

        let release = try JSONDecoder().decode(F1DBRelease.self, from: await client.data(from: releasesURL))
        guard let asset = release.assets.first(where: { $0.name == "f1db-json-splitted.zip" }),
            asset.downloadURL.scheme == "https", asset.downloadURL.host == "github.com",
            asset.downloadURL.path.hasPrefix("/f1db/f1db/releases/download/"),
            release.pageURL.scheme == "https", release.pageURL.host == "github.com"
        else { throw HTTPError.invalidResponse }

        let compressed = try await client.data(from: asset.downloadURL)
        let reader = F1DBArchiveReader()
        let rows = try reader.decode([F1DBDriver].self, entry: "f1db-drivers.json", from: compressed)
        let seasons = try reader.decode([F1DBDriverSeason].self, entry: "f1db-seasons-drivers.json", from: compressed)
        let countries = try reader.decode([F1DBCountry].self, entry: "f1db-countries.json", from: compressed)
        let source = EditorialSource(
            title: "F1DB · " + release.version + " · CC BY 4.0", url: release.pageURL,
            checkedOn: Date().formatted(date: .abbreviated, time: .omitted))
        let curated = try await editorial.load().validated()
        let catalog = try curated.catalog.map {
            try F1DBCatalogMapper().catalog(
                from: compressed, curated: $0, countries: countries,
                drivers: rows, source: source, today: String(Date().ISO8601Format().prefix(10)))
        }
        return try F1DBSnapshotMapper().snapshot(
            drivers: rows, countries: countries, seasons: seasons,
            editorial: curated, source: source, catalog: catalog)
    }
}
