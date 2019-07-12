//
//  StartPositionFinder.swift
//  Colony
//
//  Created by Michael Rommel on 04.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

struct StartPositions: Codable {
    
    let monsterPosition: HexPoint
    let playerPosition: HexPoint
    let villagePosition: HexPoint
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
        
        let maximalDistance = HexPoint(x: 0, y: 0).distance(to: HexPoint(x: map.width - 1, y: map.height - 1))
        var optimalDistance = maximalDistance * 3 / 4
        let possiblePoints: [HexPoint] = map.filter(where: { $0?.water ?? false}).map({ $0?.point ?? HexPoint.zero })
        
        var randomItem: HexPoint
        var trial: [HexPoint]
        
        repeat {
            print("iterate to find start positions ...")
            randomItem = possiblePoints.randomItem()
        
            trial = possiblePoints.filter { $0.distance(to: randomItem) > optimalDistance && map.path(from: $0, to: randomItem, movementType: .swimOcean) != nil }
            optimalDistance = optimalDistance - 1 // reduce distance each time we fail
        } while trial.count == 0
        
        // find next non water tile next to monster
        var villagePosition: HexPoint
        var circleSize: Int = 2
        var areaToCheck: [HexPoint]
        
        repeat {
            areaToCheck = randomItem.areaWith(radius: circleSize).points.filter { map.valid(point: $0) && !map.isWater(at: $0) }
            circleSize = circleSize + 1
        } while areaToCheck.count == 0
        
        villagePosition = areaToCheck.randomItem()
            
        return StartPositions(monsterPosition: randomItem, playerPosition: trial.randomItem(), villagePosition: villagePosition)
    }
}
