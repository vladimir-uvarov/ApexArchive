//
// PhotoLoadState.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

/// Observation is scoped to a single photo so unrelated cards do not redraw on every download.
@Observable @MainActor public final class PhotoLoadState {
    public internal(set) var asset: PhotoAsset?
    public internal(set) var data: Data?
    public internal(set) var failed = false
    public internal(set) var unavailable = false
}
