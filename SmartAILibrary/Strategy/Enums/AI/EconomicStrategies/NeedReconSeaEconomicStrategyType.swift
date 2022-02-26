//
//  NeedReconSeaEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class NeedReconSeaEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            firstTurnExecuted: 5,
            advisor: .foreign,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON_SEA",
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .navalRecon, value: 20)
            ],
            flavorThresholdModifiers: [
                Flavor(type: .navalRecon, value: -1)
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let militaryStrategyAdoption = player?.militaryAI?.militaryStrategyAdoption else {
            fatalError("Cant get military strategry")
        }

        // Never desperate for explorers if we are at war and its not looking good
        if militaryStrategyAdoption.adopted(militaryStrategy: .losingWars) {
            return false
        }

        return player?.economicAI?.navalReconState() == .needed
    }
}
