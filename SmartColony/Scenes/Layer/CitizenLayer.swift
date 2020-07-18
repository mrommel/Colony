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

        guard let player = city?.player else {
            fatalError("cant get player")
        }

        guard let citizens = city?.cityCitizens else {
            fatalError("cant get citizens")
        }

        self.textureUtils = TextureUtils(with: gameModel)

        for location in citizens.workingTileLocations() {

            if let tile = gameModel.tile(at: location) {

                if player.isEqual(to: tile.workingCity()?.player) {

                    let screenPoint = HexPoint.toScreen(hex: location)
                    let selected = citizens.isWorked(at: location) || tile.point == city?.location
                    let forced = citizens.isForcedWorked(at: location)

                    if tile.isVisible(to: self.player) {
                        self.placeCitizen(for: location, at: screenPoint, selected: selected, forced: forced)
                    }
                }
            }
        }
    }

    /// handles all terrain
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
    
    func refresh() {
        
        for child in self.children {
            child.removeFromParent()
        }
        
        self.populate(with: self.gameModel)
    }
}
