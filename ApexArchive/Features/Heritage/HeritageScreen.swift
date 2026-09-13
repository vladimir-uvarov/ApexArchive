//
// HeritageScreen.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct HeritageScreen: View {
    let teams: [RacingTeam]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
                Text(
                    String(
                        localized: "heritage.intro",
                        defaultValue:
                            "Pioneers, innovators and enduring names. Explore the teams that helped shape Grand Prix racing."
                    )
                )
                .foregroundStyle(.secondary)
                ForEach(teams) { team in
                    NavigationLink {
                        TeamDetailView(team: team)
                    } label: {
                        HStack(spacing: DesignTokens.spacingRegular) {
                            Text(CountryFlag.symbol(for: team.countryCode)).font(.largeTitle)
                            VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                                Text(team.name).font(.title2.bold())
                                Text(
                                    String.localizedStringWithFormat(
                                        String(localized: "heritage.since", defaultValue: "In the archive since %@"),
                                        String(team.firstYear))
                                )
                                .font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(.secondary)
                        }.padding(DesignTokens.spacingLarge).frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                    }.buttonStyle(.plain)
                }
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                maxWidth: .infinity)
        }.background(ArchiveStyle.background)
            .navigationTitle(String(localized: "heritage.title", defaultValue: "Racing heritage"))
    }
}
