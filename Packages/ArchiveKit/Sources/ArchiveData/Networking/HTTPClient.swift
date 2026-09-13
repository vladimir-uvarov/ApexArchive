//
// HTTPClient.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public protocol HTTPClient: Sendable {
    func data(from url: URL) async throws -> Data
}
