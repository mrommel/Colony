//
//  BottomRightBar.swift
//  Colony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class SizedNode: SKNode {
    
    private var internalFrame: CGRect
    var anchorPoint: CGPoint = .middleCenter
    
    init(sized size: CGSize) {
        self.internalFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        return self.internalFrame
    }
    
    override var position: CGPoint {
        get {
            return self.internalFrame.origin
        }
        set {
            let offsetX = self.frame.width * self.anchorPoint.x
            let offsetY = self.frame.height * self.anchorPoint.y
            
            self.internalFrame.origin = CGPoint(x: newValue.x - offsetX, y: newValue.y - offsetY)
        }
    }
}

class BottomRightBar: SizedNode {

    var unitSelectorBodyNode: SKSpriteNode?
    var unitBackgroundNode: SKSpriteNode?
    var unitImageNode: SKSpriteNode?
    
    var gameObjectManager: GameObjectManager?
    
    init(for level: Level?, sized size: CGSize) {

        super.init(sized: size)
        
        self.anchorPoint = .lowerRight
        self.zPosition = 49 // FIXME: move to constants
        
        self.gameObjectManager = level?.gameObjectManager
        level?.gameObjectManager.gameObjectUnitDelegate = self
        
        let backgroundTexture = SKTexture(imageNamed: "unit_selector_body")
        self.unitSelectorBodyNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: size)
        self.unitSelectorBodyNode?.anchorPoint = .lowerLeft
        self.unitSelectorBodyNode?.position = CGPoint(x: 0, y: 0)
        self.unitSelectorBodyNode?.zPosition = 50
        
        if let unitSelectorBodyNode = self.unitSelectorBodyNode {
            self.addChild(unitSelectorBodyNode)
        }
        
        let unitBackgroundTexture = SKTexture(imageNamed: "unit_frame")
        self.unitBackgroundNode = SKSpriteNode(texture: unitBackgroundTexture, color: .black, size: CGSize(width: 72, height: 72))
        self.unitBackgroundNode?.position = CGPoint(x: 12, y: 3)
        self.unitBackgroundNode?.zPosition = 52
        self.unitBackgroundNode?.anchorPoint = .lowerLeft
        
        if let unitBackgroundNode = self.unitBackgroundNode {
            self.addChild(unitBackgroundNode)
        }
        
        let selectedUnitTextureString = (self.gameObjectManager?.selected?.atlasIdle?.textures.first)
        let selectedUnitTexture = SKTexture(imageNamed: selectedUnitTextureString!)
        self.unitImageNode = SKSpriteNode(texture: selectedUnitTexture, color: .black, size: CGSize(width: 72, height: 72))
        self.unitImageNode?.position = CGPoint(x: 12, y: 3)
        self.unitImageNode?.zPosition = 53
        self.unitImageNode?.anchorPoint = .lowerLeft
        
        if let unitImageNode = self.unitImageNode {
            self.addChild(unitImageNode)
        }
        
        //NineGridTextureSprite(imageNamed: defaultButtonImage, size: size, isNineGrid: isNineGrid)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        
        let location = touch.location(in: self)
        print("BottomRightBar: \(location)")
    }
    
    func updateLayout() {
        
        self.unitSelectorBodyNode?.position = self.position
        self.unitBackgroundNode?.position = self.position + CGPoint(x: 120, y: 3)
        self.unitImageNode?.position = self.position + CGPoint(x: 120, y: 3)
    }
}

extension BottomRightBar: GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?) {
        
        guard let gameObject = gameObject else {
            fatalError("selected unit set to nil")
        }
        
        print("selected unit changed: \(gameObject.identifier)")
        
        let selectedUnitTextureString = (gameObject.atlasIdle?.textures.first)
        let selectedUnitTexture = SKTexture(imageNamed: selectedUnitTextureString!)
        
        self.unitImageNode?.texture = selectedUnitTexture
    }
}
