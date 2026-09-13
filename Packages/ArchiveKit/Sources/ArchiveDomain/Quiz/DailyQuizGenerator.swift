//
// DailyQuizGenerator.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

public enum DailyQuizGenerator {
    private static let secondsPerDay: TimeInterval = 86_400

    /// Same UTC day and archive content produce the same mixed round, including answer order.
    public static func questions(from snapshot: ArchiveSnapshot, trivia: [TriviaQuestion], date: Date) -> [QuizQuestion]
    {
        let day = Int64(floor(date.timeIntervalSince1970 / secondsPerDay))
        var random = DailyQuizRandomGenerator(seed: UInt64(bitPattern: day))
        var pools = [QuizGenerator.questions(from: snapshot, using: &random)]
        for mode in [QuizMode.circuits, .trivia, .teams] {
            pools.append(
                CatalogQuizGenerator.questions(catalog: snapshot.catalog, mode: mode, trivia: trivia, using: &random))
        }

        var result: [QuizQuestion] = []
        var used = Set<String>()
        for index in 0..<QuizGenerator.roundLength {
            for pool in pools where pool.indices.contains(index) {
                let question = pool[index]
                if used.insert(question.id).inserted { result.append(question) }
                if result.count == QuizGenerator.roundLength { return result }
            }
        }
        return result
    }
}
