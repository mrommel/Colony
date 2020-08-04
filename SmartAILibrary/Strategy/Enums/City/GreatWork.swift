//
//  GreatWork.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum GreatWork {

    // writings
    case odyssey
    case iliad
    case artOfWar
    case theMadhyamaVyayoga
    case pratimaNataka
    case chuCi
    case lamentForYing
    case metamorphoses
    case heroides
    case theCanterburyTales
    case troilusAndCriseyde
    case drinkingAloneByMoonlight
    case inTheMountainsOnASummerDay
    case theDiaryOfLadyMurasaki
    case theTaleOfGenji

    // artworks (paitings)
    case annunciation
    case saviourInGlory
    case ascension
    case sistineChapelCeiling
    case pieta
    case david
    case saintMark
    case gattamelata
    case judithSlayingHolofernes
    case theGardenOfEarthlyDelights
    case theLastJudgement
    case theHaywainTriptych

    // musics
    case odeToJoySymphony9
    case symphony3EroicaSymphonyMvt1
    case littleFugueInGMinor
    case celloSuiteNo1
    case rokudanNoShirabe
    case hachidanNoShirabe
    case fourSeasonsWinter
    case laNotteConcerto
    case eineKleineNachtmusik
    case symphony40Mvt1

    private struct GreatWorkData {

        let name: String
        let type: GreatWorkType
    }

    private func data() -> GreatWorkData {

        switch self {

            // writings
        case .odyssey:
            return GreatWorkData(name: "Odyssey", type: .writing)
        case .iliad:
            return GreatWorkData(name: "Iliad", type: .writing)
        case .artOfWar:
            return GreatWorkData(name: "Art of War", type: .writing)
        case .theMadhyamaVyayoga:
            return GreatWorkData(name: "The Madhyama Vyayoga", type: .writing)
        case .pratimaNataka:
            return GreatWorkData(name: "Pratima-nataka", type: .writing)
        case .chuCi:
            return GreatWorkData(name: "Chu Ci", type: .writing)
        case .lamentForYing:
            return GreatWorkData(name: "Lament for Ying", type: .writing)
        case .metamorphoses:
            return GreatWorkData(name: "Metamorphoses", type: .writing)
        case .heroides:
            return GreatWorkData(name: "Heroides", type: .writing)
        case .theCanterburyTales:
            return GreatWorkData(name: "The Canterbury Tales", type: .writing)
        case .troilusAndCriseyde:
            return GreatWorkData(name: "Troilus and Criseyde", type: .writing)
        case .drinkingAloneByMoonlight:
            return GreatWorkData(name: "Drinking Alone by Moonlight", type: .writing)
        case .inTheMountainsOnASummerDay:
            return GreatWorkData(name: "In the Mountains on a Summer Day", type: .writing)
        case .theDiaryOfLadyMurasaki:
            return GreatWorkData(name: "The Diary of Lady Murasaki", type: .writing)
        case .theTaleOfGenji:
            return GreatWorkData(name: "The Tale of Genji", type: .writing)

            // artworks / paintings
        case .annunciation:
            return GreatWorkData(name: "Annunciation", type: .artwork)
        case .saviourInGlory:
            return GreatWorkData(name: "Saviour in Glory", type: .artwork)
        case .ascension:
            return GreatWorkData(name: "Ascension", type: .artwork)
        case .sistineChapelCeiling:
            return GreatWorkData(name: "Sistine Chapel Ceiling", type: .artwork)
        case .pieta:
            return GreatWorkData(name: "Pieta", type: .artwork)
        case .david:
            return GreatWorkData(name: "David", type: .artwork)
        case .saintMark:
            return GreatWorkData(name: "Saint Mark", type: .artwork)
        case .gattamelata:
            return GreatWorkData(name: "Gattamelata", type: .artwork)
        case .judithSlayingHolofernes:
            return GreatWorkData(name: "Judith Slaying Holofernes", type: .artwork)
        case .theGardenOfEarthlyDelights:
            return GreatWorkData(name: "The Garden of Earthly Delights", type: .artwork)
        case .theLastJudgement:
            return GreatWorkData(name: "The Last Judgement", type: .artwork)
        case .theHaywainTriptych:
            return GreatWorkData(name: "The Haywain Triptych", type: .artwork)

            // musics
        case .odeToJoySymphony9:
            return GreatWorkData(name: "Ode to Joy (Symphony #9)", type: .music)
        case .symphony3EroicaSymphonyMvt1:
            return GreatWorkData(name: "Symphony #3 (Eroica Symphony) Mvt. 1", type: .music)
        case .littleFugueInGMinor:
            return GreatWorkData(name: "'Little' Fugue in G minor", type: .music)
        case .celloSuiteNo1:
            return GreatWorkData(name: "Cello Suite No. 1", type: .music)
        case .rokudanNoShirabe:
            return GreatWorkData(name: "Rokudan no Shirabe", type: .music)
        case .hachidanNoShirabe:
            return GreatWorkData(name: "Hachidan no Shirabe", type: .music)
        case .fourSeasonsWinter:
            return GreatWorkData(name: "Four Seasons: Winter", type: .music)
        case .laNotteConcerto:
            return GreatWorkData(name: "La Notte Concerto", type: .music)
        case .eineKleineNachtmusik:
            return GreatWorkData(name: "Eine kleine Nachtmusik", type: .music)
        case .symphony40Mvt1:
            return GreatWorkData(name: "Symphony 40 Mvt. 1", type: .music)
        }
    }
}
