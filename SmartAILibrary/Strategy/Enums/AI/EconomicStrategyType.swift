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
    case needHappiness // ECONOMICAISTRATEGY_NEED_HAPPINESS
    case needHappinessCritical // ECONOMICAISTRATEGY_NEED_HAPPINESS_CRITICAL
    // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_GROWTH
    // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_TILE_IMPROVEMENT
    case foundCity // ECONOMICAISTRATEGY_FOUND_CITY
    // ECONOMICAISTRATEGY_TRADE_WITH_CITY_STATE
    case needImprovementFood // ECONOMICAISTRATEGY_NEED_IMPROVEMENT_FOOD
    case needImprovementProduction // ECONOMICAISTRATEGY_NEED_IMPROVEMENT_PRODUCTION
    case oneOrFewerCoastalCities // ECONOMICAISTRATEGY_ONE_OR_FEWER_COASTAL_CITIES
    case losingMoney // ECONOMICAISTRATEGY_LOSING_MONEY
    case haltGrowthBuildings // ECONOMICAISTRATEGY_HALT_GROWTH_BUILDINGS
    case tooManyUnits // ECONOMICAISTRATEGY_TOO_MANY_UNITS
    case islandStart // ECONOMICAISTRATEGY_ISLAND_START
    case expandToOtherContinents // ECONOMICAISTRATEGY_EXPAND_TO_OTHER_CONTINENTS
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
            .needHappiness,
            .needHappinessCritical,
            // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_GROWTH
            // ECONOMICAISTRATEGY_CITIES_NEED_NAVAL_TILE_IMPROVEMENT
            .foundCity,
            // ECONOMICAISTRATEGY_TRADE_WITH_CITY_STATE
            .needImprovementFood,
            .needImprovementProduction,
            .oneOrFewerCoastalCities,
            .losingMoney,
            .haltGrowthBuildings,
            .tooManyUnits,
            .islandStart,
            .expandToOtherContinents
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

    func weightThreshold() -> Int {

        return EconomicStrategyType.dataProvider[self]!.weightThreshold
    }

    func flavors() -> [Flavor] {

        return EconomicStrategyType.dataProvider[self]!.flavors
    }

    func flavorThresholdModifiers() -> [Flavor] {

        return EconomicStrategyType.dataProvider[self]!.flavorThresholdModifiers
    }

    func required() -> TechType? {

        return EconomicStrategyType.dataProvider[self]!.techPrereq
    }

    func obsolete() -> TechType? {

        return EconomicStrategyType.dataProvider[self]!.techObsolete
    }

    func notBeforeTurnElapsed() -> Int {

        return EconomicStrategyType.dataProvider[self]!.firstTurnExecuted
    }

    func noMinorCivs() -> Bool {

        return EconomicStrategyType.dataProvider[self]!.noMinorCivs
    }

    func checkEachTurns() -> Int {

        return EconomicStrategyType.dataProvider[self]!.checkTriggerTurnCount
    }

    func minimumAdoptionTurns() -> Int {

        return EconomicStrategyType.dataProvider[self]!.minimumNumTurnsExecuted
    }

    func advisorMessage() -> AdvisorMessage? {

        if EconomicStrategyType.dataProvider[self]!.advisor != .none {

            guard let advisorCounsel = EconomicStrategyType.dataProvider[self]!.advisorCounsel else {
                fatalError("advisor counsel must be set if advisor type is not none")
            }

            return AdvisorMessage(
                advisor: EconomicStrategyType.dataProvider[self]!.advisor,
                message: advisorCounsel,
                importance: EconomicStrategyType.dataProvider[self]!.advisorCounselImportance
            )
        }

        return nil
    }

    func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return EconomicStrategyType.dataProvider[self]!.shouldBeActive(for: player, in: gameModel)
    }

    // MARK: private methods and classes

    private static var dataProvider: [EconomicStrategyType: EconomicStrategyTypeData] = {

        var dict: [EconomicStrategyType: EconomicStrategyTypeData]

        dict = [EconomicStrategyType: EconomicStrategyTypeData]()

        for type in EconomicStrategyType.all {

            dict[type] = type.data()
        }

        return dict
    }()

    // https://github.com/wangxinyu199306/Civ5Configuration/blob/e598b37a4941c5974205c024e736270786349824/Gameplay/XML/AI/CIV5AIEconomicStrategies.xml
    private func data() -> EconomicStrategyTypeData {

        switch self {

        case .needRecon: return NeedReconEconomicStrategyType()
        case .enoughRecon: return EnoughReconEconomicStrategyType()
        case .reallyNeedReconSea: return ReallyNeedReconSeaEconomicStrategyType()
        case .needReconSea: return NeedReconSeaEconomicStrategyType()
        case .enoughReconSea: return EnoughReconSeaEconomicStrategyType()
        case .earlyExpansion: return EarlyExpansionEconomicStrategyType()
        case .enoughExpansion: return EnoughExpansionEconomicStrategyType()
        case .needHappiness: return NeedAmenitiesEconomicStrategyType()
        case .needHappinessCritical: return NeedAmenitiesCriticalEconomicStrategyType()
            /*
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
        case .foundCity: return FoundCityEconomicStrategyType()
            /*
                     <Row>
                         <Type>ECONOMICAISTRATEGY_TRADE_WITH_CITY_STATE</Type>
                         <WeightThreshold>10</WeightThreshold>
                         <MinimumNumTurnsExecuted>1</MinimumNumTurnsExecuted>
                         <CheckTriggerTurnCount>1</CheckTriggerTurnCount>
                     </Row>
             */
        case .needImprovementFood: return NeedImprovementFoodEconomicStrategyType()
        case .needImprovementProduction: return NeedImprovementProductionEconomicStrategyType()
        case .oneOrFewerCoastalCities: return OneOrFewerCoastalCitiesEconomicStrategyType()
        case .losingMoney: return LosingMoneyEconomicStrategyType()
        case .haltGrowthBuildings: return HaltGrowthBuildingsEconomicStrategyType()
        case .tooManyUnits: return TooManyUnitsEconomicStrategyType()
        case .islandStart: return IslandStartEconomicStrategyType()
        case .expandToOtherContinents: return ExpandToOtherContinentsEconomicStrategyType()
            /*
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
}
