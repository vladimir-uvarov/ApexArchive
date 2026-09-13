//
// GarageEntry.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

public struct GarageEntry: Identifiable, Equatable {
    public let car: PersonalCar
    public let driver: Driver
    public var id: String { car.id }

    public init(car: PersonalCar, driver: Driver) {
        self.car = car
        self.driver = driver
    }
}
