//
// ArchiveIntegrationCheck.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import ArchiveDomain
import Foundation
import ImageIO

@main struct ArchiveIntegrationCheck {
    static func main() async throws {
        guard CommandLine.arguments.contains("--live") else {
            log("Pass --live to contact F1DB and Wikimedia. Unit tests do not use the network.")
            return
        }

        let session = URLSession(configuration: .ephemeral)
        let api = URLSessionHTTPClient(session: session, configuration: .f1db)
        let repository = F1DBRepository(client: api, editorial: BundledArchiveRepository.bundled())
        let snapshot = try await repository.load()
        log("Live F1DB archive: \(snapshot.drivers.count) unique drivers; \(snapshot.cars.count) sourced personal cars")
        guard let record = snapshot.achievements["senna"] else { throw HTTPError.invalidResponse }
        guard record.wins?.count == 41, record.fastestLaps?.count == 19 else { throw HTTPError.invalidResponse }
        log("Senna: 41 wins, 19 fastest race laps; source: \(record.wins?.source.title ?? "missing")")
        if CommandLine.arguments.contains("--catalog-only") {
            guard let catalog = snapshot.catalog, catalog.circuits.count >= 75, catalog.teams.count >= 10 else {
                throw HTTPError.invalidResponse
            }
            log("Catalog verified: \(catalog.circuits.count) circuits, \(catalog.teams.count) teams")
            return
        }

        let media = URLSessionHTTPClient(session: session, configuration: .wikimedia)
        let photos = WikimediaPhotoRepository(client: media)
        for title in ["Ayrton_Senna", "Lando_Norris", "Honda_NSX_(first_generation)", "Ferrari_F50"] {
            guard let asset = try await photos.photo(wikipediaTitle: title) else {
                throw HTTPError.invalidResponse
            }

            let data = try await media.data(from: asset.imageURL)
            guard let image = CGImageSourceCreateWithData(data as CFData, nil), CGImageSourceGetCount(image) > .zero
            else {
                throw HTTPError.invalidResponse
            }
            log("Photo decoded: \(title), \(asset.license), \(data.count) bytes")
        }
    }

    private static func log(_ message: String) {
        FileHandle.standardOutput.write(Data((message + "\n").utf8))
    }
}
