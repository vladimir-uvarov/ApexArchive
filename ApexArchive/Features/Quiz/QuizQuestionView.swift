//
// QuizQuestionView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct QuizQuestionView: View {
    let question: QuizQuestion
    let selectedAnswer: String?
    let answer: (String) -> Void

    private var prompt: String {
        switch question.subject {
        case .circuit:
            return String(localized: "quiz.shape.prompt", defaultValue: "Which circuit is hiding in this outline?")
        case .team(let team):
            return String.localizedStringWithFormat(
                String(
                    localized: "quiz.team.prompt",
                    defaultValue: "Which team took its first championship Grand Prix win in %@?"),
                team.firstWinYear.map(String.init) ?? "")
        case .trivia(let trivia): return trivia.prompt
        case .driver(let driver, let topic, _):
            switch topic {
            case .country:
                return String.localizedStringWithFormat(
                    String(localized: "quiz.country.prompt", defaultValue: "Which country does %@ represent?"),
                    driver.name)
            case .debutEra:
                return String.localizedStringWithFormat(
                    String(
                        localized: "quiz.era.prompt",
                        defaultValue: "In which decade did %@ make their Grand Prix debut?"), driver.name)
            case .mostWins:
                return String(
                    localized: "quiz.winner.prompt",
                    defaultValue: "Which of these drivers has the most Grand Prix wins?")
            }
        }
    }

    private func optionTitle(_ value: String) -> String {
        if case .driver(_, .debutEra, _) = question.subject {
            return String.localizedStringWithFormat(String(localized: "quiz.decade", defaultValue: "%@s"), value)
        }
        return value
    }

    private var explanation: String {
        switch question.subject {
        case .circuit(let circuit):
            return String.localizedStringWithFormat(
                String(
                    localized: "quiz.shape.explanation",
                    defaultValue: "%@ is in %@. This outline represents its most recently raced layout in the archive."),
                circuit.name, circuit.country)
        case .team(let team):
            return String.localizedStringWithFormat(
                String(
                    localized: "quiz.team.explanation",
                    defaultValue: "%@ recorded its first championship Grand Prix victory in %@."), team.name,
                team.firstWinYear.map(String.init) ?? "")
        case .trivia(let trivia): return trivia.explanation
        case .driver(let driver, let topic, let record):
            switch topic {
            case .country:
                return String.localizedStringWithFormat(
                    String(
                        localized: "quiz.country.explanation",
                        defaultValue: "%@ represents %@ in the archive’s nationality records."), driver.name,
                    question.correctAnswer)
            case .debutEra:
                return String.localizedStringWithFormat(
                    String(localized: "quiz.era.explanation", defaultValue: "%@ first competed in %@."), driver.name,
                    driver.firstSeason.map(String.init) ?? question.correctAnswer)
            case .mostWins:
                return String.localizedStringWithFormat(
                    String(
                        localized: "quiz.winner.explanation",
                        defaultValue:
                            "%@ has %@ Grand Prix wins—the highest total among these four drivers in this archive."),
                    driver.name, record.count.formatted())
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingRegular) {
            Text(prompt).font(.title2.bold()).accessibilityAddTraits(.isHeader)
            Text(String(localized: "quiz.snapshot", defaultValue: "Based on the records loaded for this round."))
                .font(.caption).foregroundStyle(.secondary)
            if case .circuit(let circuit) = question.subject {
                CircuitOutlineView(outline: circuit.outline).frame(height: DesignTokens.featuredImageHeight)
                Text(
                    String(
                        localized: "quiz.shape.visual",
                        defaultValue: "Visual round: identify the track from its silhouette.")
                )
                .font(.caption).foregroundStyle(.secondary)
                if let outline = circuit.outline, selectedAnswer != nil { SourceView(source: outline.source) }
            }
            ForEach(question.options, id: \.self) { value in
                Button {
                    answer(value)
                } label: {
                    HStack {
                        Text(optionTitle(value)).font(.title3.monospacedDigit().bold())
                        Spacer()
                        if selectedAnswer != nil && value == question.correctAnswer {
                            Label(
                                String(localized: "quiz.correct.option", defaultValue: "Correct answer"),
                                systemImage: "checkmark.circle.fill"
                            )
                            .font(.caption)
                        } else if selectedAnswer == value {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                    .padding(DesignTokens.spacingRegular)
                    .frame(maxWidth: .infinity, minHeight: DesignTokens.minimumTouchTarget)
                    .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
                }
                .buttonStyle(.plain)
                .foregroundStyle(
                    selectedAnswer != nil && value == question.correctAnswer ? ArchiveStyle.interactive : .primary
                )
                .disabled(selectedAnswer != nil)
                .accessibilityAddTraits(selectedAnswer == value ? .isSelected : [])
            }
            if let selectedAnswer {
                VStack(alignment: .leading, spacing: DesignTokens.spacingMedium) {
                    Text(
                        selectedAnswer == question.correctAnswer
                            ? String(localized: "quiz.correct", defaultValue: "That’s right")
                            : String(localized: "quiz.incorrect", defaultValue: "Not this time")
                    )
                    .font(.headline)
                    Text(explanation).font(.subheadline).foregroundStyle(.secondary)
                    SourceView(source: question.source)
                }.padding(DesignTokens.spacingLarge)
                    .background(ArchiveStyle.card, in: RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
            }
        }
    }
}
