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
    
    // FIXME - take trading posts into account
    // FIXME - sea trading routes
    public func establishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool {
        
        guard let originCityLocation = originCity?.location else {
            fatalError("cant get origin city location")
        }
        
        guard let targetCityLocation = targetCity?.location else {
            fatalError("cant get target city location")
        }
        
        let tradeRouteFinder = AStarPathfinder()
        tradeRouteFinder.dataSource = TradeRoutePathfinderDataSource(for: self.player, with: self, in: gameModel)
        
        if let tradeRoutePath = tradeRouteFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) {
            print("tradeRoutePath: \(tradeRoutePath)")
            let posts: [HexPoint] = tradeRoutePath.pathWithoutLast().points()
            self.routes.append(TradeRoute(start: originCityLocation, posts: posts, end: targetCityLocation))
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
        tradeRouteFinder.dataSource = TradeRoutePathfinderDataSource(for: self.player, with: self, in: gameModel)
        
        if tradeRouteFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) != nil {
            return true
        }
        
        return false
    }
    
}
