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
    
    func establishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool
    
    func canEstablishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, in gameModel: GameModel?) -> Bool
    
    func numberOfTradeRoutes() -> Int
    func yields(in gameModel: GameModel?) -> Yields
    func tradeRoutesStarting(at city: AbstractCity?) -> [TradeRoute]
}

public class TradeRoutes: Codable, AbstractTradeRoutes {
    
    enum CodingKeys: String, CodingKey {
    
        case routes
    }
    
    public static let range = 15
    
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
    
    public func tradeRoutesStarting(at city: AbstractCity?) -> [TradeRoute] {
        
        guard let cityLocation = city?.location else {
            fatalError("cant get city location")
        }
        
        return self.routes.filter({ $0.start == cityLocation })
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
        
        let tradeRouteFinder = AStarPathfinder()
        tradeRouteFinder.dataSource = TradeRoutePathfinderDataSource(for: self.player, from: originCityLocation, to: targetCityLocation, in: gameModel)
        
        if let tradeRoutePath = tradeRouteFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) {
            print("tradeRoutePath: \(tradeRoutePath)")
            let posts: [HexPoint] = tradeRoutePath.pathWithoutLast().points()
            let tradeRoute = TradeRoute(start: originCityLocation, posts: posts, end: targetCityLocation)
            trader?.start(tradeRoute: tradeRoute, in: gameModel)
            self.routes.append(tradeRoute)
            return true
        }
        
        return false
    }
    
    public func canEstablishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, in gameModel: GameModel?) -> Bool {
        
        guard let originCityLocation = originCity?.location else {
            fatalError("cant get origin city location")
        }
        
        guard let targetCityLocation = targetCity?.location else {
            fatalError("cant get target city location")
        }
        
        let tradeRouteFinder = AStarPathfinder()
        tradeRouteFinder.dataSource = TradeRoutePathfinderDataSource(for: self.player, from: originCityLocation, to: targetCityLocation, in: gameModel)
        
        if tradeRouteFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) != nil {
            return true
        }
        
        return false
    }
    
}
