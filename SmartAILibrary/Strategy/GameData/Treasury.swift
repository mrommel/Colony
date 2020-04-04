//
//  Treasury.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractTreasury {
    
    func add(gold goldDelta: Double)
    func value() -> Double
    
    func turn(in gameModel: GameModel?)
}

class Treasury: AbstractTreasury {

    // user properties / values
    var player: Player?
    var gold: Double
    //var lastGoldEarned: Double = 1.0
    
    var tradeRouteGoldChangeValue: Int

    // MARK: constructor
    
    init(player: Player?) {
        
        self.player = player
        self.gold = 0.0
        
        self.tradeRouteGoldChangeValue = 0
    }
    
    func value() -> Double {
        
        return self.gold
    }
    
    func add(gold goldDelta: Double) {
        
        self.gold += goldDelta
    }
    
    /// Get the amount of gold granted by connecting the city
    func goldForRoute(to target: AbstractCity?, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let target = target else {
            return 0
        }
        
        guard let capitalCity = gameModel.capital(of: player) else {
            return 0
        }
        
        if target.location == capitalCity.location {
            return 0
        }

        var gold = 0

        let tradeRouteBaseGold = 100 /* TRADE_ROUTE_BASE_GOLD */
        let tradeRouteCapitalGoldMultiplier = 0 /* TRADE_ROUTE_CAPITAL_POP_GOLD_MULTIPLIER */
        let tradeRouteCityGoldMultiplier = 125 /* TRADE_ROUTE_CITY_POP_GOLD_MULTIPLIER */

        gold += tradeRouteBaseGold    // Base Gold: 0
        gold += capitalCity.population() * tradeRouteCapitalGoldMultiplier    // Capital Multiplier
        gold += target.population() * tradeRouteCityGoldMultiplier    // City Multiplier
        gold += self.tradeRouteGoldChange()

        /*let modifier =
        if GetTradeRouteGoldModifier() > 0 {
            gold *= (100 + GetTradeRouteGoldModifier());
            gold /= 100;
        }*/

        return gold
    }
    
    /// How much of a bonus do we get for Trade Routes
    func tradeRouteGoldChange() -> Int {
        
        // from wonders
        return self.tradeRouteGoldChangeValue
    }
    
    /// Update treasury for a turn
    func turn(in gameModel: GameModel?) {
        
        //let goldChange = m_pPlayer->calculateGoldRateTimes100();

        /*int iGoldAfterThisTurn = iGoldChange + GetGoldTimes100();
        if (iGoldAfterThisTurn < 0)
        {
            SetGold(0);

            if (iGoldAfterThisTurn <= /*-5*/ GC.getDEFICIT_UNIT_DISBANDING_THRESHOLD() * 100)
                m_pPlayer->DoDeficit();
        }
        else
        {
            ChangeGoldTimes100(iGoldChange);
        }*/
    }
}
