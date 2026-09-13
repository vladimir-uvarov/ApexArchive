//
// QuizSubject.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum QuizSubject: Sendable {
    case driver(Driver, QuizTopic, CareerRecord)
    case circuit(Circuit)
    case team(RacingTeam)
    case trivia(TriviaQuestion)
}
