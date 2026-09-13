//
// QuizScreen.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import ArchivePresentation
import SwiftUI

struct QuizScreen: View {
    @State private var model: QuizViewModel

    init(snapshot: ArchiveSnapshot, mode: QuizMode = .drivers) {
        _model = State(initialValue: QuizViewModel(snapshot: snapshot, mode: mode, trivia: TriviaCatalog.questions))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingSection) {
                if let question = model.currentQuestion {
                    Text(
                        String.localizedStringWithFormat(
                            String(localized: "quiz.progress", defaultValue: "Question %lld of %lld"),
                            model.index + 1, model.questions.count)
                    ).font(.subheadline).foregroundStyle(.secondary)
                    ProgressView(value: Double(model.index), total: Double(model.questions.count))
                    QuizQuestionView(question: question, selectedAnswer: model.selectedAnswer, answer: model.answer)
                    if model.selectedAnswer != nil {
                        Button {
                            model.next()
                        } label: {
                            Text(
                                model.index + 1 == model.questions.count
                                    ? String(localized: "quiz.results", defaultValue: "See results")
                                    : String(localized: "quiz.next", defaultValue: "Next question")
                            )
                            .frame(maxWidth: .infinity)
                        }.buttonStyle(.borderedProminent).controlSize(.large)
                    }
                } else if model.isComplete {
                    Image(systemName: "flag.checkered").font(.largeTitle).foregroundStyle(ArchiveStyle.interactive)
                    Text(String(localized: "quiz.complete", defaultValue: "Round complete")).font(.largeTitle.bold())
                    Text(
                        String.localizedStringWithFormat(
                            String(localized: "quiz.score", defaultValue: "%lld out of %lld correct"),
                            model.score, model.questions.count)
                    ).font(.title2)
                    if model.mode == .daily {
                        Text(
                            String(
                                localized: "quiz.daily.finish",
                                defaultValue:
                                    "Today’s lap is complete. Come back tomorrow for a new challenge, or replay this round."
                            )
                        )
                        .foregroundStyle(.secondary)
                    } else {
                        Text(
                            String(
                                localized: "quiz.finish.body",
                                defaultValue: "Another lap? Try a new selection of archive records.")
                        )
                        .foregroundStyle(.secondary)
                    }
                    Button(String(localized: "quiz.restart", defaultValue: "Play again")) { model.restart() }
                        .buttonStyle(.borderedProminent).controlSize(.large)
                } else {
                    ContentUnavailableView(
                        String(localized: "quiz.empty", defaultValue: "More records needed"),
                        systemImage: "questionmark.circle",
                        description: Text(
                            String(
                                localized: "quiz.empty.body",
                                defaultValue:
                                    "There isn’t enough verified content for this quiz yet. Try again after refreshing the archive."
                            )))
                }
            }.padding(DesignTokens.spacingLarge).frame(maxWidth: DesignTokens.contentMaxWidth)
                .frame(maxWidth: .infinity, alignment: .top)
        }
        .background(ArchiveStyle.background)
        .navigationTitle(
            model.mode == .daily
                ? String(localized: "quiz.daily.title", defaultValue: "Daily challenge")
                : String(localized: "quiz.title", defaultValue: "Quick quiz")
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}
