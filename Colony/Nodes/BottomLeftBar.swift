//
//  BottomLeftBar.swift
//  Colony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BottomLeftBar: SizedNode {
    
    var backgroundBodyNode: SKSpriteNode?
    var unitBackgroundNode: SKSpriteNode?
    var unitImageNode: SKSpriteNode?
    var nextUnitButton: MenuButtonNode?
    var centerUnitButton: MenuButtonNode?
    
    var gameObjectManager: GameObjectManager?
    
    init(for level: Level?, sized size: CGSize) {

        super.init(sized: size)
        
        self.anchorPoint = .lowerLeft
        self.zPosition = 49 // FIXME: move to constants
        
        self.gameObjectManager = level?.gameObjectManager
        level?.gameObjectManager.gameObjectUnitDelegates.addDelegate(self)
        
        let mapOverviewBodyTexture = SKTexture(imageNamed: "map_overview_body")
        self.backgroundBodyNode = SKSpriteNode(texture: mapOverviewBodyTexture, color: .black, size: CGSize(width: 200, height: 112))
        self.backgroundBodyNode?.position = self.position
        self.backgroundBodyNode?.zPosition = 49
        self.backgroundBodyNode?.anchorPoint = .lowerLeft
        
        if let backgroundBodyNode = self.backgroundBodyNode {
            self.addChild(backgroundBodyNode)
        }
        
        let unitBackgroundTexture = SKTexture(imageNamed: "unit_frame")
        self.unitBackgroundNode = SKSpriteNode(texture: unitBackgroundTexture, color: .black, size: CGSize(width: 72, height: 72))
        self.unitBackgroundNode?.position = self.position + CGPoint(x: 90, y: 3)
        self.unitBackgroundNode?.zPosition = 52
        self.unitBackgroundNode?.anchorPoint = .lowerLeft
        
        if let unitBackgroundNode = self.unitBackgroundNode {
            self.addChild(unitBackgroundNode)
        }
        
        let selectedUnitTextureString = (self.gameObjectManager?.selected?.atlasIdle?.textures.first)
        let selectedUnitTexture = SKTexture(imageNamed: selectedUnitTextureString!)
        self.unitImageNode = SKSpriteNode(texture: selectedUnitTexture, color: .black, size: CGSize(width: 72, height: 72))
        self.unitImageNode?.position = self.position + CGPoint(x: 90, y: 3)
        self.unitImageNode?.zPosition = 53
        self.unitImageNode?.anchorPoint = .lowerLeft
        
        if let unitImageNode = self.unitImageNode {
            self.addChild(unitImageNode)
        }
        
        self.nextUnitButton = MenuButtonNode(imageNamed: "next",
                                             title: "Next",
                                             sized: CGSize(width: 80, height: 36),
                                             buttonAction: {
                                                self.gameObjectManager?.nextPlayerUnit()
        })
        self.nextUnitButton?.position = self.position + CGPoint(x: 50, y: 21)
        self.nextUnitButton?.zPosition = 53
        
        if let nextUnitButton = self.nextUnitButton {
            self.addChild(nextUnitButton)
        }
        
        self.centerUnitButton = MenuButtonNode(imageNamed: "center",
                                             title: "",
                                             sized: CGSize(width: 36, height: 36),
                                             buttonAction: {
                                                
                                                self.gameObjectManager?.centerOnPlayerUnit()
        })
        self.centerUnitButton?.position = self.position + CGPoint(x: 45, y: 60)
        self.centerUnitButton?.zPosition = 53
        
        if let centerUnitButton = self.centerUnitButton {
            self.addChild(centerUnitButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        
        self.backgroundBodyNode?.position = self.position
        self.unitBackgroundNode?.position = self.position + CGPoint(x: 90, y: 3)
        self.unitImageNode?.position = self.position + CGPoint(x: 90, y: 3)
        self.nextUnitButton?.position = self.position + CGPoint(x: 50, y: 21)
        self.centerUnitButton?.position = self.position + CGPoint(x: 45, y: 60)
    }
}

extension BottomLeftBar: GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?) {
        
        guard let gameObject = gameObject else {
            fatalError("selected unit set to nil")
        }
        
        print("selected unit changed: \(gameObject.identifier)")
        
        let selectedUnitTextureString = (gameObject.atlasIdle?.textures.first)
        let selectedUnitTexture = SKTexture(imageNamed: selectedUnitTextureString!)
        
        self.unitImageNode?.texture = selectedUnitTexture
    }
    
    func removed(gameObject: GameObject?) {
        // NOOP
    }
}
