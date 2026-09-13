//
// DiscoverHighlightsView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct DiscoverHighlightsView: View {
    let model: DiscoverViewModel
    let driverDestination: (Driver) -> DriverDetailScreen

    var body: some View {
        GeometryReader { geometry in
            if geometry.size.height < DesignTokens.discoveryCompactStoryHeight {
                HStack(spacing: DesignTokens.spacingRegular) {
                    garage
                    circuit
                }
            } else {
                VStack(spacing: DesignTokens.spacingRegular) {
                    garage.frame(height: geometry.size.height * DesignTokens.discoveryArtworkFraction)
                    HStack(spacing: DesignTokens.spacingRegular) {
                        circuit
                        // `garage` already falls back to `story` when no car is featured; rendering it
                        // here too would stack the same card twice.
                        if model.featuredCar != nil { story }
                    }
                }
            }
        }
    }

    private var garage: some View {
        Group {
            if let entry = model.featuredCar {
                VStack(alignment: .leading, spacing: .zero) {
                    PhotoView(
                        wikipediaTitle: entry.car.wikipediaTitle,
                        accessibilityLabel: String.localizedStringWithFormat(
                            String(
                                localized: "car_card.representative.photo.of",
                                defaultValue: "Representative photo of %@"), entry.car.name)
                    ) {
                        Image(systemName: "car.side.fill").font(.largeTitle).foregroundStyle(ArchiveStyle.interactive)
                    }
                    NavigationLink {
                        CarDetailView(car: entry.car, driverName: entry.driver.name)
                    } label: {
                        VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                            Text(entry.driver.name).font(.caption).foregroundStyle(.secondary)
                            HStack {
                                Text(entry.car.name).font(.headline).lineLimit(2)
                                Spacer(minLength: .zero)
                                Image(systemName: "arrow.up.right").foregroundStyle(ArchiveStyle.interactive)
                            }
                        }.padding(DesignTokens.spacingRegular)
                    }.buttonStyle(.plain)
                }.background(ArchiveStyle.card)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            } else {
                story
            }
        }
    }

    private var circuit: some View {
        Group {
            if let circuit = model.featuredCircuit {
                NavigationLink {
                    CircuitDetailView(circuit: circuit)
                } label: {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                        Text(String(localized: "discover.mix.circuit", defaultValue: "Know this circuit?"))
                            .font(.caption.weight(.semibold)).foregroundStyle(ArchiveStyle.interactive)
                        CircuitOutlineView(outline: circuit.outline, venueName: circuit.name).frame(
                            maxHeight: .infinity)
                        Text(circuit.name).font(.subheadline.bold()).lineLimit(2)
                        Text(CountryFlag.symbol(for: circuit.countryCode) + " " + circuit.country)
                            .font(.caption).foregroundStyle(.secondary).lineLimit(1)
                    }.padding(DesignTokens.spacingRegular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .background(
                            ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                }.buttonStyle(.plain)
            }
        }
    }

    private var story: some View {
        Group {
            if let story = model.featuredLifeStory, let driver = model.featuredStoryDriver {
                NavigationLink {
                    driverDestination(driver).opening(story.contribution == nil ? .beyondRacing : .engineering)
                } label: {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingMedium) {
                        Image(systemName: story.contribution == nil ? "sparkles" : "gearshape.2")
                            .font(.title2).foregroundStyle(ArchiveStyle.interactive)
                        Text(EditorialText.value(story.title, key: "life.\(story.id).title"))
                            .font(.headline).lineLimit(4)
                        Spacer(minLength: .zero)
                        HStack {
                            Text(driver.name).font(.caption).lineLimit(2)
                            Spacer(minLength: .zero)
                            Image(systemName: "arrow.up.right")
                        }.foregroundStyle(ArchiveStyle.interactive)
                    }.padding(DesignTokens.spacingRegular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .background(
                            ArchiveStyle.interactive.opacity(DesignTokens.selectionOpacity),
                            in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                }.buttonStyle(.plain)
            } else if let driver = model.featuredDriver {
                NavigationLink {
                    driverDestination(driver)
                } label: {
                    VStack(alignment: .leading) {
                        DriverArtwork(driver: driver)
                        Text(driver.name).font(.headline).padding(DesignTokens.spacingRegular)
                    }.background(ArchiveStyle.card)
                        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                }.buttonStyle(.plain)
            }
        }
    }
}
