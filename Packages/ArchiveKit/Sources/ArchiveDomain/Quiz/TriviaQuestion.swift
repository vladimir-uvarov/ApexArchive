//
// TriviaQuestion.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public struct TriviaQuestion: Identifiable, Sendable {
    public let id: String
    public let prompt: String
    public let explanation: String
    public let options: [String]
    public let correctAnswer: String
    public let source: EditorialSource

    public init(
        id: String, prompt: String, explanation: String, options: [String], correctAnswer: String,
        source: EditorialSource
    ) {
        self.id = id
        self.prompt = prompt
        self.explanation = explanation
        self.options = options
        self.correctAnswer = correctAnswer
        self.source = source
    }
}
