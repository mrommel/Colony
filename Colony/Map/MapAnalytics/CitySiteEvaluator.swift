//
//  CitySiteEvaluator.swift
//  Colony
//
//  Created by Michael Rommel on 14.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class CitySiteEvaluator: SiteEvaluator {

    let map: HexagonTileMap?
    let tileFertilityEvaluator: TileFertilityEvaluator
    
    init(map: HexagonTileMap?) {
        self.map = map
        self.tileFertilityEvaluator = TileFertilityEvaluator(map: map)
    }
    
    func canCityBeFound(on tile: Tile?, by civilization: Civilization) -> Bool {
        
        guard let map = self.map else {
            return false
        }
        
        guard let tile = tile else {
            return false
        }
        
        guard let point = tile.point else {
            return false
        }
        
        /*guard let terrainInfo = tile.terrain.getTerrainInfo() else {
            return false
        }*/
        
        // FIXME: check if tile is owned by another player
        /*if let tileOwner = tile.owned {
            if tileOwner != civilization {
                return false
            }
        }*/
        
        // check if already found a city here
        if map.city(at: point) != nil {
            return false
        }
        
        // can't found on water
        if tile.isWater {
            return false
        }
        
        // check for distance (cities inside the area)
        let minCityDistance = 3
        let area = point.areaWith(radius: minCityDistance)
        
        for areaPoint in area {
            if map.city(at: areaPoint) != nil {
                return false
            }
        }
        
        return true
    }
    
    func value(of area: HexArea, by civilization: Civilization) -> Int {
        
        var sum = 0
        
        for point in area {
            sum += self.value(of: point, by: civilization)
        }
        
        return sum
    }
    
    func value(of point: HexPoint, by civilization: Civilization) -> Int {

        guard let map = self.map else {
            return 0
        }
        
        let tile = map.tile(at: point)
        
        if !self.canCityBeFound(on: tile, by: civilization) {
            return 0
        }
        
        let minCityDistance = 2
        let area = point.areaWith(radius: minCityDistance)
        
        var sum: Int = 0
        for areaPoint in area {
            if map.city(at: areaPoint) != nil {
                continue
            }
            
            sum += self.tileFertilityEvaluator.value(of: areaPoint, by: civilization)
        }
        
        if map.isAdjacentToRiver(at: point) {
            sum *= 2
        }
        
        if map.isAdjacentToOcean(at: point) {
            sum *= 2
        }
        
        return sum
    }
}


