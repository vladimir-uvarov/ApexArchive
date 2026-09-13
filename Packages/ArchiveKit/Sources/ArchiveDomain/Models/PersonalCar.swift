//
// PersonalCar.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct PersonalCar: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let driverID: String
    public let name: String
    public let relationship: String
    public let description: String
    public let sourceTitle: String
    public let sourceURL: URL
    public let wikipediaTitle: String?
    public let facts: [CarFact]?
    public let evidenceDate: String

    public init(
        id: String, driverID: String, name: String, relationship: String, description: String, sourceTitle: String,
        sourceURL: URL, evidenceDate: String, wikipediaTitle: String? = nil, facts: [CarFact]? = nil
    ) {
        self.facts = facts
        self.id = id
        self.driverID = driverID
        self.name = name
        self.relationship = relationship
        self.description = description
        self.sourceTitle = sourceTitle
        self.sourceURL = sourceURL
        self.evidenceDate = evidenceDate
        self.wikipediaTitle = wikipediaTitle
    }
}
