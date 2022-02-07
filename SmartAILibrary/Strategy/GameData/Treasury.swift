//
//  Treasury.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractTreasury: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func value() -> Double

    func doTurn(in gameModel: GameModel?)

    func changeGold(by amount: Double)

    func averageIncome(in lastTurns: Int) -> Double
    func calculateGrossGold(in gameModel: GameModel?) -> Double

    // in
    func goldFromCities(in gameModel: GameModel?) -> Double
    func goldPerTurnFromDiplomacy(in gameModel: GameModel?) -> Double
    func goldFromTradeRoutes(in gameModel: GameModel?) -> Double

    // out
    func goldForUnitMaintenance(in gameModel: GameModel?) -> Double
    func goldForBuildingMaintenance(in gameModel: GameModel?) -> Double
    func goldPerTurnForDiplomacy(in gameModel: GameModel?) -> Double
}

class Treasury: AbstractTreasury {

    enum CodingKeys: CodingKey {

        case gold
        case tradeRouteGoldChange
        case history
    }

    // user properties / values
    var player: AbstractPlayer?
    var gold: Double
    var history: [Double]

    var tradeRouteGoldChangeValue: Int

    // MARK: constructor

    init(player: Player?) {

        self.player = player
        self.gold = 10.0 //
        self.history = []

        self.tradeRouteGoldChangeValue = 0
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.gold = try container.decode(Double.self, forKey: .gold)
        self.history = try container.decode([Double].self, forKey: .history)
        self.tradeRouteGoldChangeValue = try container.decode(Int.self, forKey: .tradeRouteGoldChange)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.gold, forKey: .gold)
        try container.encode(self.history, forKey: .history)
        try container.encode(self.tradeRouteGoldChangeValue, forKey: .tradeRouteGoldChange)
    }

    func value() -> Double {

        return self.gold
    }

    /// Get the amount of gold granted by connecting the city
    /*func goldForRoute(to target: AbstractCity?, in gameModel: GameModel?) -> Int {
        
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
    }*/

    /// How much of a bonus do we get for Trade Routes
    func tradeRouteGoldChange() -> Int {

        // from wonders
        return self.tradeRouteGoldChangeValue
    }

    /// Update treasury for a turn
    func doTurn(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let goldChange = player.calculateGoldPerTurn(in: gameModel)

        self.history.append(goldChange)

        // predict treasury
        let goldAfterThisTurn = self.gold + goldChange

        // check if we are running low
        if goldAfterThisTurn < 0 {

            self.gold = 0

            if goldAfterThisTurn <= -5 /* DEFICIT_UNIT_DISBANDING_THRESHOLD */ {
                // player.doDeficit()
            }
        } else {
            self.changeGold(by: goldChange)
        }

        // Update the amount of gold grossed across lifetime of game

    }

    func changeGold(by amount: Double) {

        self.gold += amount
    }

    func averageIncome(in lastTurns: Int) -> Double {

        let interval = min(self.history.count, lastTurns)
        var sum: Double = 0.0

        for index in 0..<interval {
            sum += self.history[index]
        }

        return sum / Double(interval)
    }

    // Gross income for turn
    func calculateGrossGold(in gameModel: GameModel?) -> Double {

        var netGold = 0.0

        // Income
        // //////////////////

        // Gold from Cities
        netGold += self.goldFromCities(in: gameModel)

        // Gold per Turn from Diplomacy
        netGold += self.goldPerTurnFromDiplomacy(in: gameModel)

        // City connection bonuses
        netGold += self.goldFromTradeRoutes(in: gameModel)

        // Costs
        // //////////////////

        // Gold for Unit Maintenance
        netGold -= self.goldForUnitMaintenance(in: gameModel)

        // Gold for Building Maintenance
        netGold -= self.goldForBuildingMaintenance(in: gameModel)

        // Gold per Turn for Diplomacy
        netGold += self.goldPerTurnForDiplomacy(in: gameModel)

        return netGold
    }

    // MARK: income

    // Gold from Cities
    func goldFromCities(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var goldValue = 0.0

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            goldValue += city.goldPerTurn(in: gameModel)
        }

        return goldValue
    }

    func goldPerTurnFromDiplomacy(in gameModel: GameModel?) -> Double {

        return 0.0
    }

    func goldFromTradeRoutes(in gameModel: GameModel?) -> Double {

        guard let tradeRoutes = self.player?.tradeRoutes else {
            fatalError("cant get tradeRoutes")
        }

        return tradeRoutes.yields(in: gameModel).gold
    }

    // MARK: costs

    func goldForUnitMaintenance(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let government = player.government else {
            fatalError("cant get government")
        }

        var maintenanceCost = 0.0

        for unitRef in gameModel.units(of: player) {

            guard let unit = unitRef else {
                continue
            }

            var unitMaintenanceCost: Double = Double(unit.type.maintenanceCost())

            // Unit maintenance reduced by 1 Gold per turn, per unit.
            if government.has(card: .conscription) {
                unitMaintenanceCost = max(0.0, unitMaintenanceCost - 1.0)
            }

            maintenanceCost += unitMaintenanceCost
        }

        return maintenanceCost
    }

    func goldForBuildingMaintenance(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var maintenanceCost = 0.0

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            maintenanceCost += city.maintenanceCostsPerTurn()
        }

        return maintenanceCost
    }

    func goldPerTurnForDiplomacy(in gameModel: GameModel?) -> Double {

        return 0.0
    }
}
