//
//  OceanPathfinderDataSource.swift
//  Colony
//
//  Created by Michael Rommel on 31.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class MoveTypePathfinderDataSource: PathfinderDataSource {
    
    let map: HexagonTileMap?
    let gameObjectManager: GameObjectManager?
    let movementType: MovementType
    let civilization: Civilization
    let ignoreSight: Bool

    init(map: HexagonTileMap?, gameObjectManager: GameObjectManager?, movementType: MovementType, civilization: Civilization, ignoreSight: Bool) {
        self.map = map
        self.gameObjectManager = gameObjectManager
        self.movementType = movementType
        self.civilization = civilization
        self.ignoreSight = ignoreSight
    }
    
    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {
        
        var walkableCoords = [HexPoint]()
        
        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)
            if map?.valid(point: neighbor) ?? false {
                
                // are there obstacles
                /*if self.gameObjectManager?.obstacle(at: neighbor) ?? false {
                    continue
                }*/
                
                // use sight?
                if !self.ignoreSight {
                    
                    let fogState = map?.fogManager?.fog(at: neighbor, by: self.civilization)
                    
                    // skip if not in sight or discovered
                    if fogState != .discovered && fogState != .sighted {
                        continue
                    }
                }
                
                if let fromTile = self.map?.tile(at: coord), let toTile = self.map?.tile(at: neighbor) {
                
                    if toTile.movementCost(for: self.movementType, from: fromTile) > MovementType.impassible {
                        walkableCoords.append(neighbor)
                    }
                }
            }
        }
        
        return walkableCoords
    }
    
    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Float {
        
        if let toTile = self.map?.tile(at: toTileCoord), let fromTile = self.map?.tile(at: fromTileCoord) {
            return toTile.movementCost(for: self.movementType, from: fromTile)
        }
        
        return MovementType.impassible
    }
}
