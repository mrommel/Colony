//
//  TooManyUnitsEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class TooManyUnitsEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
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
            ],
            flavorThresholdModifiers: []
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        fatalError("implement")
    }
}
