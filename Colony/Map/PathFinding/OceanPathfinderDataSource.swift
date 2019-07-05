//
//  OceanPathfinderDataSource.swift
//  Colony
//
//  Created by Michael Rommel on 31.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class MoveTypePathfinderDataSource: PathfinderDataSource {
    
    let map: HexagonTileMap
    let moveType: GameObjectMoveType
    let ignoreSight: Bool

    init(map: HexagonTileMap, moveType: GameObjectMoveType, ignoreSight: Bool) {
        self.map = map
        self.moveType = moveType
        self.ignoreSight = ignoreSight
    }
    
    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {
        
        var walkableCoords = [HexPoint]()
        
        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)
            if map.valid(point: neighbor) {
                
                let fogState = map.fogManager?.fog(at: neighbor)
                
                // use sight?
                if !self.ignoreSight {
                    // skip if not in sight or discovered
                    if fogState != .discovered && fogState != .sighted {
                        continue
                    }
                }
                
                if let terrain = self.map.tile(at: neighbor)?.terrain {
                
                    if cost(for: terrain) > GameObjectMoveType.impassible {
                        walkableCoords.append(neighbor)
                    }
                }
            }
        }
        
        return walkableCoords
    }
    
    func cost(for terrain: Terrain) -> Float {
        
        switch terrain {
        case .ocean:
            return self.moveType.movementCosts.ocean
        case .plain:
            return self.moveType.movementCosts.plain
        case .grass:
            return self.moveType.movementCosts.grass
        case .desert:
            return self.moveType.movementCosts.desert
        case .tundra:
            return self.moveType.movementCosts.tundra
        case .snow:
            return self.moveType.movementCosts.snow
        case .shore:
            return self.moveType.movementCosts.shore
            
        // types from map generation
        case .water:
            return GameObjectMoveType.impassible
        case .ground:
            return GameObjectMoveType.impassible
        }
    }
    
    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Float {
        
        if let terrain = self.map.tile(at: toTileCoord)?.terrain {
            return self.cost(for: terrain)
        }
        
        return GameObjectMoveType.impassible
    }
}

/*class OceanPathfinderDataSourceIgnoreSight: PathfinderDataSource {
    
    let map: HexagonTileMap
    
    init(map: HexagonTileMap) {
        self.map = map
    }
    
    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {
        
        var walkableCoords = [HexPoint]()
        
        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)
            if map.valid(point: neighbor) {

                if map.isWater(at: neighbor) {
                    walkableCoords.append(neighbor)
                }
            }
        }
        
        return walkableCoords
    }
    
    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Float {
        return 1
    }
}*/
