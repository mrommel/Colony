//
//  TradeRoutePathfinderDataSource.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TradeRoutePathfinderDataSource: PathfinderDataSource {

    let gameModel: GameModel?
    let player: AbstractPlayer?
    let targetLocation: HexPoint

    init(for player: AbstractPlayer?, with targetLocation: HexPoint, in gameModel: GameModel?) {

        self.gameModel = gameModel
        self.player = player
        self.targetLocation = targetLocation
    }

    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let leader = self.player?.leader else {
            fatalError("cant get leader")
        }

        var walkableCoords = [HexPoint]()
        
        guard let startCity = gameModel.city(at: coord) else {
            return walkableCoords
        }

        for pt in coord.areaWith(radius: TradeRoutes.range) {
            
            if let city = gameModel.city(at: pt),
                let cityTradingPosts = city.cityTradingPosts {
                
                if (pt == targetLocation || cityTradingPosts.hasTradingPost(for: leader)) && self.canEstablishDirectTradeRoute(from: startCity, to: city, in: gameModel) {
                    walkableCoords.append(pt)
                }
            }
        }

        return walkableCoords
    }

    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Double {
        
        return 1
    }
    
    private func canEstablishDirectTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, in gameModel: GameModel?) -> Bool {
        
        guard let originCityLocation = originCity?.location else {
            fatalError("cant get origin city location")
        }
        
        guard let targetCityLocation = targetCity?.location else {
            fatalError("cant get target city location")
        }
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel?.ignoreUnitsPathfinderDataSource(for: .walk, for: originCity?.player)
        
        guard let path = pathFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) else {
            print("no path")
            return false
        }
        
        guard path.count <= TradeRoutes.range else {
            print("trading posts not handled")
            return false
        }
        
        return true
    }
}
