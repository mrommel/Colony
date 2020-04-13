//
//  BottomLeftBar.swift
//  SmartColony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BottomLeftBar: SizedNode {
    
    var unitCanvasNode: SKSpriteNode?
    var unitImageNode: TouchableSpriteNode?
    
    //var gameObjectManager: GameObjectManager?
    
    override init(/*for level: Level?, */sized size: CGSize) {

        super.init(sized: size)
        
        self.anchorPoint = .lowerLeft
        self.zPosition = Globals.ZLevels.sceneElements
        
        //self.gameObjectManager = level?.gameObjectManager
        //level?.gameObjectManager.gameObjectUnitDelegates.addDelegate(self)
        
        let unitCanvasTexture = SKTexture(imageNamed: "unit_canvas")
        self.unitCanvasNode = SKSpriteNode(texture: unitCanvasTexture, color: .black, size: CGSize(width: 111, height: 112))
        self.unitCanvasNode?.position = self.position
        self.unitCanvasNode?.zPosition = self.zPosition + 0.1
        self.unitCanvasNode?.anchorPoint = .lowerLeft
        
        if let unitCanvasNode = self.unitCanvasNode {
            self.addChild(unitCanvasNode)
        }
        
        let selectedUnitTextureString = "no_unit" //(self.gameObjectManager?.selected?.gameObject?.atlasIdle?.textures.first)
        self.unitImageNode = TouchableSpriteNode(imageNamed: selectedUnitTextureString, size: CGSize(width: 90, height: 90))
        self.unitImageNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.unitImageNode?.zPosition = self.zPosition + 0.3
        self.unitImageNode?.anchorPoint = .lowerLeft
        self.unitImageNode?.isUserInteractionEnabled = true
        self.unitImageNode?.touchHandler = {
            //self.gameObjectManager?.centerOnPlayerUnit()
            print("-touch-")
        }
        
        if let unitImageNode = self.unitImageNode {
            self.addChild(unitImageNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        
        self.unitCanvasNode?.position = self.position
        self.unitImageNode?.position = self.position + CGPoint(x: 3, y: 3)
    }
   
    func selectedUnitChanged(to unit: AbstractUnit?) {

        if let selectedUnit = unit {
            let selectedUnitTextureString = selectedUnit.type.spriteName
            let selectedUnitTexture = SKTexture(imageNamed: selectedUnitTextureString)
        
            self.unitImageNode?.texture = selectedUnitTexture
        } else {
            self.unitImageNode?.texture = nil
        }
    }
}
