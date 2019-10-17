//
//  AreaLayer.swift
//  Colony
//
//  Created by Michael Rommel on 21.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class AreaLayer: SKNode {
    
    weak var map: HexagonTileMap?
    var areaSpritesMap: [Player: AreaSprites] = [:]
    
    let civilization: Civilization

    init(civilization: Civilization) {
        
        self.civilization = civilization
        
        super.init()
        self.zPosition = GameScene.Constants.ZLevels.labels
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with level: Level?) {
        
        self.map = level?.map
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        //map.fogManager?.delegates.addDelegate(self)
        
        /*guard let players = level?.players else {
            return
        }
        
        for player in players {
            let areaSprite = AreaSprites(colored: player.leader.civilization.color)
            if let zoneOfControl = player.zoneOfControl {
                areaSprite.rebuild(with: zoneOfControl, and: map.fogManager)
            }
            self.addChild(areaSprite)
            
            self.areaSpritesMap[player] = areaSprite
        }*/
    }
}

extension AreaLayer: FogStateChangedDelegate {
    
    func changed(for civilization: Civilization, to newState: FogState, at pt: HexPoint) {

        /*for (player, areaSprite) in self.areaSpritesMap {
            if let zoneOfControl = player.zoneOfControl {
                areaSprite.rebuild(with: zoneOfControl, and: map?.fogManager)
            }
        }*/
    }
}
