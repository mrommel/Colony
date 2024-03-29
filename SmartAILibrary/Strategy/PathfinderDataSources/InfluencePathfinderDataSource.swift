//
//  InfluencePathfinderDataSource.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class InfluencePathfinderDataSource: PathfinderDataSource {

    let mapModel: MapModel?
    let cityLoction: HexPoint
    let wrapXValue: Int

    init(in mapModelRef: MapModel?, cityLoction: HexPoint) {

        self.mapModel = mapModelRef
        self.cityLoction = cityLoction

        guard let mapModel = self.mapModel else {
            fatalError("cant get mapModel")
        }

        self.wrapXValue = mapModel.wrapX ? mapModel.size.width() : -1
    }

    func walkableAdjacentTilesCoords(forTileCoord tileCoord: HexPoint) -> [HexPoint] {

        guard let mapModel = self.mapModel else {
            fatalError("cant get mapModel")
        }

        var neighbors: [HexPoint] = []

        for direction in HexDirection.all {

            var neighbor = tileCoord.neighbor(in: direction)

            if mapModel.wrapX {
                neighbor = mapModel.wrap(point: neighbor)
            }

            if mapModel.valid(point: neighbor) {
                neighbors.append(neighbor)
            }
        }

        return neighbors
    }

    /// Influence path finder - compute cost of a path
    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Double {

        guard let mapModel = self.mapModel else {
            fatalError("cant get mapModel")
        }

        guard let cityTile = mapModel.tile(at: self.cityLoction) else {
            fatalError("cant get cityTile")
        }

        guard let fromTile = mapModel.tile(at: fromTileCoord) else {
            fatalError("cant get fromTile")
        }

        guard let toTile = mapModel.tile(at: toTileCoord) else {
            fatalError("cant get toTile")
        }

        var cost = 0

        if fromTileCoord != self.cityLoction {

            if cityTile.hasOwner() && toTile.hasOwner() && cityTile.owner()?.leader != toTile.owner()?.leader {
                cost += 15
            }
        }

        if fromTile.isRiverToCross(towards: toTile, wrapX: self.wrapXValue) {
            cost += 1 /* INFLUENCE_RIVER_COST */
        }

        if toTile.hasHills() {
            // Hill cost
            cost +=  2 /* INFLUENCE_HILL_COST */
        } else if toTile.has(feature: .mountains) {
            // Mountain Cost
            cost += 3 /* INFLUENCE_MOUNTAIN_COST */

        } else {
            // Not a hill or mountain - use the terrain cost
            cost += 1 // GC.getTerrainInfo(pToPlot->getTerrainType())->getInfluenceCost();
            cost += !toTile.hasAnyFeature() ? 0 : 1 /*GC.getFeatureInfo(pToPlot->getFeatureType())->getInfluenceCost() */
        }

        cost = max(1, cost)
        return Double(cost)
    }

    func wrapX() -> Int {

        return self.wrapXValue
    }

    func useCache() -> Bool {

        return false
    }
}
