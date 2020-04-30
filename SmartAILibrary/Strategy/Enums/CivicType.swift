//
//  CivicType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct CivicAchievements {

    public let buildingTypes: [BuildingType]
    public let unitTypes: [UnitType]
    public let wonderTypes: [WonderType]
    public let buildTypes: [BuildType]
    public let policyCards: [PolicyCardType]
}

public enum CivicType: String, Codable {

    case none

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
            // ancient
            .stateWorkforce, .craftsmanship, .codeOfLaws, .earlyEmpire, .foreignTrade, .mysticism, .militaryTradition,

            // classical
            .defensiveTactics, .gamesAndRecreation, .politicalPhilosophy, .recordedHistory, .dramaAndPoetry, .theology, .militaryTraining,

            // medieval
            .navalTradition, .feudalism, .medievalFaires, .civilService, .guilds, .mercenaries, .divineRight,

            // renaissance
            .enlightenment, .humanism, .mercantilism, .diplomaticService, .exploration, .reformedChurch,

            // industrial
            .civilEngineering, .colonialism, .nationalism, .operaAndBallet, .naturalHistory, .urbanization, .scorchedEarth,

            // modern
            .conservation, .massMedia, .mobilization, .capitalism, .ideology, .nuclearProgram, .suffrage, .totalitarianism, .classStruggle,

            // atomic
            .culturalHeritage, .coldWar, .professionalSports, .rapidDeployment, .spaceRace
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func eurekaSummary() -> String {

        return self.data().eurekaSummary
    }

    public func era() -> EraType {

        return self.data().era
    }

    public func cost() -> Int {

        return self.data().cost
    }

    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Civics.xml
    func required() -> [CivicType] {

        return self.data().required
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

        return self.data().flavors
    }

    public func achievements() -> CivicAchievements {

        let buildings = BuildingType.all.filter({
            if let civic = $0.requiredCivic() {
                return civic == self
            } else {
                return false
            }
        })

        /*let units = UnitType.all.filter({
            if let civic = $0.required() {
                return civic == self
            } else {
                return false
            }
        })*/

        // districts
        // wonders
        let wonders = WonderType.all.filter({
            if let civic = $0.requiredCivic() {
                return civic == self
            } else {
                return false
            }
        })

        // buildtypes
        /*let builds = BuildType.all.filter({
            if let civic = $0.required() {
                return civic == self
            } else {
                return false
            }
        })*/

        // policyCards
        let policyCards = PolicyCardType.all.filter({
            return self == $0.required()
        })

        return CivicAchievements(buildingTypes: buildings, unitTypes: [], wonderTypes: wonders, buildTypes: [], policyCards: policyCards)
    }

    // MARK private

    private struct CivicTypeData {

        let name: String
        let eurekaSummary: String
        let era: EraType
        let cost: Int
        let required: [CivicType]
        let flavors: [Flavor]
    }

    private func data() -> CivicTypeData {

        switch self {

        case .none: return CivicTypeData(name: "---", eurekaSummary: "---", era: .ancient, cost: -1, required: [], flavors: [])

            // ancient
        case .stateWorkforce:
            return CivicTypeData(name: "State Workforce",
                                 eurekaSummary: "",
                                 era: .ancient,
                                 cost: 70,
                                 required: [.craftsmanship],
                                 flavors: [])
        case .craftsmanship:
            return CivicTypeData(name: "Craftmanship",
                                 eurekaSummary: "",
                                 era: .ancient,
                                 cost: 40,
                                 required: [.codeOfLaws],
                                 flavors: [])
        case .codeOfLaws:
            return CivicTypeData(name: "Code of Laws",
                                 eurekaSummary: "",
                                 era: .ancient,
                                 cost: 20,
                                 required: [],
                                 flavors: [])
        case .earlyEmpire:
            return CivicTypeData(name: "Early Empire",
                                 eurekaSummary: "",
                                 era: .ancient,
                                 cost: 70,
                                 required: [.foreignTrade],
                                 flavors: [])
        case .foreignTrade:
            return CivicTypeData(name: "Foreign Trade",
                                 eurekaSummary: "",
                                 era: .ancient,
                                 cost: 40,
                                 required: [.codeOfLaws],
                                 flavors: [])
        case .mysticism:
            return CivicTypeData(name: "Mysticism",
                                 eurekaSummary: "",
                                 era: .ancient,
                                 cost: 50,
                                 required: [.foreignTrade],
                                 flavors: [])
        case .militaryTradition:
            return CivicTypeData(name: "Military Tradition",
                                 eurekaSummary: "",
                                 era: .ancient,
                                 cost: 50,
                                 required: [.craftsmanship],
                                 flavors: [])

            // classical
        case .defensiveTactics:
            return CivicTypeData(name: "Defensive Tactics",
                                 eurekaSummary: "",
                                 era: .classical,
                                 cost: 175,
                                 required: [.gamesAndRecreation, .politicalPhilosophy],
                                 flavors: [])
        case .gamesAndRecreation:
            return CivicTypeData(name: "Games and Recreation",
                                 eurekaSummary: "",
                                 era: .classical,
                                 cost: 110,
                                 required: [.stateWorkforce],
                                 flavors: [])
        case .politicalPhilosophy:
            return CivicTypeData(name: "Political Philosophy",
                                 eurekaSummary: "",
                                 era: .classical,
                                 cost: 110,
                                 required: [.stateWorkforce, .earlyEmpire],
                                 flavors: [])
        case .recordedHistory:
            return CivicTypeData(name: "Recorded History",
                                 eurekaSummary: "",
                                 era: .classical,
                                 cost: 175,
                                 required: [.politicalPhilosophy, .dramaAndPoetry],
                                 flavors: [])
        case .dramaAndPoetry:
            return CivicTypeData(name: "Dramaa nd Poetry",
                                 eurekaSummary: "",
                                 era: .classical,
                                 cost: 110,
                                 required: [.earlyEmpire],
                                 flavors: [])
        case .theology:
            return CivicTypeData(name: "Theology",
                                 eurekaSummary: "",
                                 era: .classical,
                                 cost: 120,
                                 required: [.dramaAndPoetry, .mysticism],
                                 flavors: [])
        case .militaryTraining:
            return CivicTypeData(name: "Military Training",
                                 eurekaSummary: "",
                                 era: .classical,
                                 cost: 120,
                                 required: [.militaryTradition, .gamesAndRecreation],
                                 flavors: [])

            // medieval
        case .navalTradition:
            return CivicTypeData(name: "Naval Tradition",
                                 eurekaSummary: "",
                                 era: .medieval,
                                 cost: 200,
                                 required: [.defensiveTactics],
                                 flavors: [])
        case .medievalFaires:
            return CivicTypeData(name: "Medieval Faires",
                                 eurekaSummary: "",
                                 era: .medieval,
                                 cost: 385,
                                 required: [.feudalism],
                                 flavors: [])
        case .guilds:
            return CivicTypeData(name: "Guilds",
                                 eurekaSummary: "",
                                 era: .medieval,
                                 cost: 385,
                                 required: [.feudalism, .civilService],
                                 flavors: [])
        case .feudalism:
            return CivicTypeData(name: "Feudalism",
                                 eurekaSummary: "",
                                 era: .medieval,
                                 cost: 275,
                                 required: [.defensiveTactics],
                                 flavors: [])
        case .civilService:
            return CivicTypeData(name: "Civil Service",
                                 eurekaSummary: "",
                                 era: .medieval,
                                 cost: 275,
                                 required: [.defensiveTactics, .recordedHistory],
                                 flavors: [])
        case .mercenaries:
            return CivicTypeData(name: "Mercenaries",
                                 eurekaSummary: "",
                                 era: .medieval,
                                 cost: 290,
                                 required: [.feudalism, .militaryTraining],
                                 flavors: [])
        case .divineRight:
            return CivicTypeData(name: "Divine Right",
                                 eurekaSummary: "",
                                 era: .medieval,
                                 cost: 290,
                                 required: [.civilService, .theology],
                                 flavors: [])

            // renaissance
        case .humanism:
            return CivicTypeData(name: "Humanism",
                                 eurekaSummary: "",
                                 era: .renaissance,
                                 cost: 540,
                                 required: [.guilds, .medievalFaires],
                                 flavors: [])
        case .mercantilism:
            return CivicTypeData(name: "Mercantilism",
                                 eurekaSummary: "",
                                 era: .renaissance,
                                 cost: 655,
                                 required: [.humanism],
                                 flavors: [])
        case .enlightenment:
            return CivicTypeData(name: "Enlightenment",
                                 eurekaSummary: "",
                                 era: .renaissance,
                                 cost: 655,
                                 required: [.diplomaticService],
                                 flavors: [])
        case .diplomaticService:
            return CivicTypeData(name: "Diplomatic Service",
                                 eurekaSummary: "",
                                 era: .renaissance,
                                 cost: 540,
                                 required: [.guilds],
                                 flavors: [])
        case .reformedChurch:
            return CivicTypeData(name: "Reformed Church",
                                 eurekaSummary: "",
                                 era: .renaissance,
                                 cost: 400,
                                 required: [.divineRight],
                                 flavors: [])
        case .exploration:
            return CivicTypeData(name: "Exploration",
                                 eurekaSummary: "",
                                 era: .renaissance,
                                 cost: 400,
                                 required: [.mercenaries, .medievalFaires],
                                 flavors: [])

            // industrial
        case .civilEngineering:
            return CivicTypeData(name: "Civil Engineering",
                                 eurekaSummary: "",
                                 era: .industrial,
                                 cost: 920,
                                 required: [.mercantilism],
                                 flavors: [])
        case .colonialism:
            return CivicTypeData(name: "Colonialism",
                                 eurekaSummary: "",
                                 era: .industrial,
                                 cost: 725,
                                 required: [.mercantilism],
                                 flavors: [])
        case .nationalism:
            return CivicTypeData(name: "Nationalism",
                                 eurekaSummary: "",
                                 era: .industrial,
                                 cost: 920,
                                 required: [.enlightenment],
                                 flavors: [])
        case .operaAndBallet:
            return CivicTypeData(name: "Opera and Ballet",
                                 eurekaSummary: "",
                                 era: .industrial,
                                 cost: 725,
                                 required: [.enlightenment],
                                 flavors: [])
        case .naturalHistory:
            return CivicTypeData(name: "Natural History",
                                 eurekaSummary: "",
                                 era: .industrial,
                                 cost: 870,
                                 required: [.colonialism],
                                 flavors: [])
        case .urbanization:
            return CivicTypeData(name: "Urbanization",
                                 eurekaSummary: "",
                                 era: .industrial,
                                 cost: 1060,
                                 required: [.civilEngineering, .nationalism],
                                 flavors: [])
        case .scorchedEarth:
            return CivicTypeData(name: "Scorched Earth",
                                 eurekaSummary: "",
                                 era: .industrial,
                                 cost: 1060,
                                 required: [.nationalism],
                                 flavors: [])

            // modern
        case .conservation:
            return CivicTypeData(name: "Conservation",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1255,
                                 required: [.naturalHistory, .urbanization],
                                 flavors: [])
        case .massMedia:
            return CivicTypeData(name: "MassMedia",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1410,
                                 required: [.urbanization],
                                 flavors: [])
        case .mobilization:
            return CivicTypeData(name: "Mobilization",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1410,
                                 required: [.urbanization],
                                 flavors: [])
        case .capitalism:
            return CivicTypeData(name: "Capitalism",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1560,
                                 required: [.massMedia],
                                 flavors: [])
        case .ideology:
            return CivicTypeData(name: "Ideology",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 660,
                                 required: [.massMedia, .mobilization],
                                 flavors: [])
        case .nuclearProgram:
            return CivicTypeData(name: "Nuclear Program",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])
        case .suffrage:
            return CivicTypeData(name: "Suffrage",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])
        case .totalitarianism:
            return CivicTypeData(name: "Totalitarianism",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])
        case .classStruggle:
            return CivicTypeData(name: "Class Struggle",
                                 eurekaSummary: "",
                                 era: .modern,
                                 cost: 1715,
                                 required: [.ideology],
                                 flavors: [])

            // atomic
        case .culturalHeritage:
            return CivicTypeData(name: "Cultural Heritage",
                                 eurekaSummary: "",
                                 era: .atomic,
                                 cost: 1955,
                                 required: [.conservation],
                                 flavors: [])
        case .coldWar:
            return CivicTypeData(name: "Cold War",
                                 eurekaSummary: "",
                                 era: .atomic,
                                 cost: 2185,
                                 required: [.ideology],
                                 flavors: [])
        case .professionalSports:
            return CivicTypeData(name: "Professional Sports",
                                 eurekaSummary: "",
                                 era: .atomic,
                                 cost: 2185,
                                 required: [.ideology],
                                 flavors: [])
        case .rapidDeployment:
            return CivicTypeData(name: "Rapid Deployment",
                                 eurekaSummary: "",
                                 era: .atomic,
                                 cost: 2415,
                                 required: [.coldWar],
                                 flavors: [])
        case .spaceRace:
            return CivicTypeData(name: "Space Race",
                                 eurekaSummary: "",
                                 era: .atomic,
                                 cost: 2415,
                                 required: [.coldWar],
                                 flavors: [])
        }
    }
}
