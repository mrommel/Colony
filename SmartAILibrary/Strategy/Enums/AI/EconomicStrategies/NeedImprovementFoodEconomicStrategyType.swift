//
//  NeedImprovementFoodEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

/// "Need Improvement" Player Strategy: Do the cities need an improvement that increases a yield? Do we have access to an improvement that builds that yield?
class NeedImprovementEconomicStrategyType: EconomicStrategyTypeData {

    let yieldType: YieldType

    init(yieldType: YieldType) {

        var counsel: String
        var flavor: Flavor

        switch yieldType {

        case .food:
            counsel = "TXT_KEY_ECONOMICAISTRATEGY_NEED_IMPROVEMENT_FOOD"
            flavor = Flavor(type: .growth, value: 20)
        case .production:
            counsel = "TXT_KEY_ECONOMICAISTRATEGY_NEED_IMPROVEMENT_PRODUCTION"
            flavor = Flavor(type: .production, value: 10)
        default:
            fatalError("can only be food and production")
        }

        self.yieldType = yieldType

        super.init(
            dontUpdateCityFlavors: true,
            noMinorCivs: true,
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            weightThreshold: 10,
            firstTurnExecuted: 20,
            advisor: .economic,
            advisorCounsel: counsel,
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .tileImprovement, value: 10),
                flavor
            ],
            flavorThresholdModifiers: []
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError()
        }

        guard let player = player else {
            fatalError()
        }

        // find the city strategy associated with this issue
        var cityStrategyType: CityStrategyType = .none

        switch self.yieldType {

        case .food:
            cityStrategyType = .needImprovementFood
        case .production:
            cityStrategyType = .needImprovementProduction

        default:
            fatalError("can only be food and production")
        }

        guard cityStrategyType != .none else {
            print("no city strategy selected")
            return false
        }

        // if enough cities are worried about this problem
        let numCities = player.numCities(in: gameModel)
        if numCities == 0 {
            return false // no cities, no problem!
        }

        var numCitiesConcerned = 0
        for cityRef in gameModel.cities(of: player) {

            guard let cityStrategy = cityRef?.cityStrategy else {
                continue
            }

            if cityStrategy.adopted(cityStrategy: cityStrategyType) {
                numCitiesConcerned += 1
            }
        }

        let warningRatio = 0.34 // AI_STRATEGY_NEED_IMPROVEMENT_CITY_RATIO

        // if not enough cities are upset
        if (Double(numCitiesConcerned) / Double(numCities)) < warningRatio {
            return false
        }

        // see if there's a builder
        var builder: AbstractUnit?
        for loopUnitRef in gameModel.units(of: player) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            if loopUnit.type.defaultTask() == .work {
                builder = loopUnitRef
                break
            }
        }

        // if no builder, ignore
        // perhaps prompt a builder?
        if builder == nil {
            return false
        }

        // is there a build that I can create to improve the yield?

        // loop through the build types to find one that we can use
        for build in BuildType.all {

            if let requiredTech = build.required() {
                if !player.has(tech: requiredTech) {
                    continue
                }
            }

            guard let improvement = build.improvement() else {
                continue
            }

            var canBuild = false
            for plot in player.plots() {

                if player.canBuild(build: build, at: plot, testGold: false, in: gameModel) {
                    canBuild = true
                    break
                }
            }

            if !canBuild {
                continue
            }

            // we can use an improvement that increases the yield
            if improvement.yields(for: player, on: .none).value(of: yieldType) > 0 {
                return true
            }
        }

        return false
    }
}

class NeedImprovementFoodEconomicStrategyType: NeedImprovementEconomicStrategyType {

    init() {
        
        super.init(yieldType: .food)
    }
}
