//
//  BaseBuildingItemDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BaseBuildingItemDisplayNode: SKNode {

    // properties
    var cost: Double
    var size: CGSize

    // nodes
    var backgroundNode: NineGridTextureSprite?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    var costNode: YieldDisplayNode?
    var progressLabel: SKLabelNode?

    init(textureName: String, iconTexture: SKTexture, name: String, nameColor: SKColor, cost: Double, showCosts: Bool, size: CGSize) {

        self.cost = cost
        self.size = size

        super.init()

        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)

        // icon
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 20, height: 20))
        self.iconNode?.position = CGPoint(x: 10, y: -10)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)

        // name
        self.labelNode = SKLabelNode(text: name)
        self.labelNode?.position = CGPoint(x: 35, y: -12)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 16
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = nameColor
        self.labelNode?.numberOfLines = 1
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.preferredMaxLayoutWidth = size.width - 40
        self.addChild(self.labelNode!)

        // add costs
        if !showCosts {
            self.costNode = YieldDisplayNode(for: .production, value: cost, withBackground: false, size: CGSize(width: 70, height: 28))
            self.costNode?.position = CGPoint(x: self.size.width - 66, y: -3)
            self.costNode?.zPosition = self.zPosition + 2
            self.addChild(self.costNode!)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func disable() {

        self.backgroundNode?.texture = SKTexture(imageNamed: "grid9_button_disabled")
    }

    func show(progress: Double) {

        if self.costNode != nil {
            self.costNode?.removeFromParent()
            self.costNode = nil
        }

        self.progressLabel = SKLabelNode(text: "\(Int(progress)) / \(Int(self.cost))")
        self.progressLabel?.position = CGPoint(x: self.size.width - 66, y: -10)
        self.progressLabel?.zPosition = self.zPosition + 1
        self.progressLabel?.fontSize = 16
        self.progressLabel?.fontName = Globals.Fonts.customFontFamilyname
        self.progressLabel?.numberOfLines = 1
        self.progressLabel?.horizontalAlignmentMode = .left
        self.progressLabel?.verticalAlignmentMode = .top
        self.progressLabel?.preferredMaxLayoutWidth = 40
        self.addChild(self.progressLabel!)
    }
}
