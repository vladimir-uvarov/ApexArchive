//
// StaticArchiveRepository.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain

struct StaticArchiveRepository: ArchiveRepository {
    let snapshot: ArchiveSnapshot
    func load() async throws -> ArchiveSnapshot { snapshot }
}
