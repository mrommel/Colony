//
//  RiverLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class RiverLayer: SKNode {
    
    let player: AbstractPlayer?
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        
        super.init()
        self.zPosition = Globals.ZLevels.river
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with gameModel: GameModel?) {
        
    }
}