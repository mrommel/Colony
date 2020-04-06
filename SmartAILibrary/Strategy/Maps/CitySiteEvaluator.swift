//
//  CitySiteEvaluator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class CitySiteEvaluator: BaseSiteEvaluator {

    let map: MapModel?
    let tileFertilityEvaluator: TileFertilityEvaluator
    let minCityDistance = 2
    
    public init(map: MapModel?) {
        self.map = map
        self.tileFertilityEvaluator = TileFertilityEvaluator(map: map)
    }
    
    func canCityBeFound(on tile: AbstractTile?, by player: AbstractPlayer?) -> Bool {
        
        guard let map = self.map else {
            return false
        }
        
        guard let tile = tile else {
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
        if map.city(at: tile.point) != nil {
            return false
        }
        
        // can't found on water
        if tile.terrain().isWater() {
            return false
        }
        
        // check for distance (cities inside the area)
        let area = tile.point.areaWith(radius: self.minCityDistance)
        
        for areaPoint in area {
            if map.city(at: areaPoint) != nil {
                return false
            }
        }
        
        return true
    }
    
    public override func value(of point: HexPoint, for player: AbstractPlayer?) -> Double {

        guard let map = self.map else {
            return 0
        }
        
        let tile = map.tile(at: point)
        
        if !self.canCityBeFound(on: tile, by: player) {
            return 0
        }
        
        let area = point.areaWith(radius: self.minCityDistance)
        
        var sum: Double = 0.0
        for areaPoint in area {
            if map.city(at: areaPoint) != nil {
                continue
            }
            
            sum += self.tileFertilityEvaluator.value(of: areaPoint, for: player)
        }
        
        // FIXME
        /*if map.isAdjacentToRiver(at: point) {
            sum *= 2
        }
        
        if map.isAdjacentToOcean(at: point) {
            sum *= 2
        }*/
        
        return sum
    }
}
