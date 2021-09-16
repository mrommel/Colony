//
//  PolicyCardType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum PolicyCardSlotType {

    case military
    case economic
    case diplomatic
    case wildcard

    public static var all: [PolicyCardSlotType] = [
        .military, .economic, .diplomatic, .wildcard
    ]

    func name() -> String {

        switch self {

        case .military:
            return "Military"
        case .economic:
            return "Economic"
        case .diplomatic:
            return "Diplomatic"
        case .wildcard:
            return "Wildcard"
        }
    }
}

// https://civilization.fandom.com/wiki/Policy_Cards_(Civ6)
public enum PolicyCardType: Int, Codable {

    case slot // empty

    // ancient
    case survey // FIXME Doubles experience for recon units.
    case godKing // +1 Faith and +1 Gold in the Capital.
    case discipline // +5 Combat Strength when fighting Barbarians.
    case urbanPlanning // +1 Production in all cities.
    case ilkum // FIXME +30% Production toward Builders.
    case agoge // FIXME +50% Production towards Ancient and Classical era melee and ranged units.
    case caravansaries // +2 additional Gold from all Trade Routes.
    case maritimeIndustries // FIXME +100% Production towards all Ancient and Classical era naval units.
    case maneuver // FIXME +50% Production towards all Ancient and Classical era light and heavy cavalry units.
    case strategos // FIXME +2 Great General points per turn.
    case conscription // FIXME Unit maintenance reduced by 1 Gold per turn per unit.
    case corvee // FIXME +15% Production towards Ancient and Classical era wonders.
    case landSurveyors // FIXME Reduces the cost to purchase a tile by 20%.
    case colonization // FIXME +50% Production towards Settlers.
    case inspiration // FIXME +2 Great Scientist points per turn.
    case revelation // FIXME +2 Great Prophet points per turn.
    case limitanei // +2 Loyalty per turn for cities with a garrisoned unit.

    // classical
    case insulae // FIXME +1 Housing in all cities with at least 2 specialty districts.
    case praetorium // Governors provide +2 Loyalty per turn to their city.
    // ...
    case bastions

    // mediaval

    // information

    public static var all: [PolicyCardType] {
        return [
            // ancient
            .survey, .godKing, .discipline, .urbanPlanning, .ilkum, .agoge, .caravansaries, .maritimeIndustries, .maneuver,
            .strategos, .conscription, .corvee, .landSurveyors, .colonization, .inspiration, .revelation, .limitanei,

            // classical
            .insulae, .praetorium, /* ... */ .bastions,

            // information
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func bonus() -> String {

        return self.data().bonus
    }

    public func slot() -> PolicyCardSlotType {

        return self.data().slot
    }

    public func required() -> CivicType {

        return self.data().required
    }

    private func data() -> PolicyCardTypeData {

        switch self {

        case .slot:
            return PolicyCardTypeData(name: "-", bonus: "-", slot: .wildcard, required: .none, obsolete: nil, flavours: [])

        case .survey:
            // https://civilization.fandom.com/wiki/Survey_(Civ6)
            return PolicyCardTypeData(name: "Survey",
                                      bonus: "Doubles experience for recon units.",
                                      slot: .military,
                                      required: .codeOfLaws,
                                      obsolete: .exploration,
                                      flavours: [Flavor(type: .recon, value: 5)])
        case .godKing:
            // https://civilization.fandom.com/wiki/God_King_(Civ6)
            return PolicyCardTypeData(name: "God King",
                                      bonus: "+1 Civ6Faith Faith and +1 Civ6Gold Gold in the Capital6 Capital.",
                                      slot: .economic,
                                      required: .codeOfLaws,
                                      obsolete: .theology,
                                      flavours: [Flavor(type: .religion, value: 3), Flavor(type: .gold, value: 2)])
        case .discipline:
            // https://civilization.fandom.com/wiki/Discipline_(Civ6)
            return PolicyCardTypeData(name: "Discipline",
                                      bonus: "+5 Civ6StrengthIcon Combat Strength when fighting Barbarians.",
                                      slot: .military,
                                      required: .codeOfLaws,
                                      obsolete: .colonialism,
                                      flavours: [Flavor(type: .defense, value: 4), Flavor(type: .growth, value: 1)])
        case .urbanPlanning:
            return PolicyCardTypeData(name: "Urban Planning",
                                      bonus: "+1 Civ6Production Production in all cities.",
                                      slot: .economic,
                                      required: .codeOfLaws,
                                      obsolete: .gamesAndRecreation,
                                      flavours: [Flavor(type: .growth, value: 2), Flavor(type: .production, value: 3)])
        case .ilkum:
            // https://civilization.fandom.com/wiki/Ilkum_(Civ6)
            return PolicyCardTypeData(name: "Ilkum",
                                      bonus: "+30% Civ6Production Production toward Builders.",
                                      slot: .economic,
                                      required: .craftsmanship,
                                      obsolete: .gamesAndRecreation,
                                      flavours: [Flavor(type: .growth, value: 2), Flavor(type: .tileImprovement, value: 3)])
        case .agoge:
            // https://civilization.fandom.com/wiki/Agoge_(Civ6)
            return PolicyCardTypeData(name: "Agoge",
                                      bonus: "+50% Civ6Production Production toward Ancient and Classical era melee, ranged units and anti-cavalry units.",
                                      slot: .military,
                                      required: .craftsmanship,
                                      obsolete: .feudalism,
                                      flavours: [Flavor(type: .offense, value: 3), Flavor(type: .defense, value: 2)])
        case .caravansaries:
            // https://civilization.fandom.com/wiki/Caravansaries_(Civ6)
            return PolicyCardTypeData(name: "Caravansaries",
                                      bonus: "+2 Civ6Gold Gold from all TradeRoute6 Trade Routes.", // FIXME niy
                                      slot: .economic,
                                      required: .foreignTrade,
                                      obsolete: .mercantilism,
                                      flavours: [Flavor(type: .gold, value: 5)])
        case .maritimeIndustries:
            // https://civilization.fandom.com/wiki/Maritime_Industries_(Civ6)
            return PolicyCardTypeData(name: "Maritime Industries",
                                      bonus: "+100% Civ6Production Production toward Ancient and Classical era naval units.",
                                      slot: .military,
                                      required: .foreignTrade,
                                      obsolete: .colonialism,
                                      flavours: [Flavor(type: .navalGrowth, value: 3), Flavor(type: .naval, value: 2)])
        case .maneuver:
            // https://civilization.fandom.com/wiki/Maneuver_(Civ6)
            return PolicyCardTypeData(name: "Maneuver",
                                      bonus: "+50% Civ6Production Production toward Ancient and Classical era heavy and light cavalry units.",
                                      slot: .military,
                                      required: .militaryTradition,
                                      obsolete: .divineRight,
                                      flavours: [Flavor(type: .mobile, value: 4), Flavor(type: .offense, value: 1)])
        case .strategos:
            // https://civilization.fandom.com/wiki/Strategos_(Civ6)
            return PolicyCardTypeData(name: "Strategos",
                                      bonus: "+2 General6 Great General points per turn.", // FIXME niy
                                      slot: .wildcard,
                                      required: .militaryTradition,
                                      obsolete: .scorchedEarth,
                                      flavours: [Flavor(type: .greatPeople, value: 5)])
        case .conscription:
            // https://civilization.fandom.com/wiki/Conscription_(Civ6)
            return PolicyCardTypeData(name: "Conscription",
                                      bonus: "Unit maintenance reduced by 1 Civ6Gold Gold per turn, per unit.",
                                      slot: .military,
                                      required: .stateWorkforce,
                                      obsolete: .mobilization,
                                      flavours: [Flavor(type: .offense, value: 4), Flavor(type: .gold, value: 1)])
        case .corvee:
            // https://civilization.fandom.com/wiki/Corv%C3%A9e_(Civ6)
            return PolicyCardTypeData(name: "Corvee",
                                      bonus: "+15% Civ6Production Production toward Ancient and Classical wonders.",
                                      slot: .economic,
                                      required: .stateWorkforce,
                                      obsolete: .divineRight,
                                      flavours: [Flavor(type: .wonder, value: 5)])
        case .landSurveyors:
            // https://civilization.fandom.com/wiki/Land_Surveyors_(Civ6)
            return PolicyCardTypeData(name: "Land Surveyors",
                                      bonus: "Reduces the cost of purchasing a tile by 20%.",
                                      slot: .economic,
                                      required: .earlyEmpire,
                                      obsolete: .scorchedEarth,
                                      flavours: [Flavor(type: .growth, value: 3), Flavor(type: .tileImprovement, value: 2)])
        case .colonization:
            // https://civilization.fandom.com/wiki/Colonization_(Civ6)
            return PolicyCardTypeData(name: "Colonization",
                                      bonus: "+50% Civ6Production Production toward Settlers.",
                                      slot: .economic,
                                      required: .earlyEmpire,
                                      obsolete: .scorchedEarth,
                                      flavours: [Flavor(type: .growth, value: 5)])
        case .inspiration:
            // https://civilization.fandom.com/wiki/Inspiration_(Civ6)
            return PolicyCardTypeData(name: "Inspiration",
                                      bonus: "+2 Scientist6 Great Scientist points per turn.", // FIXME niy
                                      slot: .wildcard,
                                      required: .mysticism,
                                      obsolete: .nuclearProgram,
                                      flavours: [Flavor(type: .science, value: 2), Flavor(type: .greatPeople, value: 3)])
        case .revelation:
            // https://civilization.fandom.com/wiki/Revelation_(Civ6)
            return PolicyCardTypeData(name: "Revelation",
                                      bonus: "+2 Prophet6 Great Prophet points per turn.", // FIXME niy
                                      slot: .wildcard,
                                      required: .mysticism,
                                      obsolete: .humanism,
                                      flavours: [Flavor(type: .religion, value: 2), Flavor(type: .greatPeople, value: 3)])
        case .limitanei:
            // https://civilization.fandom.com/wiki/Limitanei_(Civ6)
            return PolicyCardTypeData(
                name: "Limitanei",
                bonus: "+2 Loyalty per turn for cities with a garrisoned unit.", // FIXME niy
                slot: .military,
                required: .earlyEmpire,
                obsolete: nil,
                flavours: [Flavor(type: .growth, value: 5)]
            )

            // classical
        case .insulae:
            // https://civilization.fandom.com/wiki/Insulae_(Civ6)
            return PolicyCardTypeData(
                name: "Insulae",
                bonus: "+1 Housing in all cities with at least 2 specialty districts.",
                slot: .economic,
                required: .gamesAndRecreation,
                obsolete: .medievalFaires,
                flavours: [Flavor(type: .growth, value: 3), Flavor(type: .tileImprovement, value: 2)]
            )
        case .praetorium:
            // https://civilization.fandom.com/wiki/Praetorium_(Civ6)
            return PolicyCardTypeData(
                name: "Praetorium",
                bonus: "Governors provide +2 Loyalty per turn to their city.",
                slot: .diplomatic,
                required: .recordedHistory,
                obsolete: .socialMedia,
                flavours: [Flavor(type: .growth, value: 4)]
            )
            /* ... */
        case .bastions:
            // https://civilization.fandom.com/wiki/Bastions_(Civ6)
            return PolicyCardTypeData(
                name: "Bastions",
                bonus: "+6 City Civ6StrengthIcon Defense Strength. +5 City Civ6RangedStrength Ranged Strength.",
                slot: .military,
                required: .defensiveTactics,
                obsolete: .civilEngineering,
                flavours: []
            )
        }
    }

    private struct PolicyCardTypeData {

        let name: String
        let bonus: String
        let slot: PolicyCardSlotType
        let required: CivicType
        let obsolete: CivicType?
        let flavours: [Flavor]
    }

    public func obsoleteCivic() -> CivicType? {

        return self.data().obsolete
    }

    func flavorValue(for flavor: FlavorType) -> Int {

        if let flavorOfTech = self.flavours().first(where: { $0.type == flavor }) {
            return flavorOfTech.value
        }

        return 0
    }

    func flavours() -> [Flavor] {

        return self.data().flavours
    }
}
