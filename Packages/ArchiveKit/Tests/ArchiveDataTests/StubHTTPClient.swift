//
// StubHTTPClient.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import Foundation

actor StubHTTPClient: HTTPClient {
    private var responses: [Result<Data, Error>]
    private(set) var requests: [URL] = []
    init(_ responses: [Result<Data, Error>]) { self.responses = responses }

    func data(from url: URL) async throws -> Data {
        requests.append(url)
        guard !responses.isEmpty else { throw HTTPError.invalidResponse }
        return try responses.removeFirst().get()
    }
}
