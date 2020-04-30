//
//  MapNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class MapNode: SKNode {

    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    var resourceLayer: ResourceLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer
    var yieldLayer: YieldLayer
    
    var unitLayer: UnitLayer
    var cityLayer: CityLayer
    var improvementLayer: ImprovementLayer
    var borderLayer: BorderLayer

    // MARK: properties

    private var game: GameModel?

    // MARK: constructors
    
    init(with game: GameModel?) {

        self.game = game
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        let humanPlayer = game.humanPlayer()

        self.terrainLayer = TerrainLayer(player: humanPlayer)
        self.terrainLayer.populate(with: self.game)
        self.terrainLayer.zPosition = Globals.ZLevels.terrain
        
        self.borderLayer = BorderLayer(player: humanPlayer)
        self.borderLayer.populate(with: self.game)
        self.borderLayer.zPosition = Globals.ZLevels.border

        self.featureLayer = FeatureLayer(player: humanPlayer)
        self.featureLayer.populate(with: self.game)
        self.featureLayer.zPosition = Globals.ZLevels.feature
        
        self.resourceLayer = ResourceLayer(player: humanPlayer)
        self.resourceLayer.populate(with: self.game)
        self.resourceLayer.zPosition = Globals.ZLevels.resource

        self.boardLayer = BoardLayer(player: humanPlayer)
        self.boardLayer.populate(with: self.game)
        self.boardLayer.zPosition = Globals.ZLevels.caldera

        self.riverLayer = RiverLayer(player: humanPlayer)
        self.riverLayer.populate(with: self.game)
        
        self.unitLayer = UnitLayer(player: humanPlayer)
        self.unitLayer.populate(with: self.game)
        self.unitLayer.zPosition = Globals.ZLevels.unit
        
        self.cityLayer = CityLayer(player: humanPlayer)
        self.cityLayer.populate(with: self.game)
        self.cityLayer.zPosition = Globals.ZLevels.city
        
        self.improvementLayer = ImprovementLayer(player: humanPlayer)
        self.improvementLayer.populate(with: self.game)
        self.improvementLayer.zPosition = Globals.ZLevels.improvement

        self.yieldLayer = YieldLayer(player: humanPlayer)
        self.yieldLayer.populate(with: self.game)
        self.yieldLayer.zPosition = Globals.ZLevels.yields
        
        super.init()
        self.zPosition = 0

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.resourceLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)
        self.addChild(self.unitLayer)
        self.addChild(self.cityLayer)
        self.addChild(self.improvementLayer)
        self.addChild(self.borderLayer)
        self.addChild(self.yieldLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    
    func showCross(at hex: HexPoint) {
        
        let crossSprite = SKSpriteNode(imageNamed: "cross")
        crossSprite.position = HexPoint.toScreen(hex: hex)
        crossSprite.zPosition = 500
        crossSprite.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(crossSprite)
        
        let delayAction = SKAction.wait(forDuration: 0.5)
        let hideAction = SKAction.run { crossSprite.removeFromParent() }
        
        crossSprite.run(SKAction.sequence([delayAction, hideAction]))
    }

    func updateLayout() {
        
    }
    
    func update(tile: AbstractTile?) {
        
        self.terrainLayer.update(tile: tile)
        self.borderLayer.update(tile: tile)
        self.featureLayer.update(tile: tile)
        self.resourceLayer.update(tile: tile)
        self.improvementLayer.update(tile: tile)
        self.boardLayer.update(tile: tile)
        self.yieldLayer.update(tile: tile)
    }
}
