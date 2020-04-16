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
        
        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameLabel = nil
            self.nameBackground?.removeFromParent()
            self.nameBackground = nil
        }

        let texture = SKTexture(imageNamed: "city_label_background")
        self.nameBackground = SKSpriteNode(texture: texture, size: CGSize(width: 48, height: 48))
        self.nameBackground?.zPosition = Globals.ZLevels.cityName - 0.1
        self.nameBackground?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        if let nameBackground = self.nameBackground {
            self.sprite.addChild(nameBackground)
        }

        self.nameLabel = SKLabelNode(text: city.name)
        self.nameLabel?.fontSize = 8
        self.nameLabel?.position = CGPoint(x: 24, y: 0)
        self.nameLabel?.zPosition = Globals.ZLevels.cityName
        self.nameLabel?.fontName = Globals.Fonts.customFontBoldFamilyname

        if let nameLabel = self.nameLabel {
            self.sprite.addChild(nameLabel)
        }
    }

    func hideCityName() {

        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameBackground?.removeFromParent()
        }
    }
}
