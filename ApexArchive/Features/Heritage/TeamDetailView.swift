//
// TeamDetailView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct TeamDetailView: View {
    let team: RacingTeam

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
                Text(CountryFlag.symbol(for: team.countryCode)).font(.largeTitle)
                Text(team.name).font(.largeTitle.bold())
                Text(team.country).font(.title3).foregroundStyle(.secondary)
                Text(
                    String.localizedStringWithFormat(
                        String(
                            localized: "heritage.history.body",
                            defaultValue:
                                "%@ entered the World Championship record in %@. Its entries span through %@ in this archive, across changing cars, drivers and racing eras."
                        ), team.name, String(team.firstYear), String(team.lastYear)))
                if team.id == "alfa-romeo" {
                    Text(
                        String(
                            localized: "heritage.alfa.history",
                            defaultValue:
                                "Alfa Romeo powered the first two Drivers’ World Champions: Nino Farina in 1950 and Juan Manuel Fangio in 1951. The Alfetta 158 and 159 connect the sport’s opening chapter to the brand’s earlier racing heritage. The later Alfa Romeo Racing name was used by the Sauber-operated team; it was not a continuous operation of the original works squad."
                        ))
                    if let url = URL(
                        string:
                            "https://www.media.stellantis.com/uk-en/alfa-romeo/press/alfa-romeo-celebrates-65th-anniversary-of-its-victory-in-the-inaugural-formula-one-race-in-silverstone"
                    ) {
                        Link(
                            String(localized: "heritage.alfa.source", defaultValue: "Alfa Romeo historical account"),
                            destination: url)
                    }
                }
                TeamHistoryView(teamID: team.id)
                if let year = team.firstWinYear {
                    Text(
                        String.localizedStringWithFormat(
                            String(
                                localized: "heritage.first.win",
                                defaultValue:
                                    "The first championship Grand Prix victory credited to this constructor came in %@."
                            ), String(year)))
                }
                if let year = team.firstTitleYear {
                    Text(
                        String.localizedStringWithFormat(
                            String(
                                localized: "heritage.first.title",
                                defaultValue: "Its first Constructors’ Championship followed in %@."), String(year)))
                }
                LabeledContent(
                    String(localized: "heritage.wins", defaultValue: "Grand Prix victories"),
                    value: team.wins.formatted())
                LabeledContent(
                    String(localized: "heritage.titles", defaultValue: "Constructors’ Championships"),
                    value: team.championships.formatted())
                Text(
                    String(
                        localized: "heritage.scope",
                        defaultValue:
                            "Figures follow F1DB’s constructor identities. A team name may cover different operators or eras; this does not imply continuous ownership. The Constructors’ Championship began in 1958, so these totals do not include earlier Drivers’ titles."
                    )
                )
                .font(.footnote).foregroundStyle(.secondary)
                SourceView(source: team.source)
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth).frame(
                maxWidth: .infinity)
        }.background(ArchiveStyle.background).navigationBarTitleDisplayMode(.inline)
    }
}
