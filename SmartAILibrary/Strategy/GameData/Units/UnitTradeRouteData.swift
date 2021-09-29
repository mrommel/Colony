//
//  UnitTradeRoute.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class UnitTradeRouteData {

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
            if mission.type == .routeTo {
                isFollowingMission = true
            }
        }

        if !isFollowingMission {
            if let target = self.nextTarget(for: unit, in: gameModel) {
                let mission = UnitMission(type: .routeTo, at: target)
                unit.push(mission: mission, in: gameModel)
            } else {
                unit.endTrading()
            }
        }
    }

    func nextTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {

        guard let current = unit?.location else {
            fatalError("cant get location")
        }

        switch self.direction {

        case .start: // move to start location (without building a road)

            // check if unit directly at start city
            if current == self.tradeRoute.start {
                self.direction = .forward
                return self.nextTarget(for: unit, in: gameModel)
            }

            // otherwise go to the start city
            return self.tradeRoute.start

        case .forward: // go towards target city

            // check if unit directly at one of the points
            if current == self.tradeRoute.start {

                if let firstPost = self.tradeRoute.posts.first {
                    return firstPost
                } else {
                    return self.tradeRoute.end
                }
            }

            for (index, post) in self.tradeRoute.posts.enumerated() where post == current {

                if index + 1 < self.tradeRoute.posts.count {
                    return self.tradeRoute.posts[index + 1]
                } else {
                    return self.tradeRoute.end
                }
            }

            if current == self.tradeRoute.end {
                self.direction = .backward
                return self.nextTarget(for: unit, in: gameModel)
            }
        case .backward: // come back to start city

            if current == self.tradeRoute.end {
                if let lastPost = self.tradeRoute.posts.last {
                    return lastPost
                } else {
                    return self.tradeRoute.start
                }
            }

            for (index, post) in self.tradeRoute.posts.reversed().enumerated() where post == current {

                if index > 0 {
                    return self.tradeRoute.posts[index - 1]
                } else {
                    return self.tradeRoute.start
                }
            }

            if current == self.tradeRoute.start {

                // if route is expired, stop here
                self.checkExpiration(for: unit, in: gameModel)
                if self.state == .expired {
                    unit?.endTrading()
                    return nil // this should stop the route, user can select next route
                }

                self.direction = .forward
                return self.nextTarget(for: unit, in: gameModel)
            }
        }

        // find next city and go there
        var bestDistance = Int.max
        var bestLocation: HexPoint?

        var points: [HexPoint] = [self.tradeRoute.start, self.tradeRoute.end]
        points.append(contentsOf: self.tradeRoute.posts)

        for point in points {

            let distance = current.distance(to: point)

            if distance < bestDistance {
                bestDistance = distance
                bestLocation = point
            }
        }

        return bestLocation
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
