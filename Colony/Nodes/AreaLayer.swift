//
//  AreaLayer.swift
//  Colony
//
//  Created by Michael Rommel on 21.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class AreaLayer: SKNode {
    
    var areaSpritesMap: [Player: AreaSprites] = [:]
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with level: Level?) {
        
        guard let players = level?.players else {
            return
        }
        
        for player in players {
            let areaSprite = AreaSprites()
            if let zoneOfControl = player.zoneOfControl {
                areaSprite.rebuild(with: zoneOfControl)
            }
            self.addChild(areaSprite)
            
            self.areaSpritesMap[player] = areaSprite
        }
        
        /*map.fogManager?.delegates.addDelegate(self)
        
        for (player, areaSprite) in self.areaSpritesMap {
            if let zoneOfControl = player.zoneOfControl {
                areaSprite.rebuild(with: zoneOfControl)
            }
        }*/
    }
}

extension AreaLayer: FogStateChangedDelegate {
    
    func changed(to newState: FogState, at pt: HexPoint) {
        
        // NOOP
        for (player, areaSprite) in self.areaSpritesMap {
            if let zoneOfControl = player.zoneOfControl {
                areaSprite.rebuild(with: zoneOfControl)
            }
        }
    }
}
