//
//  BaseDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 19.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class BaseDisplayNode: SKNode {

    // nodes
    var backgroundNode: NineGridTextureSprite?
    var progressNode: CircularProgressBarNode?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    //var costNode: SpriteButtonNode?
    private var iconNodes: [SKSpriteNode?] = []

    var touchHandler: (() -> Void)?

    init(texture: String, type progressBarType: ProgressBarType, name: String, progress: Int, iconTextures: [SKTexture], size: CGSize) {

        super.init()

        self.isUserInteractionEnabled = true

        // background
        let textureName = "techInfo_researched"
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)

        // progress
        self.progressNode = CircularProgressBarNode(type: progressBarType, size: CGSize(width: 24, height: 24))
        self.progressNode?.position = CGPoint(x: 0, y: 0)
        self.progressNode?.zPosition = self.zPosition + 1
        self.progressNode?.anchorPoint = CGPoint.upperLeft
        self.progressNode?.value = progress
        self.addChild(self.progressNode!)

        // icon
        let iconTexture = SKTexture(imageNamed: texture)
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 18, height: 18))
        self.iconNode?.position = CGPoint(x: 3, y: -3)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)

        // name
        self.labelNode = SKLabelNode(text: name)
        self.labelNode?.position = CGPoint(x: 25, y: -1)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 12
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = .white
        self.labelNode?.numberOfLines = 1
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.fitToWidth(maxWidth: size.width - 26)
        self.addChild(self.labelNode!)

        // icons
        for iconTexture in iconTextures {
            self.addIcon(texture: iconTexture)
        }

        // eureka
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let handler = self.touchHandler {
            handler()
        }
    }

    func selected() {

        let textureName = "techInfo_researching"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)

        self.touchHandler = nil
    }

    func researched() {

        let textureName = "techInfo_researched"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)

        self.touchHandler = nil
    }

    func possible() {

        let textureName = "techInfo_active"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)
    }

    func disabled() {

        let textureName = "techInfo_disabled"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)

        self.touchHandler = nil
    }

    func addIcon(texture: SKTexture) {

        let newIconNode = SKSpriteNode(texture: texture, size: CGSize(width: 18, height: 18))
        newIconNode.position = self.position + CGPoint(x: 25 + self.iconNodes.count * 20, y: -23)
        newIconNode.zPosition = self.zPosition + 2
        newIconNode.anchorPoint = CGPoint.middleLeft
        self.addChild(newIconNode)

        // keep a reference to icons
        self.iconNodes.append(newIconNode)
    }
}
