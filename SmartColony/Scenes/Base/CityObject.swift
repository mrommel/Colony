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
    private var growthProgressNode: SKSpriteNode?
    private var productionNode: SKSpriteNode?
    private var productionProgressNode: SKSpriteNode?

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

    func showCityBanner() {

        guard let city = self.city else {
            fatalError("cant get unit")
        }

        guard let player = city.player else {
            fatalError("cant get player")
        }

        self.hideCityBanner()

        let nameLabelWidth: Double = Double(city.name.count) * 4.2 + (city.isCapital() ? 10.0 : 0)
        let nameBackgroundWidth = nameLabelWidth + 18.0

        self.nameBackground = NineGridTextureSprite(imageNamed: "city_banner", size: CGSize(width: nameBackgroundWidth, height: 10))
        self.nameBackground?.position = CGPoint(x: 24, y: 35)
        self.nameBackground?.zPosition = Globals.ZLevels.cityName - 0.1
        self.nameBackground?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.nameBackground?.colorBlendFactor = 1.0
        self.nameBackground?.color = player.leader.civilization().backgroundColor()

        if let nameBackground = self.nameBackground {
            self.sprite.addChild(nameBackground)
        }

        self.sizeLabel = SKLabelNode(text: "\(city.population())")
        self.sizeLabel?.fontSize = 8
        self.sizeLabel?.position = CGPoint(x: 24 - nameBackgroundWidth / 2 + 4, y: 36)
        self.sizeLabel?.zPosition = Globals.ZLevels.cityName
        self.sizeLabel?.fontName = Globals.Fonts.customFontFamilyname
        self.sizeLabel?.fontColor = player.leader.civilization().iconColor()
        self.sizeLabel?.preferredMaxLayoutWidth = 12

        if let sizeLabel = self.sizeLabel {
            self.sprite.addChild(sizeLabel)
        }

        let growthProgress: Int = Int(Double(city.growthInTurns() * 100) / Double(city.maxGrowthInTurns())) / 5 * 5
        let growthProgressTextureName = "linear_progress_\(growthProgress)"
        let growthProgressTexture = SKTexture(imageNamed: growthProgressTextureName)

        self.growthProgressNode = SKSpriteNode(texture: growthProgressTexture, color: .black, size: CGSize(width: 2, height: 10))
        self.growthProgressNode?.position = CGPoint(x: 24 - nameBackgroundWidth / 2 + 4 + 4, y: 35)
        self.growthProgressNode?.zPosition = Globals.ZLevels.cityName
        self.growthProgressNode?.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let growthProgressNode = self.growthProgressNode {
            self.sprite.addChild(growthProgressNode)
        }

        self.nameLabel = SKLabelNode(text: "\(city.isCapital() ? "✪ ": "")\(city.name)")
        self.nameLabel?.fontSize = 8
        self.nameLabel?.position = CGPoint(x: 24, y: 36)
        self.nameLabel?.zPosition = Globals.ZLevels.cityName
        self.nameLabel?.fontName = Globals.Fonts.customFontFamilyname
        self.nameLabel?.fontColor = player.leader.civilization().iconColor()
        self.nameLabel?.preferredMaxLayoutWidth = 30

        self.nameLabel?.fitToWidth(maxWidth: CGFloat(nameLabelWidth))

        if let nameLabel = self.nameLabel {
            self.sprite.addChild(nameLabel)
        }

        // show production only for human cities
        if city.isHuman() {
            var texture: SKTexture = SKTexture(imageNamed: "questionmark")
            var productionProgress: Int = 0
            if let item = city.currentBuildableItem() {
                switch item.type {

                case .unit:
                    if let unitType = item.unitType {
                        texture = unitType.iconTexture()
                        productionProgress = Int((item.production * 100.0) / Double(unitType.productionCost())) / 5 * 5
                    }
                case .building:
                    if let buildingType = item.buildingType {
                        texture = SKTexture(imageNamed: buildingType.iconTexture())
                        productionProgress = Int((item.production * 100.0) / Double(buildingType.productionCost())) / 5 * 5
                    }
                case .wonder:
                    if let wonderType = item.wonderType {
                        texture = SKTexture(imageNamed: wonderType.iconTexture())
                        productionProgress = Int((item.production * 100.0) / Double(wonderType.productionCost())) / 5 * 5
                    }
                case .district:
                    if let districtType = item.districtType {
                        texture = SKTexture(imageNamed: districtType.iconTexture())
                        productionProgress = Int((item.production * 100.0) / Double(districtType.productionCost())) / 5 * 5
                    }
                case .project:
                    /*if let projectType = item.projectType {
                    textureName = projectType.iconTexture()
                }*/
                    break
                }
            }

            let productionProgressTextureName = "linear_progress_\(productionProgress)"
            let productionProgressTexture = SKTexture(imageNamed: productionProgressTextureName)

            self.productionProgressNode = SKSpriteNode(texture: productionProgressTexture, color: .black, size: CGSize(width: 2, height: 10))
            self.productionProgressNode?.position = CGPoint(x: 24 + nameBackgroundWidth / 2 - 11, y: 35)
            self.productionProgressNode?.zPosition = Globals.ZLevels.cityName
            self.productionProgressNode?.anchorPoint = CGPoint(x: 0.0, y: 0.0)

            if let productionProgressNode = self.productionProgressNode {
                self.sprite.addChild(productionProgressNode)
            }

            self.productionNode = SKSpriteNode(texture: texture, color: .black, size: CGSize(width: 8, height: 8))
            self.productionNode?.position = CGPoint(x: 24 + nameBackgroundWidth / 2 - 9, y: 36)
            self.productionNode?.zPosition = Globals.ZLevels.cityName
            self.productionNode?.anchorPoint = CGPoint(x: 0.0, y: 0.0)

            if let productionNode = self.productionNode {
                self.sprite.addChild(productionNode)
            }
        }
    }

    func hideCityBanner() {

        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameLabel = nil
            self.nameBackground?.removeFromParent()
            self.nameBackground = nil
            self.sizeLabel?.removeFromParent()
            self.sizeLabel = nil
            self.growthProgressNode?.removeFromParent()
            self.growthProgressNode = nil
            self.productionNode?.removeFromParent()
            self.productionNode = nil
            self.productionProgressNode?.removeFromParent()
            self.productionProgressNode = nil
        }
    }
}
