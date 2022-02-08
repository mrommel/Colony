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

    public func name() -> String {

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

    // renaissance
    case colonialOffices
    case invention
    case frescoes
    case machiavellianism
    case warsOfReligion
    case simultaneum
    case religiousOrders
    case logistics
    case triangularTrade
    case drillManuals
    case rationalism
    case freeMarket
    case liberalism
    case wisselbanken
    case pressGangs

    // industrial
    case nativeConquest
    case grandeArmee
    case nationalIdentity
    case colonialTaxes
    case raj
    case publicWorks
    case skyscrapers
    case grandOpera
    case symphonies
    case publicTransport
    case militaryResearch
    case forceModernization
    case totalWar
    case expropriation
    case militaryOrganization

    // modern
    case resourceManagement
    case propaganda
    case leveeEnMasse
    case laissezFaire
    case marketEconomy
    case policyState
    case nobelPrize
    case scienceFoundations
    case nuclearEspionage
    case economicUnion
    case theirFinestHour
    case arsenalOfDemocracy
    case newDeal
    case lightningWarfare
    case thirdAlternative
    case martialLaw
    case gunboatDiplomacy
    case fiveYearPlan
    case collectivization
    case patrioticWar
    case defenseOfTheMotherland

    // atomic
    case cryptography
    case internationalWaters
    case containment
    case heritageTourism
    case sportsMedia
    case militaryFirst
    case satelliteBroadcasts
    case musicCensorship
    case integratedSpaceCell
    case secondStrikeCapability

    // information
    case strategicAirForce
    case ecommerce
    case internationalSpaceAgency
    case onlineCommunities
    case collectiveActivism
    case afterActionReports
    case communicationsOffice
    case aerospaceContractors

    // future
    case spaceTourism
    case hallyu
    case nonStateActors
    case integratedAttackLogistics
    case rabblerousing
    case diplomaticCapital
    case globalCoalition

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
            .craftsmen, .townCharters, .travelingMerchants, .chivalry, .gothicArchitecture, .civilPrestige,

            // renaissance
            .colonialOffices, .invention, .frescoes, .machiavellianism, .warsOfReligion, .simultaneum, .religiousOrders,
            .logistics, .triangularTrade, .drillManuals, .rationalism, .freeMarket, .liberalism, .wisselbanken,
            .pressGangs,

            // industrial
            .nativeConquest, .grandeArmee, .nationalIdentity, .colonialTaxes, .raj, .publicWorks, .skyscrapers,
            .grandOpera, .symphonies, .publicTransport, .militaryResearch, .forceModernization, .totalWar, .expropriation,
            .militaryOrganization,

            // modern
            .resourceManagement, .propaganda, .leveeEnMasse, .laissezFaire, .marketEconomy, .policyState, .nobelPrize,
            .scienceFoundations, .nuclearEspionage, .economicUnion, .theirFinestHour, .arsenalOfDemocracy, .newDeal,
            .lightningWarfare, .thirdAlternative, .martialLaw, .gunboatDiplomacy, .fiveYearPlan, .collectivization,
            .patrioticWar, .defenseOfTheMotherland,

            // atomic
            .cryptography, .internationalWaters, .containment, .heritageTourism, .sportsMedia, .militaryFirst,
            .satelliteBroadcasts, .musicCensorship, .integratedSpaceCell, .secondStrikeCapability,

            // information
            .strategicAirForce, .ecommerce, .internationalSpaceAgency, .onlineCommunities, .collectiveActivism,
            .afterActionReports, .communicationsOffice, .aerospaceContractors,

            // future
            .spaceTourism, .hallyu, .nonStateActors, .integratedAttackLogistics, .rabblerousing, .diplomaticCapital,
            .globalCoalition
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

    // swiftlint:disable function_body_length cyclomatic_complexity line_length
    private func data() -> PolicyCardTypeData {

        switch self {

        case .slot:
            return PolicyCardTypeData(
                name: "-",
                bonus: "-",
                slot: .wildcard,
                required: .none,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .survey:
            // https://civilization.fandom.com/wiki/Survey_(Civ6)
            return PolicyCardTypeData(
                name: "TXT_KEY_POLICY_CARD_SURVEY_TITLE",
                bonus: "TXT_KEY_POLICY_CARD_SURVEY_BONUS",
                slot: .military,
                required: .codeOfLaws,
                obsolete: .exploration,
                replace: [],
                flavours: [Flavor(type: .recon, value: 5)]
            )
        case .godKing:
            // https://civilization.fandom.com/wiki/God_King_(Civ6)
            return PolicyCardTypeData(
                name: "TXT_KEY_POLICY_CARD_GOD_KING_TITLE",
                bonus: "TXT_KEY_POLICY_CARD_GOD_KING_BONUS",
                slot: .economic,
                required: .codeOfLaws,
                obsolete: .theology,
                replace: [],
                flavours: [
                    Flavor(type: .religion, value: 3),
                    Flavor(type: .gold, value: 2)
                ]
            )
        case .discipline:
            // https://civilization.fandom.com/wiki/Discipline_(Civ6)
            return PolicyCardTypeData(
                name: "TXT_KEY_POLICY_CARD_DISCIPLINE_TITLE",
                bonus: "TXT_KEY_POLICY_CARD_DISCIPLINE_BONUS",
                slot: .military,
                required: .codeOfLaws,
                obsolete: .colonialism,
                replace: [],
                flavours: [
                    Flavor(type: .defense, value: 4),
                    Flavor(type: .growth, value: 1)
                ]
            )
        case .urbanPlanning:
            return PolicyCardTypeData(
                name: "TXT_KEY_POLICY_CARD_URBAN_PLANNING_TITLE",
                bonus: "TXT_KEY_POLICY_CARD_URBAN_PLANNING_BONUS",
                slot: .economic,
                required: .codeOfLaws,
                obsolete: .gamesAndRecreation,
                replace: [],
                flavours: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .production, value: 3)
                ]
            )
        case .ilkum:
            // https://civilization.fandom.com/wiki/Ilkum_(Civ6)
            return PolicyCardTypeData(
                name: "TXT_KEY_POLICY_CARD_ILKUM_TITLE",
                bonus: "TXT_KEY_POLICY_CARD_ILKUM_BONUS",
                slot: .economic,
                required: .craftsmanship,
                obsolete: .gamesAndRecreation,
                replace: [],
                flavours: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .tileImprovement, value: 3)
                ]
            )
        case .agoge:
            // https://civilization.fandom.com/wiki/Agoge_(Civ6)
            return PolicyCardTypeData(
                name: "TXT_KEY_POLICY_CARD_AGOGE_TITLE",
                bonus: "TXT_KEY_POLICY_CARD_AGOGE_BONUS",
                slot: .military,
                required: .craftsmanship,
                obsolete: .feudalism,
                replace: [],
                flavours: [
                    Flavor(type: .offense, value: 3),
                    Flavor(type: .defense, value: 2)
                ]
            )
        case .caravansaries:
            // https://civilization.fandom.com/wiki/Caravansaries_(Civ6)
            return PolicyCardTypeData(
                name: "Caravansaries",
                bonus: "+2 [Gold] Gold from all [TradeRoute] Trade Routes.",
                slot: .economic,
                required: .foreignTrade,
                obsolete: .mercantilism,
                replace: [],
                flavours: [Flavor(type: .gold, value: 5)]
            )
        case .maritimeIndustries:
            // https://civilization.fandom.com/wiki/Maritime_Industries_(Civ6)
            return PolicyCardTypeData(
                name: "Maritime Industries",
                bonus: "+100% [Production] Production toward Ancient and Classical era naval units.",
                slot: .military,
                required: .foreignTrade,
                obsolete: .colonialism,
                replace: [],
                flavours: [
                    Flavor(type: .navalGrowth, value: 3),
                    Flavor(type: .naval, value: 2)
                ]
            )
        case .maneuver:
            // https://civilization.fandom.com/wiki/Maneuver_(Civ6)
            return PolicyCardTypeData(
                name: "Maneuver",
                bonus: "+50% [Production] Production toward Ancient and Classical era heavy and light cavalry units.",
                slot: .military,
                required: .militaryTradition,
                obsolete: .divineRight,
                replace: [],
                flavours: [
                    Flavor(type: .mobile, value: 4),
                    Flavor(type: .offense, value: 1)
                ]
            )
        case .strategos:
            // https://civilization.fandom.com/wiki/Strategos_(Civ6)
            return PolicyCardTypeData(
                name: "Strategos",
                bonus: "+2 [GreatGeneral] Great General points per turn.",
                slot: .wildcard,
                required: .militaryTradition,
                obsolete: .scorchedEarth,
                replace: [],
                flavours: [Flavor(type: .greatPeople, value: 5)]
            )
        case .conscription:
            // https://civilization.fandom.com/wiki/Conscription_(Civ6)
            return PolicyCardTypeData(
                name: "Conscription",
                bonus: "Unit maintenance reduced by 1 [Gold] Gold per turn, per unit.",
                slot: .military,
                required: .stateWorkforce,
                obsolete: .mobilization,
                replace: [],
                flavours: [
                    Flavor(type: .offense, value: 4),
                    Flavor(type: .gold, value: 1)
                ]
            )
        case .corvee:
            // https://civilization.fandom.com/wiki/Corv%C3%A9e_(Civ6)
            return PolicyCardTypeData(
                name: "Corvee",
                bonus: "+15% [Production] Production toward Ancient and Classical wonders.",
                slot: .economic,
                required: .stateWorkforce,
                obsolete: .divineRight,
                replace: [],
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
                replace: [],
                flavours: [
                    Flavor(type: .growth, value: 3),
                    Flavor(type: .tileImprovement, value: 2)
                ]
            )
        case .colonization:
            // https://civilization.fandom.com/wiki/Colonization_(Civ6)
            return PolicyCardTypeData(
                name: "Colonization",
                bonus: "+50% [Production] Production toward Settlers.",
                slot: .economic,
                required: .earlyEmpire,
                obsolete: .scorchedEarth,
                replace: [],
                flavours: [Flavor(type: .growth, value: 5)]
            )
        case .inspiration:
            // https://civilization.fandom.com/wiki/Inspiration_(Civ6)
            return PolicyCardTypeData(
                name: "Inspiration",
                bonus: "+2 [GreatScientist] Great Scientist points per turn.",
                slot: .wildcard,
                required: .mysticism,
                obsolete: .nuclearProgram,
                replace: [],
                flavours: [
                    Flavor(type: .science, value: 2),
                    Flavor(type: .greatPeople, value: 3)
                ]
            )
        case .revelation:
            // https://civilization.fandom.com/wiki/Revelation_(Civ6)
            return PolicyCardTypeData(
                name: "Revelation",
                bonus: "+2 [GreatProphet] Great Prophet points per turn.",
                slot: .wildcard,
                required: .mysticism,
                obsolete: .humanism,
                replace: [],
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
                replace: [],
                flavours: [Flavor(type: .growth, value: 5)]
            )

            // classical
        case .insulae:
            // https://civilization.fandom.com/wiki/Insulae_(Civ6)
            return PolicyCardTypeData(
                name: "Insulae",
                bonus: "+1 [Housing] Housing in all cities with at least 2 specialty districts.",
                slot: .economic,
                required: .gamesAndRecreation,
                obsolete: .medievalFaires,
                replace: [],
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
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .literaryTradition:
            // https://civilization.fandom.com/wiki/Literary_Tradition_(Civ6)
            return PolicyCardTypeData(
                name: "Literary Tradition",
                bonus: "+2 [GreatWriter] Great Writer points per turn.",
                slot: .wildcard,
                required: .dramaAndPoetry,
                obsolete: nil,
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .veterancy:
            // https://civilization.fandom.com/wiki/Veterancy_(Civ6)
            return PolicyCardTypeData(
                name: "Veterancy",
                bonus: "+30% [Production] Production toward Encampment and Harbor districts and buildings for those districts.", // #
                slot: .military,
                required: .militaryTraining,
                obsolete: nil,
                replace: [],
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
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .limes:
            // https://civilization.fandom.com/wiki/Limes_(Civ6)
            return PolicyCardTypeData(
                name: "Limes",
                bonus: "+100% [Production] Production toward defensive buildings.", // #
                slot: .military,
                required: .defensiveTactics,
                obsolete: .totalitarianism,
                replace: [],
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
                replace: [],
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
                replace: [.godKing],
                flavours: []
            )

        case .praetorium:
            // https://civilization.fandom.com/wiki/Praetorium_(Civ6)
            return PolicyCardTypeData(
                name: "Praetorium",
                bonus: "[Governor] Governors provide +2 Loyalty per turn to their city.",
                slot: .diplomatic,
                required: .recordedHistory,
                obsolete: .socialMedia,
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .navigation:
            // https://civilization.fandom.com/wiki/Navigation_(Civ6)
            return PolicyCardTypeData(
                name: "Navigation",
                bonus: "+2 [GreatAdmiral] Great Admiral points per turn.",
                slot: .wildcard,
                required: .navalTradition,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .feudalContract:
            // https://civilization.fandom.com/wiki/Feudal_Contract_(Civ6)
            return PolicyCardTypeData(
                name: "Feudal Contract",
                bonus:
                    "+50% [Production] Production toward Ancient, Classical, Medieval and Renaissance era melee, " + // #
                    "ranged and anti-cavalry units.",
                slot: .military,
                required: .feudalism,
                obsolete: .nationalism,
                replace: [.agoge],
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
                replace: [.ilkum],
                flavours: []
            )

        case .meritocracy:
            // https://civilization.fandom.com/wiki/Meritocracy_(Civ6)
            return PolicyCardTypeData(
                name: "Meritocracy",
                bonus: "Each city receives +1 [Culture] Culture for each specialty District it constructs.", // #
                slot: .economic,
                required: .civilService,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .retainers:
            // https://civilization.fandom.com/wiki/Retainers_(Civ6)
            return PolicyCardTypeData(
                name: "Retainers",
                bonus: "+1 [Amenities] Amenity for cities with a garrisoned unit.",
                slot: .military,
                required: .civilService,
                obsolete: .massMedia,
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .professionalArmy:
            // https://civilization.fandom.com/wiki/Professional_Army_(Civ6)
            return PolicyCardTypeData(
                name: "Professional Army",
                bonus: "50% [Gold] Gold discount on all unit upgrades.",
                slot: .military,
                required: .mercenaries,
                obsolete: .urbanization,
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .tradeConfederation:
            // https://civilization.fandom.com/wiki/Trade_Confederation_(Civ6)
            return PolicyCardTypeData(
                name: "Trade Confederation",
                bonus: "+1 [Culture] Culture and +1 [Science] Science from international [TradeRoute] Trade Routes.",
                slot: .economic,
                required: .mercenaries,
                obsolete: .capitalism,
                replace: [],
                flavours: []
            )

        case .merchantConfederation:
            // https://civilization.fandom.com/wiki/Merchant_Confederation_(Civ6)
            return PolicyCardTypeData(
                name: "Merchant Confederation",
                bonus: "+1 [Gold] Gold from each of your Envoys at city-states.", // #
                slot: .diplomatic,
                required: .medievalFaires,
                obsolete: nil,
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .medinaQuarter:
            // https://civilization.fandom.com/wiki/Medina_Quarter_(Civ6)
            return PolicyCardTypeData(
                name: "Medina Quarter",
                bonus: "+2 [Housing] Housing in all cities with at least 3 specialty Districts.", // #
                slot: .economic,
                required: .medievalFaires,
                obsolete: .suffrage,
                replace: [.insulae],
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
                replace: [],
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
                replace: [],
                flavours: []
            )

        case .travelingMerchants:
            // https://civilization.fandom.com/wiki/Traveling_Merchants_(Civ6)
            return PolicyCardTypeData(
                name: "Traveling Merchants",
                bonus: "+2 [GreatMerchant] Great Merchant points per turn.",
                slot: .wildcard,
                required: .guilds,
                obsolete: .capitalism,
                replace: [],
                flavours: []
            )

        case .chivalry:
            // https://civilization.fandom.com/wiki/Chivalry_(Civ6)
            return PolicyCardTypeData(
                name: "Chivalry",
                bonus: "+50% [Production] Production toward Industrial era and earlier heavy and light cavalry units.", // #
                slot: .military,
                required: .divineRight,
                obsolete: .totalitarianism,
                replace: [],
                flavours: []
            )

        case .gothicArchitecture:
            // https://civilization.fandom.com/wiki/Gothic_Architecture_(Civ6)
            return PolicyCardTypeData(
                name: "Gothic Architecture",
                bonus: "+15% [Production] Production toward Ancient, Classical, Medieval and Renaissance wonders.", // #
                slot: .economic,
                required: .divineRight,
                obsolete: .civilEngineering,
                replace: [],
                flavours: []
            )

        case .civilPrestige:
            // https://civilization.fandom.com/wiki/Civil_Prestige_(Civ6)
            return PolicyCardTypeData(
                name: "Civil Prestige",
                bonus: "Established [Governor] Governors with at least 2 Promotions provide +1 [Amenities] Amenity and +2 [Housing] Housing.",
                slot: .economic,
                required: .civilService,
                obsolete: nil,
                replace: [],
                flavours: []
            )

            // //////////////////////
            // renaissance

        case .colonialOffices:
            // https://civilization.fandom.com/wiki/Colonial_Offices_(Civ6)
            return PolicyCardTypeData(
                name: "Colonial Offices",
                bonus: "+15% faster growth and 3 Loyalty per turn for cities not on your original [Capital] Capital's continent.",
                slot: .diplomatic,
                required: .exploration,
                obsolete: nil,
                replace: [.urbanPlanning],
                flavours: []
            )

        case .invention:
            // https://civilization.fandom.com/wiki/Invention_(Civ6)
            return PolicyCardTypeData(
                name: "Invention",
                bonus: "+4 [GreatEngineer] Great Engineer points per turn. +2 additional [GreatEngineer] Great Engineer points for every Workshop.",
                slot: .wildcard,
                required: .humanism,
                obsolete: nil,
                replace: [.revelation],
                flavours: []
            )

        case .frescoes:
            // https://civilization.fandom.com/wiki/Frescoes_(Civ6)
            return PolicyCardTypeData(
                name: "Frescoes",
                bonus: "+2 [GreatArtist] Great Artist points per turn. +2 additional [GreatArtist] Great Artist points for every Art Museum.",
                slot: .wildcard,
                required: .humanism,
                obsolete: nil,
                replace: [.revelation],
                flavours: []
            )

        case .machiavellianism:
            // https://civilization.fandom.com/wiki/Machiavellianism_(Civ6)
            return PolicyCardTypeData(
                name: "Machiavellianism",
                bonus: "+50% [Production] Production towards Spies. Spy operations take 25% less time.",
                slot: .diplomatic,
                required: .diplomaticService,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .warsOfReligion:
            // https://civilization.fandom.com/wiki/Wars_of_Religion_(Civ6)
            return PolicyCardTypeData(
                name: "Wars of Religion",
                bonus: "+4 [Strength] Combat Strength when fighting civilizations that follow other religions.",
                slot: .military,
                required: .reformedChurch,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .simultaneum:
            // https://civilization.fandom.com/wiki/Simultaneum_(Civ6)
            return PolicyCardTypeData(
                name: "Simultaneum",
                bonus: "Extra [Faith] Faith from buildings in Holy Sites: +50% if city [Citizen] population is 15 or higher, +50% if district has at least +4 adjacency bonus.",
                slot: .economic,
                required: .reformedChurch,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .religiousOrders:
            // https://civilization.fandom.com/wiki/Religious_Orders_(Civ6)
            return PolicyCardTypeData(
                name: "Religious Orders",
                bonus: "All religious units gain +5 [ReligiousStrength] Religious Strength in theological combat.",
                slot: .economic,
                required: .reformedChurch,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .logistics:
            // https://civilization.fandom.com/wiki/Logistics_(Civ6)
            return PolicyCardTypeData(
                name: "Logistics",
                bonus: "+1 [Movement] Movement if starting turn in friendly territory.",
                slot: .military,
                required: .mercantilism,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .triangularTrade:
            // https://civilization.fandom.com/wiki/Triangular_Trade_(Civ6)
            return PolicyCardTypeData(
                name: "Triangular Trade",
                bonus: "+4 [Gold] Gold and +1 [Faith] Faith from all [TradeRoute] Trade Routes.",
                slot: .economic,
                required: .mercantilism,
                obsolete: .globalization,
                replace: [.ecommerce],
                flavours: []
            )

        case .drillManuals:
            // https://civilization.fandom.com/wiki/Drill_Manuals_(Civ6)
            return PolicyCardTypeData(
                name: "Drill Manuals",
                bonus: "All improved [Niter] Niter and [Coal] Coal resources yield 1 additional resource per turn.",
                slot: .military,
                required: .mercantilism,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .rationalism:
            // https://civilization.fandom.com/wiki/Rationalism_(Civ6)
            return PolicyCardTypeData(
                name: "Rationalism",
                bonus: "Extra [Science] Science from buildings in Campuses: +50% if city [Citizen] population is 15 or higher, +50% if district has at least +4 adjacency bonus.",
                slot: .economic,
                required: .enlightenment,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .freeMarket:
            // https://civilization.fandom.com/wiki/Free_Market_(Civ6)
            return PolicyCardTypeData(
                name: "Free Market",
                bonus: "Extra [Gold] Gold from buildings in Commercial Hubs: +50% if city [Citizen] population is 15 or higher, +50% if district has at least +4 adjacency bonus.",
                slot: .economic,
                required: .enlightenment,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .liberalism:
            // https://civilization.fandom.com/wiki/Liberalism_(Civ6)
            return PolicyCardTypeData(
                name: "Liberalism",
                bonus: "+1 [Amenities] Amenity to all cities with at least 2 specialty districts.",
                slot: .economic,
                required: .enlightenment,
                obsolete: nil,
                replace: [.newDeal],
                flavours: []
            )

        case .wisselbanken:
            // https://civilization.fandom.com/wiki/Wisselbanken_(Civ6)
            return PolicyCardTypeData(
                name: "Wisselbanken",
                bonus: "Your [TradeRoute] Trade Routes to an Ally's city or a city-state you are the Suzerain of provide +2 [Food] Food and +2 [Production] Production for both cities. Alliance Points with each ally grow 25% faster.",
                slot: .diplomatic,
                required: .diplomaticService,
                obsolete: nil,
                replace: [.arsenalOfDemocracy],
                flavours: []
            )

        case .pressGangs:
            // https://civilization.fandom.com/wiki/Press_Gangs_(Civ6)
            return PolicyCardTypeData(
                name: "Press Gangs",
                bonus: "+100% [Production] Production towards Industrial era and earlier naval units.",
                slot: .military,
                required: .exploration,
                obsolete: .coldWar,
                replace: [.maritimeIndustries],
                flavours: []
            )

            // ////////////////////////
            // industrial

        case .nativeConquest:
            // https://civilization.fandom.com/wiki/Native_Conquest_(Civ6)
            return PolicyCardTypeData(
                name: "Native Conquest",
                bonus: "Combat victories over units from earlier eras provide [Gold] Gold equal to 50% of the Strength Combat Strength of the defeated unit.",
                slot: .military,
                required: .colonialism,
                obsolete: nil,
                replace: [.discipline, .survey],
                flavours: []
            )

        case .grandeArmee:
            // https://civilization.fandom.com/wiki/Grande_Arm%C3%A9e_(Civ6)
            return PolicyCardTypeData(
                name: "Grande Armée",
                bonus: "+50% [Production] Production towards Industrial era and earlier melee, ranged and anti-cavalry units.",
                slot: .military,
                required: .nationalism,
                obsolete: nil,
                replace: [.militaryFirst],
                flavours: []
            )

        case .nationalIdentity:
            // https://civilization.fandom.com/wiki/National_Identity_(Civ6)
            return PolicyCardTypeData(
                name: "National Identity",
                bonus: "Units have 50% less [Strength] Combat Strength reduction from being injured.",
                slot: .military,
                required: .nationalism,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .colonialTaxes:
            // https://civilization.fandom.com/wiki/Colonial_Taxes_(Civ6)
            return PolicyCardTypeData(
                name: "Colonial Taxes",
                bonus: "+25% [Gold] Gold and +10% [Production] Production in cities not on your original [Capital] Capital's continent.",
                slot: .diplomatic,
                required: .colonialism,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .raj:
            // https://civilization.fandom.com/wiki/Raj_(Civ6)
            return PolicyCardTypeData(
                name: "Raj",
                bonus: "+2 [Science] Science, [Culture] Culture, [Faith] Faith and [Gold] Gold from each city-state you are Suzerain of. +2 [Gold] Gold for [TradeRoute] Trade Routes to city-states.",
                slot: .diplomatic,
                required: .colonialism,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .publicWorks:
            // https://civilization.fandom.com/wiki/Public_Works_(Civ6)
            return PolicyCardTypeData(
                name: "Public Works",
                bonus: "+30% [Production] Production towards Builders. Newly trained Builders gain 2 additional Build actions.",
                slot: .economic,
                required: .civilEngineering,
                obsolete: nil,
                replace: [.serfdom],
                flavours: []
            )

        case .skyscrapers:
            // https://civilization.fandom.com/wiki/Skyscrapers_(Civ6)
            return PolicyCardTypeData(
                name: "Skyscrapers",
                bonus: "+15% [Production] Production towards all Wonders.",
                slot: .economic,
                required: .civilEngineering,
                obsolete: nil,
                replace: [.gothicArchitecture],
                flavours: []
            )

        case .grandOpera:
            // https://civilization.fandom.com/wiki/Grand_Opera_(Civ6)
            return PolicyCardTypeData(
                name: "Grand Opera",
                bonus: "Extra [Culture] Culture from buildings in Theater Squares: +50% if city [Citizen] population is 15 or higher, +50% if district has at least +4 adjacency bonus.",
                slot: .economic,
                required: .operaAndBallet,
                obsolete: .professionalSports,
                replace: [],
                flavours: []
            )

        case .symphonies:
            // https://civilization.fandom.com/wiki/Symphonies_(Civ6)
            return PolicyCardTypeData(
                name: "Symphonies",
                bonus: "+4 [GreatMusician] Great Musician points per turn. +4 additional [GreatMusician] Great Musician points for every Broadcast Center.",
                slot: .wildcard,
                required: .operaAndBallet,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .publicTransport:
            // https://civilization.fandom.com/wiki/Public_Transport_(Civ6)
            return PolicyCardTypeData(
                name: "Public Transport",
                bonus: "Neighborhoods with Charming Appeal receive +3 [Food] Food and +1 [Production] Production. Neighborhoods with Breathtaking Appeal receive an additional 1 [Food] Food and 1 [Production] Production. All Neighborhoods receive +1 [Gold] Gold.",
                slot: .economic,
                required: .urbanization,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .militaryResearch:
            // https://civilization.fandom.com/wiki/Military_Research_(Civ6)
            return PolicyCardTypeData(
                name: "Military Research",
                bonus: "Military Academies, Seaports, and Renaissance Walls generate +2 [Science] Science.",
                slot: .military,
                required: .urbanization,
                obsolete: nil,
                replace: [.integratedSpaceCell],
                flavours: []
            )

        case .forceModernization:
            // https://civilization.fandom.com/wiki/Force_Modernization_(Civ6)
            return PolicyCardTypeData(
                name: "Force Modernization",
                bonus: "50% [Gold] Gold and resource discount on all unit upgrades.",
                slot: .military,
                required: .urbanization,
                obsolete: nil,
                replace: [.professionalArmy, .retinues],
                flavours: []
            )

        case .totalWar:
            // https://civilization.fandom.com/wiki/Total_War_(Civ6)
            return PolicyCardTypeData(
                name: "Total War",
                bonus: "Yields gained from pillaging and coastal raids are +100%. +50% rewards for plundering [TradeRoute] Trade Routes.",
                slot: .military,
                required: .scorchedEarth,
                obsolete: nil,
                replace: [.raid, .sack],
                flavours: []
            )

        case .expropriation:
            // https://civilization.fandom.com/wiki/Expropriation_(Civ6)
            return PolicyCardTypeData(
                name: "Expropriation",
                bonus: "Settler cost reduced by 50%. Plot purchase cost reduced by 20%.",
                slot: .economic,
                required: .scorchedEarth,
                obsolete: nil,
                replace: [.colonization, .landSurveyors],
                flavours: []
            )

        case .militaryOrganization:
            // https://civilization.fandom.com/wiki/Military_Organization_(Civ6)
            return PolicyCardTypeData(
                name: "Military Organization",
                bonus: "+2 [GreatGeneral] Great General points for every Armory and +4 [GreatGeneral] Great General points for every Military Academy. [GreatGeneral] Great Generals receive +2 [Movement] Movement.",
                slot: .wildcard,
                required: .scorchedEarth,
                obsolete: nil,
                replace: [.strategos],
                flavours: []
            )

            // ////////////////////
            // modern

        case .resourceManagement:
            // https://civilization.fandom.com/wiki/Resource_Management_(Civ6)
            return PolicyCardTypeData(
                name: "Resource Management",
                bonus: "All improved [Aluminum] Aluminum and [Oil] Oil resources yield 1 additional resource per turn.",
                slot: .military,
                required: .conservation,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .propaganda:
            // https://civilization.fandom.com/wiki/Propaganda_(Civ6)
            return PolicyCardTypeData(
                name: "Propaganda",
                bonus: "Accumulate 25% less war weariness than usual.",
                slot: .military,
                required: .massMedia,
                obsolete: nil,
                replace: [.retainers],
                flavours: []
            )

        case .leveeEnMasse:
            // https://civilization.fandom.com/wiki/Lev%C3%A9e_en_Masse_(Civ6)
            return PolicyCardTypeData(
                name: "Levée en Masse",
                bonus: "Unit maintenance cost reduced by 2 [Gold] Gold per unit.",
                slot: .military,
                required: .mobilization,
                obsolete: nil,
                replace: [.conscription],
                flavours: []
            )

        case .laissezFaire:
            // https://civilization.fandom.com/wiki/Laissez-Faire_(Civ6)
            return PolicyCardTypeData(
                name: "Laissez-Faire",
                bonus: "+2 Great Merchant Great Merchant points for every Bank and +4 Great Merchant Great Merchant points for every Stock Exchange. +2 Great Admiral Great Admiral points for every Shipyard and +4 Great Admiral Great Admiral points for every Seaport.",
                slot: .wildcard,
                required: .capitalism,
                obsolete: nil,
                replace: [.travelingMerchants],
                flavours: []
            )

        case .marketEconomy:
            // https://civilization.fandom.com/wiki/Market_Economy_(Civ6)
            return PolicyCardTypeData(
                name: "Market Economy",
                bonus: "Your international [TradeRoute] Trade Routes provide +1 [Gold] Gold, +2 [Culture] Culture, and +2 [Science] Science per Strategic Resource improved at the destination.",
                slot: .economic,
                required: .capitalism,
                obsolete: nil,
                replace: [.tradeConfederation],
                flavours: []
            )

        case .policyState:
            // https://civilization.fandom.com/wiki/Police_State_(Civ6)
            return PolicyCardTypeData(
                name: "Police State",
                bonus: "Enemy Spies level reduced by 2 in your lands. However all cities suffer -2 Loyalty per turn.",
                slot: .diplomatic,
                required: .ideology,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .nobelPrize:
            // https://civilization.fandom.com/wiki/Nobel_Prize_(Civ6)
            return PolicyCardTypeData(
                name: "Nobel Prize",
                bonus: "+4 [GreatScientist] Great Scientist points per turn.",
                slot: .wildcard,
                required: .nuclearProgram,
                obsolete: nil,
                replace: [.inspiration],
                flavours: []
            )

        case .scienceFoundations:
            // https://civilization.fandom.com/wiki/Science_Foundations_(Civ6)
            return PolicyCardTypeData(
                name: "Science Foundations",
                bonus: "+2 [GreatScientist] Great Scientist points for every University and +4 [GreatScientist] Great Scientist points for every Research Lab. +2 [GreatEngineer] Great Engineer points for every Factory and +4 [GreatEngineer] Great Engineer points for every Power Plant.",
                slot: .wildcard,
                required: .nuclearProgram,
                obsolete: nil,
                replace: [.inspiration],
                flavours: []
            )

        case .nuclearEspionage:
            // https://civilization.fandom.com/wiki/Nuclear_Espionage_(Civ6)
            return PolicyCardTypeData(
                name: "Nuclear Espionage",
                bonus: "Spies who steal a tech boost without being detected gain an extra boost.",
                slot: .diplomatic,
                required: .nuclearProgram,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .economicUnion:
            // https://civilization.fandom.com/wiki/Economic_Union_(Civ6)
            return PolicyCardTypeData(
                name: "Economic Union",
                bonus: "+100% Commercial Hub and Harbor district adjacency bonuses.",
                slot: .economic,
                required: .suffrage,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .theirFinestHour:
            // https://civilization.fandom.com/wiki/Their_Finest_Hour_(Civ6)
            return PolicyCardTypeData(
                name: "Their Finest Hour",
                bonus: "All units +5 [Strength] Combat Strength when fighting in or adjacent to their home territory.",
                slot: .wildcard,
                required: .suffrage,
                obsolete: nil,
                replace: [.strategicAirForce],
                flavours: []
            )

        case .arsenalOfDemocracy:
            // https://civilization.fandom.com/wiki/Arsenal_of_Democracy_(Civ6)
            return PolicyCardTypeData(
                name: "Arsenal of Democracy",
                bonus: "Your [TradeRoute] Trade Routes to an Ally's city provide +4 [Food] Food and +4 [Production] Production for both cities. Alliance Points with each ally grow 25% faster.",
                slot: .diplomatic,
                required: .suffrage,
                obsolete: nil,
                replace: [.wisselbanken],
                flavours: []
            )

        case .newDeal:
            // https://civilization.fandom.com/wiki/New_Deal_(Civ6)
            return PolicyCardTypeData(
                name: "New Deal",
                bonus: "+4 [Housing] Housing and +2 [Amenities] Amenities to all cities with at least 3 specialty districts.",
                slot: .economic,
                required: .suffrage,
                obsolete: nil,
                replace: [.medinaQuarter, .liberalism],
                flavours: []
            )

        case .lightningWarfare:
            // https://civilization.fandom.com/wiki/Lightning_Warfare_(Civ6)
            return PolicyCardTypeData(
                name: "Lightning Warfare",
                bonus: "+50% [Production] Production for all heavy and light cavalry units.",
                slot: .military,
                required: .totalitarianism,
                obsolete: nil,
                replace: [.chivalry, .maneuver],
                flavours: []
            )

        case .thirdAlternative:
            // https://civilization.fandom.com/wiki/Third_Alternative_(Civ6)
            return PolicyCardTypeData(
                name: "Third Alternative",
                bonus: "+2 [Culture] Culture and +4 [Gold] Gold from each Research Lab, Military Academy, Coal Power Plant, Oil Power Plant, and Nuclear Power Plant.",
                slot: .military,
                required: .totalitarianism,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .martialLaw:
            // https://civilization.fandom.com/wiki/Martial_Law_(Civ6)
            return PolicyCardTypeData(
                name: "Martial Law",
                bonus: "Accumulate 25% less war weariness than usual. Cities with a garrisoned unit get +4 Loyalty per turn.",
                slot: .wildcard,
                required: .totalitarianism,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .gunboatDiplomacy:
            // https://civilization.fandom.com/wiki/Gunboat_Diplomacy_(Civ6)
            return PolicyCardTypeData(
                name: "Gunboat Diplomacy",
                bonus: "Open Borders with all City-States, and +4 influence points per turn towards earning Envoy Envoys.",
                slot: .diplomatic,
                required: .totalitarianism,
                obsolete: nil,
                replace: [.charismaticLeader],
                flavours: []
            )

        case .fiveYearPlan:
            // https://civilization.fandom.com/wiki/Five-Year_Plan_(Civ6)
            return PolicyCardTypeData(
                name: "Five-Year Plan",
                bonus: "+100% Campus and Industrial Zone district adjacency bonuses.",
                slot: .economic,
                required: .classStruggle,
                obsolete: nil,
                replace: [.craftsmen, .naturalPhilosophy],
                flavours: []
            )

        case .collectivization:
            // https://civilization.fandom.com/wiki/Collectivization_(Civ6)
            return PolicyCardTypeData(
                name: "Collectivization",
                bonus: "+2 [Production] Production and +4 [Food] Food from domestic [TradeRoute] Trade Routes.",
                slot: .economic,
                required: .classStruggle,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .patrioticWar:
            // https://civilization.fandom.com/wiki/Patriotic_War_(Civ6)
            return PolicyCardTypeData(
                name: "Patriotic War",
                bonus: "+100% [Production] Production towards Modern, Atomic and Information era support units.",
                slot: .military,
                required: .classStruggle,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .defenseOfTheMotherland:
            // https://civilization.fandom.com/wiki/Defense_of_the_Motherland_(Civ6)
            return PolicyCardTypeData(
                name: "Defense of the Motherland",
                bonus: "No war weariness from combat in your territory. +100% [Production] Production for Modern, Atomic, and Information era support units.",
                slot: .wildcard,
                required: .classStruggle,
                obsolete: nil,
                replace: [],
                flavours: []
            )

            // ///////////////////////
            // atomic

        case .cryptography:
            // https://civilization.fandom.com/wiki/Cryptography_(Civ6)
            return PolicyCardTypeData(
                name: "Cryptography",
                bonus: "Enemy Spy level reduced by 2 in your lands. Your Spy level is increased by 1 for offensive operations.",
                slot: .diplomatic,
                required: .coldWar,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .internationalWaters:
            // https://civilization.fandom.com/wiki/International_Waters_(Civ6)
            return PolicyCardTypeData(
                name: "International Waters",
                bonus: "+100% [Production] Production towards all naval units, excluding Carriers.",
                slot: .military,
                required: .coldWar,
                obsolete: nil,
                replace: [.maritimeIndustries, .pressGangs],
                flavours: []
            )

        case .containment:
            // https://civilization.fandom.com/wiki/Containment_(Civ6)
            return PolicyCardTypeData(
                name: "Containment",
                bonus: "Each Envoy Envoy you send to a City-State counts as two, if its Suzerain has different government than you.",
                slot: .diplomatic,
                required: .coldWar,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .heritageTourism:
            // https://civilization.fandom.com/wiki/Heritage_Tourism_(Civ6)
            return PolicyCardTypeData(
                name: "Heritage Tourism",
                bonus: "+100% [Tourism] Tourism from Great Works and [Artifact] Artifacts.",
                slot: .economic,
                required: .culturalHeritage,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .sportsMedia:
            // https://civilization.fandom.com/wiki/Sports_Media_(Civ6)
            return PolicyCardTypeData(
                name: "Sports Media",
                bonus: "+100% Theater Square district adjacency bonuses, and Stadiums generate +1 [Amenities] Amenity.",
                slot: .economic,
                required: .professionalSports,
                obsolete: nil,
                replace: [.aesthetics, .grandOpera],
                flavours: []
            )

        case .militaryFirst:
            // https://civilization.fandom.com/wiki/Military_First_(Civ6)
            return PolicyCardTypeData(
                name: "Military First",
                bonus: "+50% [Production] Production toward all melee, anti-cavalry and ranged units.",
                slot: .military,
                required: .rapidDeployment,
                obsolete: nil,
                replace: [.grandeArmee],
                flavours: []
            )

        case .satelliteBroadcasts:
            // https://civilization.fandom.com/wiki/Satellite_Broadcasts_(Civ6)
            return PolicyCardTypeData(
                name: "Satellite Broadcasts",
                bonus: "+200% [Tourism] Tourism from Great Work of Music Great Works of Music.",
                slot: .economic,
                required: .spaceRace,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .musicCensorship:
            // https://civilization.fandom.com/wiki/Music_Censorship_(Civ6)
            return PolicyCardTypeData(
                name: "Music Censorship",
                bonus: "Rock Bands from other players may not enter your territory. -1 [Amenities] Amenity in all of your cities with 10 or more [Citizen] Population.",
                slot: .diplomatic,
                required: .spaceRace,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .integratedSpaceCell:
            // https://civilization.fandom.com/wiki/Integrated_Space_Cell_(Civ6)
            return PolicyCardTypeData(
                name: "Integrated Space Cell",
                bonus: "+15% [Production] Production towards Space Race projects if a city has either a Military Academy or a Seaport.",
                slot: .military,
                required: .spaceRace,
                obsolete: nil,
                replace: [.militaryResearch],
                flavours: []
            )

        case .secondStrikeCapability:
            // https://civilization.fandom.com/wiki/Second_Strike_Capability_(Civ6)
            return PolicyCardTypeData(
                name: "Second Strike Capability",
                bonus: "Nuclear Device maintenance reduced by 50% [Gold] Gold per turn.",
                slot: .military,
                required: .coldWar,
                obsolete: nil,
                replace: [],
                flavours: []
            )

            // /////////////////////////////////
            // information

        case .strategicAirForce:
            // https://civilization.fandom.com/wiki/Strategic_Air_Force_(Civ6)
            return PolicyCardTypeData(
                name: "Strategic Air Force",
                bonus: "+50% [Production] Production toward all air units and toward Carriers.",
                slot: .military,
                required: .globalization,
                obsolete: nil,
                replace: [.theirFinestHour],
                flavours: []
            )

        case .ecommerce:
            // https://civilization.fandom.com/wiki/Ecommerce_(Civ6)
            return PolicyCardTypeData(
                name: "Ecommerce",
                bonus: "+2 [Production] Production and +5 [Gold] Gold from all [TradeRoute] Trade Routes.",
                slot: .economic,
                required: .globalization,
                obsolete: nil,
                replace: [.triangularTrade],
                flavours: []
            )

        case .internationalSpaceAgency:
            // https://civilization.fandom.com/wiki/International_Space_Agency_(Civ6)
            return PolicyCardTypeData(
                name: "International Space Agency",
                bonus: "5% [Science] Science per City-State you are the Suzerain of.",
                slot: .diplomatic,
                required: .globalization,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .onlineCommunities:
            // https://civilization.fandom.com/wiki/Online_Communities_(Civ6)
            return PolicyCardTypeData(
                name: "Online Communities",
                bonus: "+50% [Tourism] Tourism output to civilizations to which you have a [TradeRoute] Trade Route.",
                slot: .economic,
                required: .socialMedia,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .collectiveActivism:
            // https://civilization.fandom.com/wiki/Collective_Activism_(Civ6)
            return PolicyCardTypeData(
                name: "Collective Activism",
                bonus: "5% [Culture] Culture per City-State you are the Suzerain of.",
                slot: .diplomatic,
                required: .socialMedia,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .afterActionReports:
            // https://civilization.fandom.com/wiki/After_Action_Reports_(Civ6)
            return PolicyCardTypeData(
                name: "After Action Reports",
                bonus: "All units gain +50% combat experience.",
                slot: .military,
                required: .rapidDeployment,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .communicationsOffice:
            // https://civilization.fandom.com/wiki/Communications_Office_(Civ6)
            return PolicyCardTypeData(
                name: "Communications Office",
                bonus: "Governors provide +1 Loyalty per turn to their city, per Promotion the Governor has.",
                slot: .diplomatic,
                required: .socialMedia,
                obsolete: nil,
                replace: [.praetorium],
                flavours: []
            )

        case .aerospaceContractors:
            // https://civilization.fandom.com/wiki/Aerospace_Contractors_(Civ6)
            return PolicyCardTypeData(
                name: "Aerospace Contractors",
                bonus: "Cities with a Spaceport gain +3 [Aluminum] Aluminum per turn and +3 [Power] Power.",
                slot: .wildcard,
                required: .exodusImperative,
                obsolete: nil,
                replace: [],
                flavours: []
            )

            // //////////////////////////
            // future

        case .spaceTourism:
            // https://civilization.fandom.com/wiki/Space_Tourism_(Civ6)
            return PolicyCardTypeData(
                name: "Space Tourism",
                bonus: "[Tourism] Tourism from other players is reduced by 20% versus your civilization.",
                slot: .wildcard,
                required: .exodusImperative,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .hallyu:
            // https://civilization.fandom.com/wiki/Hallyu_(Civ6)
            return PolicyCardTypeData(
                name: "Hallyu",
                bonus: "Your Rock Band units can choose from any possible [Promotion] Promotion.",
                slot: .wildcard,
                required: .culturalHegemony,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .nonStateActors:
            // https://civilization.fandom.com/wiki/Non-State_Actors_(Civ6)
            return PolicyCardTypeData(
                name: "Non-State Actors",
                bonus: "Your Spy units can choose from any possible [Promotion] Promotion.",
                slot: .wildcard,
                required: .culturalHegemony,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .integratedAttackLogistics:
            // https://civilization.fandom.com/wiki/Integrated_Attack_Logistics_(Civ6)
            return PolicyCardTypeData(
                name: "Integrated Attack Logistics",
                bonus: "+1 [Movement] Movement if starting turn in enemy territory. +50% [Production] Production for Giant Death Robots.",
                slot: .wildcard,
                required: .informationWarfare,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .rabblerousing:
            // https://civilization.fandom.com/wiki/Rabblerousing_(Civ6)
            return PolicyCardTypeData(
                name: "Rabblerousing",
                bonus: "When you reduce a player's Diplomatic Victory points in the World Congress, get 50% of your spent [DiplomaticFavor] Diplomatic Favor back. +1 [DiplomaticFavor] Diplomatic Favor per turn.",
                slot: .wildcard,
                required: .informationWarfare,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .diplomaticCapital:
            // https://civilization.fandom.com/wiki/Diplomatic_Capital_(Civ6)
            return PolicyCardTypeData(
                name: "Diplomatic Capital",
                bonus: "+4 [DiplomaticFavor] Diplomatic Favor per turn.",
                slot: .wildcard,
                required: .smartPowerDoctrine,
                obsolete: nil,
                replace: [],
                flavours: []
            )

        case .globalCoalition:
            // https://civilization.fandom.com/wiki/Global_Coalition_(Civ6)
            return PolicyCardTypeData(
                name: "Global Coalition",
                bonus: "+7 [Strength] Combat Strength for units in friendly territory.",
                slot: .wildcard,
                required: .smartPowerDoctrine,
                obsolete: nil,
                replace: [],
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
        let replace: [PolicyCardType]
        let flavours: [Flavor]
    }

    public func obsoleteCivic() -> CivicType? {

        return self.data().obsolete
    }

    public func replacePolicyCards() -> [PolicyCardType] {

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
