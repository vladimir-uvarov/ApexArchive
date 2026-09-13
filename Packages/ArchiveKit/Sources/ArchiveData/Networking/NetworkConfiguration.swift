//
// NetworkConfiguration.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct NetworkConfiguration: Sendable {
    public let userAgent: String
    public let minimumRequestInterval: TimeInterval
    public let timeout: TimeInterval
    public static let f1db = NetworkConfiguration(
        userAgent: "ApexArchive/0.2", minimumRequestInterval: 0.35, timeout: 25)
    public static let wikimedia = NetworkConfiguration(
        userAgent: "ApexArchive/0.2 (https://github.com/vladimir-uvarov; independent editorial archive)",
        minimumRequestInterval: 0.2, timeout: 25)
    public init(userAgent: String, minimumRequestInterval: TimeInterval, timeout: TimeInterval) {
        self.userAgent = userAgent
        self.minimumRequestInterval = minimumRequestInterval
        self.timeout = timeout
    }
}
