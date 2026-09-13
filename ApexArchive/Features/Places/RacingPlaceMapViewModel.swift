//
// RacingPlaceMapViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import MapKit
import Observation

@Observable @MainActor final class RacingPlaceMapViewModel {
    private(set) var mapItem: MKMapItem?
    private(set) var isLoading = true

    func load(_ place: RacingPlace) async {
        mapItem = nil
        isLoading = true
        defer { isLoading = false }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = place.name + ", " + place.address
        request.resultTypes = .pointOfInterest
        let search = MKLocalSearch(request: request)
        defer { search.cancel() }
        do {
            let response = try await search.start()
            try Task.checkCancellation()
            mapItem = response.mapItems.first
        } catch {
            mapItem = nil
        }
    }
}
