//
// F1DBArchiveReader.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation
import ZIPFoundation

/// Extracts only the named JSON entries into memory; never writes archive paths to disk.
struct F1DBArchiveReader {
    private static let maximumArchiveBytes = 20 * 1_024 * 1_024
    private static let maximumEntryBytes = 8 * 1_024 * 1_024

    func decode<T: Decodable>(_ type: T.Type, entry name: String, from data: Data) throws -> T {
        guard data.count <= Self.maximumArchiveBytes else { throw HTTPError.invalidResponse }

        let archive = try Archive(data: data, accessMode: .read)
        guard let entry = archive[name], entry.type == .file,
            entry.uncompressedSize <= Self.maximumEntryBytes
        else { throw HTTPError.invalidResponse }

        var output = Data()
        let checksum = try archive.extract(entry) { chunk in
            try Task.checkCancellation()
            guard output.count + chunk.count <= Self.maximumEntryBytes else { throw HTTPError.invalidResponse }
            output.append(chunk)
        }
        guard checksum == entry.checksum else { throw HTTPError.invalidResponse }
        return try JSONDecoder().decode(type, from: output)
    }
}
