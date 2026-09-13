//
// TeamHistoryView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import SwiftUI

struct TeamHistoryView: View {
    let teamID: String

    var body: some View {
        if let story {
            Text(story.text)
            if let url = URL(string: story.url) {
                Link(
                    String(localized: "heritage.story.source", defaultValue: "Read the historical account"),
                    destination: url)
            }
        }
    }

    private var story: (text: String, url: String)? {
        switch teamID {
        case "lotus":
            return (
                String(
                    localized: "heritage.story.lotus",
                    defaultValue:
                        "Colin Chapman’s Team Lotus made experimentation central to its identity. Its first championship Grand Prix victory came at Monaco in 1960, with Stirling Moss driving for the privateer Rob Walker team. The original Team Lotus is distinct from later teams that used the Lotus name."
                ), "https://classicteamlotus.co.uk/en/past/"
            )
        case "mclaren":
            return (
                String(
                    localized: "heritage.story.mclaren",
                    defaultValue:
                        "Bruce McLaren founded his team in 1963 and personally delivered its first championship Grand Prix victory at Spa in 1968. That founder-driver story remains an important part of the team’s identity, alongside its success beyond Formula 1."
                ), "https://www.mclaren.com/racing/heritage/mclarens-famous-f1-firsts/"
            )
        case "cooper":
            return (
                String(
                    localized: "heritage.story.cooper",
                    defaultValue:
                        "Cooper helped overturn the front-engined racing order. Its compact cars placed the engine behind the driver, and Jack Brabham won the 1959 and 1960 Drivers’ titles with the team. A small constructor helped change what a Grand Prix car could look like."
                ), "https://www.formula1.com/en/information/drivers-hall-of-fame-jack-brabham.3XK2XWdL0moCmnSC55m84J"
            )
        case "brabham":
            return (
                String(
                    localized: "heritage.story.brabham",
                    defaultValue:
                        "After winning titles with Cooper, Jack Brabham built a team bearing his own name. His 1966 Drivers’ Championship made him the only driver to win that title in a car of his own manufacture—a distinctive link between engineering and driving."
                ), "https://www.formula1.com/en/information/drivers-hall-of-fame-jack-brabham.3XK2XWdL0moCmnSC55m84J"
            )
        case "williams":
            return (
                String(
                    localized: "heritage.story.williams",
                    defaultValue:
                        "Frank Williams and Patrick Head established Williams Grand Prix Engineering in 1977 after Frank’s earlier racing ventures. Their partnership joined determined team-building with engineering leadership and developed into one of the sport’s defining independent constructors."
                ), "https://www.williamsf1.com/persons/sir-frank-williams-v2"
            )
        case "tyrrell":
            return (
                String(
                    localized: "heritage.story.tyrrell",
                    defaultValue:
                        "Tyrrell’s P34 challenged convention with four small front wheels and two rear wheels. Jody Scheckter won the 1976 Swedish Grand Prix in it, leading Patrick Depailler home. Its six-wheel experiment remains one of racing’s most recognizable departures from the ordinary."
                ), "https://www.formula1.com/en/latest/article/six-fascinating-facts-tyrrell-p34.5Eqy5lE9SsSLmF9an1Ak5g"
            )
        case "brm":
            return (
                String(
                    localized: "heritage.story.brm",
                    defaultValue:
                        "BRM reached its championship peak in 1962, when Graham Hill won the Drivers’ title and the team secured the Constructors’ Championship. Hill’s four victories that season made the British marque a central part of the era’s racing story."
                ), "https://www.formula1.com/en/information/drivers-hall-of-fame-graham-hill.NUqzbttsJ2gsuGtW9PzNG"
            )
        default: return nil
        }
    }
}
