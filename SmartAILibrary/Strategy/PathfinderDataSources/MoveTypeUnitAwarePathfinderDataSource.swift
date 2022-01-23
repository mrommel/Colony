//
//  MoveTypeUnitAwarePathfinderDataSource.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 25.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class MoveTypeUnitAwareOptions {

    let ignoreSight: Bool
    let ignoreOwner: Bool
    let unitMapType: UnitMapType
    let canEmbark: Bool
    let canEnterOcean: Bool

    init(ignoreSight: Bool = true, ignoreOwner: Bool = false, unitMapType: UnitMapType, canEmbark: Bool, canEnterOcean: Bool) {

        self.ignoreSight = ignoreSight
        self.ignoreOwner = ignoreOwner
        self.unitMapType = unitMapType
        self.canEmbark = canEmbark
        self.canEnterOcean = canEnterOcean
    }
}

class MoveTypeUnitAwarePathfinderDataSource: PathfinderDataSource {

    let gameModel: GameModel?
    let movementType: UnitMovementType
    let player: AbstractPlayer?
    let options: MoveTypeUnitAwareOptions

    init(in gameModel: GameModel?, for movementType: UnitMovementType, for player: AbstractPlayer?, options: MoveTypeUnitAwareOptions) {

        self.gameModel = gameModel
        self.movementType = movementType
        self.player = player

        self.options = options
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
                    if self.movementType == .walk {
                        if toTile.terrain() == .ocean && !self.options.canEnterOcean {
                            continue
                        }

                        if toTile.isWater() && !self.options.canEmbark {
                            continue
                        }

                        if toTile.isWater() && (self.options.canEmbark && toTile.isImpassable(for: .swim)) {
                            continue
                        }

                        if toTile.isLand() && toTile.isImpassable(for: .walk) {
                            continue
                        }
                    } else if self.movementType == .swim {
                        if toTile.terrain() == .ocean && !self.options.canEnterOcean {
                            continue
                        }
                        
                        if toTile.isWater() && toTile.isImpassable(for: .swim) {
                            continue
                        }
                    }

                    // civilian cant walk on barbarian camps
                    if self.options.unitMapType == .civilian && toTile.has(improvement: .barbarianCamp) {
                        continue
                    }

                    // use sight?
                    if !self.options.ignoreSight {

                        // skip if not in sight or discovered
                        if !toTile.isDiscovered(by: self.player) {
                            continue
                        }

                        /*if !toTile.isVisible(to: self.player) {
                            continue
                        }*/
                    }

                    // if there is a unit of own type ...
                    if let otherUnit = gameModel.unit(at: neighbor, of: self.options.unitMapType) {

                        // ... there are two cases:
                        if player.isEqual(to: otherUnit.player) {
                            // 1) it's us:
                            // only 1x combat + 1x civilian

                            // FIXME
                            continue
                        } else {
                            // 2) it's some else:
                            // we cant step into a tile that is occupied by another players unit

                            // unless we are at war, the we can
                            /*if !diplomacyAI.isAtWar(with: otherUnit.player) && !otherUnit.player!.isBarbarian() {
                                continue
                            }*/
                            continue
                        }
                    }

                    // territory
                    if let owner = toTile.owner() {

                        // we cant step into a tile that is owned by another players
                        if !player.isEqual(to: owner) && !self.options.ignoreOwner {

                            // unless we are at war, the we can
                            if !diplomacyAI.isAtWar(with: owner) {
                                continue
                            }
                        }
                    }

                    if let city = gameModel.city(at: neighbor) {

                        // own city has little costs
                        if player.isEqual(to: city.player) {
                            walkableCoords.append(neighbor)
                            continue
                        }
                    }

                    if let fromTile = gameModel.tile(at: coord) {

                        let normalMovementCosts = toTile.movementCost(for: self.movementType, from: fromTile)
                        var embarkedMovementCosts = UnitMovementType.max

                        if self.options.canEmbark && self.movementType == .walk {

                            if fromTile.isLand() && toTile.isWater() {
                                embarkedMovementCosts = 2.0
                            } else if fromTile.isWater() && toTile.isLand() {
                                embarkedMovementCosts = 2.0
                            } else {
                                embarkedMovementCosts = toTile.movementCost(for: .swim, from: fromTile)
                            }
                        }

                        if min(normalMovementCosts, embarkedMovementCosts) < UnitMovementType.max {
                            walkableCoords.append(neighbor)
                        }
                    }
                }
            }
        }

        return walkableCoords
    }

    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Double {

        guard let gameModel = self.gameModel, let player = self.player else {
            fatalError("cant get gameModel")
        }

        if let toTile = gameModel.tile(at: toTileCoord),
            let fromTile = gameModel.tile(at: fromTileCoord) {

            if let city = gameModel.city(at: toTileCoord) {

                // own city has little costs
                if player.isEqual(to: city.player) {
                    return 0.7
                }
            }

            let normalMovementCosts = toTile.movementCost(for: self.movementType, from: fromTile)
            var embarkedMovementCosts = UnitMovementType.max

            if self.options.canEmbark && self.movementType == .walk {

                if fromTile.isLand() && toTile.isWater() {
                    embarkedMovementCosts = 2.0
                } else if fromTile.isWater() && toTile.isLand() {
                    embarkedMovementCosts = 2.0
                } else {
                    embarkedMovementCosts = toTile.movementCost(for: .swim, from: fromTile)
                }
            }

            return min(normalMovementCosts, embarkedMovementCosts)
        }

        return UnitMovementType.max
    }
}
