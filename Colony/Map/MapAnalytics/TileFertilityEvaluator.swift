//
//  TileFertilityEvaluator.swift
//  Colony
//
//  Created by Michael Rommel on 15.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class TileFertilityEvaluator: SiteEvaluator {
    
    let map: HexagonTileMap?
    
    init(map: HexagonTileMap?) {
        self.map = map
    }
    
    func value(of point: HexPoint, by civilization: Civilization) -> Int {
        
        guard let tile = self.map?.tile(at: point) else {
            return 0
        }
        
        // FIXME features, buildings
        
        return tile.terrain.yields.food
    }
    
    func value(of area: HexArea, by civilization: Civilization) -> Int {
        
        var sum = 0
        
        for point in area {
            sum += self.value(of: point, by: civilization)
        }
        
        return sum
    }
}
