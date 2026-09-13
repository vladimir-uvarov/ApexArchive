//
// PhotoLibrary.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class PhotoLibrary {
    @ObservationIgnored private var entries: [String: PhotoLoadState] = [:]
    @ObservationIgnored private var pending: [String: Task<Void, Never>] = [:]
    @ObservationIgnored private var insertionOrder: [String] = []
    private let automaticRetryDelay: Duration
    private let maximumAutomaticRetries: Int
    private let maximumImageCount: Int
    private let repository: any PhotoRepository

    public init(
        repository: any PhotoRepository, maximumImageCount: Int = 128, maximumAutomaticRetries: Int = 1,
        automaticRetryDelay: Duration = .seconds(2)
    ) {
        self.maximumAutomaticRetries = max(0, maximumAutomaticRetries)
        self.automaticRetryDelay = automaticRetryDelay
        self.repository = repository
        self.maximumImageCount = max(1, maximumImageCount)
    }

    public func photo(for title: String) -> PhotoLoadState {
        if let state = entries[title] { return state }

        let state = PhotoLoadState()
        entries[title] = state
        return state
    }

    public func load(_ title: String, retry: Bool = false) async {
        if let task = pending[title] {
            await task.value
            return
        }

        let state = photo(for: title)
        // A previous transport failure is transient: a later appearance may retry it. Only an
        // absent licensed photo (`unavailable`) is sticky, and `retry` overrides even that.
        guard state.data == nil, retry || !state.unavailable else { return }

        let task = Task {
            for attempt in 0...maximumAutomaticRetries {
                await fetch(title, state: state)
                guard state.failed, attempt < maximumAutomaticRetries else { return }
                do { try await Task.sleep(for: automaticRetryDelay) } catch { return }
            }
        }
        pending[title] = task
        await task.value
        pending[title] = nil
    }

    /// Preload a bounded batch; visible requests share the same in-flight work.
    public func preload(_ titles: [String], maximumCount: Int = 24) async {
        var seen = Set<String>()
        let unique = titles.filter { seen.insert($0).inserted }.prefix(max(0, maximumCount))
        await withTaskGroup(of: Void.self) { group in
            var iterator = unique.makeIterator()
            let concurrency = 2
            for _ in 0..<concurrency {
                if let title = iterator.next() { group.addTask { await self.load(title) } }
            }
            for await _ in group {
                guard !Task.isCancelled else {
                    group.cancelAll()
                    return
                }
                if let title = iterator.next() { group.addTask { await self.load(title) } }
            }
        }
    }

    private func fetch(_ title: String, state: PhotoLoadState) async {
        state.failed = false
        if let cached = await repository.cachedPhoto(wikipediaTitle: title),
            let data = await repository.cachedImageData(for: cached)
        {
            display(cached, data: data, title: title, state: state)
        }
        do {
            guard let asset = try await repository.photo(wikipediaTitle: title) else {
                state.data = nil
                state.asset = nil
                state.unavailable = true
                return
            }

            let data = try await repository.imageData(for: asset)
            display(asset, data: data, title: title, state: state)
        } catch is CancellationError {
            return
        } catch {
            state.failed = state.data == nil
        }
    }

    private func display(_ asset: PhotoAsset, data: Data, title: String, state: PhotoLoadState) {
        state.asset = asset
        state.data = data
        state.unavailable = false
        insertionOrder.removeAll { $0 == title }
        insertionOrder.append(title)
        while insertionOrder.count > maximumImageCount {
            let expired = insertionOrder.removeFirst()
            entries[expired]?.data = nil
        }
    }
}
