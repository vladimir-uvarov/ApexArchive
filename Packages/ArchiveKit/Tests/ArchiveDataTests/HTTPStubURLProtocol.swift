//
// HTTPStubURLProtocol.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

/// Intercepts only the test host; no mutable global request handler is needed.
final class HTTPStubURLProtocol: URLProtocol, @unchecked Sendable {
    override class func canInit(with request: URLRequest) -> Bool { request.url?.host == "transport.test" }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url,
            let response = HTTPURLResponse(
                url: url, statusCode: url.path == "/missing" ? 404 : 200,
                httpVersion: "HTTP/1.1", headerFields: nil)
        else { return }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data((request.value(forHTTPHeaderField: "User-Agent") ?? "").utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
