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

class MoveTypeUnitAwarePathfinderDataSource: PathfinderDataSource {

    let gameModel: GameModel?
    let movementType: UnitMovementType
    let player: AbstractPlayer?
    let ignoreSight: Bool

    init(in gameModel: GameModel?, for movementType: UnitMovementType, for player: AbstractPlayer?, ignoreSight: Bool = true) {

        self.gameModel = gameModel
        self.movementType = movementType
        self.player = player
        self.ignoreSight = ignoreSight
    }

    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        var walkableCoords = [HexPoint]()

        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)

            if gameModel.valid(point: neighbor) {

                // are there obstacles

                if let toTile = gameModel.tile(at: neighbor) {
                    
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
                    
                    // if there is a unit of another players
                    if let otherUnit = gameModel.unit(at: neighbor) {
                        // we cant step into a tile that is occupied by another players unit
                        if !player.isEqual(to: otherUnit.player) {
                        
                            // unless we are at war, the we can
                            if !diplomacyAI.isAtWar(with: otherUnit.player) {
                                continue
                            }
                        }
                    }
                    
                    // territory
                    if let owner = toTile.owner() {
                        
                        // we cant step into a tile that is owned by another players
                        if !player.isEqual(to: owner) {
                            
                            // unless we are at war, the we can
                            if !diplomacyAI.isAtWar(with: owner) {
                                continue
                            }
                        }
                    }
                    
                    if let fromTile = gameModel.tile(at: coord) {
                        
                        if toTile.movementCost(for: self.movementType, from: fromTile) < UnitMovementType.max {
                            walkableCoords.append(neighbor)
                        }
                    }
                }
            }
        }

        return walkableCoords
    }

    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Double {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        if let toTile = gameModel.tile(at: toTileCoord),
            let fromTile = gameModel.tile(at: fromTileCoord) {
            
            return toTile.movementCost(for: self.movementType, from: fromTile)
        }

        return UnitMovementType.max
    }
}
