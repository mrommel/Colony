//
//  EnoughReconSeaEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class EnoughReconSeaEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            firstTurnExecuted: 5,
            advisor: .economic,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_RECON",
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .navalRecon, value: -200)
            ],
            flavorThresholdModifiers: [
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return player?.economicAI?.navalReconState() == .enough
    }
}
