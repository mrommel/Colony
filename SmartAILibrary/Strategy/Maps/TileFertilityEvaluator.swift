//
//  TileFertilityEvaluator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TileFertilityEvaluator: BaseSiteEvaluator {
    
    let map: MapModel?
    
    init(map: MapModel?) {
        self.map = map
    }
    
    override func value(of point: HexPoint, for player: AbstractPlayer?) -> Double {
        
        guard let tile = self.map?.tile(at: point) else {
            return 0
        }
        
        // FIXME improvements
        
        return tile.yields(for: player, ignoreFeature: false).food
    }
    
    func placementFertility(of tile: AbstractTile?, checkForCoastalLand: Bool) -> Int {
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let map = self.map else {
            fatalError("cant get map")
        }
        
        var plotFertility = 0
        
        // Measure Fertility -- Any cases absent from the process have a 0 value.
        if tile.feature() == .mountains {  // Note, mountains cannot belong to a landmass AreaID, so they usually go unmeasured.
            plotFertility = 1 // mountains are better than ice because they allow special buildings and mine bonuses
        } else if tile.feature() == .forest {
            plotFertility = 4 // 2Y
        } else if tile.feature() == .rainforest {
            plotFertility = 3 //  1Y, but can be removed
        } else if tile.feature() == .marsh {
            plotFertility = 3 // 1Y, but can be removed
        } else if tile.feature() == .ice {
            plotFertility = -1 // useless
        } else if tile.feature() == .oasis {
            plotFertility = 6 // 4Y, but can't be improved (7 with fresh water bonus)
        } else if tile.feature() == .floodplains {
            plotFertility = 6 // 3Y (8 with river and fresh water bonuses)
        } else if tile.terrain() == .grass {
            plotFertility = 4 //  2Y
        } else if tile.terrain() == .plains {
            plotFertility = 4 // 2Y
        } else if tile.terrain() == .desert {
            plotFertility = 1 // 0Y
        } else if tile.terrain() == .tundra {
            plotFertility = 2 // 1Y
        } else if tile.terrain() == .snow {
            plotFertility = 1 // 0Y
        } else if tile.terrain() == .shore {
            plotFertility = 4 // 2Y
        } else if tile.terrain() == .ocean {
            plotFertility = 2 // 1Y
        }
        
        if tile.hasHills() && plotFertility == 1 {
            plotFertility = 2 // hills give +1 production even on worthless terrains like desert and snow
        }
        
        if tile.feature() == .reef || tile.feature() == .greatBarrierReef {
            plotFertility = plotFertility + 2 // +1 yield
        } else if tile.feature() == .atoll {
            plotFertility = plotFertility + 4 // +2 yields
        }
        
        if map.river(at: tile.point) {
            plotFertility = plotFertility + 1
        }
        
        if map.isFreshWater(at: tile.point) {
            plotFertility = plotFertility + 1
        }
        
        if checkForCoastalLand == true { // When measuring only one AreaID, this shortcut helps account for coastal plots not measured.
            if map.isCoastal(at: tile.point) && tile.feature() != .mountains {
                plotFertility = plotFertility + 2
            }
        }

        return plotFertility
    }
}
