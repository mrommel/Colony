//
//  MoveTypeIgnoreUnitsPathfinderDataSource.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class MoveTypeIgnoreUnitsOptions {

    let ignoreSight: Bool
    let unitMapType: UnitMapType
    let canEmbark: Bool
    let canEnterOcean: Bool

    init(ignoreSight: Bool = true, unitMapType: UnitMapType, canEmbark: Bool, canEnterOcean: Bool) {

        self.ignoreSight = ignoreSight
        self.unitMapType = unitMapType
        self.canEmbark = canEmbark
        self.canEnterOcean = canEnterOcean
    }
}

class MoveTypeIgnoreUnitsPathfinderDataSource: PathfinderDataSource {

    let mapModel: MapModel?
    let movementType: UnitMovementType
    let player: AbstractPlayer?
    let options: MoveTypeIgnoreUnitsOptions

    init(in mapModel: MapModel?, for movementType: UnitMovementType, for player: AbstractPlayer?, options: MoveTypeIgnoreUnitsOptions) {

        self.mapModel = mapModel
        self.movementType = movementType
        self.player = player
        self.options = options
    }

    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {

        guard let mapModel = self.mapModel else {
            fatalError("cant get mapModel")
        }

        var walkableCoords = [HexPoint]()

        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)

            if mapModel.valid(point: neighbor) {

                // are there obstacles

                if let toTile = mapModel.tile(at: neighbor) {

                    // walkable ?
                    if self.movementType == .walk {
                        if toTile.terrain() == .ocean && !self.options.canEnterOcean {
                            continue
                        }

                        if toTile.isWater() && self.options.canEmbark && toTile.isImpassable(for: .swim) {
                            continue
                        }

                        if toTile.isLand() && toTile.isImpassable(for: .walk) {
                            continue
                        }
                    } else if self.movementType == .swim {
                        if toTile.terrain() == .ocean && !self.options.canEnterOcean {
                            continue
                        }
                        
                        if toTile.isWater() &&  toTile.isImpassable(for: .swim) {
                            continue
                        }
                    }

                    // use sight?
                    if !self.options.ignoreSight {

                        // skip if not in sight or discovered
                        if !toTile.isDiscovered(by: self.player) {
                            continue
                        }

                        if !toTile.isVisible(to: self.player) {
                            continue
                        }
                    }

                    if let fromTile = mapModel.tile(at: coord) {

                        if toTile.movementCost(for: self.movementType, from: fromTile)  < UnitMovementType.max {
                            walkableCoords.append(neighbor)
                        }
                    }
                }
            }
        }

        return walkableCoords
    }

    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Double {

        guard let mapModel = self.mapModel else {
            fatalError("cant get mapModel")
        }

        if let toTile = mapModel.tile(at: toTileCoord),
            let fromTile = mapModel.tile(at: fromTileCoord) {

            return toTile.movementCost(for: self.movementType, from: fromTile)
        }

        return UnitMovementType.max
    }
}
