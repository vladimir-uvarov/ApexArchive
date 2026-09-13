//
// F1DBRepositoryTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import ArchiveDomain
import ArchiveTestSupport
import XCTest

final class F1DBRepositoryTests: XCTestCase {
    private func release(host: String = "github.com") -> Data {
        Data(
            """
            {"tag_name":"v2026.14.0","html_url":"https://github.com/f1db/f1db/releases/tag/v2026.14.0","assets":[{"name":"f1db-json-splitted.zip","browser_download_url":"https://\(host)/f1db/f1db/releases/download/v2026.14.0/f1db-json-splitted.zip"}]}
            """.utf8)
    }

    private func fixture(_ name: String) throws -> Data {
        let url = try XCTUnwrap(Bundle.module.url(forResource: name, withExtension: "zip", subdirectory: "Fixtures"))
        return try Data(contentsOf: url)
    }

    private func editorial() -> StaticArchiveRepository {
        StaticArchiveRepository(snapshot: ArchiveSnapshot(drivers: [], cars: [], achievements: [:]))
    }

    func testLoadsDriversAndCareerRecordsTogether() async throws {
        let client = StubHTTPClient([.success(release()), .success(try fixture("valid"))])
        let repository = F1DBRepository(client: client, editorial: editorial())
        let archive = try await repository.load()
        XCTAssertEqual(archive.drivers.first?.name, "Ayrton Senna")
        XCTAssertEqual(archive.drivers.first?.country, "Brazil")
        let record = try XCTUnwrap(archive.achievements["ayrton-senna"])
        XCTAssertEqual(record.wins?.count, 41)
        XCTAssertEqual(record.fastestLaps?.count, 19)
        XCTAssertEqual(record.championships?.count, 3)
        XCTAssertEqual(record.podiums?.count, 80)
        XCTAssertEqual(record.polePositions?.count, 65)
        XCTAssertEqual(record.raceStarts?.count, 161)
        XCTAssertTrue(record.wins?.source.title.contains("CC BY 4.0") == true)
        let requests = await client.requests
        XCTAssertEqual(requests.count, 2)
    }

    func testRejectsUnexpectedDownloadHostBeforeRequestingIt() async {
        let client = StubHTTPClient([.success(release(host: "example.org"))])
        do {
            _ = try await F1DBRepository(client: client, editorial: editorial()).load()
            XCTFail("Expected rejected host")
        } catch {}

        let requests = await client.requests
        XCTAssertEqual(requests.count, 1)
    }

    func testRejectsDuplicateDriverIDs() async throws {
        let client = StubHTTPClient([.success(release()), .success(try fixture("duplicate"))])
        do {
            _ = try await F1DBRepository(client: client, editorial: editorial()).load()
            XCTFail("Expected duplicate rejection")
        } catch { XCTAssertEqual(error as? HTTPError, .invalidResponse) }
    }

    func testRejectsNegativeStatistics() async throws {
        let client = StubHTTPClient([.success(release()), .success(try fixture("negative"))])
        do {
            _ = try await F1DBRepository(client: client, editorial: editorial()).load()
            XCTFail("Expected negative total rejection")
        } catch { XCTAssertEqual(error as? HTTPError, .invalidResponse) }
    }

    func testRejectsCorruptArchive() async {
        let client = StubHTTPClient([.success(release()), .success(Data("not a ZIP".utf8))])
        let repository = F1DBRepository(client: client, editorial: editorial())
        do {
            _ = try await repository.load()
            XCTFail("Expected invalid archive")
        } catch {}

    }
}
