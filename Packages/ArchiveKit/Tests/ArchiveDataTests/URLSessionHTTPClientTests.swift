//
// URLSessionHTTPClientTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import Foundation
import XCTest

final class URLSessionHTTPClientTests: XCTestCase {
    func testReturnsBytesAndIdentifiesOperator() async throws {
        let url = try XCTUnwrap(URL(string: "https://transport.test/success"))
        let data = try await client().data(from: url)
        XCTAssertEqual(String(decoding: data, as: UTF8.self), "ApexArchiveTest")
    }

    func testHTTPFailureIsNotDecodedAsSuccessfulData() async throws {
        let url = try XCTUnwrap(URL(string: "https://transport.test/missing"))
        do {
            _ = try await client().data(from: url)
            XCTFail("Expected an HTTP status failure")
        } catch { XCTAssertEqual(error as? HTTPError, .status(404)) }
    }

    func testCancelledRequestDoesNotReachTransport() async throws {
        let url = try XCTUnwrap(URL(string: "https://transport.test/success"))
        let client = client()
        let request = Task { () throws -> Data in
            withUnsafeCurrentTask { $0?.cancel() }
            return try await client.data(from: url)
        }
        do {
            _ = try await request.value
            XCTFail("Expected cancellation")
        } catch { XCTAssertTrue(error is CancellationError) }
    }

    private func client() -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [HTTPStubURLProtocol.self]
        return URLSessionHTTPClient(
            session: URLSession(configuration: configuration),
            configuration: NetworkConfiguration(userAgent: "ApexArchiveTest", minimumRequestInterval: 0, timeout: 1))
    }
}
