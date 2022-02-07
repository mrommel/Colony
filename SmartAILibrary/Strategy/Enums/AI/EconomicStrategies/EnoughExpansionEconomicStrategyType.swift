//
//  EnoughExpansionEconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

/// "Enough Expansion" Player Strategy: Never want a lot of settlers hanging around
class EnoughExpansionEconomicStrategyType: EconomicStrategyTypeData {

    init() {

        super.init(
            noMinorCivs: true,
            checkTriggerTurnCount: 5,
            minimumNumTurnsExecuted: 1,
            weightThreshold: 1, // one settler
            advisor: .economic,
            advisorCounsel: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_EXPANSION",
            advisorCounselImportance: 2,
            flavors: [
                Flavor(type: .expansion, value: -30)
            ],
            flavorThresholdModifiers: [
            ]
        )
    }

    override func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("Cant get economicAI")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("Cant get militaryAI")
        }

        if player.isBarbarian() { // || CannotMinorCiv(pPlayer, eStrategy) || pPlayer->GetPlayerTraits()->IsNoAnnexing();
            return true
        }

        if gameModel.cities(of: player).count <= 1 {
            return false
        }

        /*if player.isEmpireUnhappy() {
            return true
        }*/

        if player.countUnitsWith(defaultTask: .settle, in: gameModel) > 1 {
            return true
        }

        if militaryAI.adopted(militaryStrategy: .losingWars) && player.isCramped() {
            return true
        }

        // Don't self-sabotage with too many cities
        /*if (pPlayer->GetPlayerTraits()->IsSmaller() || pPlayer->GetPlayerTraits()->IsTourism() || pPlayer->GetDiplomacyAI()->IsGoingForCultureVictory())
         {
         int iNonPuppetCities = pPlayer->GetNumEffectiveCities();
         int iTourismMod = GC.getMap().getWorldInfo().GetNumCitiesTourismCostMod() * (iNonPuppetCities - 1);
         //the modifier is positive even if the effect is negative, wtf
         if (iTourismMod > 23 + pPlayer->GetDiplomacyAI()->GetBoldness())
         {
         return true;
         }
         }*/

        // If we are running "ECONOMICAISTRATEGY_EXPAND_TO_OTHER_CONTINENTS"
        if economicAI.adopted(economicStrategy: .expandToOtherContinents) {
            return false
        }

        // If we are running "ECONOMICAISTRATEGY_EARLY_EXPANSION"
        if economicAI.adopted(economicStrategy: .earlyExpansion) {
            return false
        }

        // do this check last, it can be expensive
        /*if player.goodsett(!pPlayer->HaveGoodSettlePlot(-1) )
        {
            return true
        }*/

        return false
    }
}
