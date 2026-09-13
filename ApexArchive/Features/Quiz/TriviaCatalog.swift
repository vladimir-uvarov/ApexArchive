//
// TriviaCatalog.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import Foundation

enum TriviaCatalog {
    static var questions: [TriviaQuestion] {
        [
            make(
                id: "bus",
                prompt: String(
                    localized: "trivia.bus.prompt", defaultValue: "Spa had a “Bus Stop”. What inspired the name?"),
                explanation: String(
                    localized: "trivia.bus.explanation",
                    defaultValue:
                        "The circuit’s own account explains that a bus stop stood there when the roads were open to ordinary traffic. Racing history occasionally takes public transport."
                ),
                options: [
                    String(localized: "trivia.bus.option.0", defaultValue: "An actual bus stop"),
                    String(localized: "trivia.bus.option.1", defaultValue: "A driver’s nickname"),
                    String(localized: "trivia.bus.option.2", defaultValue: "A team radio code"),
                    String(localized: "trivia.bus.option.3", defaultValue: "A very slow pit stop"),
                ], sourceTitle: String(localized: "trivia.bus.source", defaultValue: "Circuit de Spa-Francorchamps"),
                url: "https://www.spa-francorchamps.be/en/news/96_the-corners-of-the-spa-francorchamps-circuit"),
            make(
                id: "papaya",
                prompt: String(
                    localized: "trivia.papaya.prompt",
                    defaultValue: "Which team brought a little fruit-bowl energy to racing with papaya orange?"),
                explanation: String(
                    localized: "trivia.papaya.explanation",
                    defaultValue:
                        "McLaren’s M6A wore papaya in the 1967 Can-Am season. The colour became one of the team’s best-known signatures."
                ),
                options: [
                    String(localized: "trivia.papaya.option.0", defaultValue: "McLaren"),
                    String(localized: "trivia.papaya.option.1", defaultValue: "Ferrari"),
                    String(localized: "trivia.papaya.option.2", defaultValue: "Tyrrell"),
                    String(localized: "trivia.papaya.option.3", defaultValue: "BRM"),
                ], sourceTitle: String(localized: "trivia.papaya.source", defaultValue: "McLaren Racing"),
                url: "https://www.mclaren.com/racing/2026/endurance/reigniting-bruces-dream/"),
            make(
                id: "shoey",
                prompt: String(
                    localized: "trivia.shoey.prompt",
                    defaultValue: "Daniel Ricciardo’s podium “shoey” used which unconventional drinking vessel?"),
                explanation: String(
                    localized: "trivia.shoey.explanation",
                    defaultValue:
                        "Ricciardo celebrated with a drink from his racing shoe. At Monza in 2021, Lando Norris and Zak Brown joined in."
                ),
                options: [
                    String(localized: "trivia.shoey.option.0", defaultValue: "A racing shoe"),
                    String(localized: "trivia.shoey.option.1", defaultValue: "A steering wheel"),
                    String(localized: "trivia.shoey.option.2", defaultValue: "A miniature helmet"),
                    String(localized: "trivia.shoey.option.3", defaultValue: "A fuel funnel"),
                ], sourceTitle: String(localized: "trivia.shoey.source", defaultValue: "Formula 1 race coverage"),
                url:
                    "https://www.formula1.com/en/video/2021-italian-grand-prix-ricciardos-shoey-returns-zak-brown-and-lando-norris-his-newest-victims.1710711512708902315"
            ),
            make(
                id: "founder",
                prompt: String(
                    localized: "trivia.founder.prompt",
                    defaultValue:
                        "“I’ll drive it myself.” Which founder scored McLaren’s first championship Grand Prix win?"),
                explanation: String(
                    localized: "trivia.founder.explanation",
                    defaultValue:
                        "Bruce McLaren won the 1968 Belgian Grand Prix in a car bearing his own name. Quite a hands-on approach to management."
                ),
                options: [
                    String(localized: "trivia.founder.option.0", defaultValue: "Bruce McLaren"),
                    String(localized: "trivia.founder.option.1", defaultValue: "Enzo Ferrari"),
                    String(localized: "trivia.founder.option.2", defaultValue: "Colin Chapman"),
                    String(localized: "trivia.founder.option.3", defaultValue: "Ken Tyrrell"),
                ], sourceTitle: String(localized: "trivia.founder.source", defaultValue: "McLaren Racing"),
                url: "https://www.mclaren.com/racing/heritage/mclarens-famous-f1-firsts/"),
            make(
                id: "alfa",
                prompt: String(
                    localized: "trivia.alfa.prompt",
                    defaultValue:
                        "The championship was brand new. Which marque supplied both of its first two Drivers’ champions?"
                ),
                explanation: String(
                    localized: "trivia.alfa.explanation",
                    defaultValue:
                        "Nino Farina won the 1950 title and Juan Manuel Fangio followed in 1951, both with Alfa Romeo. A very strong opening act."
                ),
                options: [
                    String(localized: "trivia.alfa.option.0", defaultValue: "Alfa Romeo"),
                    String(localized: "trivia.alfa.option.1", defaultValue: "Lotus"),
                    String(localized: "trivia.alfa.option.2", defaultValue: "Williams"),
                    String(localized: "trivia.alfa.option.3", defaultValue: "Benetton"),
                ], sourceTitle: String(localized: "trivia.alfa.source", defaultValue: "Alfa Romeo historical account"),
                url:
                    "https://www.media.stellantis.com/uk-en/alfa-romeo/press/alfa-romeo-celebrates-65th-anniversary-of-its-victory-in-the-inaugural-formula-one-race-in-silverstone"
            ),
            make(
                id: "spa",
                prompt: String(
                    localized: "trivia.spa.prompt",
                    defaultValue: "Before racing cars took over, Spa’s original route connected what?"),
                explanation: String(
                    localized: "trivia.spa.explanation",
                    defaultValue:
                        "The old Spa circuit linked local roads in the Ardennes. The modern course is much shorter than that original road circuit."
                ),
                options: [
                    String(localized: "trivia.spa.option.0", defaultValue: "Public roads between local towns"),
                    String(localized: "trivia.spa.option.1", defaultValue: "Airport taxiways"),
                    String(localized: "trivia.spa.option.2", defaultValue: "An indoor exhibition hall"),
                    String(localized: "trivia.spa.option.3", defaultValue: "A shopping-centre car park"),
                ], sourceTitle: String(localized: "trivia.spa.source", defaultValue: "Circuit de Spa-Francorchamps"),
                url: "https://www.spa-francorchamps.be/en/the-circuit"),
        ].compactMap { $0 }
    }

    private static func make(
        id: String, prompt: String, explanation: String, options: [String], sourceTitle: String, url: String
    ) -> TriviaQuestion? {
        guard let sourceURL = URL(string: url), let answer = options.first else { return nil }
        return TriviaQuestion(
            id: id, prompt: prompt, explanation: explanation, options: options, correctAnswer: answer,
            source: EditorialSource(title: sourceTitle, url: sourceURL, checkedOn: "2026-09-15"))
    }
}
