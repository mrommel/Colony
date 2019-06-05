//
//  StartPositionFinder.swift
//  Colony
//
//  Created by Michael Rommel on 04.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

struct StartPositions {
    
    let monsterPosition: HexPoint
    let playerPosition: HexPoint
}

class StartPositionFinder {
    
    weak var map: HexagonTileMap?
    
    init(map: HexagonTileMap?) {
        self.map = map
    }
    
    func identifyStartPositions() -> StartPositions {
        
        guard let map = self.map else {
            fatalError("can identify start positions without a map")
        }
        
        let maximalDistance = HexPoint(x: 0, y: 0).distance(to: HexPoint(x: map.tiles.columns - 1, y: map.tiles.rows - 1))
        let optimalDistance = maximalDistance * 4 / 5
        
        var possiblePoints: [HexPoint] = []
        
        for x in 0..<map.tiles.columns {
            for y in 0..<map.tiles.rows {
                if map.tile(x: x, y: y)?.water ?? false {
                    possiblePoints.append(HexPoint(x: x, y: y))
                }
            }
        }
        
        var randomItem: HexPoint
        var trial: [HexPoint]
        
        repeat {
            randomItem = possiblePoints.randomItem()
        
            trial = possiblePoints.filter { $0.distance(to: randomItem) > optimalDistance && map.path(from: $0, to: randomItem) != nil }
        } while trial.count == 0
        
        return StartPositions(monsterPosition: randomItem, playerPosition: trial.randomItem())
    }
    
    func findPatrolPath(from point: HexPoint) -> [HexPoint] {
        
        guard let map = self.map else {
            fatalError("can identify start positions without a map")
        }
        
        var path: [HexPoint] = []
        var currentPoint = point
        
        for _ in 0..<8 {
            let neighbors = currentPoint.neighbors().filter { map.valid(point: $0) && map.tile(at: $0)?.water ?? false }
            
            currentPoint = neighbors.randomItem()
            path.append(currentPoint)
        }
        
        return path
    }
}
