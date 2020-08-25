//
//  MoveTypeIgnoreUnitsPathfinderDataSource.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class MoveTypeIgnoreUnitsPathfinderDataSource: PathfinderDataSource {

    let mapModel: MapModel?
    let movementType: UnitMovementType
    let player: AbstractPlayer?
    let ignoreSight: Bool

    init(in mapModel: MapModel?, for movementType: UnitMovementType, for player: AbstractPlayer?, ignoreSight: Bool = true) {

        self.mapModel = mapModel
        self.movementType = movementType
        self.player = player
        self.ignoreSight = ignoreSight
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
                    if toTile.isImpassable() {
                        continue
                    }
                    
                    // use sight?
                    if !self.ignoreSight {

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
