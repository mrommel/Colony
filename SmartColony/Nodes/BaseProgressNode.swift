//
//  BaseProgressNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BaseProgressNode: SKNode {
    
    // variables
    let progressBarType: ProgressBarType
    var title: String
    var iconTexture: String
    var progress: Int // 0..100
    
    // nodes
    var backgroundNode: SKSpriteNode?
    
    var iconNode: SKSpriteNode?
    var progressNode: CircularProgressBarNode?
    var labelNode: SKLabelNode?
    
    var iconNodes: [SKSpriteNode?] = []
    
    init(progressBarType: ProgressBarType, title: String, iconTexture: String, progress: Int) {
        
        self.progressBarType = progressBarType
        self.title = title
        self.iconTexture = iconTexture
        self.progress = progress
        
        super.init()

        // background
        let backgroundTexture = SKTexture(imageNamed: "science_progress")
        self.backgroundNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: CGSize(width: 200, height: 64))
        self.backgroundNode?.position = CGPoint(x: 0.0, y: 0.0)
        self.backgroundNode?.anchorPoint = CGPoint.upperLeft
        self.backgroundNode?.zPosition = self.zPosition
        super.addChild(self.backgroundNode!)
        
        // name
        self.labelNode = SKLabelNode(text: self.title)
        self.labelNode?.position = CGPoint(x: 44, y: -1)
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
        self.progressNode?.position = CGPoint(x: 21, y: -23)
        self.progressNode?.zPosition = self.zPosition + 1
        self.progressNode?.anchorPoint = CGPoint.middleCenter
        self.progressNode?.value = self.progress
        self.addChild(self.progressNode!)
        
        // icon
        let iconTexture = SKTexture(imageNamed: self.iconTexture)
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 28, height: 28))
        self.iconNode?.position = CGPoint(x: 21, y: -23)
        self.iconNode?.zPosition = self.zPosition + 2
        self.iconNode?.anchorPoint = CGPoint.middleCenter
        self.addChild(self.iconNode!)
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
    
    func addIcon(named: String) {
        
        let iconTexture = SKTexture(imageNamed: named)
        let newIconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 20, height: 20))
        newIconNode.position = CGPoint(x: 55 + self.iconNodes.count * 20, y: -30)
        newIconNode.zPosition = self.zPosition + 2
        newIconNode.anchorPoint = CGPoint.middleCenter
        self.addChild(newIconNode)
    }
}

class ScienceProgressNode: BaseProgressNode {
    
    init() {
        
        super.init(progressBarType: .science, title: "Choose Research", iconTexture: "tech_none", progress: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(tech: TechType, progress value: Int) {
        
        self.iconNode?.texture = SKTexture(imageNamed: tech.iconTexture())
        self.labelNode?.text = tech.name()
        self.progressNode?.value = value
        
        let achievements = tech.achievements()
        
        for buildingType in achievements.buildingTypes {
            self.addIcon(named: buildingType.iconTexture())
        }
        
        for unitType in achievements.unitTypes {
            self.addIcon(named: unitType.iconTexture())
        }
    }
}

class CultureProgressNode: BaseProgressNode {
    
    init() {
        
        super.init(progressBarType: .culture, title: "Code of Laws", iconTexture: "civic_codeOfLaws", progress: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(civic: CivicType, progress value: Int) {
        
        self.iconNode?.texture = SKTexture(imageNamed: civic.iconTexture())
        self.labelNode?.text = civic.name()
        self.progressNode?.value = value
    }
}
