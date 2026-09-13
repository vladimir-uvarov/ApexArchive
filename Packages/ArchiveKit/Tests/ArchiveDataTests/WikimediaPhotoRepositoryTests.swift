//
// WikimediaPhotoRepositoryTests.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveData
import XCTest

final class WikimediaPhotoRepositoryTests: XCTestCase {
    func testReturnsLicensedPhotoWithAttributionAndCachesIt() async throws {
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(try WikimediaFixtures.photo())])
        let repository = WikimediaPhotoRepository(client: client)
        let asset = try await repository.photo(wikipediaTitle: "Test Driver")
        XCTAssertEqual(asset?.author, "Test Artist")
        XCTAssertEqual(asset?.license, "CC BY-SA 4.0")
        XCTAssertTrue(asset?.imageURL.path.contains("thumb.jpg") == true)
        _ = try await repository.photo(wikipediaTitle: "Test Driver")
        let requests = await client.requests
        XCTAssertEqual(requests.count, 2)
    }

    func testRejectsNonCommercialPhotoLicense() async throws {
        let client = StubHTTPClient([
            .success(WikimediaFixtures.page), .success(try WikimediaFixtures.photo(license: "CC BY-NC 4.0")),
        ])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Test Driver")
        XCTAssertNil(asset)
    }

    func testNetworkFailureCanBeRetried() async throws {
        let client = StubHTTPClient([
            .failure(HTTPError.status(503)), .success(WikimediaFixtures.page), .success(try WikimediaFixtures.photo()),
        ])
        let repository = WikimediaPhotoRepository(client: client)
        do {
            _ = try await repository.photo(wikipediaTitle: "Test Driver")
            XCTFail("Expected failure")
        } catch {}

        let result = try await repository.photo(wikipediaTitle: "Test Driver")
        XCTAssertNotNil(result)
    }

    func testNoPhotoIsDifferentFromNetworkFailure() async throws {
        let client = StubHTTPClient([.success(Data(#"{"query":{"pages":{"1":{}}}}"#.utf8))])
        let result = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Test Driver")
        XCTAssertNil(result)
    }

    func testIgnoresNumericExtensionMetadata() async throws {
        let raw = try WikimediaFixtures.photo()
        var text = String(decoding: raw, as: UTF8.self)
        text = text.replacingOccurrences(
            of: "\"extmetadata\":{", with: "\"extmetadata\":{\"CommonsMetadataExtension\":{\"value\":1},")
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(Data(text.utf8))])
        let result = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Test Driver")
        XCTAssertNotNil(result)
    }

    func testUpgradesLegacyCreativeCommonsLicenseURL() async throws {
        let raw = String(decoding: try WikimediaFixtures.photo(), as: UTF8.self)
            .replacingOccurrences(of: "https://creativecommons.org", with: "http://creativecommons.org")
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(Data(raw.utf8))])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Honda NSX")
        XCTAssertEqual(asset?.licenseURL.scheme, "https")
    }

    func testUsesArticleLinkedWikidataImageWhenLeadImageIsAbsent() async throws {
        let page = Data(#"{"query":{"pages":{"1":{"pageprops":{"wikibase_item":"Q123"}}}}}"#.utf8)
        let claims = Data(
            #"{"claims":{"P18":[{"rank":"normal","mainsnak":{"datavalue":{"value":"Fallback.jpg"}}}]}}"#.utf8)
        let client = StubHTTPClient([.success(page), .success(claims), .success(try WikimediaFixtures.photo())])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
        XCTAssertNotNil(asset)
        let requests = await client.requests
        XCTAssertEqual(requests.count, 3)
        XCTAssertEqual(requests[1].host, "www.wikidata.org")
        XCTAssertTrue(requests[2].absoluteString.contains("Fallback.jpg"))
    }

    func testFallbackStillRejectsNonCommercialImages() async throws {
        let page = Data(#"{"query":{"pages":{"1":{"pageprops":{"wikibase_item":"Q123"}}}}}"#.utf8)
        let claims = Data(
            #"{"claims":{"P18":[{"rank":"normal","mainsnak":{"datavalue":{"value":"Fallback.jpg"}}}]}}"#.utf8)
        let client = StubHTTPClient([
            .success(page), .success(claims), .success(try WikimediaFixtures.photo(license: "CC BY-NC 4.0")),
        ])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
        XCTAssertNil(asset)
    }

    func testDisambiguationPageCannotSupplyWrongPersonPortrait() async throws {
        let page = Data(
            #"{"query":{"pages":{"1":{"pageimage":"Wrong.jpg","pageprops":{"wikibase_item":"Q123","disambiguation":""}}}}}"#
                .utf8)
        // The qualified retry finds nothing, so the disambiguation page's own image stays unused.
        let empty = Data(#"{"query":{"pages":{"1":{}}}}"#.utf8)
        let client = StubHTTPClient([.success(page), .success(empty)])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Ambiguous name")
        XCTAssertNil(asset)
        let requests = await client.requests
        XCTAssertEqual(requests.count, 2, "only the qualified title is retried")
        XCTAssertFalse(requests.contains { $0.absoluteString.contains("Wrong.jpg") })
    }

    func testAPIFailureIsNotCachedAsNoPhoto() async throws {
        let client = StubHTTPClient([.success(Data(#"{"error":{"code":"maxlag"}}"#.utf8))])
        do {
            _ = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
            XCTFail("Expected a retryable lookup failure")
        } catch {
            XCTAssertTrue(error is HTTPError)
        }
    }

    func testAcceptsOGL3OnlyWithOfficialLicenseURL() async throws {
        let raw = try WikimediaFixtures.photo(
            license: "OGL 3", licenseURL: "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3")
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(raw)])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Lewis Hamilton")
        XCTAssertEqual(asset?.license, "OGL 3")
        XCTAssertEqual(asset?.licenseURL.scheme, "https")
        XCTAssertEqual(asset?.author, "Test Artist")
        let mismatch = StubHTTPClient([
            .success(WikimediaFixtures.page), .success(try WikimediaFixtures.photo(license: "OGL 3")),
        ])
        let rejected = try await WikimediaPhotoRepository(client: mismatch).photo(wikipediaTitle: "Driver")
        XCTAssertNil(rejected)
    }

    func testPublicDomainWithoutSeparateLicenseLinksToCommonsRightsStatement() async throws {
        let data = try WikimediaFixtures.photo(license: "Public domain", licenseURL: "")
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(data)])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Stirling Moss")
        XCTAssertNotNil(asset)
        XCTAssertEqual(asset?.licenseURL, asset?.pageURL)
        let missing = try WikimediaFixtures.photo(license: "CC BY 4.0", licenseURL: "")
        let other = StubHTTPClient([.success(WikimediaFixtures.page), .success(missing)])
        let rejected = try await WikimediaPhotoRepository(client: other).photo(wikipediaTitle: "Driver")
        XCTAssertNil(rejected)
    }

    func testRejectsLicenseNameAndURLMismatch() async throws {
        let data = try WikimediaFixtures.photo(
            license: "CC BY 4.0", licenseURL: "https://creativecommons.org/licenses/by-sa/4.0/")
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(data)])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
        XCTAssertNil(asset)
    }

    /// Commons short names are not always three words. Rejecting these lost real, correctly
    /// licensed portraits, while the name/URL agreement below must still hold.
    func testAcceptsPortedAndMultiVersionCreativeCommonsNames() async throws {
        let ported = try WikimediaFixtures.photo(
            license: "CC BY-SA 3.0 de", licenseURL: "https://creativecommons.org/licenses/by-sa/3.0/de/")
        var client = StubHTTPClient([.success(WikimediaFixtures.page), .success(ported)])
        var asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
        XCTAssertEqual(asset?.license, "CC BY-SA 3.0 de")

        let multiple = try WikimediaFixtures.photo(
            license: "CC BY-SA 4.0,3.0,2.5", licenseURL: "https://creativecommons.org/licenses/by-sa/3.0/")
        client = StubHTTPClient([.success(WikimediaFixtures.page), .success(multiple)])
        asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
        XCTAssertEqual(asset?.license, "CC BY-SA 4.0,3.0,2.5")
    }

    func testPortedLicenseStillRejectsAMismatchedURL() async throws {
        let data = try WikimediaFixtures.photo(
            license: "CC BY-SA 3.0 de", licenseURL: "https://creativecommons.org/licenses/by/3.0/de/")
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(data)])
        let mismatched = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
        XCTAssertNil(mismatched)

        let version = try WikimediaFixtures.photo(
            license: "CC BY-SA 4.0,3.0", licenseURL: "https://creativecommons.org/licenses/by-sa/2.0/")
        let versionClient = StubHTTPClient([.success(WikimediaFixtures.page), .success(version)])
        let wrongVersion = try await WikimediaPhotoRepository(client: versionClient).photo(wikipediaTitle: "Driver")
        XCTAssertNil(wrongVersion)
    }

    /// F1DB stores a plain name, so a historical driver whose name is shared resolves to a
    /// disambiguation page. Giving up there loses drivers who do have a portrait.
    func testDisambiguationRetriesTheQualifiedDriverTitle() async throws {
        let disambiguation = Data(#"{"query":{"pages":{"1":{"pageprops":{"disambiguation":""}}}}}"#.utf8)
        let client = StubHTTPClient([
            .success(disambiguation), .success(WikimediaFixtures.page), .success(try WikimediaFixtures.photo()),
        ])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Alan_Jones")
        XCTAssertEqual(asset?.license, "CC BY-SA 4.0")
        let requested = await client.requests
        XCTAssertTrue(
            requested.contains { $0.absoluteString.contains("racing_driver") },
            "the retry must ask for the qualified title")
    }

    func testDisambiguationIsNotRetriedForever() async throws {
        let disambiguation = Data(#"{"query":{"pages":{"1":{"pageprops":{"disambiguation":""}}}}}"#.utf8)
        let client = StubHTTPClient([.success(disambiguation), .success(disambiguation)])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Alan_Jones")
        XCTAssertNil(asset)
        let requested = await client.requests
        XCTAssertEqual(requested.count, 2, "one lookup plus a single qualified retry")
    }

    func testRetainsSuppliedAttributionAndCopyrightNotices() async throws {
        let raw = String(decoding: try WikimediaFixtures.photo(), as: UTF8.self)
            .replacingOccurrences(
                of: "\"extmetadata\":{",
                with:
                    "\"extmetadata\":{\"Attribution\":{\"value\":\"Photo by Example Agency\"},\"Copyright\":{\"value\":\"Copyright Example\"},"
            )
        let client = StubHTTPClient([.success(WikimediaFixtures.page), .success(Data(raw.utf8))])
        let asset = try await WikimediaPhotoRepository(client: client).photo(wikipediaTitle: "Driver")
        XCTAssertTrue(asset?.attribution?.contains("Photo by Example Agency") == true)
        XCTAssertTrue(asset?.attribution?.contains("Copyright Example") == true)
    }

}
