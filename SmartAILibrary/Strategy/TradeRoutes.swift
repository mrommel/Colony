//
//  TradeRoutes.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractTradeRoutes {

    var player: Player? { get set }

    func hasTradeRoute(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool

    func establishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool
    func finish(tradeRoute: TradeRoute?)

    func canEstablishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, in gameModel: GameModel?) -> Bool

    func numberOfTradeRoutes() -> Int
    func tradeRoute(at index: Int) -> TradeRoute?
    func tradeRoutesStarting(at city: AbstractCity?) -> [TradeRoute]
    func clearTradeRoutes(at point: HexPoint)

    func yields(in gameModel: GameModel?) -> Yields
}

public class TradeRoutes: Codable, AbstractTradeRoutes {

    enum CodingKeys: String, CodingKey {

        case routes
    }

    public static let landRange = 15

    public var player: Player?
    private var routes: [TradeRoute]

    // MARK: constructors

    init(player: Player?) {

        self.player = player
        self.routes = []
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.routes = try container.decode([TradeRoute].self, forKey: .routes)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.routes, forKey: .routes)
    }

    public func numberOfTradeRoutes() -> Int {

        return self.routes.count
    }

    public func hasTradeRoute(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get other player")
        }

        return self.routes.contains(where: { route in
            guard let startCity = route.startCity(in: gameModel) else {
                return false
            }

            guard let endCity = route.endCity(in: gameModel) else {
                return false
            }

            return otherPlayer.isEqual(to: startCity.player) || otherPlayer.isEqual(to: endCity.player)
        })
    }

    public func tradeRoute(at index: Int) -> TradeRoute? {

        guard 0 <= index && index < self.routes.count else {
            return nil
        }

        return self.routes[index]
    }

    public func tradeRoutesStarting(at city: AbstractCity?) -> [TradeRoute] {

        guard let cityLocation = city?.location else {
            fatalError("cant get city location")
        }

        return self.routes.filter({ $0.start == cityLocation })
    }

    public func clearTradeRoutes(at point: HexPoint) {

        self.routes.removeAll(where: { $0.start == point })
    }

    public func yields(in gameModel: GameModel?) -> Yields {

        var yields: Yields = Yields(food: 0.0, production: 0.0, gold: 0.0)

        for route in self.routes {
            yields += route.yields(in: gameModel)
        }

        return yields
    }

    // FIXME - sea trading routes
    public func establishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool {

        guard let originCityLocation = originCity?.location else {
            fatalError("cant get origin city location")
        }

        guard let targetCityLocation = targetCity?.location else {
            fatalError("cant get target city location")
        }

        let tradeRouteFinderDataSource = TradeRoutePathfinderDataSource(
            for: self.player,
            from: originCityLocation,
            to: targetCityLocation,
            in: gameModel
        )
        let tradeRouteFinder = AStarPathfinder(with: tradeRouteFinderDataSource)

        if var tradeRoutePath = tradeRouteFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) {

            tradeRoutePath.prepend(point: originCityLocation, cost: 0.0)

            if tradeRoutePath.last?.0 != targetCityLocation {
                tradeRoutePath.append(point: targetCityLocation, cost: 0.0)
            }

            let tradeRoute = TradeRoute(path: tradeRoutePath)
            trader?.start(tradeRoute: tradeRoute, in: gameModel)
            self.routes.append(tradeRoute)
            return true
        }

        return false
    }

    public func finish(tradeRoute tradeRouteRef: TradeRoute?) {

        guard let tradeRoute = tradeRouteRef else {
            fatalError("cant get trade route")
        }

        self.routes.removeAll(where: { $0.start == tradeRoute.start && $0.end == tradeRoute.end })
    }

    public func canEstablishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let originCityLocation = originCity?.location else {
            fatalError("cant get origin city location")
        }

        guard let targetCityLocation = targetCity?.location else {
            fatalError("cant get target city location")
        }

        let tradeRouteFinderDataSource = TradeRoutePathfinderDataSource(
            for: self.player,
            from: originCityLocation,
            to: targetCityLocation,
            in: gameModel
        )
        let tradeRouteFinder = AStarPathfinder(with: tradeRouteFinderDataSource)

        if tradeRouteFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) != nil {
            return true
        }

        return false
    }
}
