//
// WikimediaPhotoRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import ImageIO

public actor WikimediaPhotoRepository: PhotoRepository {
    private let client: any HTTPClient
    private var cache: [String: PhotoAsset] = [:]
    private var inFlight: [String: Task<PhotoAsset?, Error>] = [:]
    private static let thumbnailWidth = 640
    public init(client: any HTTPClient) { self.client = client }

    public func photo(wikipediaTitle: String) async throws -> PhotoAsset? {
        if let cached = cache[wikipediaTitle] { return cached }
        if let pending = inFlight[wikipediaTitle] { return try await pending.value }

        let task = Task { try await self.resolve(title: wikipediaTitle) }
        inFlight[wikipediaTitle] = task
        defer { inFlight[wikipediaTitle] = nil }

        let asset = try await task.value
        if let asset { cache[wikipediaTitle] = asset }
        return asset
    }

    private enum Lookup {
        case asset(PhotoAsset)
        case disambiguation
        case unavailable
    }

    private static let driverQualifier = "_(racing_driver)"

    private func resolve(title: String) async throws -> PhotoAsset? {
        switch try await lookup(title: title) {
        case .asset(let asset): return asset
        case .unavailable: return nil
        case .disambiguation:
            // A title derived from a plain name lands on a disambiguation page whenever English
            // Wikipedia qualifies the driver who shares it. Spend one extra request on the
            // conventional qualifier rather than giving up on a driver who does have a portrait.
            guard !title.hasSuffix(Self.driverQualifier) else { return nil }
            if case .asset(let asset) = try await lookup(title: title + Self.driverQualifier) { return asset }
            return nil
        }
    }

    private func lookup(title: String) async throws -> Lookup {
        let response = try await query(
            host: "en.wikipedia.org",
            parameters: [
                "prop": "pageimages|pageprops", "piprop": "name", "pilicense": "free", "titles": title,
                "redirects": "1",
            ])
        guard let page = response.query?.pages.values.first else { return .unavailable }
        guard page.pageProperties?["disambiguation"] == nil else { return .disambiguation }
        if let filename = page.imageName, let asset = try await commonsPhoto(filename: filename) {
            return .asset(asset)
        }
        guard let entity = page.pageProperties?["wikibase_item"],
            entity.range(of: "^Q[0-9]+$", options: .regularExpression) != nil
        else { return .unavailable }

        let claims: WikidataImageResponse = try await request(
            host: "www.wikidata.org", parameters: ["action": "wbgetclaims", "entity": entity, "property": "P18"])
        guard claims.error == nil else { throw HTTPError.invalidResponse }

        var seen = Set([page.imageName].compactMap { $0 })
        for filename in claims.filenames.filter({ seen.insert($0).inserted }).prefix(Self.maximumFallbackImages) {
            if let asset = try await commonsPhoto(filename: filename) { return .asset(asset) }
        }
        return .unavailable
    }

    private static let maximumFallbackImages = 3

    private func commonsPhoto(filename: String) async throws -> PhotoAsset? {
        let response = try await query(
            host: "commons.wikimedia.org",
            parameters: [
                "prop": "imageinfo", "iiprop": "url|extmetadata", "iiurlwidth": String(Self.thumbnailWidth),
                "titles": "File:" + filename, "redirects": "1",
            ])
        guard let info = response.query?.pages.values.compactMap({ $0.imageInfo?.first }).first,
            let metadata = info.metadata,
            let license = metadata.licenseName?.value,
            let author = metadata.artist?.value,
            let licenseURL = Self.rightsURL(metadata: metadata, info: info, license: license),
            license.hasPrefix("CC BY") || license == "CC0" || license == "Public domain" || license == "OGL 3"
        else { return nil }
        guard !license.contains("NC"), !license.contains("ND"), info.url.scheme == "https",
            info.descriptionURL.scheme == "https"
        else { return nil }
        return PhotoAsset(
            imageURL: info.thumbnailURL ?? info.url, pageURL: info.descriptionURL, author: Self.plainText(author),
            license: license, licenseURL: licenseURL,
            attribution: [metadata.attribution, metadata.credit, metadata.copyright, metadata.restrictions]
                .compactMap { $0?.value }.map(Self.plainText).filter { !$0.isEmpty }.joined(separator: "\n"))
    }

    public func imageData(for asset: PhotoAsset) async throws -> Data {
        let data = try await client.data(from: asset.imageURL)
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
            CGImageSourceGetCount(source) > .zero
        else { throw HTTPError.invalidResponse }
        return data
    }

    private static func rightsURL(metadata: WikimediaImageMetadata, info: WikimediaImageInfo, license: String) -> URL? {
        if license == "Public domain", metadata.licenseURL?.value.isEmpty != false {
            guard info.descriptionURL.scheme == "https", info.descriptionURL.host == "commons.wikimedia.org",
                info.descriptionURL.path.hasPrefix("/wiki/File:")
            else { return nil }
            return info.descriptionURL
        }
        guard let text = metadata.licenseURL?.value else { return nil }
        return licenseURL(text, license: license)
    }

    private static func licenseURL(_ text: String, license: String) -> URL? {
        guard var components = URLComponents(string: text.hasPrefix("//") ? "https:" + text : text),
            components.scheme == "https" || components.scheme == "http"
        else { return nil }
        if license == "OGL 3" {
            guard components.host == "www.nationalarchives.gov.uk",
                components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                    == "doc/open-government-licence/version/3"
            else { return nil }
        } else {
            guard components.host == "creativecommons.org" || components.host == "www.creativecommons.org" else {
                return nil
            }

            let path = components.path.split(separator: "/").map(String.init)
            if license == "CC0" {
                guard path.starts(with: ["publicdomain", "zero", "1.0"]) else { return nil }
            } else if license == "Public domain" {
                guard path.starts(with: ["publicdomain", "mark", "1.0"]) else { return nil }
            } else {
                // Commons short names are not always three words: ported licences add a jurisdiction
                // ("CC BY-SA 3.0 de") and multi-licensed files list versions ("CC BY-SA 4.0,3.0,2.5").
                // The invariant worth enforcing is that the name and the URL agree on permissiveness
                // and version; the jurisdiction suffix does not change either.
                let parts = license.split(separator: " ").map(String.init)
                let versions = parts.count >= 3 ? parts[2].split(separator: ",").map(String.init) : []
                guard parts.count >= 3, parts[0] == "CC", ["BY", "BY-SA"].contains(parts[1]),
                    !versions.isEmpty,
                    versions.allSatisfy(["1.0", "2.0", "2.5", "3.0", "4.0"].contains),
                    path.count >= 3, path[0] == "licenses", path[1] == parts[1].lowercased(),
                    versions.contains(path[2])
                else { return nil }
            }
        }
        components.scheme = "https"
        return components.url
    }

    private func query(host: String, parameters: [String: String]) async throws -> WikimediaResponse {
        let response: WikimediaResponse = try await request(host: host, parameters: parameters)
        guard response.error == nil else { throw HTTPError.invalidResponse }
        return response
    }

    private func request<Response: Decodable>(host: String, parameters: [String: String]) async throws -> Response {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/w/api.php"
        var values = parameters
        values["action"] = values["action"] ?? "query"
        values["format"] = "json"
        components.queryItems = values.sorted { $0.key < $1.key }.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components.url else { throw HTTPError.invalidURL }
        return try JSONDecoder().decode(Response.self, from: await client.data(from: url))
    }

    private static func plainText(_ html: String) -> String {
        html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&amp;", with: "&").replacingOccurrences(of: "&quot;", with: "\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
