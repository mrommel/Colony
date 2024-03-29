//
//  UnitTradeRoute.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class UnitTradeRouteData: Codable {

    enum CodingKeys: String, CodingKey {

        case tradeRoute
        case direction
        case establishedInTurn
        case state
    }

    let tradeRoute: TradeRoute
    var direction: UnitTradeRouteDirection
    let establishedInTurn: Int
    var state: UnitTradeRouteState

    init(from tradeRoute: TradeRoute, in turn: Int) {

        self.tradeRoute = tradeRoute
        self.direction = .start
        self.establishedInTurn = turn
        self.state = .active
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.tradeRoute = try container.decode(TradeRoute.self, forKey: .tradeRoute)
        self.direction = try container.decode(UnitTradeRouteDirection.self, forKey: .direction)
        self.establishedInTurn = try container.decode(Int.self, forKey: .establishedInTurn)
        self.state = try container.decode(UnitTradeRouteState.self, forKey: .state)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.tradeRoute, forKey: .tradeRoute)
        try container.encode(self.direction, forKey: .direction)
        try container.encode(self.establishedInTurn, forKey: .establishedInTurn)
        try container.encode(self.state, forKey: .state)
    }

    // https://civilization.fandom.com/wiki/Trade_Route_(Civ6)#Duration
    private func tradeRouteDuration(in era: EraType) -> Int {

        let baseDuration = 21

        switch era {

        case .none, .ancient, .classical:
            return baseDuration + 0
        case .medieval, .renaissance:
            return baseDuration + 10
        case .industrial, .modern, .atomic:
            return baseDuration + 20
        case .information, .future:
            return baseDuration + 30
        }
    }

    func doTurn(for unit: AbstractUnit?, in gameModel: GameModel?) {

        guard let unit = unit else {
            fatalError("cant get data")
        }

        var isFollowingMission = false
        if let mission = unit.peekMission() {
            if mission.type == .followPath {
                isFollowingMission = true
            }
        }

        if !isFollowingMission {
            if let path = self.nextPath(for: unit, in: gameModel) {
                let mission = UnitMission(type: .followPath, follow: path)
                unit.push(mission: mission, in: gameModel)
            }
        }
    }

    func nextPath(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPath? {

        guard let current = unit?.location else {
            fatalError("cant get location")
        }

        switch self.direction {

        case .start: // move to start location (without building a road)

            // check if unit directly at start city
            if current == self.tradeRoute.start {
                self.direction = .forward
                return self.nextPath(for: unit, in: gameModel)
            }

            // otherwise go to the start city
            if let path = unit?.path(towards: self.tradeRoute.start, options: .none, in: gameModel) {
                return path
            }

        case .forward: // go towards target city

            // check if unit directly at one of the points
            if current == self.tradeRoute.start {
                return self.tradeRoute.path
            }

            if current == self.tradeRoute.end {
                self.direction = .backward
                return self.nextPath(for: unit, in: gameModel)
            }

        case .backward: // come back to start city

            if current == self.tradeRoute.end {
                return self.tradeRoute.path.reversed()
            }

            if current == self.tradeRoute.start {

                // if route is expired, stop here
                self.checkExpiration(for: unit, in: gameModel)
                if self.state == .expired {
                    unit?.endTrading(in: gameModel)
                    return nil // this should stop the route, user can select next route
                }

                self.direction = .forward
                return self.nextPath(for: unit, in: gameModel)
            }
        }

        return nil
    }

    func checkExpiration(for unit: AbstractUnit?, in gameModel: GameModel?) {

        if self.expiresInTurns(for: unit, in: gameModel) < 0 {
            self.state = .expired
        }
    }

    public func expiresInTurns(for unit: AbstractUnit?, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
                fatalError("cant get game")
        }

        guard let playerEra = unit?.player?.currentEra() else {
            fatalError("cant get era")
        }

        return self.establishedInTurn + self.tradeRouteDuration(in: playerEra) - gameModel.currentTurn
    }

    public func startCity(in gameModel: GameModel?) -> AbstractCity? {

        return self.tradeRoute.startCity(in: gameModel)
    }

    public func endCity(in gameModel: GameModel?) -> AbstractCity? {

        return self.tradeRoute.endCity(in: gameModel)
    }

    public func yields(in gameModel: GameModel?) -> Yields {

        return self.tradeRoute.yields(in: gameModel)
    }
}
