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

    let startLocation: HexPoint
    let targetLocation: HexPoint

    var tradingPostLocations: [HexPoint] = []

    init(for player: AbstractPlayer?,
         from startLocation: HexPoint,
         to targetLocation: HexPoint,
         in gameModel: GameModel?) {

        self.player = player

        self.startLocation = startLocation
        self.targetLocation = targetLocation

        self.gameModel = gameModel
    }

    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }

        guard let leader = self.player?.leader else {
            fatalError("cant get leader")
        }

        guard let startCity = gameModel.city(at: self.startLocation) else {
            return []
        }

        var walkableCoords = [HexPoint]()

        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)

            var isReachable: Bool = false

            if neighbor.distance(to: startLocation) < TradeRoutes.range {
                isReachable = true
            }

            for tradingPostLocation in self.tradingPostLocations {
                if neighbor.distance(to: tradingPostLocation) < TradeRoutes.range {
                    isReachable = true
                }
            }

            if !isReachable {
                continue
            }

            if gameModel.valid(point: neighbor) {

                if let toTile = gameModel.tile(at: neighbor) {

                    // walkable ?
                    if toTile.isWater() {
                        continue
                    }
                }

                // add city
                if let city = gameModel.city(at: neighbor),
                    let cityTradingPosts = city.cityTradingPosts {

                    if cityTradingPosts.hasTradingPost(for: leader) &&
                        self.canEstablishDirectTradeRoute(from: startCity, to: city, in: gameModel) {

                        self.tradingPostLocations.append(neighbor)
                    }
                }

                walkableCoords.append(neighbor)
            }
        }
        /*for pt in coord.areaWith(radius: TradeRoutes.range) {
            
            if let city = gameModel.city(at: pt),
                let cityTradingPosts = city.cityTradingPosts {
                
                if (pt == targetLocation || cityTradingPosts.hasTradingPost(for: leader)) && self.canEstablishDirectTradeRoute(from: startCity, to: city, in: gameModel) {
                    walkableCoords.append(pt)
                }
            }
        }*/

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
        pathFinder.dataSource = gameModel?.ignoreUnitsPathfinderDataSource(for: .walk, for: originCity?.player, unitMapType: .combat, canEmbark: true)

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
