//
//  BottomRightBar.swift
//  Colony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BottomRightBar: SKNode {
    
    var unitSelectorBodyNode: SKSpriteNode?
    var gameObjectManager: GameObjectManager?
    
    init(for level: Level?, sized size: CGSize) {
        
        super.init()
        
        self.zPosition = 49 // FIXME: move to constants
        
        self.gameObjectManager = level?.gameObjectManager
        level?.gameObjectManager.gameObjectUnitDelegate = self
        
        let backgroundTexture = SKTexture(imageNamed: "unit_selector_body")
        self.unitSelectorBodyNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: size)
        self.unitSelectorBodyNode?.anchorPoint = .lowerRight
        self.unitSelectorBodyNode?.position = CGPoint(x: 0, y: 0)
        self.unitSelectorBodyNode?.zPosition = 50
        
        if let unitSelectorBodyNode = self.unitSelectorBodyNode {
            self.addChild(unitSelectorBodyNode)
        }
        
        let unitBackgroundTexture = SKTexture(imageNamed: "unit_frame")
        let unitBackgroundNode = SKSpriteNode(texture: unitBackgroundTexture, color: .black, size: CGSize(width: 92, height: 92))
        unitBackgroundNode.position = CGPoint(x: -12, y: 3)
        unitBackgroundNode.zPosition = 52
        unitBackgroundNode.anchorPoint = .lowerRight
        self.addChild(unitBackgroundNode)
        
        let selectedUnitTextureString = (self.gameObjectManager?.selected?.atlasIdle?.textures.first)
        let selectedUnitTexture = SKTexture(imageNamed: selectedUnitTextureString!)
        let unitImageNode = SKSpriteNode(texture: selectedUnitTexture, color: .black, size: CGSize(width: 92, height: 92))
        unitImageNode.position = CGPoint(x: -12, y: 3)
        unitImageNode.zPosition = 53
        unitImageNode.anchorPoint = .lowerRight
        self.addChild(unitImageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
    }
}

extension BottomRightBar: GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?) {
        
        guard let gameObject = gameObject else {
            fatalError("selected unit set to nil")
        }
        
        print("selected unit changed: \(gameObject.identifier)")
    }
}
