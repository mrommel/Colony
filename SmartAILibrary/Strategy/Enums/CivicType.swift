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
    public let districtTypes: [DistrictType]
    public let policyCards: [PolicyCardType]
    public let governments: [GovernmentType]
}

// swiftlint:disable type_body_length
public enum CivicType: String, Codable {

    case none

    // ancient
    case stateWorkforce
    case craftsmanship
    case codeOfLaws // no eureka
    case earlyEmpire
    case foreignTrade
    case mysticism
    case militaryTradition

    // classical
    case defensiveTactics // # Be the target of a Declaration of War.
    case gamesAndRecreation
    case politicalPhilosophy // # Meet 3 City-States
    case recordedHistory // # Build 2 Campus Districts.
    case dramaAndPoetry
    case theology
    case militaryTraining

    // medieval
    case navalTradition // # Found a Religion.
    case feudalism // # Build 6 Farms.
    case medievalFaires // # Maintain 4 Trade Routes.
    case civilService // # Grow a city to 10 Citizen Population.
    case guilds // # Build 2 Markets.
    case mercenaries // # Have 8 land combat units in your military.
    case divineRight // # Build 2 Temples.

    // renaissance
    case enlightenment // # Build 3 Great People.
    case humanism // # Earn a Great Artist.
    case mercantilism // # Earn a Great Merchant.
    case diplomaticService // # Have an alliance with another civilization.
    case exploration // # Build 2 Caravels.
    case reformedChurch // # Have 6 cities following your Religion.

    // industrial
    case civilEngineering // # Build 7 different specialty Districts.
    case colonialism // # Research the Astronomy technology.
    case nationalism // # Declare war using a Casus Belli.
    case operaAndBallet // # Build an Art Museum.
    case naturalHistory // # Build an Archaeological Museum.
    case urbanization // # Grow a city to 15 CitizenPopulation.
    case scorchedEarth // # Build 2 Field Cannons.

    // modern
    case conservation // # Have a Neighborhood district with a Breathtaking Appeal.
    case massMedia
    case mobilization // # Have 3 Corps in your military.
    case capitalism // # Build 3 Stock Exchanges.
    case ideology
    case nuclearProgram // # Build a Research Lab.
    case suffrage // # Build 4 Sewers.
    case totalitarianism // # Build 3 Military Academies.
    case classStruggle // # Build 3 Factories.

    // atomic
    case culturalHeritage // # Have a Themed Museum.
    case coldWar // # Research Nuclear Fission.
    case professionalSports // # Build 4 Entertainment Complex Districts.
    case rapidDeployment // # Build an Aerodrome or Airstrip on a foreign continent.
    case spaceRace // # Build a Spaceport district.

    // information
    case environmentalism // #
    case globalization // #
    case socialMedia // #

    public static var all: [CivicType] {
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
            .culturalHeritage, .coldWar, .professionalSports, .rapidDeployment, .spaceRace,

            // information
            .environmentalism, .globalization, .socialMedia
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func inspirationSummary() -> String {

        return self.data().inspirationSummary
    }

    public func inspirationDescription() -> String {

        return self.data().inspirationDescription
    }

    public func quoteTexts() -> [String] {

        return self.data().quoteTexts
    }

    public func era() -> EraType {

        return self.data().era
    }

    public func cost() -> Int {

        return self.data().cost
    }

    public func required() -> [CivicType] {

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

    public func governorTitle() -> Bool {

        return self.data().governorTitle
    }

    public func achievements() -> CivicAchievements {

        let buildings = BuildingType.all.filter({
            if let civic = $0.requiredCivic() {
                return civic == self
            } else {
                return false
            }
        })

        let units = UnitType.all.filter({

            if $0.civilization() != nil {
                return false
            }

            if let civic = $0.requiredCivic() {
                return civic == self
            } else {
                return false
            }
        })

        // districts
        let districts = DistrictType.all.filter({
            if let district = $0.requiredCivic() {
                return district == self
            } else {
                return false
            }
        })

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

        let governments = GovernmentType.all.filter({
            return self == $0.required()
        })

        return CivicAchievements(
            buildingTypes: buildings,
            unitTypes: units,
            wonderTypes: wonders,
            buildTypes: [],
            districtTypes: districts,
            policyCards: policyCards,
            governments: governments
        )
    }

    // MARK: private

    private struct CivicTypeData {

        let name: String
        let inspirationSummary: String
        let inspirationDescription: String
        let quoteTexts: [String]
        let era: EraType
        let cost: Int
        let required: [CivicType]
        let flavors: [Flavor]
        let governorTitle: Bool
    }

    // swiftlint:disable line_length
    // swiftlint:disable function_body_length
    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Civics.xml
    // https://civilization.fandom.com/wiki/Module:Data/Civ6/RF/Boosts
    private func data() -> CivicTypeData {

        switch self {

        case .none:
            return CivicTypeData(
                name: "---",
                inspirationSummary: "---",
                inspirationDescription: "-",
                quoteTexts: [],
                era: .ancient,
                cost: -1,
                required: [],
                flavors: [],
                governorTitle: false
            )

            // ancient
        case .codeOfLaws:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_CODE_OF_LAWS_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_CODE_OF_LAWS_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_CODE_OF_LAWS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_CODE_OF_LAWS_QUOTE1",
                    "TXT_KEY_CIVIC_CODE_OF_LAWS_QUOTE2"
                ],
                era: .ancient,
                cost: 20,
                required: [],
                flavors: [],
                governorTitle: false
            )
        case .stateWorkforce:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_STATE_WORKFORCE_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_STATE_WORKFORCE_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_STATE_WORKFORCE_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_STATE_WORKFORCE_QUOTE1",
                    "TXT_KEY_CIVIC_STATE_WORKFORCE_QUOTE2"
                ],
                era: .ancient,
                cost: 70,
                required: [.craftsmanship],
                flavors: [],
                governorTitle: true
            )
        case .craftsmanship:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_CRAFTMANSHIP_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_CRAFTMANSHIP_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_CRAFTMANSHIP_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_CRAFTMANSHIP_QUOTE1",
                    "TXT_KEY_CIVIC_CRAFTMANSHIP_QUOTE2"
                ],
                era: .ancient,
                cost: 40,
                required: [.codeOfLaws],
                flavors: [],
                governorTitle: false
            )
        case .earlyEmpire:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_EARLY_EMPIRE_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_EARLY_EMPIRE_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_EARLY_EMPIRE_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_EARLY_EMPIRE_QUOTE1",
                    "TXT_KEY_CIVIC_EARLY_EMPIRE_QUOTE2"
                ],
                era: .ancient,
                cost: 70,
                required: [.foreignTrade],
                flavors: [],
                governorTitle: true
            )
        case .foreignTrade:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_FOREIGN_TRADE_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_FOREIGN_TRADE_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_FOREIGN_TRADE_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_FOREIGN_TRADE_QUOTE1",
                    "TXT_KEY_CIVIC_FOREIGN_TRADE_QUOTE2"
                ],
                era: .ancient,
                cost: 40,
                required: [.codeOfLaws],
                flavors: [],
                governorTitle: false
            )
        case .mysticism:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_MYSTICISM_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_MYSTICISM_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_MYSTICISM_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_MYSTICISM_QUOTE1",
                    "TXT_KEY_CIVIC_MYSTICISM_QUOTE2"
                ],
                era: .ancient,
                cost: 50,
                required: [.foreignTrade],
                flavors: [],
                governorTitle: false
            )
        case .militaryTradition:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_MILITARY_TRADITION_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_MILITARY_TRADITION_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_MILITARY_TRADITION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_MILITARY_TRADITION_QUOTE1",
                    "TXT_KEY_CIVIC_MILITARY_TRADITION_QUOTE2"
                ],
                era: .ancient,
                cost: 50,
                required: [.craftsmanship],
                flavors: [],
                governorTitle: false
            )

            // classical
        case .defensiveTactics:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_DEFENSIVE_TACTICS_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_DEFENSIVE_TACTICS_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_DEFENSIVE_TACTICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_DEFENSIVE_TACTICS_QUOTE1",
                    "TXT_KEY_CIVIC_DEFENSIVE_TACTICS_QUOTE2"
                ],
                era: .classical,
                cost: 175,
                required: [.gamesAndRecreation, .politicalPhilosophy],
                flavors: [],
                governorTitle: true
            )
        case .gamesAndRecreation:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_GAMES_AND_RECREATION_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_GAMES_AND_RECREATION_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_GAMES_AND_RECREATION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_GAMES_AND_RECREATION_QUOTE1",
                    "TXT_KEY_CIVIC_GAMES_AND_RECREATION_QUOTE2"
                ],
                era: .classical,
                cost: 110,
                required: [.stateWorkforce],
                flavors: [],
                governorTitle: false
            )
        case .politicalPhilosophy:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_POLITICAL_PHILOSOPHY_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_POLITICAL_PHILOSOPHY_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_POLITICAL_PHILOSOPHY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_POLITICAL_PHILOSOPHY_QUOTE1",
                    "TXT_KEY_CIVIC_POLITICAL_PHILOSOPHY_QUOTE2"
                ],
                era: .classical,
                cost: 110,
                required: [.stateWorkforce, .earlyEmpire],
                flavors: [],
                governorTitle: false
            )
        case .recordedHistory:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_RECORDED_HISTORY_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_RECORDED_HISTORY_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_RECORDED_HISTORY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_RECORDED_HISTORY_QUOTE1",
                    "TXT_KEY_CIVIC_RECORDED_HISTORY_QUOTE2"
                ],
                era: .classical,
                cost: 175,
                required: [.politicalPhilosophy, .dramaAndPoetry],
                flavors: [],
                governorTitle: true
            )
        case .dramaAndPoetry:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_DRAMA_AND_POETRY_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_DRAMA_AND_POETRY_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_DRAMA_AND_POETRY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_DRAMA_AND_POETRY_QUOTE1",
                    "TXT_KEY_CIVIC_DRAMA_AND_POETRY_QUOTE2"
                ],
                era: .classical,
                cost: 110,
                required: [.earlyEmpire],
                flavors: [],
                governorTitle: false
            )
        case .theology:
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_THEOLOGY_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_THEOLOGY_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_THEOLOGY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_THEOLOGY_QUOTE1",
                    "TXT_KEY_CIVIC_THEOLOGY_QUOTE2"
                ],
                era: .classical,
                cost: 120,
                required: [.dramaAndPoetry, .mysticism],
                flavors: [],
                governorTitle: false
            )
        case .militaryTraining:
            // https://civilization.fandom.com/wiki/Military_Training_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_MILITARY_TRAINING_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_MILITARY_TRAINING_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_MILITARY_TRAINING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_MILITARY_TRAINING_QUOTE1",
                    "TXT_KEY_CIVIC_MILITARY_TRAINING_QUOTE2"
                ],
                era: .classical,
                cost: 120,
                required: [.militaryTradition, .gamesAndRecreation],
                flavors: [],
                governorTitle: false
            )

            // medieval

        case .navalTradition:
            // https://civilization.fandom.com/wiki/Naval_Tradition_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_NAVAL_TRADITION_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_NAVAL_TRADITION_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_NAVAL_TRADITION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_NAVAL_TRADITION_QUOTE1",
                    "TXT_KEY_CIVIC_NAVAL_TRADITION_QUOTE2"
                ],
                era: .medieval,
                cost: 200,
                required: [.defensiveTactics],
                flavors: [],
                governorTitle: false
            )

        case .medievalFaires:
            // https://civilization.fandom.com/wiki/Medieval_Faires_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_MEDIEVAL_FAIRES_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_MEDIEVAL_FAIRES_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_MEDIEVAL_FAIRES_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_MEDIEVAL_FAIRES_QUOTE1",
                    "TXT_KEY_CIVIC_MEDIEVAL_FAIRES_QUOTE2"
                ],
                era: .medieval,
                cost: 385,
                required: [.feudalism],
                flavors: [],
                governorTitle: true
            )

        case .guilds:
            // https://civilization.fandom.com/wiki/Guilds_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_GUILDS_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_GUILDS_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_GUILDS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_GUILDS_QUOTE1",
                    "TXT_KEY_CIVIC_GUILDS_QUOTE2"
                ],
                era: .medieval,
                cost: 385,
                required: [.feudalism, .civilService],
                flavors: [],
                governorTitle: true
            )

        case .feudalism:
            // https://civilization.fandom.com/wiki/Feudalism_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_FEUDALISM_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_FEUDALISM_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_FEUDALISM_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_FEUDALISM_QUOTE1",
                    "TXT_KEY_CIVIC_FEUDALISM_QUOTE2"
                ],
                era: .medieval,
                cost: 275,
                required: [.defensiveTactics],
                flavors: [],
                governorTitle: false
            )

        case .civilService:
            // https://civilization.fandom.com/wiki/Civil_Service_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_CIVIL_SERVICE_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_CIVIL_SERVICE_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_CIVIL_SERVICE_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_CIVIL_SERVICE_QUOTE1",
                    "TXT_KEY_CIVIC_CIVIL_SERVICE_QUOTE2"
                ],
                era: .medieval,
                cost: 275,
                required: [.defensiveTactics, .recordedHistory],
                flavors: [],
                governorTitle: false
            )

        case .mercenaries:
            // https://civilization.fandom.com/wiki/Mercenaries_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_MERCENARIES_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_MERCENARIES_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_MERCENARIES_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_MERCENARIES_QUOTE1",
                    "TXT_KEY_CIVIC_MERCENARIES_QUOTE2"
                ],
                era: .medieval,
                cost: 290,
                required: [.feudalism, .militaryTraining],
                flavors: [],
                governorTitle: false
            )
        case .divineRight:
            // https://civilization.fandom.com/wiki/Divine_Right_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_DIVINE_RIGHT_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_DIVINE_RIGHT_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_DIVINE_RIGHT_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_DIVINE_RIGHT_QUOTE1",
                    "TXT_KEY_CIVIC_DIVINE_RIGHT_QUOTE2"
                ],
                era: .medieval,
                cost: 290,
                required: [.civilService, .theology],
                flavors: [],
                governorTitle: false
            )

            // renaissance

        case .humanism:
            // https://civilization.fandom.com/wiki/Humanism_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_HUMANISM_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_HUMANISM_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_HUMANISM_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_HUMANISM_QUOTE1",
                    "TXT_KEY_CIVIC_HUMANISM_QUOTE2"
                ],
                era: .renaissance,
                cost: 540,
                required: [.guilds, .medievalFaires],
                flavors: [],
                governorTitle: false
            )

        case .mercantilism:
            // https://civilization.fandom.com/wiki/Mercantilism_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_MERCANTILISM_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_MERCANTILISM_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_MERCANTILISM_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_MERCANTILISM_QUOTE1",
                    "TXT_KEY_CIVIC_MERCANTILISM_QUOTE2"
                ],
                era: .renaissance,
                cost: 655,
                required: [.humanism],
                flavors: [], governorTitle: false
            )

        case .enlightenment:
            // https://civilization.fandom.com/wiki/The_Enlightenment_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_ENLIGHTENMENT_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_ENLIGHTENMENT_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_ENLIGHTENMENT_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_ENLIGHTENMENT_QUOTE1",
                    "TXT_KEY_CIVIC_ENLIGHTENMENT_QUOTE2"
                ],
                era: .renaissance,
                cost: 655,
                required: [.diplomaticService],
                flavors: [],
                governorTitle: false
            )

        case .diplomaticService:
            // https://civilization.fandom.com/wiki/Diplomatic_Service_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_DIPLOMATIC_SERVICE_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_DIPLOMATIC_SERVICE_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_DIPLOMATIC_SERVICE_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_DIPLOMATIC_SERVICE_QUOTE1",
                    "TXT_KEY_CIVIC_DIPLOMATIC_SERVICE_QUOTE2"
                ],
                era: .renaissance,
                cost: 540,
                required: [.guilds],
                flavors: [],
                governorTitle: false
            )

        case .reformedChurch:
            // https://civilization.fandom.com/wiki/Reformed_Church_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_REFORMED_CHURCH_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_REFORMED_CHURCH_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_REFORMED_CHURCH_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_REFORMED_CHURCH_QUOTE1",
                    "TXT_KEY_CIVIC_REFORMED_CHURCH_QUOTE2"
                ],
                era: .renaissance,
                cost: 400,
                required: [.divineRight],
                flavors: [],
                governorTitle: false
            )

        case .exploration:
            // https://civilization.fandom.com/wiki/Exploration_(Civ6)
            return CivicTypeData(
                name: "TXT_KEY_CIVIC_EXPLORATION_TITLE",
                inspirationSummary: "TXT_KEY_CIVIC_EXPLORATION_EUREKA",
                inspirationDescription: "TXT_KEY_CIVIC_EXPLORATION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_CIVIC_EXPLORATION_QUOTE1",
                    "TXT_KEY_CIVIC_EXPLORATION_QUOTE2"
                ],
                era: .renaissance,
                cost: 400,
                required: [.mercenaries, .medievalFaires],
                flavors: [],
                governorTitle: false
            )

            // industrial
            
        case .civilEngineering:
            // https://civilization.fandom.com/wiki/Civil_Engineering_(Civ6)
            return CivicTypeData(
                name: "Civil Engineering",
                inspirationSummary: "Build 7 different specialty districts.",
                inspirationDescription: "Having constructed so many types of districts, your engineers have become skilled in city construction.",
                quoteTexts: [],
                era: .industrial,
                cost: 920,
                required: [.mercantilism],
                flavors: [],
                governorTitle: true
            )

        case .colonialism:
            // https://civilization.fandom.com/wiki/Colonialism_(Civ6)
            return CivicTypeData(
                name: "Colonialism",
                inspirationSummary: "Research the Astronomy technology.",
                inspirationDescription: "Your new knowledge of the heavens is helping your navy navigate and establish a global empire.",
                quoteTexts: [],
                era: .industrial,
                cost: 725,
                required: [.mercantilism],
                flavors: [],
                governorTitle: false
            )

        case .nationalism:
            // https://civilization.fandom.com/wiki/Nationalism_(Civ6)
            return CivicTypeData(
                name: "Nationalism",
                inspirationSummary: "Declare war using a casus belli.",
                inspirationDescription: "Your people believe in the just nature of this war.  It has become an issue of national pride for us!",
                quoteTexts: [],
                era: .industrial,
                cost: 920,
                required: [.enlightenment],
                flavors: [],
                governorTitle: true
            )

        case .operaAndBallet:
            // https://civilization.fandom.com/wiki/Opera_and_Ballet_(Civ6)
            return CivicTypeData(
                name: "Opera and Ballet",
                inspirationSummary: "Build an Art Museum.",
                inspirationDescription: "The unveiling of a new museum is drawing people to the arts. Perhaps dance and opera are next?",
                quoteTexts: [],
                era: .industrial,
                cost: 725,
                required: [.enlightenment],
                flavors: [],
                governorTitle: false
            )

        case .naturalHistory:
            // https://civilization.fandom.com/wiki/Natural_History_(Civ6)
            return CivicTypeData(
                name: "Natural History",
                inspirationSummary: "Build an Archaeological Museum.",
                inspirationDescription: "With a museum now ready to hold your findings, it is time to see what you can discover out in the natural world.",
                quoteTexts: [],
                era: .industrial,
                cost: 870,
                required: [.colonialism],
                flavors: [],
                governorTitle: false
            )

        case .urbanization:
            // https://civilization.fandom.com/wiki/Urbanization_(Civ6)
            return CivicTypeData(
                name: "Urbanization",
                inspirationSummary: "Grow a city to 15 population.",
                inspirationDescription: "Your large city is getting overcrowded. It's time to start planning for some suburbs.",
                quoteTexts: [],
                era: .industrial,
                cost: 1060,
                required: [.civilEngineering, .nationalism],
                flavors: [],
                governorTitle: false
            )
        case .scorchedEarth:
            // https://civilization.fandom.com/wiki/Scorched_Earth_(Civ6)
            return CivicTypeData(
                name: "Scorched Earth",
                inspirationSummary: "Build 2 Field Cannons.",
                inspirationDescription: "Modern warfare is clearly a brutal affair. Your military doctrine is starting to reflect some of these principles of total war.",
                quoteTexts: [],
                era: .industrial,
                cost: 1060,
                required: [.nationalism],
                flavors: [],
                governorTitle: false
            )

            // modern

        case .conservation:
            // https://civilization.fandom.com/wiki/Conservation_(Civ6)
            return CivicTypeData(
                name: "Conservation",
                inspirationSummary: "Have a Neighborhood district with Breathtaking Appeal.",
                inspirationDescription: "The residents of your breathtaking new neighborhood clamor for a plan to conserve all the world’s natural treasures.",
                quoteTexts: [],
                era: .modern,
                cost: 1255,
                required: [.naturalHistory, .urbanization],
                flavors: [],
                governorTitle: false
            )

        case .massMedia:
            // https://civilization.fandom.com/wiki/Mass_Media_(Civ6)
            return CivicTypeData(
                name: "MassMedia",
                inspirationSummary: "Research Radio.",
                inspirationDescription: "The advent of radio beckons the start of a new era of communication.",
                quoteTexts: [],
                era: .modern,
                cost: 1410,
                required: [.urbanization],
                flavors: [],
                governorTitle: true
            )

        case .mobilization:
            // https://civilization.fandom.com/wiki/Mobilization_(Civ6)
            return CivicTypeData(
                name: "Mobilization",
                inspirationSummary: "Have 3 Corps in your military.",
                inspirationDescription: "Your military is better organized. Now time to take your force to the world stage.",
                quoteTexts: [],
                era: .modern,
                cost: 1410,
                required: [.urbanization],
                flavors: [],
                governorTitle: true
            )

        case .capitalism:
            // https://civilization.fandom.com/wiki/Capitalism_(Civ6)
            return CivicTypeData(
                name: "Capitalism",
                inspirationSummary: "Build 3 Stock Exchanges.",
                inspirationDescription: "With stock exchanges springing up in several cities, investment capital is plentiful and a market economy is ready to emerge.",
                quoteTexts: [],
                era: .modern,
                cost: 1560,
                required: [.massMedia],
                flavors: [],
                governorTitle: false
            )

        case .ideology:
            // https://civilization.fandom.com/wiki/Ideology_(Civ6)
            return CivicTypeData(
                name: "Ideology",
                inspirationSummary: "", // no inspiration !
                inspirationDescription: "", // no inspiration !
                quoteTexts: [],
                era: .modern,
                cost: 660,
                required: [.massMedia, .mobilization],
                flavors: [],
                governorTitle: false
            )

        case .nuclearProgram:
            // https://civilization.fandom.com/wiki/Nuclear_Program_(Civ6)
            return CivicTypeData(
                name: "Nuclear Program",
                inspirationSummary: "Build a Research Lab.",
                inspirationDescription: "With a dedicated research lab in place, your initiative to recruit scientists into a nuclear research program can commence.",
                quoteTexts: [],
                era: .modern,
                cost: 1715,
                required: [.ideology],
                flavors: [],
                governorTitle: false
            )

        case .suffrage:
            // https://civilization.fandom.com/wiki/Suffrage_(Civ6)
            return CivicTypeData(
                name: "Suffrage",
                inspirationSummary: "Build 4 Sewers.",
                inspirationDescription: "The women of your empire have clamored for proper sanitation. Having won that battle, they now need the right to vote.",
                quoteTexts: [],
                era: .modern,
                cost: 1715,
                required: [.ideology],
                flavors: [],
                governorTitle: false
            )

        case .totalitarianism:
            // https://civilization.fandom.com/wiki/Totalitarianism_(Civ6)
            return CivicTypeData(
                name: "Totalitarianism",
                inspirationSummary: "Build 3 Military Academies.",
                inspirationDescription: "The discipline instilled by your military academies is now second nature to your citizens.",
                quoteTexts: [],
                era: .modern,
                cost: 1715,
                required: [.ideology],
                flavors: [],
                governorTitle: false
            )

        case .classStruggle:
            // https://civilization.fandom.com/wiki/Class_Struggle_(Civ6)
            return CivicTypeData(
                name: "Class Struggle",
                inspirationSummary: "Build 3 Factories.",
                inspirationDescription: "Your factory workers clamor for better working conditions. It is time for the workers of the world to unite!",
                quoteTexts: [],
                era: .modern,
                cost: 1715,
                required: [.ideology],
                flavors: [],
                governorTitle: false
            )

            // atomic

        case .culturalHeritage:
            // https://civilization.fandom.com/wiki/Cultural_Heritage_(Civ6)
            return CivicTypeData(
                name: "Cultural Heritage",
                inspirationSummary: "Have a Themed Building.",
                inspirationDescription: "With a perfectly curated museum, your people's strong cultural heritage is on exhibit for all to see.",
                quoteTexts: [],
                era: .atomic,
                cost: 1955,
                required: [.conservation],
                flavors: [],
                governorTitle: false
            )

        case .coldWar:
            // https://civilization.fandom.com/wiki/Cold_War_(Civ6)
            return CivicTypeData(
                name: "Cold War",
                inspirationSummary: "Research the Nuclear Fission technology.",
                inspirationDescription: "The advent of nuclear weaponry will surely change the nature of armed conflict across the globe.",
                quoteTexts: [],
                era: .atomic,
                cost: 2185,
                required: [.ideology],
                flavors: [],
                governorTitle: false
            )

        case .professionalSports:
            // https://civilization.fandom.com/wiki/Professional_Sports_(Civ6)
            return CivicTypeData(
                name: "Professional Sports",
                inspirationSummary: "Build 4 Entertainment Complex districts.",
                inspirationDescription: "Your 4 cites with Entertainment Complexes want to compete in a new professional sports league.",
                quoteTexts: [],
                era: .atomic,
                cost: 2185,
                required: [.ideology],
                flavors: [],
                governorTitle: false
            )

        case .rapidDeployment:
            // https://civilization.fandom.com/wiki/Rapid_Deployment_(Civ6)
            return CivicTypeData(
                name: "Rapid Deployment",
                inspirationSummary: "",
                inspirationDescription: "With air bases now spanning the globe, our military is ready to be deployed anywhere in the world at a moment's notice.",
                quoteTexts: [],
                era: .atomic,
                cost: 2415,
                required: [.coldWar],
                flavors: [],
                governorTitle: false
            )

        case .spaceRace:
            // https://civilization.fandom.com/wiki/Space_Race_(Civ6)
            return CivicTypeData(
                name: "Space Race",
                inspirationSummary: "Build a Spaceport district.",
                inspirationDescription: "The unveiling of your new Spaceport has energized your people to push into space.",
                quoteTexts: [],
                era: .atomic,
                cost: 2415,
                required: [.coldWar],
                flavors: [],
                governorTitle: false
            )

        // information

        case .environmentalism:
            // https://civilization.fandom.com/wiki/Environmentalism_(Civ6)
            return CivicTypeData(
                name: "Environmentalism",
                inspirationSummary: "Build 2 Solar Farms.",
                inspirationDescription: "Build 2 Solar Farms.",
                quoteTexts: [],
                era: .information,
                cost: 2880,
                required: [.culturalHeritage, .rapidDeployment],
                flavors: [],
                governorTitle: false
            )

        case .globalization:
            // https://civilization.fandom.com/wiki/Globalization_(Civ6)
            return CivicTypeData(
                name: "Globalization",
                inspirationSummary: "Build 3 Airports.",
                inspirationDescription: "With so many airports in place, the world is truly becoming a smaller place.",
                quoteTexts: [
                    "”It has been said that arguing against globalization is like arguing against the laws of gravity.” [NEWLINE]– Kofi Annan",
                    "”One day there will be no borders, no boundaries, no flags and no countries and the only passport will be the heart.” [NEWLINE]– Carlos Santana"
                ],
                era: .information,
                cost: 2880,
                required: [.rapidDeployment, .spaceRace],
                flavors: [],
                governorTitle: true
            )

        case .socialMedia:
            // https://civilization.fandom.com/wiki/Social_Media_(Civ6)
            return CivicTypeData(
                name: "Social Media",
                inspirationSummary: "",
                inspirationDescription: "Research the Telecommunications technology.",
                quoteTexts: [
                    "”Which of all my important nothings shall I tell you first?”[NEWLINE]– Jane Austen",
                    "”Distracted from distraction by distraction!”[NEWLINE]– T.S. Eliot"
                ],
                era: .information,
                cost: 2880,
                required: [.professionalSports, .spaceRace],
                flavors: [Flavor(type: .growth, value: 6)],
                governorTitle: true
            )

        // governor titles: Near Future Governance
            /*
        <Replace Language="sv_SE" Tag="LOC_BOOST_TRIGGER_LONGDESC_SOCIAL_MEDIA">
            <Text>Your advances in communications technology are allowing people to congregate online.</Text>
        </Replace> */
        }
    }
}
