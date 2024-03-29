//
//  TradeRoute.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class TradeRoute: Codable {

    enum CodingKeys: String, CodingKey {

        case path
    }

    let path: HexPath

    var start: HexPoint {

        guard let firstHexPathPoint = self.path.first else {
            fatalError("cant get first point of path")
        }

        return firstHexPathPoint.0
    }

    var end: HexPoint {

        guard let lastHexPathPoint = self.path.last else {
            fatalError("cant get last point of path")
        }

        return lastHexPathPoint.0
    }

    // MARK: constructors

    public init(path: HexPath) {

        self.path = path
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.path = try container.decode(HexPath.self, forKey: .path)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.path, forKey: .path)
    }

    // MARK: methods

    public func startCity(in gameModel: GameModel?) -> AbstractCity? {

        guard let firstPoint: HexPoint = self.path.first?.0 else {
            return nil
        }

        return gameModel?.city(at: firstPoint)
    }

    public func endCity(in gameModel: GameModel?) -> AbstractCity? {

        guard let lastPoint: HexPoint = self.path.last?.0 else {
            return nil
        }

        return gameModel?.city(at: lastPoint)
    }

    public func isDomestic(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let startLeader = self.startCity(in: gameModel)?.player?.leader else {
            return false
        }

        guard let endLeader = self.endCity(in: gameModel)?.player?.leader else {
            return false
        }

        return startLeader == endLeader
    }

    public func isInternational(in gameModel: GameModel?) -> Bool {

        return !self.isDomestic(in: gameModel)
    }

    /// get the yields per turn of a specific trade route
    ///
    /// - Parameter gameModel: game
    /// - Returns: `Yields` of this trade rotue
    /// https://civilization.fandom.com/wiki/Trade_Route_(Civ6)#Trade_Yields_Based_on_Districts
    public func yields(in gameModel: GameModel?) -> Yields {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let startCity = self.startCity(in: gameModel) else {
#warning("unclear why this happens")
            return Yields(food: 0, production: 0, gold: 0)
        }

        // this is the player that initiated the trade route
        guard let startPlayer = startCity.player else {
            fatalError("cant get start player")
        }

        guard let startPlayerGovernment = startPlayer.government else {
            fatalError("cant get start player government")
        }

        guard let endCity = self.endCity(in: gameModel) else {
            fatalError("cant get end city")
        }

        guard let endDistricts = endCity.districts else {
            fatalError("cant get end city districts")
        }

        var yields: Yields = Yields(food: 0.0, production: 0.0, gold: 0.0)

        if self.isDomestic(in: gameModel) {

            yields += endDistricts.domesticTradeYields()

            // satrapies - Domestic Trade Routes provide +2 Gold and +1 Culture.
            if startPlayer.leader.civilization().ability() == .satrapies {
                yields.gold += 2.0
                yields.culture += 1.0
            }

            // collectivization - +2 [Production] Production and +4 [Food] Food from domestic [TradeRoute] Trade Routes.
            if startPlayerGovernment.has(card: .collectivization) {
                yields.production += 2.0
                yields.food += 4.0
            }

            // universityOfSankore - Domestic Trade Routes give an additional +1 Faith to this city
            if endCity.has(wonder: .universityOfSankore) {
                yields.faith += 1.0
            }

            // isolationism - Domestic routes provide +2 [Food] Food, +2 [Production] Production.
            //    BUT: Can't train or buy Settlers nor settle new cities.
            if startPlayerGovernment.has(card: .isolationism) {
                yields.food += 2
                yields.production += 2
            }

        } else {

            yields += endDistricts.foreignTradeYields()

            if startPlayer.hasRetired(greatPerson: .zhangQian) {

                // Foreign Trade Routes to this city provide +2 Gold to both cities.
                yields.gold += 2.0
            }

            // amsterdam or antioch suzerain bonus
            // Your [TradeRoute] Trade Routes to foreign cities earn +1 [Gold] Gold for each luxury resource.
            if startPlayer.isSuzerain(of: .amsterdam, in: gameModel) ||
                startPlayer.isSuzerain(of: .antioch, in: gameModel) {

                let amountOfLuxuryResources = startCity.numLocalLuxuryResources(in: gameModel)
                yields.gold += 1.0 * Double(amountOfLuxuryResources)
            }

            // kumasi suzerain bonus
            // Your Trade Routes to any city-state provide +2 Culture and +1 Gold for every specialty district in the origin city.
            if startPlayer.isSuzerain(of: .kumasi, in: gameModel) && endCity.player?.isCityState() == true {

                guard let startCityDistricts = startCity.districts else {
                    fatalError("cant get start city districts")
                }

                let numberOfSpecialtyDistricts: Double = Double(startCityDistricts.numberOfSpecialtyDistricts())
                yields.culture += 2.0 * numberOfSpecialtyDistricts
                yields.gold += 1.0 * numberOfSpecialtyDistricts
            }

            // universityOfSankore - Other civilizations' Trade Routes to this city provide +1 Science and +1 Gold for them
            if endCity.has(wonder: .universityOfSankore) {
                yields.science += 1.0
                yields.gold += 1.0
            }
        }

        // caravansaries - +2 Gold from all Trade Routes.
        if startPlayerGovernment.has(card: .caravansaries) {
            yields.gold += 2.0
        }

        // tradeConfederation - +1 Culture and +1 Science from international Trade Routes.
        if startPlayerGovernment.has(card: .tradeConfederation) {

            yields.culture += 1.0
            yields.science += 1.0
        }

        // triangularTrade - +4 Gold and +1 Faith from all Trade Routes.
        if startPlayerGovernment.has(card: .triangularTrade) {

            yields.gold += 4.0
            yields.faith += 1.0
        }

        // ecommerce - +2 [Production] Production and +5 [Gold] Gold from all [TradeRoute] Trade Routes.
        if startPlayerGovernment.has(card: .ecommerce) {

            yields.production += 2.0
            yields.gold += 5.0
        }

        // universityOfSankore - +2 Science for every Trade Route to this city
        if endCity.has(wonder: .universityOfSankore) {
            yields.science += 2.0
        }

        if let endCityGovernor = endCity.governor() {
            // Your [TradeRoute] Trade Routes ending here provide +2 [Food] Food to their starting city.
            if endCityGovernor.type == .magnus && endCityGovernor.has(title: .surplusLogistics) {
                yields.food += 2.0
            }
        }

        /*
        // posts - currently no implemented
        yields.gold += Double(self.posts.count)

        if startPlayer.leader.civilization().ability() == .allRoadsLeadToRome {
            //  Trade Routes generate +1 additional Gold from Roman Trading Posts they pass through.
            yields.gold += Double(self.posts.count)
        }
         */

        return yields
    }
}
