//
// UserDefaultsDiscoveryStore.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

/// A local visit counter gives each launch a different, reproducible editorial selection.
@MainActor public final class UserDefaultsDiscoveryStore {
    private let defaults: UserDefaults
    private static let key = "discover.visitIndex"

    public init(defaults: UserDefaults) { self.defaults = defaults }

    public func nextVisit() -> Int {
        let current = max(0, defaults.integer(forKey: Self.key))
        saveNextVisit(after: current)
        return current
    }

    public func saveNextVisit(after current: Int) {
        defaults.set(current == Int.max ? 0 : max(0, current) + 1, forKey: Self.key)
    }

}
