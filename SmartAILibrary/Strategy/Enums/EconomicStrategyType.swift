//
//  EconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum EconomicReconState: Int, Codable {

    case none
    case enough
    case neutral
    case needed
}

enum EconomicStrategyType: Int, Codable {

    case needRecon // ECONOMICAISTRATEGY_NEED_RECON
    case enoughRecon // ECONOMICAISTRATEGY_ENOUGH_RECON
    case reallyNeedReconSea // ECONOMICAISTRATEGY_REALLY_NEED_RECON_SEA
    case needReconSea // ECONOMICAISTRATEGY_NEED_RECON_SEA
    case enoughReconSea // ECONOMICAISTRATEGY_ENOUGH_RECON_SEA
    case earlyExpansion // ECONOMICAISTRATEGY_EARLY_EXPANSION
    case enoughExpansion // ECONOMICAISTRATEGY_ENOUGH_EXPANSION
    // ECONOMICAISTRATEGY_NEED_HAPPINESS
    // ECONOMICAISTRATEGY_NEED_HAPPINESS_CRITICAL
    // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_GROWTH
    // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_TILE_IMPROVEMENT
    case foundCity // ECONOMICAISTRATEGY_FOUND_CITY
    // ECONOMICAISTRATEGY_TRADE_WITH_CITY_STATE
    case needImprovementFood // ECONOMICAISTRATEGY_NEED_IMPROVEMENT_FOOD
    case needImprovementProduction // ECONOMICAISTRATEGY_NEED_IMPROVEMENT_PRODUCTION
    // ECONOMICAISTRATEGY_ONE_OR_FEWER_COASTAL_CITIES
    case losingMoney // ECONOMICAISTRATEGY_LOSING_MONEY
    // ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS
    case tooManyUnits // ECONOMICAISTRATEGY_TOO_MANY_UNITS
    // ECONOMICAISTRATEGY_ISLAND_START
    case expandToOtherContinents // ECONOMICAISTRATEGY_EXPAND_TO_OTHER_CONTINENTS
    // ECONOMICAISTRATEGY_REALLY_EXPAND_TO_OTHER_CONTINENTS
    // ECONOMICAISTRATEGY_MOSTLY_ON_THE_COAST
    // ECONOMICAISTRATEGY_EXPAND_LIKE_CRAZY
    // ECONOMICAISTRATEGY_GROW_LIKE_CRAZY
    // ECONOMICAISTRATEGY_GS_CULTURE
    // ECONOMICAISTRATEGY_GS_CONQUEST
    // ECONOMICAISTRATEGY_GS_DIPLOMACY
    // ECONOMICAISTRATEGY_GS_SPACESHIP
    // ECONOMICAISTRATEGY_GS_SPACESHIP_HOMESTRETCH
    // ECONOMICAISTRATEGY_NAVAL_MAP
    // ECONOMICAISTRATEGY_OFFSHORE_EXPANSION_MAP
    // ECONOMICAISTRATEGY_DEVELOPING_RELIGION
    // ECONOMICAISTRATEGY_TECH_LEADER
    // ECONOMICAISTRATEGY_NEED_ARCHAEOLOGISTS
    // ECONOMICAISTRATEGY_ENOUGH_ARCHAEOLOGISTS
    // ECONOMICAISTRATEGY_NEED_MUSEUMS
    // ECONOMICAISTRATEGY_NEED_GUILDS
    // ECONOMICAISTRATEGY_CONCERT_TOUR
    // ECONOMICAISTRATEGY_STARTED_PIETY

    static var all: [EconomicStrategyType] {
        return [
            .needRecon,
            .enoughRecon,
            .reallyNeedReconSea,
            .needReconSea,
            .enoughReconSea,
            .earlyExpansion,
            .enoughExpansion,
            // ECONOMICAISTRATEGY_NEED_HAPPINESS
            // ECONOMICAISTRATEGY_NEED_HAPPINESS_CRITICAL
            // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_GROWTH
            // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_TILE_IMPROVEMENT
            .foundCity,
            // ECONOMICAISTRATEGY_TRADE_WITH_CITY_STATE
            .needImprovementFood,
            .needImprovementProduction,
            // ECONOMICAISTRATEGY_ONE_OR_FEWER_COASTAL_CITIES
            .losingMoney,
            // ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS
            .tooManyUnits,
            // ECONOMICAISTRATEGY_ISLAND_START
            .expandToOtherContinents
            // ECONOMICAISTRATEGY_REALLY_EXPAND_TO_OTHER_CONTINENTS
            // ECONOMICAISTRATEGY_MOSTLY_ON_THE_COAST
            // ECONOMICAISTRATEGY_EXPAND_LIKE_CRAZY
            // ECONOMICAISTRATEGY_GROW_LIKE_CRAZY
            // ECONOMICAISTRATEGY_GS_CULTURE
            // ECONOMICAISTRATEGY_GS_CONQUEST
            // ECONOMICAISTRATEGY_GS_DIPLOMACY
            // ECONOMICAISTRATEGY_GS_SPACESHIP
            // ECONOMICAISTRATEGY_GS_SPACESHIP_HOMESTRETCH
            // ECONOMICAISTRATEGY_NAVAL_MAP
            // ECONOMICAISTRATEGY_OFFSHORE_EXPANSION_MAP
            // ECONOMICAISTRATEGY_DEVELOPING_RELIGION
            // ECONOMICAISTRATEGY_TECH_LEADER
            // ECONOMICAISTRATEGY_NEED_ARCHAEOLOGISTS
            // ECONOMICAISTRATEGY_ENOUGH_ARCHAEOLOGISTS
            // ECONOMICAISTRATEGY_NEED_MUSEUMS
            // ECONOMICAISTRATEGY_NEED_GUILDS
            // ECONOMICAISTRATEGY_CONCERT_TOUR
            // ECONOMICAISTRATEGY_STARTED_PIETY
        ]
    }

    private class EconimicStrategyTypeData {

        let dontUpdateCityFlavors: Bool
        let noMinorCivs: Bool
        let checkTriggerTurnCount: Int
        let minimumNumTurnsExecuted: Int
        let weightThreshold: Int
        let firstTurnExecuted: Int
        let techPrereq: TechType?
        let techObsolete: TechType?
        let advisor: AdvisorType
        let advisorCounsel: String?
        let advisorCounselImportance: Int
        let flavors: [Flavor]

        init(dontUpdateCityFlavors: Bool = false,
             noMinorCivs: Bool = false,
             checkTriggerTurnCount: Int = 0,
             minimumNumTurnsExecuted: Int = 0,
             weightThreshold: Int = 0,
             firstTurnExecuted: Int = 0,
             techPrereq: TechType? = nil,
             techObsolete: TechType? = nil,
             advisor: AdvisorType = .none,
             advisorCounsel: String? = nil,
             advisorCounselImportance: Int = 1,
             flavors: [Flavor]) {

            self.dontUpdateCityFlavors = dontUpdateCityFlavors
            self.noMinorCivs = noMinorCivs
            self.checkTriggerTurnCount = checkTriggerTurnCount
            self.minimumNumTurnsExecuted = minimumNumTurnsExecuted
            self.weightThreshold = weightThreshold
            self.firstTurnExecuted = firstTurnExecuted
            self.techPrereq = techPrereq
            self.techObsolete = techObsolete
            self.advisor = advisor
            self.advisorCounsel = advisorCounsel
            self.advisorCounselImportance = advisorCounselImportance
            self.flavors = flavors
        }
    }

    // https://github.com/wangxinyu199306/Civ5Configuration/blob/e598b37a4941c5974205c024e736270786349824/Gameplay/XML/AI/CIV5AIEconomicStrategies.xml
    private func data() -> EconimicStrategyTypeData {

        switch self {

        case .needRecon:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                firstTurnExecuted: 5,
                advisor: .foreign,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .recon, value: 100)
                ]
            )

        case .enoughRecon:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                firstTurnExecuted: 5,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_RECON",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .recon, value: -25)
                ]
            )

        case .reallyNeedReconSea:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                firstTurnExecuted: 50,
                flavors: [
                    Flavor(type: .navalRecon, value: 500),
                    Flavor(type: .naval, value: 100)
                ]
            )

        case .needReconSea:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                firstTurnExecuted: 5,
                advisor: .foreign,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON_SEA",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .navalRecon, value: 20)
                ]
            )

        case .enoughReconSea:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                firstTurnExecuted: 5,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_RECON",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .navalRecon, value: -200)
                ]
            )

        case .earlyExpansion:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 5,
                minimumNumTurnsExecuted: 10,
                weightThreshold: 3,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_EARLY_EXPANSION",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .navalGrowth, value: -5),
                    Flavor(type: .expansion, value: 75),
                    Flavor(type: .production, value: -4),
                    Flavor(type: .gold, value: -4),
                    Flavor(type: .science, value: -4),
                    Flavor(type: .culture, value: -4)
                ]
            )

        case .enoughExpansion:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 5,
                minimumNumTurnsExecuted: 1,
                weightThreshold: 1,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_EXPANSION",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .expansion, value: -30)
                ]
            )

            /*
             <Row>
                         <Type>ECONOMICAISTRATEGY_NEED_HAPPINESS</Type>
                         <WeightThreshold>2</WeightThreshold>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <Advisor>ECONOMIC</Advisor>
                         <AdvisorCounsel>TXT_KEY_ECONOMICAISTRATEGY_NEED_HAPPINESS</AdvisorCounsel>
                         <AdvisorCounselImportance>2</AdvisorCounselImportance>
                     </Row>
                     <Row>
                         <Type>ECONOMICAISTRATEGY_NEED_HAPPINESS_CRITICAL</Type>
                         <WeightThreshold>-3</WeightThreshold>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <Advisor>ECONOMIC</Advisor>
                         <AdvisorCounsel>TXT_KEY_ECONOMICAISTRATEGY_NEED_HAPPINESS_CRITICAL</AdvisorCounsel>
                         <AdvisorCounselImportance>3</AdvisorCounselImportance>
                     </Row>
                     <Row>
                         <Type>ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_GROWTH</Type>
                         <WeightThreshold>25</WeightThreshold>
                         <DontUpdateCityFlavors>true</DontUpdateCityFlavors>
                         <MinimumNumTurnsExecuted>15</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>5</CheckTriggerTurnCount>
                         <Advisor>ECONOMIC</Advisor>
                         <AdvisorCounsel>TXT_KEY_ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_GROWTH</AdvisorCounsel>
                         <AdvisorCounselImportance>2</AdvisorCounselImportance>
                     </Row>
                     <Row>
                         <Type>ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_TILE_IMPROVEMENT</Type>
                         <WeightThreshold>25</WeightThreshold>
                         <DontUpdateCityFlavors>true</DontUpdateCityFlavors>
                         <MinimumNumTurnsExecuted>5</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <Advisor>ECONOMIC</Advisor>
                         <AdvisorCounsel>TXT_KEY_ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_TILE_IMPROVEMENT</AdvisorCounsel>
                         <AdvisorCounselImportance>2</AdvisorCounselImportance>
                     </Row>
             */
        case .foundCity:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                weightThreshold: 10,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_FOUND_CITY",
                advisorCounselImportance: 2,
                flavors: [
                ]
            )
            /*
                     <Row>
                         <Type>ECONOMICAISTRATEGY_TRADE_WITH_CITY_STATE</Type>
                         <WeightThreshold>10</WeightThreshold>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                     </Row>
             */
        case .needImprovementFood:
            return EconimicStrategyTypeData(
                dontUpdateCityFlavors: true,
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                weightThreshold: 10,
                firstTurnExecuted: 20,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_IMPROVEMENT_FOOD",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .tileImprovement, value: 10),
                    Flavor(type: .growth, value: 20)
                ]
            )

        case .needImprovementProduction:
            return EconimicStrategyTypeData(
                dontUpdateCityFlavors: true,
                noMinorCivs: true,
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                weightThreshold: 10,
                firstTurnExecuted: 20,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_IMPROVEMENT_PRODUCTION",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .tileImprovement, value: 10),
                    Flavor(type: .production, value: 10)
                ]
            )
            /*
                     <Row>
                         <Type>ECONOMICAISTRATEGY_ONE_OR_FEWER_COASTAL_CITIES</Type>
                         <WeightThreshold>10</WeightThreshold>
                         <MinimumNumTurnsExecuted>10</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                     </Row>
             */
        case .losingMoney:
            return EconimicStrategyTypeData(
                checkTriggerTurnCount: 5,
                minimumNumTurnsExecuted: 5,
                weightThreshold: 2,
                firstTurnExecuted: 20,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_LOSING_MONEY",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .gold, value: 25),
                    Flavor(type: .offense, value: -10),
                    Flavor(type: .defense, value: -10),
                ]
            )
            /*
                     <Row>
                         <Type>ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>20</FirstTurnExecuted>
                         <Advisor>ECONOMIC</Advisor>
                         <AdvisorCounsel>TXT_KEY_ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS</AdvisorCounsel>
                         <AdvisorCounselImportance>2</AdvisorCounselImportance>
                     </Row>
             */
        case .tooManyUnits:
            return EconimicStrategyTypeData(
                checkTriggerTurnCount: 1,
                minimumNumTurnsExecuted: 1,
                firstTurnExecuted: 20,
                advisor: .economic,
                advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_TOO_MANY_UNITS",
                advisorCounselImportance: 2,
                flavors: [
                    Flavor(type: .offense, value: -30),
                    Flavor(type: .naval, value: -30),
                    Flavor(type: .ranged, value: -30),
                    Flavor(type: .mobile, value: -30),
                    Flavor(type: .recon, value: -50),
                    Flavor(type: .gold, value: 15),
                    Flavor(type: .growth, value: 20),
                    Flavor(type: .science, value: 15),
                    Flavor(type: .culture, value: 10),
                    Flavor(type: .happiness, value: 10),
                    Flavor(type: .wonder, value: 5)
                ]
            )
            /*
                     <Row>
                         <Type>ECONOMICAISTRATEGY_ISLAND_START</Type>
                         <WeightThreshold>200</WeightThreshold>
                         <MinimumNumTurnsExecuted>50</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <Advisor>SCIENCE</Advisor>
                         <AdvisorCounsel>TXT_KEY_ECONOMICAISTRATEGY_ISLAND_START</AdvisorCounsel>
                         <AdvisorCounselImportance>50</AdvisorCounselImportance>
                     </Row>
             */
        case .expandToOtherContinents:
            return EconimicStrategyTypeData(
                noMinorCivs: true,
                minimumNumTurnsExecuted: 25,
                weightThreshold: 50,
                techPrereq: .celestialNavigation, // ???
                advisorCounselImportance: 1,
                flavors: [

                ]
            )
            /*
                     <Row>
                         <Type>ECONOMICAISTRATEGY_EXPAND_TO_OTHER_CONTINENTS</Type>
                         <WeightThreshold>50</WeightThreshold>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>25</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>10</CheckTriggerTurnCount>
                         <TechPrereq>TECH_OPTICS</TechPrereq>
                     </Row>
                     <!-- Ours goes to 11 -->
                     <Row>
                         <Type>ECONOMICAISTRATEGY_EXPAND_LIKE_CRAZY</Type>
                         <WeightThreshold>10</WeightThreshold>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>25</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>10</CheckTriggerTurnCount>
                         <FirstTurnExecuted>25</FirstTurnExecuted>
                     </Row>
                     <Row>
                         <Type>ECONOMICAISTRATEGY_GROW_LIKE_CRAZY</Type>
                         <WeightThreshold>10</WeightThreshold>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>25</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>10</CheckTriggerTurnCount>
                         <FirstTurnExecuted>25</FirstTurnExecuted>
                     </Row>
                     <!-- The following Player Strategies are associated with the Grand Strategy the player has adopted -->
                     <Row>
                         <Type>ECONOMICAISTRATEGY_GS_CULTURE</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>25</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>75</FirstTurnExecuted>
                     </Row>
                     <Row>
                         <Type>ECONOMICAISTRATEGY_GS_CONQUEST</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>25</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>75</FirstTurnExecuted>
                     </Row>
                     <Row>
                         <Type>ECONOMICAISTRATEGY_GS_DIPLOMACY</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>25</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>75</FirstTurnExecuted>
                     </Row>
                     <Row>
                         <Type>ECONOMICAISTRATEGY_GS_SPACESHIP</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>25</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>75</FirstTurnExecuted>
                     </Row>
                     <!-- The following Player Strategies are associated with the home stretch of player strategies -->
                     <Row>
                         <Type>ECONOMICAISTRATEGY_GS_SPACESHIP_HOMESTRETCH</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>100</FirstTurnExecuted>
                     </Row>
                     <!-- We could theoretically start finding other continents if only we had a ship -->
                     <Row>
                         <Type>ECONOMICAISTRATEGY_REALLY_NEED_RECON_SEA</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>50</FirstTurnExecuted>
                     </Row>
                     <!-- Our civ is mostly on the coast -->
                     <Row>
                         <Type>ECONOMICAISTRATEGY_MOSTLY_ON_THE_COAST</Type>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>50</FirstTurnExecuted>
                     </Row>
                     <!-- This Map is marked as a Naval Map -->
                     <Row>
                         <Type>ECONOMICAISTRATEGY_NAVAL_MAP</Type>
                         <NoMinorCivs>true</NoMinorCivs>
                         <MinimumNumTurnsExecuted>10</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                         <FirstTurnExecuted>1</FirstTurnExecuted>
                     </Row>
             */
        }
    }

    func weightThreshold() -> Int {

        return self.data().weightThreshold
    }

    func flavorThresholdModifiers() -> [Flavor] {

        return []
    }

    func flavorThresholdModifier(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavorThresholdModifiers().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }

    func flavorModifiers() -> [Flavor] {

        return self.data().flavors
    }

    func required() -> TechType? {

        return self.data().techPrereq
    }

    func obsolete() -> TechType? {

        return self.data().techObsolete
    }

    func notBeforeTurnElapsed() -> Int {

        return self.data().firstTurnExecuted
    }

    func checkEachTurns() -> Int {

        return self.data().checkTriggerTurnCount
    }

    func minimumAdoptionTurns() -> Int {

        return self.data().minimumNumTurnsExecuted
    }

    private func weightThresholdModifier(for player: AbstractPlayer) -> Int {

        var value = 0

        for flavor in FlavorType.all {

            value += player.valueOfPersonalityFlavor(of: flavor) * self.flavorThresholdModifier(for: flavor)
        }

        return value
    }

    func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        switch self {

        case .needRecon: return self.shouldBeActiveNeedRecon(for: player, in: gameModel)
        case .enoughRecon: return self.shouldBeActiveEnoughRecon(for: player, in: gameModel)
        case .reallyNeedReconSea: return self.shouldBeActiveReallyNeedReconSea(for: player, in: gameModel)
        case .needReconSea: return self.shouldBeActiveNeedReconSea(for: player, in: gameModel)
        case .enoughReconSea: return self.shouldBeActiveEnoughReconSea(for: player, in: gameModel)
        case .earlyExpansion: return self.shouldBeActiveEarlyExpansion(for: player, in: gameModel)
        case .enoughExpansion: return self.shouldBeActiveEnoughExpansion(for: player, in: gameModel)
            // ECONOMICAISTRATEGY_NEED_HAPPINESS
            // ECONOMICAISTRATEGY_NEED_HAPPINESS_CRITICAL
            // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_GROWTH
            // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_TILE_IMPROVEMENT
        case .foundCity: return self.shouldBeActiveFoundCity(for: player, in: gameModel)
            // ECONOMICAISTRATEGY_TRADE_WITH_CITY_STATE
        case .needImprovementFood: return self.shouldBeActiveNeedImprovementFood(for: player, in: gameModel)
        case .needImprovementProduction:return self.shouldBeActiveNeedImprovementProduction(for: player, in: gameModel)
            // ECONOMICAISTRATEGY_ONE_OR_FEWER_COASTAL_CITIES
        case .losingMoney: return self.shouldBeActiveLosingMoney(for: player, in: gameModel)
            // ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS
        case .tooManyUnits: return self.shouldBeActiveTooManyUnits(for: player, in: gameModel)
            // ECONOMICAISTRATEGY_ISLAND_START
        case .expandToOtherContinents: return self.shouldBeActiveExpandToOtherContinents(for: player, in: gameModel)
            // ECONOMICAISTRATEGY_REALLY_EXPAND_TO_OTHER_CONTINENTS
            // ECONOMICAISTRATEGY_MOSTLY_ON_THE_COAST
            // ECONOMICAISTRATEGY_EXPAND_LIKE_CRAZY
            // ECONOMICAISTRATEGY_GROW_LIKE_CRAZY
            // ECONOMICAISTRATEGY_GS_CULTURE
            // ECONOMICAISTRATEGY_GS_CONQUEST
            // ECONOMICAISTRATEGY_GS_DIPLOMACY
            // ECONOMICAISTRATEGY_GS_SPACESHIP
            // ECONOMICAISTRATEGY_GS_SPACESHIP_HOMESTRETCH
            // ECONOMICAISTRATEGY_NAVAL_MAP
            // ECONOMICAISTRATEGY_OFFSHORE_EXPANSION_MAP
            // ECONOMICAISTRATEGY_DEVELOPING_RELIGION
            // ECONOMICAISTRATEGY_TECH_LEADER
            // ECONOMICAISTRATEGY_NEED_ARCHAEOLOGISTS
            // ECONOMICAISTRATEGY_ENOUGH_ARCHAEOLOGISTS
            // ECONOMICAISTRATEGY_NEED_MUSEUMS
            // ECONOMICAISTRATEGY_NEED_GUILDS
            // ECONOMICAISTRATEGY_CONCERT_TOUR
            // ECONOMICAISTRATEGY_STARTED_PIETY
        }
    }

    private func shouldBeActiveNeedRecon(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let militaryStrategyAdoption = player?.militaryAI?.militaryStrategyAdoption else {
            fatalError("Cant get military strategry")
        }

        // Never desperate for explorers if we are at war
        if militaryStrategyAdoption.adopted(militaryStrategy: .atWar) {
            return false
        }

        return player?.economicAI?.reconState() == .needed
    }

    private func shouldBeActiveEnoughRecon(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return player?.economicAI?.reconState() == .enough
    }

    /// "Really Need Recon Sea" Player Strategy: If we could theoretically start exploring other continents but we don't have any appropriate ship...
    private func shouldBeActiveReallyNeedReconSea(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }

        guard let player = player else {
            fatalError("Cant get player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("Cant get economicAI")
        }

        if economicAI.navalReconState() == .needed {

            if player.canEnterOcean() { // get a caravel out there NOW!

                // check current units - if we chave already an ocean recon unit - we dont need to hurry
                for unitRef in gameModel.units(of: player) {

                    guard let unit = unitRef else {
                        continue
                    }

                    if unit.task() == .escortSea && !unit.isImpassable(terrain: .ocean) {
                        return false
                    }
                }

                // check cities, if a ocean recon units is already training
                for cityRef in gameModel.cities(of: player) {

                    guard let city = cityRef else {
                        continue
                    }

                    if city.buildQueue.isCurrentlyTrainingUnit() {
                        for unitType in city.buildQueue.unitTypesTraining() {
                            if unitType.domain() == .sea && unitType.defaultTask() == .exploreSea {
                                if !unitType.abilities().contains(.oceanImpassable) {
                                    return false
                                }
                            }
                        }
                    }
                }

                return true

            } else if player.canEmbark() { // get a trireme out there NOW!

                // check current units - if we chave already an ocean recon unit - we dont need to hurry
                for unitRef in gameModel.units(of: player) {

                    guard let unit = unitRef else {
                        continue
                    }

                    if unit.task() == .escortSea {
                        return false
                    }
                }

                // check cities, if a ocean recon units is already training
                for cityRef in gameModel.cities(of: player) {

                    guard let city = cityRef else {
                        continue
                    }

                    if city.buildQueue.isCurrentlyTrainingUnit() {
                        for unitType in city.buildQueue.unitTypesTraining() {
                            if unitType.domain() == .sea && unitType.defaultTask() == .exploreSea {
                                return false
                            }
                        }
                    }
                }

                return true
            }
        }

        return false
    }

    private func shouldBeActiveNeedReconSea(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let militaryStrategyAdoption = player?.militaryAI?.militaryStrategyAdoption else {
            fatalError("Cant get military strategry")
        }

        // Never desperate for explorers if we are at war
        if militaryStrategyAdoption.adopted(militaryStrategy: .losingWars) {
            return false
        }

        return player?.economicAI?.navalReconState() == .needed
    }

    private func shouldBeActiveEnoughReconSea(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return player?.economicAI?.navalReconState() == .enough
    }

    // "Early Expansion" Player Strategy: An early Strategy simply designed to get player up to 3 Cities quickly.
    private func shouldBeActiveEarlyExpansion(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        let flavorExpansion = player.valueOfStrategyAndPersonalityFlavor(of: .expansion)
        let flavorGrowth = player.valueOfStrategyAndPersonalityFlavor(of: .growth)
        let maxCultureCities = 6 // AI_GS_CULTURE_MAX_CITIES

        var desiredCities = (3 * flavorExpansion) / max(flavorGrowth, 1)
        let difficulty = max(0, gameModel.handicap.rawValue - 3)
        desiredCities += difficulty

        if player.grandStrategyAI?.activeStrategy == .culture {
            desiredCities = min(desiredCities, maxCultureCities)
        }

        desiredCities = max(desiredCities, maxCultureCities)

        // scale this based on world size
        let standardMapSize: MapSize = .standard
        desiredCities = desiredCities * gameModel.mapSize().numberOfTiles() / standardMapSize.numberOfTiles()

        // See how many unowned Tiles there are on this player's landmass
        if let capital = gameModel.capital(of: player) {

            // Make sure city specialization has gotten one chance to specialize the capital before we adopt this
            if gameModel.currentTurn > 25 { // AI_CITY_SPECIALIZATION_EARLIEST_TURN

                if let capitalArea = gameModel.area(of: capital.location) {

                    // Is this area still the best to settle?
                    let (_, bestArea, _) = player.bestSettleAreasWith(minimumSettleFertility: economicAI.minimumSettleFertility(), in: gameModel)

                    if bestArea == capitalArea {

                        let tilesInCapitalArea = gameModel.tiles(in: capitalArea)
                        let numOwnedTiles = tilesInCapitalArea.filter({ $0?.hasOwner() ?? false }).count
                        let numUnownedTiles = tilesInCapitalArea.filter({ !($0?.hasOwner() ?? true) }).count
                        let numTiles = max(1, numOwnedTiles + numUnownedTiles)
                        let ownageRatio = numOwnedTiles * 100 / numTiles
                        let numCities = gameModel.cities(of: player).count

                        let numSettlersOnMap = gameModel.units(of: player).count(where: { $0!.task() == .settle })

                        if ownageRatio < 75 /* AI_STRATEGY_AREA_IS_FULL_PERCENT */

                            && (numCities + numSettlersOnMap) < desiredCities
                            && numUnownedTiles >= 25 /* AI_STRATEGY_EARLY_EXPANSION_NUM_UNOWNED_TILES_REQUIRED */ {

                            return true
                        }
                    }
                }
            }
        }

        return false
    }

    func shouldBeActiveEnoughExpansion(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }

    /// "Found City" Player Strategy: If there is a settler who isn't in an operation?  If so, find him a city site
    /// Very dependent on the fact that the player probably won't have more than 2 settlers available at a time; needs an
    ///   upgrade if that assumption is no longer true
    func shouldBeActiveFoundCity(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        // Never run this strategy for a human player or barbarian
        if player.isHuman() || player.isBarbarian() {
            return false
        }

        var firstLooseSettler: AbstractUnit?
        var looseSettlers = 0

        for unitRef in gameModel.units(of: player) {

            if let unit = unitRef {
                if unit.has(task: .settle) {
                    if unit.army() == nil {

                        looseSettlers += 1
                        if looseSettlers == 1 {
                            firstLooseSettler = unitRef
                        }
                    }
                }
            }
        }

        let strategyWeight = looseSettlers * 10 // Just one settler will trigger this
        let weightThresholdModifier = self.weightThresholdModifier(for: player)
        let weightThreshold = self.weightThreshold() + weightThresholdModifier

        // Don't run this strategy if have 0 cities, in that case we just want to drop down a city wherever we happen to be
        if strategyWeight >= weightThreshold && gameModel.cities(of: player).count >= 1 {

            let (numAreas, bestArea, _) = player.bestSettleAreasWith(minimumSettleFertility: economicAI.minimumSettleFertility(), in: gameModel)

            if numAreas == 0 {
                return false
            }

            guard let bestSettlePlot = player.bestSettlePlot(for: firstLooseSettler, in: gameModel, escorted: true, area: nil) else {
                return false
            }

            let area = bestSettlePlot.area

            let canEmbark = player.canEmbark()
            let isAtWarWithSomeone = player.atWarCount() > 0

            // CASE 1: Need a city on this area
            if bestArea == area {
                player.addOperation(of: .foundCity, towards: nil, target: nil, in: bestArea, muster: nil, in: gameModel)
                return true
            } else if canEmbark && self.isSafeForQuickColony(in: area, in: gameModel, for: player) {
                // CASE 2: Need a city on a safe distant area
                // Have an overseas we can get to safely
                player.addOperation(of: .colonize, towards: nil, target: nil, in: bestArea, muster: nil, in: gameModel)
                return true
            }

            // CASE 3: My embarked units can fight, I always do quick colonization overseas
            /*else if canEmbark && pPlayer->GetPlayerTraits()->IsEmbarkedNotCivilian() {
                player.addOperation(of: .notSoQuickColonize, towards: nil, target: nil, area: iArea)
                return true
            }*/
            else if canEmbark && !isAtWarWithSomeone {
                // CASE 3a: Need a city on a not so safe distant area
                // not at war with anyone
                player.addOperation(of: .notSoQuickColonize, towards: nil, target: nil, in: area, muster: nil, in: gameModel)
                return true

            } else if canEmbark {
                // CASE 4: Need a city on distant area
                player.addOperation(of: .colonize, towards: nil, target: nil, in: area, muster: nil, in: gameModel)
                return true
            }
        }

        return false
    }

    func shouldBeActiveNeedImprovementFood(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }

    func shouldBeActiveNeedImprovementProduction(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }

    func shouldBeActiveLosingMoney(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }

    func shouldBeActiveTooManyUnits(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }

    func shouldBeActiveExpandToOtherContinents(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }

    /// Do we have an island clear of hostile units to settle on?
    func isSafeForQuickColony(in area: HexArea?, in gameModel: GameModel?, for player: AbstractPlayer?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let boundingBox = area?.boundingBox {

            for x in boundingBox.minX..<boundingBox.maxX {
                for y in boundingBox.minY..<boundingBox.maxY {

                    if gameModel.isEnemyVisible(at: HexPoint(x: x, y: y), for: player) {
                        return false
                    }
                }
            }
        }

        return true
    }

    func advisorMessage() -> AdvisorMessage? {

        if self.data().advisor != .none {

            guard let advisorCounsel = self.data().advisorCounsel else {
                fatalError("advisor counsel must be set if advisor type is not none")
            }

            return AdvisorMessage(
                advisor: self.data().advisor,
                message: advisorCounsel,
                importance: self.data().advisorCounselImportance
            )
        }

        return nil
    }
}
