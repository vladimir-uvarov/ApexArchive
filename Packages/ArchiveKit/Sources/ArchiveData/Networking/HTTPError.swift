//
// HTTPError.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum HTTPError: Error, Equatable {
    case invalidResponse
    case status(Int)
    case invalidURL
    case inconsistentPagination
}
