//
// QuizGenerator.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum QuizGenerator {
    public static let roundLength = 5
    public static let optionCount = 4
    private static let yearsPerDecade = 10

    /// Curated identities and eras, plus one comparison; never an exact fastest-lap total.
    public static func questions<R: RandomNumberGenerator>(
        from snapshot: ArchiveSnapshot, using random: inout R
    ) -> [QuizQuestion] {
        let drivers = snapshot.drivers.filter { $0.category == .modern || $0.category == .legends }

        var used = Set<String>()
        var questions: [QuizQuestion] = []
        let topics: [QuizTopic] = [.country, .debutEra, .country, .debutEra]
        for topic in topics {
            let available = drivers.filter { !used.contains($0.id) }.shuffled(using: &random)
            var question: QuizQuestion?
            for driver in available {
                guard let record = snapshot.achievements[driver.id]?.wins else { continue }
                question = identityQuestion(
                    driver: driver, topic: topic, record: record, drivers: drivers, using: &random)
                if question != nil { break }
            }
            // Bundled data may not contain debut seasons yet; use another country clue.
            if question == nil && topic == .debutEra {
                for driver in available {
                    guard let record = snapshot.achievements[driver.id]?.wins else { continue }
                    question = identityQuestion(
                        driver: driver, topic: .country, record: record, drivers: drivers, using: &random)
                    if question != nil { break }
                }
            }
            if let question {
                if case .driver(let driver, _, _) = question.subject { used.insert(driver.id) }
                questions.append(question)
            }
        }

        let winners = drivers.filter {
            !used.contains($0.id) && (snapshot.achievements[$0.id]?.wins?.count ?? 0) > 0
        }.shuffled(using: &random)
        for winner in winners {
            guard let record = snapshot.achievements[winner.id]?.wins else { continue }

            let alternatives = winners.filter {
                $0.name != winner.name && (snapshot.achievements[$0.id]?.wins?.count ?? 0) < record.count
            }

            var names = Set<String>()
            let distinct = alternatives.filter { names.insert($0.name).inserted }
            guard distinct.count >= optionCount - 1 else { continue }

            let options = (Array(distinct.prefix(optionCount - 1)).map(\.name) + [winner.name])
                .shuffled(using: &random)
            questions.append(
                QuizQuestion(
                    driver: winner, topic: .mostWins, record: record,
                    options: options, correctAnswer: winner.name))
            break
        }
        return questions.count == roundLength ? questions.shuffled(using: &random) : []
    }

    private static func identityQuestion<R: RandomNumberGenerator>(
        driver: Driver, topic: QuizTopic, record: CareerRecord, drivers: [Driver], using random: inout R
    ) -> QuizQuestion? {
        let answer: String
        let pool: [String]
        switch topic {
        case .country:
            answer = driver.country
            pool = drivers.map(\.country)
        case .debutEra:
            guard let season = driver.firstSeason else { return nil }
            answer = String(season / yearsPerDecade * yearsPerDecade)
            pool = drivers.compactMap { $0.firstSeason.map { String($0 / yearsPerDecade * yearsPerDecade) } }
        case .mostWins: return nil
        }
        guard !answer.isEmpty else { return nil }

        let alternatives = Set(pool).filter { !$0.isEmpty && $0 != answer }.sorted().shuffled(using: &random)
        guard alternatives.count >= optionCount - 1 else { return nil }

        let options = (Array(alternatives.prefix(optionCount - 1)) + [answer]).shuffled(using: &random)
        return QuizQuestion(driver: driver, topic: topic, record: record, options: options, correctAnswer: answer)
    }
}
