//
// URLSessionHTTPClient.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public actor URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let configuration: NetworkConfiguration
    private var nextRequest = Date.distantPast
    public init(session: URLSession, configuration: NetworkConfiguration) {
        self.session = session
        self.configuration = configuration
    }

    public func data(from url: URL) async throws -> Data {
        let now = Date()
        let scheduled = max(now, nextRequest)
        nextRequest = scheduled.addingTimeInterval(configuration.minimumRequestInterval)
        let delay = scheduled.timeIntervalSince(now)
        if delay > .zero { try await Task.sleep(for: .seconds(delay)) }
        try Task.checkCancellation()
        var request = URLRequest(url: url)
        request.timeoutInterval = configuration.timeout
        request.setValue(configuration.userAgent, forHTTPHeaderField: "User-Agent")
        for attempt in 0...Self.maximumRetries {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw HTTPError.invalidResponse }
            if (200..<300).contains(response.statusCode) { return data }
            guard Self.retryableStatusCodes.contains(response.statusCode), attempt < Self.maximumRetries else {
                throw HTTPError.status(response.statusCode)
            }

            guard let delay = retryDelay(response: response, attempt: attempt) else {
                throw HTTPError.status(response.statusCode)
            }
            try await Task.sleep(for: .seconds(delay))
            try Task.checkCancellation()
        }
        throw HTTPError.invalidResponse
    }

    private static let maximumRetries = 2
    private static let maximumRetryDelay: TimeInterval = 60
    private static let retryableStatusCodes: Set<Int> = [429, 502, 503, 504]

    private func retryDelay(response: HTTPURLResponse, attempt: Int) -> TimeInterval? {
        let fallback = pow(2, Double(attempt + 1))
        guard let header = response.value(forHTTPHeaderField: "Retry-After") else { return fallback }
        if let seconds = TimeInterval(header) {
            return seconds <= Self.maximumRetryDelay ? max(fallback, seconds) : nil
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        guard let date = formatter.date(from: header) else { return fallback }

        let remaining = date.timeIntervalSinceNow
        return remaining <= Self.maximumRetryDelay ? max(fallback, remaining) : nil
    }
}
