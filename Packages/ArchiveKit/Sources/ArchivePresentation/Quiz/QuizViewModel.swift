//
// QuizViewModel.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation
import Observation

@Observable @MainActor public final class QuizViewModel {
    public private(set) var questions: [QuizQuestion] = []
    public private(set) var index = 0
    public private(set) var selectedAnswer: String?
    public private(set) var score = 0
    private let snapshot: ArchiveSnapshot
    public let mode: QuizMode
    private let date: Date
    private let trivia: [TriviaQuestion]

    public var currentQuestion: QuizQuestion? {
        questions.indices.contains(index) ? questions[index] : nil
    }

    public var isComplete: Bool { !questions.isEmpty && index == questions.count }

    public init(
        snapshot: ArchiveSnapshot, mode: QuizMode = .drivers, trivia: [TriviaQuestion] = [], date: Date = Date()
    ) {
        self.date = date
        self.mode = mode
        self.trivia = trivia
        self.snapshot = snapshot
        restart()
    }

    public func answer(_ value: String) {
        guard selectedAnswer == nil, let question = currentQuestion, question.options.contains(value) else { return }
        selectedAnswer = value
        if value == question.correctAnswer { score += 1 }
    }

    public func next() {
        guard selectedAnswer != nil, currentQuestion != nil else { return }
        index += 1
        selectedAnswer = nil
    }

    public func restart() {
        var random = SystemRandomNumberGenerator()
        if mode == .daily {
            questions = DailyQuizGenerator.questions(from: snapshot, trivia: trivia, date: date)
        } else {
            questions =
                mode == .drivers
                ? QuizGenerator.questions(from: snapshot, using: &random)
                : CatalogQuizGenerator.questions(catalog: snapshot.catalog, mode: mode, trivia: trivia, using: &random)
        }
        index = 0
        selectedAnswer = nil
        score = 0
    }
}
