//
//  PediaItemNode.swift
//  Colony
//
//  Created by Michael Rommel on 12.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class PediaItemNode: SKNode {
    
    init(terrain: Terrain, action: @escaping () -> Void) {
        
        super.init()
        
        let terrainTexture = SKTexture(imageNamed: terrain.textureNameHex.first!)
        let terrainIcon = SKSpriteNode(texture: terrainTexture, size: CGSize(width: 42, height: 42))
        terrainIcon.zPosition = self.zPosition + 1
        terrainIcon.position = CGPoint(x: -60, y: 15)
        self.addChild(terrainIcon)
        
        let terrainLabel = ClickableLabelNode(text: terrain.title, buttonAction: action)
        terrainLabel.fontSize = 20
        terrainLabel.fontName = Formatters.Fonts.customFontFamilyname
        terrainLabel.zPosition = self.zPosition + 1
        terrainLabel.horizontalAlignmentMode = .left
        terrainLabel.position = CGPoint(x: -20, y: 0)
        self.addChild(terrainLabel)
    }
    
    init(feature: Feature, action: @escaping () -> Void) {
        
        super.init()
        
        let featureTexture = SKTexture(imageNamed: feature.textureNamesHex.first!)
        let featureIcon = SKSpriteNode(texture: featureTexture, size: CGSize(width: 42, height: 42))
        featureIcon.zPosition = self.zPosition + 1
        featureIcon.position = CGPoint(x: -60, y: 15)
        self.addChild(featureIcon)
        
        let featureLabel = ClickableLabelNode(text: feature.title, buttonAction: action)
        featureLabel.fontSize = 20
        featureLabel.fontName = Formatters.Fonts.customFontFamilyname
        featureLabel.zPosition = self.zPosition + 1
        featureLabel.horizontalAlignmentMode = .left
        featureLabel.position = CGPoint(x: -20, y: 0)
        self.addChild(featureLabel)
    }
    
    init(unitType: UnitType, action: @escaping () -> Void) {
        
        super.init()
        
        let unitTypeTexture = SKTexture(imageNamed: unitType.textureName)
        let unitTypeIcon = SKSpriteNode(texture: unitTypeTexture, size: CGSize(width: 42, height: 42))
        unitTypeIcon.zPosition = self.zPosition + 1
        unitTypeIcon.position = CGPoint(x: -60, y: 15)
        self.addChild(unitTypeIcon)
        
        let unitTypeLabel = ClickableLabelNode(text: unitType.title, buttonAction: action)
        unitTypeLabel.fontSize = 20
        unitTypeLabel.fontName = Formatters.Fonts.customFontFamilyname
        unitTypeLabel.zPosition = self.zPosition + 1
        unitTypeLabel.horizontalAlignmentMode = .left
        unitTypeLabel.position = CGPoint(x: -20, y: 0)
        self.addChild(unitTypeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
