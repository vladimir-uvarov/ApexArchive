//
// DriverComparisonScreen.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct DriverComparisonScreen: View {
    @State private var model: DriverComparisonViewModel
    @State private var choosingFirst = true
    @State private var showingPicker = false

    init(snapshot: ArchiveSnapshot) {
        _model = State(initialValue: DriverComparisonViewModel(snapshot: snapshot))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingSection) {
                if let first = model.first, let second = model.second {
                    ViewThatFits(in: .horizontal) {
                        HStack(alignment: .top) {
                            driverButton(first, isFirst: true)
                            driverButton(second, isFirst: false)
                        }
                        VStack {
                            driverButton(first, isFirst: true)
                            driverButton(second, isFirst: false)
                        }
                    }
                    Button {
                        model.swap()
                    } label: {
                        Label(
                            String(localized: "comparison.swap", defaultValue: "Swap drivers"),
                            systemImage: "arrow.left.arrow.right")
                    }.buttonStyle(.bordered)
                    ComparisonRecordView(
                        title: String(localized: "comparison.wins", defaultValue: "Grand Prix wins"),
                        firstName: first.name, secondName: second.name,
                        first: model.snapshot.achievements[first.id]?.wins,
                        second: model.snapshot.achievements[second.id]?.wins)
                    ComparisonRecordView(
                        title: String(localized: "comparison.laps", defaultValue: "Fastest race laps"),
                        firstName: first.name, secondName: second.name,
                        first: model.snapshot.achievements[first.id]?.fastestLaps,
                        second: model.snapshot.achievements[second.id]?.fastestLaps)
                    Text(
                        String(
                            localized: "comparison.context",
                            defaultValue:
                                "Career totals reflect different eras and numbers of starts. They aren’t a ranking of driver ability. Missing records are not zero."
                        )
                    )
                    .font(.footnote).foregroundStyle(.secondary)
                } else {
                    ContentUnavailableView(
                        String(localized: "comparison.empty", defaultValue: "Two drivers needed"),
                        systemImage: "person.2",
                        description: Text(
                            String(
                                localized: "comparison.empty.body",
                                defaultValue: "Refresh the archive to load more drivers.")))
                }
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                maxWidth: .infinity)
        }.background(ArchiveStyle.background)
            .navigationTitle(String(localized: "comparison.title", defaultValue: "Compare drivers"))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingPicker) {
                ComparisonDriverPicker(
                    model: model,
                    excludedID: choosingFirst ? model.secondID : model.firstID
                ) {
                    model.select($0, forFirst: choosingFirst)
                }
            }
    }

    private func driverButton(_ driver: Driver, isFirst: Bool) -> some View {
        Button {
            choosingFirst = isFirst
            showingPicker = true
        } label: {
            VStack(alignment: .leading, spacing: DesignTokens.spacingMedium) {
                DriverArtwork(driver: driver).frame(height: DesignTokens.driverThumbnailHeight)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                Text(driver.name).font(.headline).foregroundStyle(.primary)
                Text(driver.country).font(.subheadline).foregroundStyle(.secondary)
                Label(
                    String(localized: "comparison.change", defaultValue: "Change driver"), systemImage: "chevron.down"
                )
                .font(.caption)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.buttonStyle(.plain)
    }
}
