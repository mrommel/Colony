//
//  BaseProgressNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BaseProgressNode: SizedNode {

    // variables
    let progressBarType: ProgressBarType
    var title: String
    var iconTexture: String
    var eureka: String
    var progress: Int // 0..100

    // nodes
    var backgroundNode: SKSpriteNode?

    var iconNode: SKSpriteNode?
    var progressNode: CircularProgressBarNode?
    var labelNode: SKLabelNode?
    var eurekaNode: SKLabelNode?
    var turnsRemainingNode: SKLabelNode?

    private var iconNodes: [SKSpriteNode?] = []

    init(progressBarType: ProgressBarType, title: String, iconTexture: String, eureka: String, progress: Int) {

        self.progressBarType = progressBarType
        self.title = title
        self.iconTexture = iconTexture
        self.eureka = eureka
        self.progress = progress

        super.init(sized: CGSize(width: 200, height: 64))
        
        self.anchorPoint = .upperLeft
        
        // background
        let backgroundTexture = SKTexture(imageNamed: "science_progress")
        self.backgroundNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: CGSize(width: 200, height: 64))
        self.backgroundNode?.anchorPoint = CGPoint.upperLeft
        self.backgroundNode?.zPosition = self.zPosition
        super.addChild(self.backgroundNode!)

        // name
        self.labelNode = SKLabelNode(text: self.title)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 16
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = .white
        self.labelNode?.numberOfLines = 2
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.preferredMaxLayoutWidth = 160
        self.addChild(self.labelNode!)

        // progress
        self.progressNode = CircularProgressBarNode(type: self.progressBarType, size: CGSize(width: 40, height: 40))
        self.progressNode?.zPosition = self.zPosition + 1
        self.progressNode?.anchorPoint = CGPoint.middleCenter
        self.progressNode?.value = self.progress
        self.addChild(self.progressNode!)

        // icon
        let iconTexture = SKTexture(imageNamed: self.iconTexture)
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 28, height: 28))
        self.iconNode?.zPosition = self.zPosition + 2
        self.iconNode?.anchorPoint = CGPoint.middleCenter
        self.addChild(self.iconNode!)

        // eureka
        self.eurekaNode = SKLabelNode(text: self.eureka)
        self.eurekaNode?.zPosition = self.zPosition + 1
        self.eurekaNode?.fontSize = 9
        self.eurekaNode?.fontName = Globals.Fonts.customFontFamilyname
        self.eurekaNode?.fontColor = .white
        self.eurekaNode?.numberOfLines = 1
        self.eurekaNode?.horizontalAlignmentMode = .left
        self.eurekaNode?.verticalAlignmentMode = .top
        self.eurekaNode?.preferredMaxLayoutWidth = 160
        self.addChild(self.eurekaNode!)
        
        // turns remaining
        self.turnsRemainingNode = SKLabelNode(text: "?")
        self.turnsRemainingNode?.zPosition = self.zPosition + 1
        self.turnsRemainingNode?.fontSize = 9
        self.turnsRemainingNode?.fontName = Globals.Fonts.customFontFamilyname
        self.turnsRemainingNode?.fontColor = .white
        self.turnsRemainingNode?.numberOfLines = 1
        self.turnsRemainingNode?.horizontalAlignmentMode = .left
        self.turnsRemainingNode?.verticalAlignmentMode = .top
        self.turnsRemainingNode?.preferredMaxLayoutWidth = 25
        self.addChild(self.turnsRemainingNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetIcons() {

        for iconNode in self.iconNodes {

            iconNode?.removeFromParent()
        }

        self.iconNodes.removeAll()
    }

    func addIcon(texture: SKTexture) {

        let newIconNode = SKSpriteNode(texture: texture, size: CGSize(width: 20, height: 20))
        newIconNode.position = self.position + CGPoint(x: 55 + self.iconNodes.count * 22, y: -33)
        newIconNode.zPosition = self.zPosition + 2
        newIconNode.anchorPoint = CGPoint.middleCenter
        self.addChild(newIconNode)

        // keep a reference to icons
        self.iconNodes.append(newIconNode)
    }
    
    override func updateLayout() {
        
        self.backgroundNode?.position = self.position + CGPoint(x: 0.0, y: 0.0)
        self.labelNode?.position = self.position + CGPoint(x: 44, y: 1)
        self.progressNode?.position = self.position + CGPoint(x: 21, y: -23)
        self.iconNode?.position = self.position + CGPoint(x: 21, y: -23)
        self.eurekaNode?.position = self.position + CGPoint(x: 53, y: -51)
        self.turnsRemainingNode?.position = self.position + CGPoint(x: 20, y: -51)
        
        for (index, iconNode) in self.iconNodes.enumerated() {
            iconNode?.position = self.position + CGPoint(x: 55 + index * 22, y: -33)
        }
    }
}
