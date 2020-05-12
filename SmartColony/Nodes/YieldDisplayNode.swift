//
//  YieldDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class YieldDisplayNode: SKNode {

    // properties
    
    var yieldType: YieldType

    // nodes
    
    var backgroundNode: NineGridTextureSprite?
    var yieldIconNode: SKSpriteNode?
    var yieldLabelNode: SKLabelNode?
    
    // callback
    
    var action: ((_ yieldType: YieldType) -> Void)?

    // MARK: constructors
    
    init(for yieldType: YieldType, value: Double, withBackground showBackground: Bool = true, size: CGSize) {

        self.yieldType = yieldType

        super.init()
        
        self.isUserInteractionEnabled = true

        if showBackground {
            let textureName = self.yieldType.backgroundTexture()
            self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
            self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
            self.addChild(self.backgroundNode!)
        }

        let yieldIconTexture = SKTexture(imageNamed: self.yieldType.iconTexture())
        self.yieldIconNode = SKSpriteNode(texture: yieldIconTexture, size: CGSize(width: 20, height: 20))
        self.yieldIconNode?.position = CGPoint(x: 15, y: -16)
        self.yieldIconNode?.zPosition = self.zPosition + 1
        self.addChild(self.yieldIconNode!)

        let prefix = value >= 0.0 ? "+" : ""
        self.yieldLabelNode = SKLabelNode(text: "\(prefix)\(value)")
        self.yieldLabelNode?.position = CGPoint(x: 54, y: -26)
        self.yieldLabelNode?.zPosition = self.zPosition + 1
        self.yieldLabelNode?.fontSize = 14
        self.yieldLabelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.yieldLabelNode?.fontColor = showBackground ? self.yieldType.fontColor() : .white
        self.yieldLabelNode?.numberOfLines = 0
        self.yieldLabelNode?.horizontalAlignmentMode = .right
        self.yieldLabelNode?.preferredMaxLayoutWidth = size.width - 20
        self.addChild(self.yieldLabelNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var zPosition: CGFloat {
        get {
            return super.zPosition
        }
        set {
            super.zPosition = newValue

            self.backgroundNode?.zPosition = newValue + 1
            self.yieldIconNode?.zPosition = newValue + 2
            self.yieldLabelNode?.zPosition = newValue + 2
        }
    }

    func set(yieldValue value: Double) {

        let prefix = value >= 0.0 ? "+" : ""
        self.yieldLabelNode?.text = "\(prefix)\(value)"
    }
    
    // elements
    
    func enable() {
        
        let textureName = self.yieldType.backgroundTexture()
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)
    }
    
    func disable() {
        
        let textureName = self.yieldType.backgroundTexture() + "_inactive"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)
    }
    
    // MARK: touch handling

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)

            if self.backgroundNode!.contains(location) {
                //print("clicked")
                self.action?(self.yieldType)
            }
        }
    }
}
