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
    
    var unitLayer: UnitLayer

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

        self.featureLayer = FeatureLayer(player: humanPlayer)
        self.featureLayer.populate(with: self.game)
        
        self.resourceLayer = ResourceLayer(player: humanPlayer)
        self.resourceLayer.populate(with: self.game)

        self.boardLayer = BoardLayer(player: humanPlayer)
        self.boardLayer.populate(with: self.game)

        self.riverLayer = RiverLayer(player: humanPlayer)
        self.riverLayer.populate(with: self.game)
        
        self.unitLayer = UnitLayer(player: humanPlayer)
        self.unitLayer.populate(with: self.game)

        super.init()
        self.zPosition = 0

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.resourceLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)
        self.addChild(self.unitLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    
    func showCross(at hex: HexPoint) {
        
        let crossSprite = SKSpriteNode(imageNamed: "cross")
        crossSprite.position = HexPoint.toScreen(hex: hex) //HexMapDisplay.shared.toScreen(hex: hex)
        crossSprite.zPosition = 500
        crossSprite.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(crossSprite)
        
        let delayAction = SKAction.wait(forDuration: 0.5)
        let hideAction = SKAction.run { crossSprite.removeFromParent() }
        
        crossSprite.run(SKAction.sequence([delayAction, hideAction]))
    }

    func moveSelectedUnit(to hex: HexPoint) {

        /*guard let currentCivilization = self.userUsecase.currentUser()?.civilization else {
            return
        }*/
        
        /*if let selectedUnit = self.gameObjectManager?.selected {

            guard selectedUnit.civilization == currentCivilization else {
                // FIXME: show x
                self.showCross(at: hex)
                return
            }
            
            // can only select new target when unit is idle
            /*guard selectedUnit.state.state == .idle else {
                // FIXME: show x
                self.showCross(at: hex)
                return
            }*/
            
            if self.map?.valid(point: hex) ?? false {
                let pathFinder = AStarPathfinder()
                
                pathFinder.dataSource = map?.pathfinderDataSource(with: self.gameObjectManager, movementType: selectedUnit.unitType.movementType, civilization: currentCivilization, ignoreSight: false)
                
                if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.position, toTileCoord: hex) {
                    selectedUnit.gameObject?.showWalk(on: path, completion: {
                        selectedUnit.gameObject?.showIdle()
                    })
                    return
                }
            }
        }*/
    }

    func updateLayout() {
        
    }
}
