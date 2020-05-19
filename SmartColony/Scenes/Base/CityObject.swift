//
//  CityObject.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class CityObject {
    
    weak var city: AbstractCity?
    weak var gameModel: GameModel?
    
    let identifier: String
    var spriteName: String
    
    // internal UI elements
    var sprite: SKSpriteNode
    private var nameLabel: SKLabelNode?
    private var nameBackground: SKSpriteNode?
    private var sizeLabel: SKLabelNode?
    
    init(city: AbstractCity?, in gameModel: GameModel?) {
     
        self.identifier = UUID.init().uuidString
        self.city = city
        self.gameModel = gameModel
        
        guard let city = self.city else {
            fatalError("cant get city")
        }

        self.spriteName = "hex_city_1"
        self.sprite = SKSpriteNode(imageNamed: self.spriteName)
        self.sprite.position = HexPoint.toScreen(hex: city.location)
        self.sprite.zPosition = Globals.ZLevels.city
        self.sprite.anchorPoint = CGPoint.lowerLeft
    }
    
    func addTo(node parent: SKNode) {

        parent.addChild(self.sprite)
    }
    
    func showCityName() {

        guard let city = self.city else {
            fatalError("cant get unit")
        }
        
        guard let player = city.player else {
            fatalError("cant get player")
        }
        
        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameLabel = nil
            self.nameBackground?.removeFromParent()
            self.nameBackground = nil
            self.sizeLabel?.removeFromParent()
            self.sizeLabel = nil
        }

        let texture = SKTexture(imageNamed: "city_banner")
        self.nameBackground = SKSpriteNode(texture: texture, size: CGSize(width: 48, height: 48))
        self.nameBackground?.zPosition = Globals.ZLevels.cityName - 0.1
        self.nameBackground?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.nameBackground?.colorBlendFactor = 0.7
        self.nameBackground?.color = player.leader.civilization().backgroundColor()
        
        if let nameBackground = self.nameBackground {
            self.sprite.addChild(nameBackground)
        }
        
        self.sizeLabel = SKLabelNode(text: "\(city.population())")
        self.sizeLabel?.fontSize = 8
        self.sizeLabel?.position = CGPoint(x: 8, y: 35)
        self.sizeLabel?.zPosition = Globals.ZLevels.cityName
        self.sizeLabel?.fontName = Globals.Fonts.customFontBoldFamilyname
        self.sizeLabel?.fontColor = player.leader.civilization().iconColor()
        self.sizeLabel?.preferredMaxLayoutWidth = 12

        if let sizeLabel = self.sizeLabel {
            self.sprite.addChild(sizeLabel)
        }

        self.nameLabel = SKLabelNode(text: city.name)
        self.nameLabel?.fontSize = 8
        self.nameLabel?.position = CGPoint(x: 24, y: 35)
        self.nameLabel?.zPosition = Globals.ZLevels.cityName
        self.nameLabel?.fontName = Globals.Fonts.customFontBoldFamilyname
        self.nameLabel?.fontColor = player.leader.civilization().iconColor()
        self.nameLabel?.preferredMaxLayoutWidth = 30

        if let nameLabel = self.nameLabel {
            self.sprite.addChild(nameLabel)
        }
    }

    func hideCityName() {

        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameBackground?.removeFromParent()
            self.sizeLabel?.removeFromParent()
        }
    }
}
