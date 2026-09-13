//
// CatalogQuizGenerator.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum CatalogQuizGenerator {
    public static func questions<R: RandomNumberGenerator>(
        catalog: RacingCatalog?, mode: QuizMode,
        trivia: [TriviaQuestion], using random: inout R
    ) -> [QuizQuestion] {
        switch mode {
        case .drivers, .daily: return []
        case .trivia:
            return Array(
                trivia.filter {
                    Set($0.options).count == QuizGenerator.optionCount && $0.options.contains($0.correctAnswer)
                }
                .shuffled(using: &random).prefix(QuizGenerator.roundLength)
            ).map {
                QuizQuestion(
                    subject: .trivia($0), options: $0.options.shuffled(using: &random), correctAnswer: $0.correctAnswer)
            }
        case .circuits:
            let circuits = (catalog?.circuits ?? []).filter { $0.outline != nil }
            return Array(circuits.shuffled(using: &random).prefix(QuizGenerator.roundLength)).compactMap { circuit in
                let choices = options(answer: circuit.name, alternatives: circuits.map(\.name), using: &random)
                guard choices.count == QuizGenerator.optionCount else { return nil }
                return QuizQuestion(subject: .circuit(circuit), options: choices, correctAnswer: circuit.name)
            }
        case .teams:
            let teams = (catalog?.teams ?? []).filter { $0.firstWinYear != nil }
            return Array(teams.shuffled(using: &random).prefix(QuizGenerator.roundLength)).compactMap { team in
                let alternatives = teams.filter { $0.firstWinYear != team.firstWinYear }.map(\.name)
                let choices = options(answer: team.name, alternatives: alternatives, using: &random)
                guard choices.count == QuizGenerator.optionCount else { return nil }
                return QuizQuestion(subject: .team(team), options: choices, correctAnswer: team.name)
            }
        }
    }

    private static func options<R: RandomNumberGenerator>(answer: String, alternatives: [String], using random: inout R)
        -> [String]
    {
        let choices = Set(alternatives).filter { $0 != answer }.sorted().shuffled(using: &random)
        guard choices.count >= QuizGenerator.optionCount - 1 else { return [] }
        return (Array(choices.prefix(QuizGenerator.optionCount - 1)) + [answer]).shuffled(using: &random)
    }
}
