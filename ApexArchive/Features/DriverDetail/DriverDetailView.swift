//
// DriverDetailView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import Foundation
import SwiftUI

struct DriverDetailView: View {
    @Bindable var viewModel: DriverDetailViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var section: DriverDetailSection = .story
    init(viewModel: DriverDetailViewModel, initialSection: DriverDetailSection = .story) {
        self.viewModel = viewModel
        _section = State(initialValue: initialSection)
    }

    var body: some View {
        Group {
            if let driver = viewModel.driver {
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingSection) {
                        DriverArtwork(driver: driver, large: true).frame(height: DesignTokens.portraitHeight).clipShape(
                            RoundedRectangle(cornerRadius: DesignTokens.heroCornerRadius))
                        VStack(alignment: .leading, spacing: DesignTokens.spacingMedium) {
                            Eyebrow(text: "\(driver.category.title) / \(driver.country)")
                            Text(driver.name).font(.system(.largeTitle, design: .rounded, weight: .heavy))
                            Text(EditorialText.value(driver.subtitle, key: "driver.\(driver.id).subtitle")).font(
                                .title3
                            ).foregroundStyle(.secondary)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DesignTokens.spacingCompact) {
                                ForEach(viewModel.sections, id: \.self) { item in
                                    Button {
                                        section = item
                                    } label: {
                                        Text(item.title).font(.subheadline.weight(.semibold)).padding(
                                            .horizontal, DesignTokens.spacingRegular
                                        ).padding(.vertical, DesignTokens.spacingMedium)
                                            .background(
                                                section == item
                                                    ? ArchiveStyle.interactive.opacity(DesignTokens.selectionOpacity)
                                                    : ArchiveStyle.card, in: Capsule())
                                    }.animation(reduceMotion ? nil : MotionTokens.selection, value: section)
                                        .foregroundStyle(section == item ? ArchiveStyle.interactive : .primary)
                                        .accessibilityAddTraits(section == item ? .isSelected : [])
                                }
                            }
                        }
                        .scrollClipDisabled()
                        if let error = viewModel.errorMessage {
                            Text(error).font(.footnote)
                            Button(
                                String(
                                    localized: "driver_detail_view.retry.saved.drivers",
                                    defaultValue: "Retry saved drivers")
                            ) { viewModel.retryFavorites() }
                        }
                        if section == .story {
                            CareerOverviewView(achievements: viewModel.achievements)
                            CareerTimelineView(seasons: viewModel.careerSeasons)
                            Text(EditorialText.value(driver.biography, key: "driver.\(driver.id).biography")).font(
                                .body
                            ).lineSpacing(DesignTokens.spacingSmall)
                            if let url = viewModel.biographyURL {
                                Link(
                                    String(
                                        localized: "driver_detail_view.read.the.full.biography.on.wikipedia",
                                        defaultValue: "Read the full biography on Wikipedia"), destination: url)
                            }
                            VStack(alignment: .leading, spacing: DesignTokens.spacingCompact) {
                                Eyebrow(
                                    text: String(
                                        localized: "driver_detail_view.about.this.profile",
                                        defaultValue: "About this profile"))
                                Text(
                                    String(
                                        localized: "driver_detail_view.driver.identity.and.win.totals.are.fetched",
                                        defaultValue:
                                            "Driver identity and win totals are fetched from F1DB. Editorial stories and personal-car connections are separately sourced."
                                    )
                                )
                                .font(.footnote).foregroundStyle(.secondary)
                            }.padding(DesignTokens.spacingLarge).background(
                                ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                        } else if section == .engineering {
                            DriverLifeStoriesView(stories: viewModel.engineeringStories, showsIntroduction: false)
                        } else if section == .beyondRacing {
                            DriverLifeStoriesView(stories: viewModel.lifeStories)
                        } else if section == .wins {
                            RecordSection(
                                title: String(localized: "driver_detail_view.wins", defaultValue: "Wins"),
                                icon: "trophy", record: viewModel.achievements.wins,
                                emptyDescription:
                                    String(
                                        localized: "driver_detail_view.a.verified.grand.prix.win.record.has",
                                        defaultValue:
                                            "A verified Grand Prix win record has not been added to this profile yet. Missing data is not a zero-win total."
                                    )
                            )
                        } else if section == .fastestLaps {
                            RecordSection(
                                title: String(
                                    localized: "driver_detail_view.fastest.laps", defaultValue: "Fastest laps"),
                                icon: "stopwatch", record: viewModel.achievements.fastestLaps,
                                emptyDescription:
                                    String(
                                        localized: "driver_detail_view.official.fastest.race.laps.will.appear.here",
                                        defaultValue:
                                            "Official fastest race laps will appear here once verified. Qualifying times and circuit records are separate measures."
                                    )
                            )
                        } else if section == .tracks {
                            SectionTitle(
                                title: String(
                                    localized: "driver_detail_view.favourite.tracks", defaultValue: "Favourite tracks"),
                                subtitle: String(
                                    localized: "driver_detail_view.the.circuits.they.love.in.their.own",
                                    defaultValue: "The circuits they love, in their own telling."))
                            if viewModel.achievements.favouriteTracks.isEmpty {
                                ContentUnavailableView(
                                    String(
                                        localized: "driver_detail_view.no.sourced.preference.yet",
                                        defaultValue: "No sourced preference yet"), systemImage: "flag.checkered",
                                    description: Text(
                                        String(
                                            localized: "driver_detail_view.we.have.not.added.an.attributed.favourite",
                                            defaultValue:
                                                "We have not added an attributed favourite circuit for this driver. Winning at a track does not make it a personal favourite."
                                        )
                                    ))
                            }
                            ForEach(viewModel.achievements.favouriteTracks) { track in
                                VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                                    Image(systemName: "flag.checkered").font(.largeTitle).foregroundStyle(
                                        ArchiveStyle.interactive)
                                    Eyebrow(text: EditorialText.value(track.country, key: "editorial.\(track.country)"))
                                    Text(track.name).font(.title.bold())
                                    Text(
                                        EditorialText.value(
                                            track.attribution, key: "track.\(track.id).\(driver.id).attribution")
                                    ).lineSpacing(DesignTokens.spacingSmall)
                                    SourceView(source: track.source)
                                }.padding(DesignTokens.spacingLarge).background(
                                    ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius)
                                )
                            }
                        } else {
                            let cars = viewModel.cars
                            if cars.isEmpty {
                                ContentUnavailableView(
                                    String(
                                        localized: "driver_detail_view.still.researching.this.garage",
                                        defaultValue: "Still researching this garage"), systemImage: "car.side",
                                    description: Text(
                                        String(
                                            localized: "driver_detail_view.no.verified.personal.cars.documented.yet.we",
                                            defaultValue:
                                                "No verified personal cars documented yet. We publish a car only when we can explain and source its connection to the driver."
                                        )
                                    ))
                            } else {
                                ForEach(cars) { car in
                                    NavigationLink {
                                        CarDetailView(car: car, driverName: driver.name)
                                    } label: {
                                        CarCard(car: car, driverName: driver.name)
                                    }.buttonStyle(.plain)
                                }
                            }
                        }
                    }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                        maxWidth: .infinity)
                }.background(ArchiveStyle.background).navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.toggleFavorite()
                            } label: {
                                Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                                    .contentTransition(.symbolEffect(.replace))
                                    .transaction {
                                        if reduceMotion {
                                            $0.animation = nil
                                            $0.disablesAnimations = true
                                        }
                                    }
                            }.accessibilityLabel(
                                viewModel.isFavorite
                                    ? String.localizedStringWithFormat(
                                        String(
                                            localized: "driver_detail_view.remove.from.saved.drivers",
                                            defaultValue: "Remove %@ from saved drivers"),
                                        String(describing: driver.name))
                                    : String.localizedStringWithFormat(
                                        String(localized: "driver_detail_view.save.driver", defaultValue: "Save %@"),
                                        driver.name))
                        }
                    }
            } else {
                ContentUnavailableView(
                    String(localized: "driver_detail_view.driver.unavailable", defaultValue: "Driver unavailable"),
                    systemImage: "person.crop.circle.badge.questionmark",
                    description: Text(
                        String(
                            localized: "driver_detail_view.this.profile.is.no.longer.in.the",
                            defaultValue: "This profile is no longer in the current archive.")))
            }
        }
        .onChange(of: viewModel.sections) { _, available in
            if !available.contains(section) { section = .story }
        }
    }
}
