//
// FilePhotoCache.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import CryptoKit
import Foundation
import ImageIO

/// A disposable, URL-keyed disk cache. Metadata retains the attribution beside each photo.
public actor FilePhotoCache {
    private let directory: URL
    private let maximumBytes: Int
    private let fileManager = FileManager.default

    public init(directory: URL, maximumBytes: Int = 256 * 1_024 * 1_024) {
        self.directory = directory
        self.maximumBytes = max(0, maximumBytes)
    }

    public func asset(for title: String) -> PhotoAsset? {
        guard let data = try? Data(contentsOf: path(for: title, suffix: "json")) else { return nil }
        return try? JSONDecoder().decode(PhotoAsset.self, from: data)
    }

    public func store(_ asset: PhotoAsset, for title: String) {
        guard let data = try? JSONEncoder().encode(asset) else { return }
        write(data, to: path(for: title, suffix: "json"))
        trim()
    }

    public func removeAsset(for title: String) {
        try? fileManager.removeItem(at: path(for: title, suffix: "json"))
    }

    public func image(for url: URL) -> Data? {
        let file = path(for: url.absoluteString, suffix: "image")
        guard let data = try? Data(contentsOf: file),
            let source = CGImageSourceCreateWithData(data as CFData, nil), CGImageSourceGetCount(source) > 0
        else {
            try? fileManager.removeItem(at: file)
            return nil
        }
        try? fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: file.path)
        return data
    }

    public func store(_ data: Data, for url: URL) {
        guard data.count <= maximumBytes else { return }
        write(data, to: path(for: url.absoluteString, suffix: "image"))
        trim()
    }

    private func path(for key: String, suffix: String) -> URL {
        let digest = SHA256.hash(data: Data(key.utf8)).map { String(format: "%02x", $0) }.joined()
        return directory.appendingPathComponent(digest).appendingPathExtension(suffix)
    }

    private func write(_ data: Data, to url: URL) {
        // Cache failures must never prevent a successfully downloaded photo from appearing.
        do {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            try data.write(to: url, options: .atomic)
        } catch { return }
    }

    private func trim() {
        let keys: Set<URLResourceKey> = [.fileSizeKey, .contentModificationDateKey]
        guard
            let files = try? fileManager.contentsOfDirectory(
                at: directory, includingPropertiesForKeys: Array(keys))
        else { return }

        let entries = files.compactMap { url -> (url: URL, size: Int, date: Date)? in
            guard let values = try? url.resourceValues(forKeys: keys) else { return nil }
            return (url, values.fileSize ?? 0, values.contentModificationDate ?? .distantPast)
        }.sorted { $0.date < $1.date }

        var size = entries.reduce(0) { $0 + $1.size }
        for entry in entries where size > maximumBytes {
            do {
                try fileManager.removeItem(at: entry.url)
                size -= entry.size
            } catch { continue }
        }
    }
}
