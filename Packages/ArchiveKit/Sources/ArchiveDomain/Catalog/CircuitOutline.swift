//
// CircuitOutline.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct CircuitOutline: Codable, Equatable, Sendable {
    public let points: [CircuitPoint]
    public let source: EditorialSource

    public init(points: [CircuitPoint], source: EditorialSource) {
        self.points = points
        self.source = source
    }
}
