//
// ArchiveActivitiesView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct ArchiveActivitiesView: View {
    let snapshot: ArchiveSnapshot
    let openCategory: (DriverFilter) -> Void
    var compact = false

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: DesignTokens.spacingMedium) {
                if let catalog = snapshot.catalog {
                    NavigationLink {
                        CircuitsScreen(circuits: catalog.circuits)
                    } label: {
                        activity(
                            title: String(localized: "circuits.title", defaultValue: "Circuits"),
                            subtitle: String(
                                localized: "activities.circuits",
                                defaultValue: "Shapes, lap records and racing history."),
                            symbol: "point.topleft.down.to.point.bottomright.curvepath")
                    }.buttonStyle(.plain)
                    NavigationLink {
                        HeritageScreen(teams: catalog.teamsByDebut)
                    } label: {
                        activity(
                            title: String(localized: "heritage.title", defaultValue: "Racing heritage"),
                            subtitle: String(
                                localized: "activities.heritage", defaultValue: "The teams behind the legends."),
                            symbol: "flag.checkered")
                    }.buttonStyle(.plain)
                }
                NavigationLink {
                    QuizMenuView(snapshot: snapshot)
                } label: {
                    activity(
                        title: String(localized: "quiz.title", defaultValue: "Quick quiz"),
                        subtitle: String(
                            localized: "activities.quiz",
                            defaultValue: "Five questions, no timer, a source behind every answer."),
                        symbol: "questionmark.circle")
                }.buttonStyle(.plain)
                NavigationLink {
                    DriverComparisonScreen(snapshot: snapshot)
                } label: {
                    activity(
                        title: String(localized: "comparison.title", defaultValue: "Compare drivers"),
                        subtitle: String(
                            localized: "activities.compare", defaultValue: "Two careers. Their records and sources."),
                        symbol: "person.2")
                }.buttonStyle(.plain)
                Button {
                    openCategory(.modern)
                } label: {
                    activity(
                        title: String(localized: "discover_view.modern.icons", defaultValue: "Modern icons"),
                        subtitle: String(
                            localized: "discover_view.the.contemporary.era", defaultValue: "The contemporary era"),
                        symbol: "bolt")
                }.buttonStyle(.plain)
                Button {
                    openCategory(.risingStars)
                } label: {
                    activity(
                        title: String(localized: "driver_category.rising", defaultValue: "Rising stars"),
                        subtitle: String(
                            localized: "discover.rising.subtitle", defaultValue: "Meet the next generation."),
                        symbol: "star")
                }.buttonStyle(.plain)
                Button {
                    openCategory(.legends)
                } label: {
                    activity(
                        title: String(localized: "discover_view.legends", defaultValue: "Legends"),
                        subtitle: String(
                            localized: "discover_view.an.enduring.legacy", defaultValue: "An enduring legacy"),
                        symbol: "laurel.leading")
                }.buttonStyle(.plain)
            }.scrollTargetLayout()
        }.scrollIndicators(.hidden).scrollTargetBehavior(.viewAligned)
    }

    private func activity(title: String, subtitle: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
            HStack {
                Image(systemName: symbol).font(.title3).foregroundStyle(ArchiveStyle.interactive)
                Spacer()
                Image(systemName: "arrow.up.right").font(.caption).foregroundStyle(.secondary)
            }
            Text(title).font(.headline).foregroundStyle(.primary)
            if !compact {
                Text(subtitle).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            }
        }.padding(DesignTokens.spacingRegular)
            .frame(
                width: DesignTokens.discoveryOptionWidth,
                height: compact ? DesignTokens.discoveryCompactOptionHeight : DesignTokens.discoveryOptionHeight,
                alignment: .leading
            )
            .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            .contentShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
    }
}
