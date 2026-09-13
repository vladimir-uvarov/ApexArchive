//
// CareerLeader.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public struct CareerLeader: Identifiable, Sendable {
    public let driver: Driver
    public let record: CareerRecord
    public var id: String { driver.id }

    public init(driver: Driver, record: CareerRecord) {
        self.driver = driver
        self.record = record
    }
}
