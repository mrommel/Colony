//
//  LosingMoneyEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class LosingMoneyEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
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
                Flavor(type: .defense, value: -10)
            ],
            flavorThresholdModifiers: []
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }
}
