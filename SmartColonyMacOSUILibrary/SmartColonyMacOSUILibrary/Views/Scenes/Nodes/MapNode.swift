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
    var districtLayer: DistrictLayer
    var wonderLayer: WonderLayer

    // can be shown by map options
    var yieldLayer: YieldLayer
    var gridLayer: GridLayer
    var hexCoordLayer: HexCoordLayer
    var mapLensLayer: MapLensLayer
    var mapMarkerLayer: MapMarkerLayer // default on

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

        self.gridLayer = GridLayer(player: humanPlayer)
        self.gridLayer.populate(with: self.game)
        self.gridLayer.zPosition = Globals.ZLevels.grid

        self.tooltipLayer = TooltipLayer(player: humanPlayer)
        self.tooltipLayer.populate(with: self.game)
        self.tooltipLayer.zPosition = Globals.ZLevels.tooltips

        self.hexCoordLayer = HexCoordLayer(player: humanPlayer)
        self.hexCoordLayer.populate(with: self.game)
        self.hexCoordLayer.zPosition = Globals.ZLevels.hexCoords

        self.mapLensLayer = MapLensLayer(player: humanPlayer)
        self.mapLensLayer.populate(with: self.game)
        self.mapLensLayer.zPosition = Globals.ZLevels.mapLens

        self.districtLayer = DistrictLayer(player: humanPlayer)
        self.districtLayer.populate(with: self.game)
        self.districtLayer.zPosition = Globals.ZLevels.districtEmpty

        self.wonderLayer = WonderLayer(player: humanPlayer)
        self.wonderLayer.populate(with: self.game)
        self.wonderLayer.zPosition = Globals.ZLevels.wonder

        self.mapMarkerLayer = MapMarkerLayer(player: humanPlayer)
        self.mapMarkerLayer.populate(with: self.game)
        self.mapMarkerLayer.zPosition = Globals.ZLevels.mapMarkers

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
        self.addChild(self.tooltipLayer)
        // self.addChild(self.hexCoordLayer) // ???
        self.addChild(self.districtLayer)
        self.addChild(self.wonderLayer)
        self.addChild(self.mapMarkerLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: methods

    func refresh(with mapOptions: MapDisplayOptions) {

        if mapOptions.showGrid {
            self.showGrid()
        } else {
            self.hideGrid()
        }

        if mapOptions.showResourceMarkers {
            self.showResourceMarker()
        } else {
            self.hideResourceMarker()
        }

        if mapOptions.showYields {
            self.showYields()
        } else {
            self.hideYields()
        }

        if mapOptions.showHexCoordinates {
            self.showHexCoords()
        } else {
            self.hideHexCoords()
        }

        if mapOptions.showCompleteMap {
            self.showCompleteMap()
        } else {
            self.showVisibleMap()
        }

        self.set(mapLens: mapOptions.mapLens)
    }

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

    func showGrid() {

        if self.childNode(withName: GridLayer.kName) == nil {
            self.addChild(self.gridLayer)
        }
    }

    func hideGrid() {

        if self.childNode(withName: GridLayer.kName) != nil {
            self.gridLayer.removeFromParent()
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

    func showMapMarkers() {

        if self.childNode(withName: MapMarkerLayer.kName) == nil {
            self.addChild(self.mapMarkerLayer)
        }
    }

    func hideMapMarkers() {

        if self.childNode(withName: MapMarkerLayer.kName) != nil {
            self.mapMarkerLayer.removeFromParent()
        }
    }

    func currentMapLens() -> MapLensType {

        return self.mapLensLayer.mapLens
    }

    func set(mapLens: MapLensType) {

        let oldMapLens = self.mapLensLayer.mapLens

        if mapLens == .none {
            self.mapLensLayer.removeFromParent()
            return
        }

        if oldMapLens != mapLens || self.mapLensLayer.parent == nil {

            self.mapLensLayer.mapLens = mapLens
            self.mapLensLayer.rebuild()

            if oldMapLens == .none || self.mapLensLayer.parent == nil {
                self.addChild(self.mapLensLayer)
            }
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
        /* self.unitLayer.showCompleteMap = true
        self.unitLayer.rebuild() */
        self.cityLayer.showCompleteMap = true
        // self.cityLayer.rebuild()
        self.improvementLayer.showCompleteMap = true
        self.improvementLayer.rebuild()
        self.yieldLayer.showCompleteMap = true
        self.yieldLayer.rebuild()
        self.gridLayer.showCompleteMap = true
        self.gridLayer.rebuild()
        self.borderLayer.showCompleteMap = true
        self.borderLayer.rebuild()
        // self.addChild(self.tooltipLayer)
        self.hexCoordLayer.showCompleteMap = true
        self.hexCoordLayer.rebuild()
        self.districtLayer.showCompleteMap = true
        self.districtLayer.rebuild()
        self.wonderLayer.showCompleteMap = true
        self.wonderLayer.rebuild()
        self.mapLensLayer.showCompleteMap = true
        self.mapLensLayer.rebuild()
        self.mapMarkerLayer.showCompleteMap = true
        self.mapMarkerLayer.rebuild()
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
        /* self.unitLayer.showCompleteMap = false
        self.unitLayer.rebuild() */
        self.cityLayer.showCompleteMap = false
        // self.cityLayer.rebuild()
        self.improvementLayer.showCompleteMap = false
        self.improvementLayer.rebuild()
        self.yieldLayer.showCompleteMap = false
        self.yieldLayer.rebuild()
        self.gridLayer.showCompleteMap = false
        self.gridLayer.rebuild()
        self.borderLayer.showCompleteMap = false
        self.borderLayer.rebuild()
        // self.addChild(self.tooltipLayer)
        self.hexCoordLayer.showCompleteMap = false
        self.hexCoordLayer.rebuild()
        self.districtLayer.showCompleteMap = false
        self.districtLayer.rebuild()
        self.wonderLayer.showCompleteMap = false
        self.wonderLayer.rebuild()
        self.mapLensLayer.showCompleteMap = false
        self.mapLensLayer.rebuild()
        self.mapMarkerLayer.showCompleteMap = false
        self.mapMarkerLayer.rebuild()
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
        self.gridLayer.update(tile: tile)
        self.borderLayer.update(tile: tile)
        self.hexCoordLayer.update(tile: tile)
        self.districtLayer.update(tile: tile)
        self.wonderLayer.update(tile: tile)
        self.mapLensLayer.update(tile: tile)
        self.mapMarkerLayer.update(tile: tile)
    }
}
