//
// QuizQuestion.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public struct QuizQuestion: Identifiable, Sendable {
    public let subject: QuizSubject
    public let options: [String]
    public let correctAnswer: String

    public var id: String {
        switch subject {
        case .driver(let driver, _, _): "driver." + driver.id
        case .circuit(let circuit): "circuit." + circuit.id
        case .team(let team): "team." + team.id
        case .trivia(let question): "trivia." + question.id
        }
    }

    public var source: EditorialSource {
        switch subject {
        case .driver(_, _, let record): record.source
        case .circuit(let circuit): circuit.source
        case .team(let team): team.source
        case .trivia(let question): question.source
        }
    }

    public init(subject: QuizSubject, options: [String], correctAnswer: String) {
        self.subject = subject
        self.options = options
        self.correctAnswer = correctAnswer
    }

    public init(driver: Driver, topic: QuizTopic, record: CareerRecord, options: [String], correctAnswer: String) {
        self.init(subject: .driver(driver, topic, record), options: options, correctAnswer: correctAnswer)
    }
}
