//
// QuizMenuView.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import ArchiveDomain
import SwiftUI

struct QuizMenuView: View {
    let snapshot: ArchiveSnapshot

    var body: some View {
        List {
            Section {
                NavigationLink {
                    QuizScreen(snapshot: snapshot, mode: .daily)
                } label: {
                    Label(
                        String(localized: "quiz.daily.title", defaultValue: "Daily challenge"), systemImage: "sun.max")
                }
            } footer: {
                Text(
                    String(
                        localized: "quiz.daily.note",
                        defaultValue:
                            "Five questions, mixing people, circuits and stories. A fresh selection every day at midnight UTC."
                    ))
            }

            NavigationLink {
                QuizScreen(snapshot: snapshot)
            } label: {
                Label(String(localized: "quiz.mode.drivers", defaultValue: "Meet the drivers"), systemImage: "person.2")
            }
            NavigationLink {
                QuizScreen(snapshot: snapshot, mode: .circuits)
            } label: {
                Label(
                    String(localized: "quiz.mode.circuits", defaultValue: "Guess the circuit"),
                    systemImage: "point.topleft.down.to.point.bottomright.curvepath")
            }
            NavigationLink {
                QuizScreen(snapshot: snapshot, mode: .teams)
            } label: {
                Label(
                    String(localized: "quiz.mode.teams", defaultValue: "Team time machine"),
                    systemImage: "flag.checkered")
            }
            NavigationLink {
                QuizScreen(snapshot: snapshot, mode: .trivia)
            } label: {
                Label(String(localized: "quiz.mode.trivia", defaultValue: "The lighter side"), systemImage: "sparkles")
            }
        }.navigationTitle(String(localized: "quiz.title", defaultValue: "Quick quiz"))
    }
}
