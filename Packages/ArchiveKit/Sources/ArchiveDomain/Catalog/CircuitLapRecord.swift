//
// CircuitLapRecord.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct CircuitLapRecord: Codable, Equatable, Sendable {
    public let time: String
    public let driver: String
    public let year: Int

    public init(time: String, driver: String, year: Int) {
        self.time = time
        self.driver = driver
        self.year = year
    }
}
