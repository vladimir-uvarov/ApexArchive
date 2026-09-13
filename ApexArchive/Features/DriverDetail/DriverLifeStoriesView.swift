//
// DriverLifeStoriesView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct DriverLifeStoriesView: View {
    let stories: [DriverLifeStory]
    var showsIntroduction = true

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingLarge) {
            if showsIntroduction {
                Text(
                    String(
                        localized: "driver.life.intro",
                        defaultValue: "Other passions, unexpected talents and work beyond the paddock.")
                )
                .foregroundStyle(.secondary)
            }
            ForEach(stories) { story in
                VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
                    if let contribution = story.contribution { DriverContributionBadge(contribution: contribution) }
                    Text(EditorialText.value(story.title, key: "life.\(story.id).title")).font(.title2.bold())
                    Text(EditorialText.value(story.body, key: "life.\(story.id).body"))
                        .fixedSize(horizontal: false, vertical: true)
                    if let impact = story.impact {
                        VStack(alignment: .leading, spacing: DesignTokens.spacingSmall) {
                            Label(
                                String(localized: "driver.engineering.impact", defaultValue: "Their contribution"),
                                systemImage: "gearshape.2"
                            )
                            .font(.headline).foregroundStyle(ArchiveStyle.interactive)
                            Text(EditorialText.value(impact, key: "life.\(story.id).impact"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    SourceView(source: story.source)
                }.padding(DesignTokens.spacingLarge).frame(maxWidth: .infinity, alignment: .leading)
                    .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            }
        }
    }
}
