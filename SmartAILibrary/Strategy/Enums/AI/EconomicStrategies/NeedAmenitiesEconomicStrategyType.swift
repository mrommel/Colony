//
//  NeedAmenitiesEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 06.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// ECONOMICAISTRATEGY_NEED_HAPPINESS
// "Need Amenities" Player Strategy: Time for Happiness?
class NeedAmenitiesEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            weightThreshold: 2,
            advisor: .economic,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_AMENITIES",
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .amenities, value: 35),
                Flavor(type: .expansion, value: -10),
                Flavor(type: .growth, value: -5)
            ],
            flavorThresholdModifiers: [
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        /*if gameModel.population(of: player) > 0 && player.unhappiness() > 0 {

            let excessHappiness = player.excessHappiness()

            var weightThresholdModifier = self.weightThresholdModifier(for: player) // 1 Weight per HAPPINESS Flavor

                // This will range from 0 to 5. If Happiness is less than this we will activate the strategy
            let divisor = / *2* / self.weightThreshold
            weightThresholdModifier /= divisor

            if excessHappiness <= weightThresholdModifier {
                return true
            }
        }*/

        return false
    }
}
