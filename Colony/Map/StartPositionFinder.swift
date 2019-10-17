//
//  StartPositionFinder.swift
//  Colony
//
//  Created by Michael Rommel on 04.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

struct StartPositions: Codable {
    
    let playerPosition: HexPoint
    let cityPositions: [HexPoint]
    
    init(playerPosition: HexPoint, cityPositions: [HexPoint]) {
        
        self.playerPosition = playerPosition
        self.cityPositions = cityPositions
    }
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
        
        let possiblePoints: [HexPoint] = map.filter(where: { $0?.isWater ?? false}).map({ $0?.point ?? HexPoint.zero })
        
        // map is divided into regions
        let fertilityEvaluator = CitySiteEvaluator(map: self.map)
        let finder = RegionFinder(map: self.map, evaluator: fertilityEvaluator)
        let regions = finder.divideInto(regions: 5)
        
        var startPositions: [HexPoint] = []
        for region in regions {
            let startPosition = finder.findStartPosition(in: region)
            startPositions.append(startPosition)
        }
        
        return StartPositions(playerPosition: possiblePoints.randomItem(), cityPositions: startPositions)
    }
}
