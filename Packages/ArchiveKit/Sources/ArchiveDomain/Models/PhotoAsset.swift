//
// PhotoAsset.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public struct PhotoAsset: Codable, Equatable, Sendable {
    public let imageURL: URL
    public let pageURL: URL
    public let attribution: String?
    public let author: String
    public let license: String
    public let licenseURL: URL
    public init(
        imageURL: URL, pageURL: URL, author: String, license: String, licenseURL: URL, attribution: String? = nil
    ) {
        self.attribution = attribution
        self.imageURL = imageURL
        self.pageURL = pageURL
        self.author = author
        self.license = license
        self.licenseURL = licenseURL
    }
}
