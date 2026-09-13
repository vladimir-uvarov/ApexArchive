//
// LegalDocumentTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import XCTest

@testable import ApexArchive

/// Settings links every document by resource name; a renamed file would only show as
/// "Document unavailable" at runtime.
final class LegalDocumentTests: XCTestCase {
    func testEveryDocumentIsBundledAndNonEmpty() throws {
        for document in LegalDocument.allCases {
            let url = try XCTUnwrap(
                Bundle.main.url(forResource: document.resource, withExtension: "txt"), document.resource)
            let text = try String(contentsOf: url, encoding: .utf8)
            XCTAssertFalse(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, document.resource)
        }
    }
}
