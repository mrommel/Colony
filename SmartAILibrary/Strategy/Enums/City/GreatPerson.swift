//
//  GreatPerson.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum GreatPerson {

    // generals
    // https://civilization.fandom.com/wiki/Great_General_(Civ6)
    case boudica
    case hannibalBarca
    case sunTzu

    // writers
    case homer

    static var all: [GreatPerson] {
        return [
            // general
            .boudica, .hannibalBarca, .sunTzu,

            // writer
            .homer
        ]
    }

    func name() -> String {

        return self.data().name
    }

    func type() -> GreatPersonType {

        return self.data().type
    }

    func era() -> EraType {

        return self.data().era
    }

    struct GreatPersonData {

        let name: String
        let type: GreatPersonType
        let era: EraType
        let bonus: String
        let works: [GreatWork]
    }

    private func data() -> GreatPersonData {

        switch self {

            // generals
        case .boudica:
            return GreatPersonData(name: "Boudica",
                                   type: .greatGeneral,
                                   era: .classical,
                                   bonus: "Convert adjacent barbarian units.",
                                   works: [])
        case .hannibalBarca:
            return GreatPersonData(name: "Hannibal Barca",
                                   type: .greatGeneral,
                                   era: .classical,
                                   bonus: "Grants 1 promotion level to a military land unit.",
                                   works: [])
        case .sunTzu:
            return GreatPersonData(name: "Sun Tzu",
                                   type: .greatGeneral,
                                   era: .classical,
                                   bonus: "Creates the Art of War Great Work of Writing (+2 Civ6Culture Culture, +2 Tourism6 Tourism).",
                                   works: [])

            // writers
        case .homer:
            return GreatPersonData(name: "Homer",
                                   type: .greatWriter,
                                   era: .classical,
                                   bonus: "Activate on an appropriate tile to create a Great Work",
                                   works: [.iliad, .odyssey])

        }
    }
}
