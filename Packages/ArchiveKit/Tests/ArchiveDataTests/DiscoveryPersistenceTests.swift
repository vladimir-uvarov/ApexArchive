//
// DiscoveryPersistenceTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import Foundation
import XCTest

@MainActor final class DiscoveryPersistenceTests: XCTestCase {
    func testVisitsPersistAcrossStoreInstancesAndRespectShuffle() {
        let suite = UUID().uuidString
        guard let defaults = UserDefaults(suiteName: suite) else { return XCTFail("Missing test defaults") }
        defer { defaults.removePersistentDomain(forName: suite) }

        let first = UserDefaultsDiscoveryStore(defaults: defaults)
        XCTAssertEqual(first.nextVisit(), 0)
        first.saveNextVisit(after: 4)
        let restarted = UserDefaultsDiscoveryStore(defaults: defaults)
        XCTAssertEqual(restarted.nextVisit(), 5)
        XCTAssertEqual(restarted.nextVisit(), 6)
    }

    func testOverflowResetsCounter() {
        let suite = UUID().uuidString
        guard let defaults = UserDefaults(suiteName: suite) else { return XCTFail("Missing test defaults") }
        defer { defaults.removePersistentDomain(forName: suite) }

        let store = UserDefaultsDiscoveryStore(defaults: defaults)
        store.saveNextVisit(after: Int.max)
        XCTAssertEqual(store.nextVisit(), 0)
    }
}
