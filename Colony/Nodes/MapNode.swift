//
//  MapNode.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MapNode: SKNode {

    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer

    // MARK: properties

    private var map: HexagonTileMap?
    weak var gameObjectManager: GameObjectManager?
    let userUsecase: UserUsecase

    // MARK: constructors
    
    init(with level: Level) {

        self.userUsecase = UserUsecase()
        
        guard let currentUser = self.userUsecase.currentUser() else {
            fatalError("can't get current user")
        }
        
        self.map = level.map
        self.gameObjectManager = level.gameObjectManager
        self.gameObjectManager?.map = self.map

        // TODO: make objects generic

        self.terrainLayer = TerrainLayer(civilization: currentUser.civilization)
        self.terrainLayer.populate(with: self.map)

        self.featureLayer = FeatureLayer(civilization: currentUser.civilization)
        self.featureLayer.populate(with: self.map)

        self.boardLayer = BoardLayer(civilization: currentUser.civilization)
        self.boardLayer.populate(with: self.map)

        self.riverLayer = RiverLayer(civilization: currentUser.civilization)
        self.riverLayer.populate(with: self.map)

        super.init()
        self.zPosition = 0 // GameScene.Constants.ZLevels.labels

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)

        for objectRef in self.gameObjectManager?.objects ?? [] {
            if let object = objectRef {
                object.addTo(node: self)
                //unit.idle()
            }
        }

        level.gameObjectManager.gameObjectUnitDelegates.addDelegate(self)
        level.gameObjectManager.node = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    
    func showCross(at hex: HexPoint) {
        
        let crossSprite = SKSpriteNode(imageNamed: "cross")
        crossSprite.position = HexMapDisplay.shared.toScreen(hex: hex)
        crossSprite.zPosition = 500
        crossSprite.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(crossSprite)
        
        let delayAction = SKAction.wait(forDuration: 0.5)
        let hideAction = SKAction.run { crossSprite.removeFromParent() }
        
        crossSprite.run(SKAction.sequence([delayAction, hideAction]))
    }

    func moveSelectedUnit(to hex: HexPoint) {

        guard let currentCivilization = self.userUsecase.currentUser()?.civilization else {
            return
        }
        
        if let selectedUnit = self.gameObjectManager?.selected {

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
        }
    }

    func updateLayout() {
        
    }
}

extension MapNode: GameObjectUnitDelegate {
    
    func selectedUnitChanged(to unit: Unit?) {
        // NOOP
    }
    
    func removed(unit: Unit?) {
        // NOOP
    }
}
