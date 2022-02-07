//
//  NeedAmenitiesCriticalEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 06.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// TXT_KEY_ECONOMICAISTRATEGY_NEED_HAPPINESS_CRITICAL
/// "Need Amenities" Player Strategy: REALLY time for Happiness?
class NeedAmenitiesCriticalEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            checkTriggerTurnCount: 1,
            minimumNumTurnsExecuted: 1,
            weightThreshold: -3,
            advisor: .economic,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_NEED_AMENITIES_CRITICAL",
            advisorCounselImportance: 3,
            flavors: [
                Flavor(type: .amenities, value: 150),
                Flavor(type: .expansion, value: -100),
                Flavor(type: .growth, value: -10)
            ],
            flavorThresholdModifiers: [
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
/*
        // If we're losing at war, return false
        if(pPlayer->GetDiplomacyAI()->GetStateAllWars() == STATE_ALL_WARS_LOSING)
            return false;

        if(pPlayer->getTotalPopulation() > 0 && pPlayer->GetUnhappiness() > 0)
        {
            int iExcessHappiness = pPlayer->GetExcessHappiness();

            CvEconomicAIStrategyXMLEntry* pStrategy = pPlayer->GetEconomicAI()->GetEconomicAIStrategies()->GetEntry(eStrategy);
            int iThreshold = /*-3*/ pStrategy->GetWeightThreshold();

            if(iExcessHappiness <= iThreshold)
                return true;
        }
*/
        return false
    }
}
