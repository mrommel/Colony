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
    let wrapXValue: Int

    init(for player: AbstractPlayer?,
         from startLocation: HexPoint,
         to targetLocation: HexPoint,
         in gameModelRef: GameModel?) {

        guard let gameModel = gameModelRef else {
            fatalError("cant get gameModel")
        }

        self.player = player

        self.startLocation = startLocation
        self.targetLocation = targetLocation

        self.gameModel = gameModel

        self.wrapXValue = gameModel.wrappedX() ? gameModel.mapSize().width() : -1
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
            var neighbor = coord.neighbor(in: direction)

            if gameModel.wrappedX() {
                neighbor = gameModel.wrap(point: neighbor)
            }

            var isReachable: Bool = false

            if neighbor.distance(to: startLocation, wrapX: self.wrapXValue) < TradeRoutes.landRange {
                isReachable = true
            }

            for tradingPostLocation in self.tradingPostLocations {
                if neighbor.distance(to: tradingPostLocation) < TradeRoutes.landRange {
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

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let originCityLocation = originCity?.location else {
            fatalError("cant get origin city location")
        }

        guard let targetCityLocation = targetCity?.location else {
            fatalError("cant get target city location")
        }

        // traders cant embark for their land trade routes
        let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: originCity?.player,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        guard let path = pathFinder.shortestPath(fromTileCoord: originCityLocation, toTileCoord: targetCityLocation) else {
            print("no path")
            return false
        }

        guard path.count <= TradeRoutes.landRange else {
            print("trading posts not handled")
            return false
        }

        return true
    }

    func wrapX() -> Int {

        return self.wrapXValue
    }

    func useCache() -> Bool {

        return false
    }
}
