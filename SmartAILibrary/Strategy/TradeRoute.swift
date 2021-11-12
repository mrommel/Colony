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

        return startLeader != endLeader
    }

    public func isInternational(in gameModel: GameModel?) -> Bool {

        return !self.isDomestic(in: gameModel)
    }

    // https://civilization.fandom.com/wiki/Trade_Route_(Civ6)#Trade_Yields_Based_on_Districts
    public func yields(in gameModel: GameModel?) -> Yields {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let startPlayer = self.startCity(in: gameModel)?.player else {
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

            if startPlayer.leader.civilization().ability() == .satrapies {
                // Domestic Trade Routes provide +2 Gold and +1 Culture.
                yields.gold += 2.0
                yields.culture += 1.0
            }
        } else {

            yields += endDistricts.foreignTradeYields()

            if startPlayer.hasRetired(greatPerson: .zhangQian) {

                // Foreign Trade Routes to this city provide +2 Gold to both cities.
                yields.gold += 2.0
            }
        }

        if startPlayerGovernment.has(card: .caravansaries) {
            yields.gold += 2.0
        }

        // tradeConfederation - +1 Culture and +1 Science from international Trade Routes.
        if startPlayerGovernment.has(card: .tradeConfederation) {

            yields.culture += 1.0
            yields.science += 1.0
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
