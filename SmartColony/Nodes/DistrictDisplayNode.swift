//
//  DistrictDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 20.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

extension DistrictType {
    
    func iconTexture() -> String {
        
        switch self {
            
        case .cityCenter: return "district_city_center"
        case .campus: return "district_campus"
        case .holySite: return "district_holy_site"
        case .encampment: return "district_encampment"
        case .harbor: return "district_harbor"
        }
    }
}

class DistrictDisplayNode: SKNode {
    
    let districtType: DistrictType
    
    // nodes
    var backgroundNode: NineGridTextureSprite?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    var costNode: YieldDisplayNode?
    
    init(districtType: DistrictType, active: Bool, size: CGSize) {
        
        self.districtType = districtType
        
        super.init()
        
        // background
        let textureName = active ? "grid9_button_district_active" : "grid9_button_district"
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        // icon
        let iconTexture = SKTexture(imageNamed: self.districtType.iconTexture())
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 20, height: 20))
        self.iconNode?.position = CGPoint(x: 10, y: -10)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)
        
        // name
        self.labelNode = SKLabelNode(text: districtType.name())
        self.labelNode?.position = CGPoint(x: 35, y: -12)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 16
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = active ? .white : SKColor(hex: "#16344f")
        self.labelNode?.numberOfLines = 1
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.preferredMaxLayoutWidth = size.width - 40
        self.addChild(self.labelNode!)
        
        // add costs
        if !active {
            self.costNode = YieldDisplayNode(for: .production, value: Double(districtType.productionCost()), withBackground: false, size: CGSize(width: 70, height: 28))
            self.costNode?.position = CGPoint(x: 134, y: -3)
            self.costNode?.zPosition = self.zPosition + 2
            self.addChild(self.costNode!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
