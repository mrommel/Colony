//
//  OceanPathfinderDataSource.swift
//  Colony
//
//  Created by Michael Rommel on 31.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class OceanPathfinderDataSource: PathfinderDataSource {
    
    let map: HexagonTileMap
    
    init(map: HexagonTileMap) {
        self.map = map
    }
    
    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {
        
        var walkableCoords = [HexPoint]()
        
        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)
            if map.valid(point: neighbor) {
                
                let fogState = map.fogManager?.fog(at: neighbor)
                if map.isWater(at: neighbor) && (fogState == .discovered || fogState == .sighted) {
                    walkableCoords.append(neighbor)
                }
            }
        }
        
        return walkableCoords
    }
    
    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Int {
        return 1
    }
    
    
}
