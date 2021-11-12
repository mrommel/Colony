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
        .military,
        .economic,
        .diplomatic,
        .wildcard
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
// swiftlint:disable type_body_length
public enum PolicyCardType: Int, Codable {

    case slot

    // ancient
    case survey
    case godKing
    case discipline
    case urbanPlanning
    case ilkum
    case agoge
    case caravansaries
    case maritimeIndustries
    case maneuver
    case strategos
    case conscription
    case corvee
    case landSurveyors
    case colonization
    case inspiration
    case revelation
    case limitanei

    // classical
    case insulae
    case charismaticLeader
    case diplomaticLeague
    case literaryTradition
    case raid
    case veterancy
    case equestrianOrders
    case bastions
    case limes
    case naturalPhilosophy
    case scripture
    case praetorium

    // medieval
    case navalInfrastructure
    case navigation
    case feudalContract
    case serfdom
    case meritocracy
    case retainers
    case sack
    case professionalArmy
    case retinues
    case tradeConfederation
    case merchantConfederation
    case aesthetics
    case medinaQuarter
    case craftsmen
    case townCharters
    case travelingMerchants
    case chivalry
    case gothicArchitecture
    case civilPrestige

    // industrial
    // case nativeConquest

    // information

    public static var all: [PolicyCardType] {
        return [
            // ancient
            .survey, .godKing, .discipline, .urbanPlanning, .ilkum, .agoge, .caravansaries, .maritimeIndustries, .maneuver,
            .strategos, .conscription, .corvee, .landSurveyors, .colonization, .inspiration, .revelation, .limitanei,

            // classical
            .insulae, .charismaticLeader, .diplomaticLeague, .literaryTradition, .raid, .veterancy, .equestrianOrders,
            .bastions, .limes, .naturalPhilosophy, .scripture, .praetorium,

            // medieval
            .navalInfrastructure, .navigation, .feudalContract, .serfdom, .meritocracy, .retainers, .sack,
            .professionalArmy, .retinues, .tradeConfederation, .merchantConfederation, .aesthetics, .medinaQuarter,
            .craftsmen, .townCharters, .travelingMerchants, .chivalry, .gothicArchitecture, .civilPrestige

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

    // swiftlint:disable function_body_length
    private func data() -> PolicyCardTypeData {

        switch self {

        case .slot:
            return PolicyCardTypeData(
                name: "-",
                bonus: "-",
                slot: .wildcard,
                required: .none,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .survey:
            // https://civilization.fandom.com/wiki/Survey_(Civ6)
            return PolicyCardTypeData(
                name: "Survey",
                bonus: "Doubles experience for recon units.",
                slot: .military,
                required: .codeOfLaws,
                obsolete: .exploration,
                replace: nil,
                flavours: [Flavor(type: .recon, value: 5)]
            )
        case .godKing:
            // https://civilization.fandom.com/wiki/God_King_(Civ6)
            return PolicyCardTypeData(
                name: "God King",
                bonus: "+1 Faith and +1 Gold in the Capital.",
                slot: .economic,
                required: .codeOfLaws,
                obsolete: .theology,
                replace: nil,
                flavours: [
                    Flavor(type: .religion, value: 3),
                    Flavor(type: .gold, value: 2)
                ]
            )
        case .discipline:
            // https://civilization.fandom.com/wiki/Discipline_(Civ6)
            return PolicyCardTypeData(
                name: "Discipline",
                bonus: "+5 Combat Strength when fighting Barbarians.",
                slot: .military,
                required: .codeOfLaws,
                obsolete: .colonialism,
                replace: nil,
                flavours: [
                    Flavor(type: .defense, value: 4),
                    Flavor(type: .growth, value: 1)
                ]
            )
        case .urbanPlanning:
            return PolicyCardTypeData(
                name: "Urban Planning",
                bonus: "+1 Production in all cities.",
                slot: .economic,
                required: .codeOfLaws,
                obsolete: .gamesAndRecreation,
                replace: nil,
                flavours: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .production, value: 3)
                ]
            )
        case .ilkum:
            // https://civilization.fandom.com/wiki/Ilkum_(Civ6)
            return PolicyCardTypeData(
                name: "Ilkum",
                bonus: "+30% Production toward Builders.",
                slot: .economic,
                required: .craftsmanship,
                obsolete: .gamesAndRecreation,
                replace: nil,
                flavours: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .tileImprovement, value: 3)
                ]
            )
        case .agoge:
            // https://civilization.fandom.com/wiki/Agoge_(Civ6)
            return PolicyCardTypeData(
                name: "Agoge",
                bonus: "+50% Production toward Ancient and Classical era melee, ranged units and anti-cavalry units.",
                slot: .military,
                required: .craftsmanship,
                obsolete: .feudalism,
                replace: nil,
                flavours: [
                    Flavor(type: .offense, value: 3),
                    Flavor(type: .defense, value: 2)
                ]
            )
        case .caravansaries:
            // https://civilization.fandom.com/wiki/Caravansaries_(Civ6)
            return PolicyCardTypeData(
                name: "Caravansaries",
                bonus: "+2 Gold from all Trade Routes.",
                slot: .economic,
                required: .foreignTrade,
                obsolete: .mercantilism,
                replace: nil,
                flavours: [Flavor(type: .gold, value: 5)]
            )
        case .maritimeIndustries:
            // https://civilization.fandom.com/wiki/Maritime_Industries_(Civ6)
            return PolicyCardTypeData(
                name: "Maritime Industries",
                bonus: "+100% Production toward Ancient and Classical era naval units.",
                slot: .military,
                required: .foreignTrade,
                obsolete: .colonialism,
                replace: nil,
                flavours: [
                    Flavor(type: .navalGrowth, value: 3),
                    Flavor(type: .naval, value: 2)
                ]
            )
        case .maneuver:
            // https://civilization.fandom.com/wiki/Maneuver_(Civ6)
            return PolicyCardTypeData(
                name: "Maneuver",
                bonus: "+50% Production toward Ancient and Classical era heavy and light cavalry units.",
                slot: .military,
                required: .militaryTradition,
                obsolete: .divineRight,
                replace: nil,
                flavours: [
                    Flavor(type: .mobile, value: 4),
                    Flavor(type: .offense, value: 1)
                ]
            )
        case .strategos:
            // https://civilization.fandom.com/wiki/Strategos_(Civ6)
            return PolicyCardTypeData(
                name: "Strategos",
                bonus: "+2 Great General points per turn.",
                slot: .wildcard,
                required: .militaryTradition,
                obsolete: .scorchedEarth,
                replace: nil,
                flavours: [Flavor(type: .greatPeople, value: 5)]
            )
        case .conscription:
            // https://civilization.fandom.com/wiki/Conscription_(Civ6)
            return PolicyCardTypeData(
                name: "Conscription",
                bonus: "Unit maintenance reduced by 1 Gold per turn, per unit.",
                slot: .military,
                required: .stateWorkforce,
                obsolete: .mobilization,
                replace: nil,
                flavours: [
                    Flavor(type: .offense, value: 4),
                    Flavor(type: .gold, value: 1)
                ]
            )
        case .corvee:
            // https://civilization.fandom.com/wiki/Corv%C3%A9e_(Civ6)
            return PolicyCardTypeData(
                name: "Corvee",
                bonus: "+15% Production toward Ancient and Classical wonders.",
                slot: .economic,
                required: .stateWorkforce,
                obsolete: .divineRight,
                replace: nil,
                flavours: [Flavor(type: .wonder, value: 5)]
            )
        case .landSurveyors:
            // https://civilization.fandom.com/wiki/Land_Surveyors_(Civ6)
            return PolicyCardTypeData(
                name: "Land Surveyors",
                bonus: "Reduces the cost of purchasing a tile by 20%.",
                slot: .economic,
                required: .earlyEmpire,
                obsolete: .scorchedEarth,
                replace: nil,
                flavours: [
                    Flavor(type: .growth, value: 3),
                    Flavor(type: .tileImprovement, value: 2)
                ]
            )
        case .colonization:
            // https://civilization.fandom.com/wiki/Colonization_(Civ6)
            return PolicyCardTypeData(
                name: "Colonization",
                bonus: "+50% Production toward Settlers.",
                slot: .economic,
                required: .earlyEmpire,
                obsolete: .scorchedEarth,
                replace: nil,
                flavours: [Flavor(type: .growth, value: 5)]
            )
        case .inspiration:
            // https://civilization.fandom.com/wiki/Inspiration_(Civ6)
            return PolicyCardTypeData(
                name: "Inspiration",
                bonus: "+2 Great Scientist points per turn.",
                slot: .wildcard,
                required: .mysticism,
                obsolete: .nuclearProgram,
                replace: nil,
                flavours: [
                    Flavor(type: .science, value: 2),
                    Flavor(type: .greatPeople, value: 3)
                ]
            )
        case .revelation:
            // https://civilization.fandom.com/wiki/Revelation_(Civ6)
            return PolicyCardTypeData(
                name: "Revelation",
                bonus: "+2 Great Prophet points per turn.", 
                slot: .wildcard,
                required: .mysticism,
                obsolete: .humanism,
                replace: nil,
                flavours: [
                    Flavor(type: .religion, value: 2),
                    Flavor(type: .greatPeople, value: 3)
                ]
            )
        case .limitanei:
            // https://civilization.fandom.com/wiki/Limitanei_(Civ6)
            return PolicyCardTypeData(
                name: "Limitanei",
                bonus: "+2 Loyalty per turn for cities with a garrisoned unit.",
                slot: .military,
                required: .earlyEmpire,
                obsolete: nil,
                replace: nil,
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
                replace: nil,
                flavours: [Flavor(type: .growth, value: 3), Flavor(type: .tileImprovement, value: 2)]
            )

        case .charismaticLeader:
            // https://civilization.fandom.com/wiki/Charismatic_Leader_(Civ6)
            return PolicyCardTypeData(
                name: "Charismatic Leader",
                bonus: "+2 Influence Points per turn toward earning city-state Envoys.", // #
                slot: .diplomatic,
                required: .politicalPhilosophy,
                obsolete: .totalitarianism,
                replace: nil,
                flavours: []
            )

        case .diplomaticLeague:
            // https://civilization.fandom.com/wiki/Diplomatic_League_(Civ6)
            return PolicyCardTypeData(
                name: "Diplomatic League",
                bonus: "The first Envoy you send to each city-state counts as two Envoys.", // #
                slot: .diplomatic,
                required: .politicalPhilosophy,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .literaryTradition:
            // https://civilization.fandom.com/wiki/Literary_Tradition_(Civ6)
            return PolicyCardTypeData(
                name: "Literary Tradition",
                bonus: "+2 Great Writer points per turn.",
                slot: .wildcard,
                required: .dramaAndPoetry,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .raid:
            // https://civilization.fandom.com/wiki/Raid_(Civ6)
            return PolicyCardTypeData(
                name: "Raid",
                bonus: "Yields gained from pillaging and coastal raids are +50%.", // #
                slot: .military,
                required: .militaryTraining,
                obsolete: .scorchedEarth,
                replace: nil,
                flavours: []
            )

        case .veterancy:
            // https://civilization.fandom.com/wiki/Veterancy_(Civ6)
            return PolicyCardTypeData(
                name: "Veterancy",
                bonus: "+30% Production toward Encampment and Harbor districts and buildings for those districts.", // #
                slot: .military,
                required: .militaryTraining,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .equestrianOrders:
            // https://civilization.fandom.com/wiki/Equestrian_Orders_(Civ6)
            return PolicyCardTypeData(
                name: "Equestrian Orders",
                bonus: "All improved Horses and Iron resources yield 1 additional resource per turn.", // #
                slot: .military,
                required: .militaryTraining,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .bastions:
            // https://civilization.fandom.com/wiki/Bastions_(Civ6)
            return PolicyCardTypeData(
                name: "Bastions",
                bonus: "+6 City Defense Strength. +5 City Ranged Strength.",
                slot: .military,
                required: .defensiveTactics,
                obsolete: .civilEngineering,
                replace: nil,
                flavours: []
            )

        case .limes:
            // https://civilization.fandom.com/wiki/Limes_(Civ6)
            return PolicyCardTypeData(
                name: "Limes",
                bonus: "+100% Production toward defensive buildings.", // #
                slot: .military,
                required: .defensiveTactics,
                obsolete: .totalitarianism,
                replace: nil,
                flavours: []
            )

        case .naturalPhilosophy:
            // https://civilization.fandom.com/wiki/Natural_Philosophy_(Civ6)
            return PolicyCardTypeData(
                name: "Natural Philosophy",
                bonus: "+100% Campus district adjacency bonuses.", // #
                slot: .economic,
                required: .recordedHistory,
                obsolete: .classStruggle,
                replace: nil,
                flavours: []
            )

        case .scripture:
            // https://civilization.fandom.com/wiki/Scripture_(Civ6)
            return PolicyCardTypeData(
                name: "Scripture",
                bonus: "+100% Holy Site district adjacency bonuses.", // #
                slot: .economic,
                required: .theology,
                obsolete: nil,
                replace: .godKing,
                flavours: []
            )

        case .praetorium:
            // https://civilization.fandom.com/wiki/Praetorium_(Civ6)
            return PolicyCardTypeData(
                name: "Praetorium",
                bonus: "Governors provide +2 Loyalty per turn to their city.",
                slot: .diplomatic,
                required: .recordedHistory,
                obsolete: .socialMedia,
                replace: nil,
                flavours: [Flavor(type: .growth, value: 4)]
            )

            // medieval
        case .navalInfrastructure:
            // https://civilization.fandom.com/wiki/Naval_Infrastructure_(Civ6)
            return PolicyCardTypeData(
                name: "Naval Infrastructure",
                bonus: "+100% Harbor district adjacency bonus.", // #
                slot: .economic,
                required: .navalTradition,
                obsolete: .suffrage,
                replace: nil,
                flavours: []
            )

        case .navigation:
            // https://civilization.fandom.com/wiki/Navigation_(Civ6)
            return PolicyCardTypeData(
                name: "Navigation",
                bonus: "+2 Great Admiral Great Admiral points per turn.",
                slot: .wildcard,
                required: .navalTradition,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .feudalContract:
            // https://civilization.fandom.com/wiki/Feudal_Contract_(Civ6)
            return PolicyCardTypeData(
                name: "Feudal Contract",
                bonus: "+50% Production toward Ancient, Classical, Medieval and Renaissance era melee, ranged and anti-cavalry units.", // #
                slot: .military,
                required: .feudalism,
                obsolete: .nationalism,
                replace: .agoge,
                flavours: []
            )

        case .serfdom:
            // https://civilization.fandom.com/wiki/Serfdom_(Civ6)
            return PolicyCardTypeData(
                name: "Serfdom",
                bonus: "Newly trained Builders gain 2 extra build actions.",
                slot: .economic,
                required: .feudalism,
                obsolete: .civilEngineering,
                replace: PolicyCardType.ilkum,
                flavours: []
            )

        case .meritocracy:
            // https://civilization.fandom.com/wiki/Meritocracy_(Civ6)
            return PolicyCardTypeData(
                name: "Meritocracy",
                bonus: "Each city receives +1 Culture for each specialty District it constructs.", // #
                slot: .economic,
                required: .civilService,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .retainers:
            // https://civilization.fandom.com/wiki/Retainers_(Civ6)
            return PolicyCardTypeData(
                name: "Retainers",
                bonus: "+1 Amenity for cities with a garrisoned unit.", // #
                slot: .military,
                required: .civilService,
                obsolete: .massMedia,
                replace: nil,
                flavours: []
            )

        case .sack:
            // https://civilization.fandom.com/wiki/Sack_(Civ6)
            return PolicyCardTypeData(
                name: "Sack",
                bonus: "Yields gained from pillaging are doubled for pillaging Districts.", // #
                slot: .military,
                required: .mercenaries,
                obsolete: .scorchedEarth,
                replace: nil,
                flavours: []
            )

        case .professionalArmy:
            // https://civilization.fandom.com/wiki/Professional_Army_(Civ6)
            return PolicyCardTypeData(
                name: "Professional Army",
                bonus: "50% Gold discount on all unit upgrades.",
                slot: .military,
                required: .mercenaries,
                obsolete: .urbanization,
                replace: nil,
                flavours: []
            )

        case .retinues:
            // https://civilization.fandom.com/wiki/Retinues_(Civ6)
            return PolicyCardTypeData(
                name: "Retinues",
                bonus: "50% resource discount on all unit upgrades.", // #
                slot: .military,
                required: .mercenaries,
                obsolete: .urbanization,
                replace: nil,
                flavours: []
            )

        case .tradeConfederation:
            // https://civilization.fandom.com/wiki/Trade_Confederation_(Civ6)
            return PolicyCardTypeData(
                name: "Trade Confederation",
                bonus: "+1 Culture and +1 Science from international Trade Routes.",
                slot: .economic,
                required: .mercenaries,
                obsolete: .capitalism,
                replace: nil,
                flavours: []
            )

        case .merchantConfederation:
            // https://civilization.fandom.com/wiki/Merchant_Confederation_(Civ6)
            return PolicyCardTypeData(
                name: "Merchant Confederation",
                bonus: "+1 Gold from each of your Envoys at city-states.", // #
                slot: .diplomatic,
                required: .medievalFaires,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

        case .aesthetics:
            // https://civilization.fandom.com/wiki/Aesthetics_(Civ6)
            return PolicyCardTypeData(
                name: "Aesthetics",
                bonus: "+100% Theater Square district adjacency bonuses.", // #
                slot: .economic,
                required: .medievalFaires,
                obsolete: .professionalSports,
                replace: nil,
                flavours: []
            )

        case .medinaQuarter:
            // https://civilization.fandom.com/wiki/Medina_Quarter_(Civ6)
            return PolicyCardTypeData(
                name: "Medina Quarter",
                bonus: "+2 Housing in all cities with at least 3 specialty Districts.", // #
                slot: .economic,
                required: .medievalFaires,
                obsolete: .suffrage,
                replace: .insulae,
                flavours: []
            )

        case .craftsmen:
            // https://civilization.fandom.com/wiki/Craftsmen_(Civ6)
            return PolicyCardTypeData(
                name: "Craftsmen",
                bonus: "+100% Industrial Zone adjacency bonuses.", // #
                slot: .military,
                required: .guilds,
                obsolete: .classStruggle,
                replace: nil,
                flavours: []
            )

        case .townCharters:
            // https://civilization.fandom.com/wiki/Town_Charters_(Civ6)
            return PolicyCardTypeData(
                name: "Town Charters",
                bonus: "+100% Commercial Hub adjacency bonuses.", // #
                slot: .economic,
                required: .guilds,
                obsolete: .suffrage,
                replace: nil,
                flavours: []
            )

        case .travelingMerchants:
            // https://civilization.fandom.com/wiki/Traveling_Merchants_(Civ6)
            return PolicyCardTypeData(
                name: "Traveling Merchants",
                bonus: "+2 Great Merchant points per turn.",
                slot: .wildcard,
                required: .guilds,
                obsolete: .capitalism,
                replace: nil,
                flavours: []
            )

        case .chivalry:
            // https://civilization.fandom.com/wiki/Chivalry_(Civ6)
            return PolicyCardTypeData(
                name: "Chivalry",
                bonus: "+50% Production toward Industrial era and earlier heavy and light cavalry units.", // #
                slot: .military,
                required: .divineRight,
                obsolete: .totalitarianism,
                replace: nil,
                flavours: []
            )

        case .gothicArchitecture:
            // https://civilization.fandom.com/wiki/Gothic_Architecture_(Civ6)
            return PolicyCardTypeData(
                name: "Gothic Architecture",
                bonus: "+15% Production toward Ancient, Classical, Medieval and Renaissance wonders.", // #
                slot: .economic,
                required: .divineRight,
                obsolete: .civilEngineering,
                replace: nil,
                flavours: []
            )

        case .civilPrestige:
            // https://civilization.fandom.com/wiki/Civil_Prestige_(Civ6)
            return PolicyCardTypeData(
                name: "Civil Prestige",
                bonus: "Established Governors with at least 2 Promotions provide +1 Amenity and +2 Housing.", // #
                slot: .economic,
                required: .civilService,
                obsolete: nil,
                replace: nil,
                flavours: []
            )

            /* ... */
        }
    }

    private struct PolicyCardTypeData {

        let name: String
        let bonus: String
        let slot: PolicyCardSlotType
        let required: CivicType
        let obsolete: CivicType?
        let replace: PolicyCardType?
        let flavours: [Flavor]
    }

    public func obsoleteCivic() -> CivicType? {

        return self.data().obsolete
    }

    public func replacePolicyCard() -> PolicyCardType? {

        return self.data().replace
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
