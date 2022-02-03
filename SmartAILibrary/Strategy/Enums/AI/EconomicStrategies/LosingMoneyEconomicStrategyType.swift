//
//  LosingMoneyEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

/// "Losing Money" Player Strategy: Stop building military if in a financial downturn
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

        guard let gameModel = gameModel else {
            fatalError()
        }

        guard let player = player else {
            fatalError()
        }

        guard let treasury = player.treasury else {
            fatalError()
        }

        let interval = self.minimumNumTurnsExecuted

        // Need a certain number of turns of history before we can turn this on
        if gameModel.currentTurn <= self.minimumNumTurnsExecuted {
            return false
        }

        // Is average income below desired threshold over past X turns?
        return treasury.averageIncome(in: interval) < Double(self.weightThreshold)
    }
}
