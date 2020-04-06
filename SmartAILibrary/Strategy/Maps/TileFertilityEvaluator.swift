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
        
        return tile.yields(ignoreFeature: false).food
    }
}
