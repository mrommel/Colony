//
//  MapNode.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class MapNode: SKNode {

    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    var resourceLayer: ResourceLayer
    var resourceMarkerLayer: ResourceMarkerLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer
    var unitLayer: UnitLayer
    var cityLayer: CityLayer
    var improvementLayer: ImprovementLayer
    var borderLayer: BorderLayer
    var tooltipLayer: TooltipLayer

    // can be shown by map options
    var yieldLayer: YieldLayer
    var waterLayer: WaterLayer
    var hexCoordLayer: HexCoordLayer

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

        self.featureLayer = FeatureLayer(player: humanPlayer)
        self.featureLayer.populate(with: self.game)
        self.featureLayer.zPosition = Globals.ZLevels.feature

        self.resourceLayer = ResourceLayer(player: humanPlayer)
        self.resourceLayer.populate(with: self.game)
        self.resourceLayer.zPosition = Globals.ZLevels.resource

        self.resourceMarkerLayer = ResourceMarkerLayer(player: humanPlayer)
        self.resourceMarkerLayer.populate(with: self.game)
        self.resourceMarkerLayer.zPosition = Globals.ZLevels.resourceMarker

        self.boardLayer = BoardLayer(player: humanPlayer)
        self.boardLayer.populate(with: self.game)
        self.boardLayer.zPosition = Globals.ZLevels.caldera

        self.riverLayer = RiverLayer(player: humanPlayer)
        self.riverLayer.populate(with: self.game)
        self.riverLayer.zPosition = Globals.ZLevels.river

        self.borderLayer = BorderLayer(player: humanPlayer)
        self.borderLayer.populate(with: self.game)
        self.borderLayer.zPosition = Globals.ZLevels.border

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

        self.waterLayer = WaterLayer(player: humanPlayer)
        self.waterLayer.populate(with: self.game)
        self.waterLayer.zPosition = Globals.ZLevels.water

        self.tooltipLayer = TooltipLayer(player: humanPlayer)
        self.tooltipLayer.populate(with: self.game)
        self.tooltipLayer.zPosition = Globals.ZLevels.tooltips

        self.hexCoordLayer = HexCoordLayer(player: humanPlayer)
        self.hexCoordLayer.populate(with: self.game)
        self.hexCoordLayer.zPosition = Globals.ZLevels.hexCoords

        super.init()
        self.zPosition = 51

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.resourceLayer)
        self.addChild(self.resourceMarkerLayer) // ???
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)
        self.addChild(self.unitLayer)
        self.addChild(self.cityLayer)
        self.addChild(self.improvementLayer)
        self.addChild(self.borderLayer)
        // self.addChild(self.tooltipLayer)
        self.addChild(self.hexCoordLayer) // ???
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: methods

    func showYields() {

        if self.childNode(withName: YieldLayer.kName) == nil {
            self.addChild(self.yieldLayer)
        }
    }

    func hideYields() {

        if self.childNode(withName: YieldLayer.kName) != nil {
            self.yieldLayer.removeFromParent()
        }
    }

    func showResourceMarker() {

        if self.childNode(withName: ResourceMarkerLayer.kName) == nil {
            self.addChild(self.resourceMarkerLayer)
        }
    }

    func hideResourceMarker() {

        if self.childNode(withName: ResourceMarkerLayer.kName) != nil {
            self.resourceMarkerLayer.removeFromParent()
        }
    }

    func showWater() {

        if self.childNode(withName: WaterLayer.kName) == nil {
            self.addChild(self.waterLayer)
        }
    }

    func hideWater() {

        if self.childNode(withName: WaterLayer.kName) != nil {
            self.waterLayer.removeFromParent()
        }
    }

    func showHexCoords() {

        if self.childNode(withName: HexCoordLayer.kName) == nil {
            self.addChild(self.hexCoordLayer)
        }
    }

    func hideHexCoords() {

        if self.childNode(withName: HexCoordLayer.kName) != nil {
            self.hexCoordLayer.removeFromParent()
        }
    }

    func showCompleteMap() {

        if self.terrainLayer.showCompleteMap {
            // early stop
            return
        }

        self.terrainLayer.showCompleteMap = true
        self.terrainLayer.rebuild()
        self.featureLayer.showCompleteMap = true
        self.featureLayer.rebuild()
        self.resourceLayer.showCompleteMap = true
        self.resourceLayer.rebuild()
        self.resourceMarkerLayer.showCompleteMap = true
        self.resourceMarkerLayer.rebuild()
        self.boardLayer.showCompleteMap = true
        self.boardLayer.rebuild()
        self.riverLayer.showCompleteMap = true
        self.riverLayer.rebuild()
        /*self.unitLayer.showCompleteMap = true
        self.unitLayer.rebuild()
        self.cityLayer.showCompleteMap = true
        self.cityLayer.rebuild()*/
        self.improvementLayer.showCompleteMap = true
        self.improvementLayer.rebuild()
        self.yieldLayer.showCompleteMap = true
        self.yieldLayer.rebuild()
        self.waterLayer.showCompleteMap = true
        self.waterLayer.rebuild()
        self.borderLayer.showCompleteMap = true
        self.borderLayer.rebuild()
        //self.addChild(self.tooltipLayer)
        self.hexCoordLayer.showCompleteMap = true
        self.hexCoordLayer.rebuild()
    }

    func showVisibleMap() {

        if !self.terrainLayer.showCompleteMap {
            // early stop
            return
        }

        self.terrainLayer.showCompleteMap = false
        self.terrainLayer.rebuild()
        self.featureLayer.showCompleteMap = false
        self.featureLayer.rebuild()
        self.resourceLayer.showCompleteMap = false
        self.resourceLayer.rebuild()
        self.resourceMarkerLayer.showCompleteMap = false
        self.resourceMarkerLayer.rebuild()
        self.boardLayer.showCompleteMap = false
        self.boardLayer.rebuild()
        self.riverLayer.showCompleteMap = false
        self.riverLayer.rebuild()
        /*self.unitLayer.showCompleteMap = false
        self.unitLayer.rebuild()
        self.cityLayer.showCompleteMap = false
        self.cityLayer.rebuild()*/
        self.improvementLayer.showCompleteMap = false
        self.improvementLayer.rebuild()
        self.yieldLayer.showCompleteMap = false
        self.yieldLayer.rebuild()
        self.waterLayer.showCompleteMap = false
        self.waterLayer.rebuild()
        self.borderLayer.showCompleteMap = false
        self.borderLayer.rebuild()
        //self.addChild(self.tooltipLayer)
        self.hexCoordLayer.showCompleteMap = false
        self.hexCoordLayer.rebuild()
    }

    func updateLayout() {

    }

    func update(tile: AbstractTile?) {

        self.terrainLayer.update(tile: tile)
        self.featureLayer.update(tile: tile)
        self.resourceLayer.update(tile: tile)
        self.resourceMarkerLayer.update(tile: tile)
        self.riverLayer.update(tile: tile)
        self.improvementLayer.update(tile: tile)
        self.boardLayer.update(tile: tile)
        self.yieldLayer.update(tile: tile)
        self.waterLayer.update(tile: tile)
        self.borderLayer.update(tile: tile)
        self.hexCoordLayer.update(tile: tile)
    }
}
