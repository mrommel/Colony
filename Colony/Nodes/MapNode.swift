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

    // MARK: map

    private var map: HexagonTileMap?
    var gameObjectManager: GameObjectManager

    // MARK: constructors
    
    init(with level: Level) {

        self.map = level.map
        self.gameObjectManager = level.gameObjectManager
        self.gameObjectManager.map = self.map

        // TODO: make objects generic

        self.terrainLayer = TerrainLayer()
        self.terrainLayer.populate(with: self.map)

        self.featureLayer = FeatureLayer()
        self.featureLayer.populate(with: self.map)

        self.boardLayer = BoardLayer()
        self.boardLayer.populate(with: self.map)

        self.riverLayer = RiverLayer()
        self.riverLayer.populate(with: self.map)

        super.init()

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)

        for unit in self.gameObjectManager.objects {
            if let unit = unit {
                self.addChild(unit.sprite)
                unit.idle()
            }
        }

        level.gameObjectManager.gameObjectUnitDelegates.addDelegate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods

    func moveSelectedUnit(to hex: HexPoint) {

        if let selectedUnit = self.gameObjectManager.selected {

            guard selectedUnit.canMoveByUserInput else {
                return
            }
            
            if self.map?.valid(point: hex) ?? false {
                let pathFinder = AStarPathfinder()
                
                pathFinder.dataSource = map?.pathfinderDataSource(with: selectedUnit.movementType, ignoreSight: false)
                
                if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.position, toTileCoord: hex) {
                    selectedUnit.walk(on: path)
                    return
                }
            }
        }
    }

    func updateLayout() {
        
    }
}

extension MapNode: GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?) {
        // NOOP
    }
    
    func removed(gameObject: GameObject?) {
        gameObject?.sprite.removeFromParent()
    }
}
