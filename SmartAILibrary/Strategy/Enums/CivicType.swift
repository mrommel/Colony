//
//  CivicType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CivicType: String, Codable {

    // ancient
    case stateWorkforce
    case craftsmanship
    case codeOfLaws
    case earlyEmpire
    case foreignTrade
    case mysticism
    case militaryTradition

    // classical
    case defensiveTactics
    case gamesAndRecreation
    case politicalPhilosophy
    case recordedHistory
    case dramaAndPoetry
    case theology
    case militaryTraining

    // medieval
    case navalTradition
    case feudalism
    case medievalFaires
    case civilService
    case guilds
    case mercenaries
    case divineRight

    // renaissance
    case enlightenment
    case humanism
    case mercantilism
    case diplomaticService
    case exploration
    case reformedChurch

    // industrial
    case civilEngineering
    case colonialism
    case nationalism
    case operaAndBallet
    case naturalHistory
    case urbanization
    case scorchedEarth

    // modern
    case conservation
    case massMedia
    case mobilization
    case capitalism
    case ideology
    case nuclearProgram
    case suffrage
    case totalitarianism
    case classStruggle

    // atomic
    case culturalHeritage
    case coldWar
    case professionalSports
    case rapidDeployment
    case spaceRace


    static var all: [CivicType] {
        return [
                .stateWorkforce, .craftsmanship, .codeOfLaws, .earlyEmpire, .foreignTrade, .mysticism, .militaryTradition,
                .defensiveTactics, .gamesAndRecreation, .politicalPhilosophy, .recordedHistory, .dramaAndPoetry, .theology, .militaryTraining,
                .navalTradition, .feudalism, .medievalFaires, .civilService, .guilds, .mercenaries, .divineRight,
                .enlightenment, .humanism, .mercantilism, .diplomaticService, .exploration, .reformedChurch,
                .civilEngineering, .colonialism, .nationalism, .operaAndBallet, .naturalHistory, .urbanization, .scorchedEarth,
                .conservation, .massMedia, .mobilization, .capitalism, .ideology, .nuclearProgram, .suffrage, .totalitarianism, .classStruggle,
                .culturalHeritage, .coldWar, .professionalSports, .rapidDeployment, .spaceRace
        ]
    }
    
    public func name() -> String {
        
        switch self {

                // ancient
            case .stateWorkforce: return "State Workforce"
            case .craftsmanship: return "Craftmanship"
            case .codeOfLaws: return "Code of Laws"
            case .earlyEmpire: return "Early Empire"
            case .foreignTrade: return "Foreign Trade"
            case .mysticism: return "Mysticism"
            case .militaryTradition: return "Military Tradition"

                // classical
            case .defensiveTactics: return "Civic Default"
            case .gamesAndRecreation: return "Civic Default"
            case .politicalPhilosophy: return "Civic Default"
            case .recordedHistory: return "Civic Default"
            case .dramaAndPoetry: return "Civic Default"
            case .theology: return "Civic Default"
            case .militaryTraining: return "Civic Default"

                // medieval
            case .navalTradition: return "Civic Default"
            case .medievalFaires: return "Civic Default"
            case .guilds: return "Civic Default"
            case .feudalism: return "Civic Default"
            case .civilService: return "Civic Default"
            case .mercenaries: return "Civic Default"
            case .divineRight: return "Civic Default"

                // renaissance
            case .humanism: return "Civic Default"
            case .mercantilism: return "Civic Default"
            case .enlightenment: return "Civic Default"
            case .diplomaticService: return "Civic Default"
            case .reformedChurch: return "Civic Default"
            case .exploration: return "Civic Default"

                // industrial
            case .civilEngineering: return "Civic Default"
            case .colonialism: return "Civic Default"
            case .nationalism: return "Civic Default"
            case .operaAndBallet: return "Civic Default"
            case .naturalHistory: return "Civic Default"
            case .urbanization: return "Civic Default"
            case .scorchedEarth: return "Civic Default"

                // modern
            case .conservation: return "Civic Default"
            case .massMedia: return "Civic Default"
            case .mobilization: return "Civic Default"
            case .capitalism: return "Civic Default"
            case .ideology: return "Civic Default"
            case .nuclearProgram: return "Civic Default"
            case .suffrage: return "Civic Default"
            case .totalitarianism: return "Civic Default"
            case .classStruggle: return "Civic Default"

                // atomic
            case .culturalHeritage: return "Civic Default"
            case .coldWar: return "Civic Default"
            case .professionalSports: return "Civic Default"
            case .rapidDeployment: return "Civic Default"
            case .spaceRace: return "Civic Default"
            }
        }

    func era() -> EraType {

        switch self {

            // ancient
        case .stateWorkforce:
            return .ancient
        case .craftsmanship:
            return .ancient
        case .codeOfLaws:
            return .ancient
        case .earlyEmpire:
            return .ancient
        case .foreignTrade:
            return .ancient
        case .mysticism:
            return .ancient
        case .militaryTradition:
            return .ancient

            // classical
        case .defensiveTactics:
            return .classical
        case .gamesAndRecreation:
            return .classical
        case .politicalPhilosophy:
            return .classical
        case .recordedHistory:
            return .classical
        case .dramaAndPoetry:
            return .classical
        case .theology:
            return .classical
        case .militaryTraining:
            return .classical

            // medieval
        case .navalTradition:
            return .medieval
        case .medievalFaires:
            return .medieval
        case .guilds:
            return .medieval
        case .feudalism:
            return .medieval
        case .civilService:
            return .medieval
        case .mercenaries:
            return .medieval
        case .divineRight:
            return .medieval

            // renaissance
        case .humanism:
            return .renaissance
        case .mercantilism:
            return .renaissance
        case .enlightenment:
            return .renaissance
        case .diplomaticService:
            return .renaissance
        case .reformedChurch:
            return .renaissance
        case .exploration:
            return .renaissance

            // industrial
        case .civilEngineering:
            return .industrial
        case .colonialism:
            return .industrial
        case .nationalism:
            return .industrial
        case .operaAndBallet:
            return .industrial
        case .naturalHistory:
            return .industrial
        case .urbanization:
            return .industrial
        case .scorchedEarth:
            return .industrial

            // modern
        case .conservation:
            return .modern
        case .massMedia:
            return .modern
        case .mobilization:
            return .modern
        case .capitalism:
            return .modern
        case .ideology:
            return .modern
        case .nuclearProgram:
            return .modern
        case .suffrage:
            return .modern
        case .totalitarianism:
            return .modern
        case .classStruggle:
            return .modern

            // atomic
        case .culturalHeritage:
            return .atomic
        case .coldWar:
            return .atomic
        case .professionalSports:
            return .atomic
        case .rapidDeployment:
            return .atomic
        case .spaceRace:
            return .atomic
        }
    }

    func cost() -> Int {

        switch self {

            // ancient
        case .stateWorkforce:
            return 70
        case .craftsmanship:
            return 40
        case .codeOfLaws:
            return 20
        case .earlyEmpire:
            return 70
        case .foreignTrade:
            return 40
        case .mysticism:
            return 50
        case .militaryTradition:
            return 50

            // classical
        case .defensiveTactics:
            return 175
        case .gamesAndRecreation:
            return 110
        case .politicalPhilosophy:
            return 110
        case .recordedHistory:
            return 175
        case .dramaAndPoetry:
            return 110
        case .theology:
            return 120
        case .militaryTraining:
            return 120

            // medieval
        case .navalTradition:
            return 200
        case .feudalism:
            return 275
        case .guilds:
            return 385
        case .medievalFaires:
            return 385
        case .civilService:
            return 275
        case .divineRight:
            return 290
        case .mercenaries:
            return 290

            // renaissance
        case .humanism:
            return 540
        case .mercantilism:
            return 655
        case .enlightenment:
            return 655
        case .diplomaticService:
            return 540
        case .exploration:
            return 400
        case .reformedChurch:
            return 400

            // industrial
        case .civilEngineering:
            return 920
        case .colonialism:
            return 725
        case .nationalism:
            return 920
        case .operaAndBallet:
            return 725
        case .naturalHistory:
            return 870
        case .urbanization:
            return 1060
        case .scorchedEarth:
            return 1060

            // modern
        case .conservation:
            return 1255
        case .massMedia:
            return 1410
        case .mobilization:
            return 1410
        case .capitalism:
            return 1560
        case .ideology:
            return 660
        case .nuclearProgram:
            return 1715
        case .suffrage:
            return 1715
        case .totalitarianism:
            return 1715
        case .classStruggle:
            return 1715

            // atomic
        case .culturalHeritage:
            return 1955
        case .coldWar:
            return 2185
        case .professionalSports:
            return 2185
        case .rapidDeployment:
            return 2415
        case .spaceRace:
            return 2415
        }
    }

    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Civics.xml
    func required() -> [CivicType] {

        switch self {

            // ancient
        case .stateWorkforce:
            return [.craftsmanship]
        case .craftsmanship:
            return [.codeOfLaws]
        case .codeOfLaws:
            return []
        case .earlyEmpire:
            return [.foreignTrade]
        case .foreignTrade:
            return [.codeOfLaws]
        case .mysticism:
            return [.foreignTrade]
        case .militaryTradition:
            return [.craftsmanship]

            // classical
        case .defensiveTactics:
            return [.gamesAndRecreation, .politicalPhilosophy]
        case .gamesAndRecreation:
            return [.stateWorkforce]
        case .politicalPhilosophy:
            return [.stateWorkforce, .earlyEmpire]
        case .recordedHistory:
            return [.politicalPhilosophy, .dramaAndPoetry]
        case .dramaAndPoetry:
            return [.earlyEmpire]
        case .theology:
            return [.dramaAndPoetry, .mysticism]
        case .militaryTraining:
            return [.militaryTradition, .gamesAndRecreation]

            // medieval
        case .navalTradition:
            return [.defensiveTactics]
        case .feudalism:
            return [.defensiveTactics]
        case .medievalFaires:
            return [.feudalism]
        case .guilds:
            return [.feudalism, .civilService]
        case .civilService:
            return [.defensiveTactics, .recordedHistory]
        case .divineRight:
            return []
        case .mercenaries:
            return [.feudalism, .militaryTraining]

            // renaissance
        case .humanism:
            return [.guilds, .medievalFaires]
        case .mercantilism:
            return [.humanism]
        case .enlightenment:
            return [.diplomaticService]
        case .diplomaticService:
            return [.guilds]
        case .exploration:
            return [.mercenaries, .medievalFaires]
        case .reformedChurch:
            return [.divineRight]

            // industrial
        case .civilEngineering:
            return [.mercantilism]
        case .colonialism:
            return [.mercantilism]
        case .nationalism:
            return [.enlightenment]
        case .operaAndBallet:
            return [.enlightenment]
        case .naturalHistory:
            return [.colonialism]
        case .urbanization:
            return [.civilEngineering, .nationalism]
        case .scorchedEarth:
            return [.nationalism]

            // modern
        case .conservation:
            return [.naturalHistory, .urbanization]
        case .massMedia:
            return [.urbanization]
        case .mobilization:
            return [.urbanization]
        case .capitalism:
            return [.massMedia]
        case .ideology:
            return [.massMedia, .mobilization]
        case .nuclearProgram:
            return [.ideology]
        case .suffrage:
            return [.ideology]
        case .totalitarianism:
            return [.ideology]
        case .classStruggle:
            return [.ideology]

            // atomic
        case .culturalHeritage:
            return [.conservation]
        case .coldWar:
            return [.ideology]
        case .professionalSports:
            return [.ideology]
        case .rapidDeployment:
            return [.coldWar]
        case .spaceRace:
            return [.coldWar]
        }
    }

    func leadsTo() -> [CivicType] {

        var leadingTo: [CivicType] = []

        for tech in CivicType.all {
            if tech.required().contains(self) {
                leadingTo.append(tech)
            }
        }

        return leadingTo
    }

    func flavorValue(for flavor: FlavorType) -> Int {

        if let flavorOfTech = self.flavours().first(where: { $0.type == flavor }) {
            return flavorOfTech.value
        }

        return 0
    }

    func flavours() -> [Flavor] {

        switch self {
            // ancient
        case .stateWorkforce: return [
            ]
        case .craftsmanship: return [
            ]
        case .codeOfLaws: return [
            ]
        case .earlyEmpire: return [
            ]
        case .foreignTrade: return [
            ]
        case .mysticism: return [
            ]
        case .militaryTradition: return [
            ]
            
            // classical
        case .defensiveTactics: return [
            ]
        case .gamesAndRecreation: return [
            ]
        case .politicalPhilosophy: return [
            ]
        case .recordedHistory: return [
            ]
        case .dramaAndPoetry: return [
            ]
        case .theology: return [
            ]
        case .militaryTraining: return [
            ]
        case .navalTradition: return [
            ]
        case .feudalism: return [
            ]
        case .medievalFaires: return [
            ]
        case .civilService: return [
            ]
        case .guilds: return [
            ]
        case .mercenaries: return [
            ]
        case .divineRight: return [
            ]
        case .enlightenment: return [
            ]
        case .humanism: return [
            ]
        case .mercantilism: return [
            ]
        case .diplomaticService: return [
            ]
        case .exploration: return [
            ]
        case .reformedChurch: return [
            ]
        case .civilEngineering: return [
            ]
        case .colonialism: return [
            ]
        case .nationalism: return [
            ]
        case .operaAndBallet: return [
            ]
        case .naturalHistory: return [
            ]
        case .urbanization: return [
            ]
        case .scorchedEarth: return [
            ]
        case .conservation: return [
            ]
        case .massMedia: return [
            ]
        case .mobilization: return [
            ]
        case .capitalism: return [
            ]
        case .ideology: return [
            ]
        case .nuclearProgram: return [
            ]
        case .suffrage: return [
            ]
        case .totalitarianism: return [
            ]
        case .classStruggle: return [
            ]
        case .culturalHeritage: return [
            ]
        case .coldWar: return [
            ]
        case .professionalSports: return [
            ]
        case .rapidDeployment: return [
            ]
        case .spaceRace: return [
            ]
        }
    }
}
