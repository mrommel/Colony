//
//  CitizenLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 09.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class CitizenLayer: SKNode {

    let city: AbstractCity?
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    // MARK: constructor

    init(city: AbstractCity?) {

        self.city = city
        self.player = city?.player

        super.init()
        self.zPosition = Globals.ZLevels.citizen
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with gameModel: GameModel?) {

        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        guard let city = self.city else {
            fatalError("cant get city")
        }

        guard let player = city.player else {
            fatalError("cant get player")
        }

        guard let citizens = city.cityCitizens else {
            fatalError("cant get citizens")
        }

        self.textureUtils = TextureUtils(with: gameModel)

        for location in citizens.workingTileLocations() {

            if let tile = gameModel.tile(at: location) {
                
                let screenPoint = HexPoint.toScreen(hex: location)

                if player.isEqual(to: tile.workingCity()?.player) {

                    let selected = citizens.isWorked(at: location) || tile.point == city.location
                    let forced = citizens.isForcedWorked(at: location)

                    if tile.isVisible(to: self.player) {
                        self.placeCitizen(for: location, at: screenPoint, selected: selected, forced: forced)
                    }
                } else {
                    
                    var isNeighborWorkedByCity = false

                    for neighbor in location.neighbors() {
                        
                        if let neighborTile = gameModel.tile(at: neighbor) {
                            if player.isEqual(to: neighborTile.workingCity()?.player) {
                                isNeighborWorkedByCity = true
                            }
                        }
                    }
                    
                    if isNeighborWorkedByCity && tile.isVisible(to: self.player) {
                        
                        let cost = city.buyPlotCost(at: tile.point, in: gameModel)
                        //print("cost: \(cost) at \(tile.point)")
                        self.placePurchaseButton(for: location, at: screenPoint, cost: cost)
                    }
                }
            }
        }
    }

    func placeCitizen(for point: HexPoint, at position: CGPoint, selected: Bool, forced: Bool) {

        var textureName = "tile_citizen_normal"

        if selected {
            if !forced {
                textureName = "tile_citizen_selected"
            } else {
                textureName = "tile_citizen_forced"
            }
        }

        let citizenSprite = SKSpriteNode(imageNamed: textureName)
        citizenSprite.position = position
        citizenSprite.zPosition = Globals.ZLevels.water
        citizenSprite.anchorPoint = CGPoint(x: 0, y: 0)
        citizenSprite.color = .black
        citizenSprite.colorBlendFactor = 0.0
        self.addChild(citizenSprite)
    }
    
    func placePurchaseButton(for point: HexPoint, at position: CGPoint, cost: Int) {
        
        let offset: CGPoint = CGPoint(x: 24, y: 9)
        
        let citizenSprite = SKSpriteNode(imageNamed: "tile_purchase")
        citizenSprite.position = position
        citizenSprite.zPosition = Globals.ZLevels.water
        citizenSprite.anchorPoint = CGPoint(x: 0, y: 0)
        citizenSprite.color = .black
        citizenSprite.colorBlendFactor = 0.0
        self.addChild(citizenSprite)
        
        // add cost
        let costShadowLabel = SKLabelNode(text: "\(cost)")
        costShadowLabel.position = position + offset + CGPoint(x: 1, y: -0.5)
        costShadowLabel.zPosition = Globals.ZLevels.water
        costShadowLabel.fontSize = 8
        costShadowLabel.fontColor = .black
        costShadowLabel.horizontalAlignmentMode = .center
        self.addChild(costShadowLabel)
        
        let costLabel = SKLabelNode(text: "\(cost)")
        costLabel.position = position + offset
        costLabel.zPosition = Globals.ZLevels.water
        costLabel.fontSize = 8
        costLabel.fontColor = .white
        costLabel.horizontalAlignmentMode = .center
        self.addChild(costLabel)
    }
    
    func refresh() {
        
        for child in self.children {
            child.removeFromParent()
        }
        
        self.populate(with: self.gameModel)
    }
}
