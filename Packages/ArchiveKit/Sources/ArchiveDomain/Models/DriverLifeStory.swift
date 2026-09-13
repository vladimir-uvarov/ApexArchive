//
// DriverLifeStory.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public struct DriverLifeStory: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let driverSourceID: String
    public let title: String
    public let body: String
    public let impact: String?
    public let contribution: DriverContribution?
    public let source: EditorialSource

    public init(
        id: String, driverSourceID: String, title: String, body: String, source: EditorialSource,
        contribution: DriverContribution? = nil, impact: String? = nil
    ) {
        self.impact = impact
        self.contribution = contribution
        self.id = id
        self.driverSourceID = driverSourceID
        self.title = title
        self.body = body
        self.source = source
    }
}
