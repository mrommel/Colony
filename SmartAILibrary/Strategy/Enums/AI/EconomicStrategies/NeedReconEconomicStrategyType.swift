//
//  NeedReconEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class NeedReconEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            firstTurnExecuted: 5,
            advisor: .foreign,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON",
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .recon, value: 100)
            ],
            flavorThresholdModifiers: [
                Flavor(type: .recon, value: -1)
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let militaryStrategyAdoption = player?.militaryAI?.militaryStrategyAdoption else {
            fatalError("Cant get military strategry")
        }

        // Never desperate for explorers, if we are at war
        if militaryStrategyAdoption.adopted(militaryStrategy: .atWar) {
            return false
        }

        return player?.economicAI?.reconState() == .needed
    }
}
