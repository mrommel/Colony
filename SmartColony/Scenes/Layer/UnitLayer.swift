//
//  UnitLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 06.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class UnitLayer: SKNode {
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    
    var unitObjects: [UnitObject]
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        self.unitObjects = []
        
        super.init()
        //self.zPosition = Globals.ZLevel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with gameModel: GameModel?) {
    
        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        self.textureUtils = TextureUtils(with: gameModel)
        
        for player in gameModel.players {
            
            for unit in gameModel.units(of: player) {
                
                print("-- \(player.leader) -> \(unit?.type)")
                let unitObject = UnitObject(unit: unit, in: self.gameModel)
                unitObjects.append(unitObject)
                
                unitObject.addTo(node: self)
            }
        }
    }
}
