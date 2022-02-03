//
//  NeedImprovementFoodEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class NeedImprovementFoodEconomicStrategyType: EconomicStrategyTypeData {

    init() {
        
        super.init(
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
            ],
            flavorThresholdModifiers: []
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }
}
