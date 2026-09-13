//
// DiscoverTeamSpotlightView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

/// A third spotlight built from `featuredTeam`, which the model already produced and nothing drew.
struct DiscoverTeamSpotlightView: View {
    let model: DiscoverViewModel

    var body: some View {
        Group {
            if let team = model.featuredTeam {
                NavigationLink {
                    TeamDetailView(team: team)
                } label: {
                    card(for: team)
                }.buttonStyle(CardPressStyle())
            }
        }
    }

    private func card(for team: RacingTeam) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
            Text(String(localized: "discover.team.eyebrow", defaultValue: "From the heritage files"))
                .font(.caption.weight(.semibold)).foregroundStyle(ArchiveStyle.interactive)
            HStack(spacing: DesignTokens.spacingRegular) {
                Text(CountryFlag.symbol(for: team.countryCode)).font(.system(size: DesignTokens.teamFlagSize))
                VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                    Text(team.name).font(.title2.bold()).lineLimit(2)
                    Text(
                        String.localizedStringWithFormat(
                            String(localized: "discover.team.span", defaultValue: "%1$@–%2$@"),
                            String(team.firstYear), String(team.lastYear))
                    ).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            HStack(spacing: DesignTokens.spacingLarge) {
                metric(
                    String(localized: "records.wins.short", defaultValue: "Wins"), value: team.wins)
                metric(
                    String(localized: "records.championships", defaultValue: "World Championships"),
                    value: team.championships)
            }
            if let milestone = milestones(for: team) {
                Text(milestone).font(.subheadline).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            SourceView(source: team.source)
            Spacer(minLength: .zero)
            HStack {
                Text(String(localized: "discover.team.open", defaultValue: "Open the team history"))
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: .zero)
                Image(systemName: "arrow.up.right")
            }.foregroundStyle(ArchiveStyle.interactive)
        }.padding(DesignTokens.spacingLarge)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
    }

    /// Uses the milestone years the catalog already carries, so the card says something specific
    /// about the team rather than leaving the space empty.
    private func milestones(for team: RacingTeam) -> String? {
        var parts: [String] = []
        if let year = team.firstWinYear {
            parts.append(
                String.localizedStringWithFormat(
                    String(localized: "discover.team.first.win", defaultValue: "First win in %@"), String(year)))
        }
        if let year = team.firstTitleYear {
            parts.append(
                String.localizedStringWithFormat(
                    String(localized: "discover.team.first.title", defaultValue: "first title in %@"), String(year)))
        }
        return parts.isEmpty ? nil : parts.joined(separator: ", ") + "."
    }

    private func metric(_ label: String, value: Int) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
            Text(String(value)).font(.title.bold()).foregroundStyle(ArchiveStyle.gold)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
    }
}
