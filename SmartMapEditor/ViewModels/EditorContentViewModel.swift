//
//  ContentViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 06.12.20.
//

import Foundation
import SmartAILibrary

class EditorContentViewModel: ObservableObject {

    @Published
    var map: MapModel? = nil

    @Published
    var zoom: CGFloat

    private var focus: AbstractTile? // input, leads to:
    @Published
    var focusedPoint: String
    @Published
    var focusedTerrainName: String
    @Published
    var focusedHillsValue: String
    @Published
    var focusedRiverValue: String
    @Published
    var focusedFeatureName: String {
        didSet {
            print("change: \(focusedFeatureName)")
        }
    }
    @Published
    var focusedResourceName: String

    @Published
    var focusedStartLocationName: String

    @Published
    var selectedZoomName: String

    @Published
    var brush: MapBrush

    @Published
    var brushTypeName: String

    @Published
    var brushSizeName: String

    @Published
    var brushTerrainName: String

    @Published
    var brushFeatureName: String

    @Published
    var brushResourceName: String

    var didChange: ((HexPoint) -> ())? = nil

    init() {

        self.zoom = 1.0
        self.focus = Tile(point: HexPoint(x: -1, y: -1), terrain: TerrainType.ocean)
        self.focusedPoint = "---"
        self.focusedTerrainName = "Ocean"
        self.focusedHillsValue = "no"
        self.focusedRiverValue = "---"
        self.focusedFeatureName = "---"
        self.focusedResourceName = "---"
        self.focusedStartLocationName = "---"

        self.selectedZoomName = "1.0"

        self.brush = MapBrush()
        self.brushTypeName = "Terrain"
        self.brushSizeName = "Small"
        self.brushTerrainName = "Ocean"
        self.brushFeatureName = "None"
        self.brushResourceName = "None"
    }

    func setZoom(to value: CGFloat) {

        self.zoom = value
    }

    private func riverName(for tile: AbstractTile?) -> String {

        if let tile = tile {
            var name: String = ""
            for flow in FlowDirection.all {

                if tile.isRiverIn(flow: flow) {
                    name += ("-" + flow.short)
                }
            }

            if name.count > 0 {
                name.removeFirst()
            }

            return name
        }

        return ""
    }

    func setFocus(to tile: AbstractTile?) {

        self.focus = tile

        if let tile = tile {

            self.focusedPoint = "\(tile.point.x), \(tile.point.y)"

            self.focusedTerrainName = tile.terrain().name()

            self.focusedHillsValue = tile.hasHills() ? "yes" : "no"

            self.focusedRiverValue = self.riverName(for: tile)

            if tile.feature() == .none {
                self.focusedFeatureName = "---"
            } else {
                self.focusedFeatureName = tile.feature().name()
            }

            if tile.resource(for: nil) == .none {
                self.focusedResourceName = "---"
            } else {
                self.focusedResourceName = tile.resource(for: nil).name()
            }

            if let startLocation = map?.startLocations.first(where: { $0.point == tile.point }) {

                self.focusedStartLocationName = startLocation.leader.name()
            } else {
                self.focusedStartLocationName = "---"
            }
        }
    }

    func setTerrain(to terrainName: String) {

        if let newTerrain = TerrainType.from(name: terrainName) {
            if let focusTile = self.focus {
                focusTile.set(terrain: newTerrain)

                // trigger redraw
                self.didChange?(focusTile.point)
            }
        }
    }

    func setHills(to value: String) {

        let newHills = value == "yes"
        if let focusTile = self.focus {
            focusTile.set(hills: newHills)

            // trigger redraw
            self.didChange?(focusTile.point)
        }
    }

    func setRiver(to value: String) {

        if let focusTile = self.focus {

            let river = River(with: "River", and: [])

            // "---", "n", "n-ne", "n-se", "ne-se", "n-ne-se", "se"
            do {
                if value == "---" {
                    focusTile.resetRiver()
                } else if value == "n" {
                    focusTile.resetRiver()
                    try focusTile.set(river: river, with: FlowDirection.east)
                } else if value == "n-ne" {
                    focusTile.resetRiver()
                    try focusTile.set(river: river, with: FlowDirection.east)
                    try focusTile.set(river: river, with: FlowDirection.northWest)
                } else if value == "n-se" {
                    focusTile.resetRiver()
                    try focusTile.set(river: river, with: FlowDirection.east)
                    try focusTile.set(river: river, with: FlowDirection.northEast)
                } else if value == "ne-se" {
                    focusTile.resetRiver()
                    try focusTile.set(river: river, with: FlowDirection.northWest)
                    try focusTile.set(river: river, with: FlowDirection.northEast)
                } else if value == "n-ne-se" {
                    focusTile.resetRiver()
                    try focusTile.set(river: river, with: FlowDirection.east)
                    try focusTile.set(river: river, with: FlowDirection.northWest)
                    try focusTile.set(river: river, with: FlowDirection.northEast)
                } else if value == "se" {
                    focusTile.resetRiver()
                    try focusTile.set(river: river, with: FlowDirection.northEast)
                } else {
                    fatalError("not handled: \(value)")
                }
            } catch {
                print("failed to set river: \(value) - \(error)")
            }

            // trigger redraw
            self.didChange?(focusTile.point)
        }
    }

    func setFeature(to featureName: String) {

        if let newFeature = FeatureType.from(name: featureName) {
            if let focusTile = self.focus {
                focusTile.set(feature: newFeature)

                // trigger redraw
                self.didChange?(focusTile.point)
            }
        } else {
            if let focusTile = self.focus {
                focusTile.set(feature: .none)

                // trigger redraw
                self.didChange?(focusTile.point)
            }
        }
    }

    func setResource(to resourceName: String) {

        if let newResource = ResourceType.from(name: resourceName) {
            if let focusTile = self.focus {
                focusTile.set(resource: newResource)

                // trigger redraw
                self.didChange?(focusTile.point)
            }
        } else {
            if let focusTile = self.focus {
                focusTile.set(resource: .none)

                // trigger redraw
                self.didChange?(focusTile.point)
            }
        }
    }

    func startLocationNames() -> [String] {

        guard let map = self.map else {
            return []
        }

        var startLocationNamesList: [String] = []

        startLocationNamesList.append("---")

        for startLocation in map.startLocations {

            startLocationNamesList.append(startLocation.leader.name())
        }

        return startLocationNamesList
    }

    func setStartLocation(to leaderName: String) {

        if let focusTile = self.focus {
            
            if let startLocation = self.map?.startLocations.first(where: { $0.leader.name() == leaderName }) {

                // trigger redraw at old location
                self.didChange?(startLocation.point)
                
                startLocation.point = focusTile.point
                
                // trigger redraw at new location
                self.didChange?(startLocation.point)
            }
        }
    }

    func setZoom(to zoomName: String) {

        if let newZoomValue = Double(zoomName) {

            self.zoom = CGFloat(newZoomValue)
            self.selectedZoomName = zoomName
        }
    }

    // MARK: brush methods

    func setBrushType(to value: String) {

        self.brush.setType(to: value)
        self.brushTypeName = value
    }

    func setBrushSize(to value: String) {

        self.brush.setSize(to: value)
        self.brushSizeName = value
    }

    func setBrushTerrain(to value: String) {

        self.brush.setTerrain(to: value)
        self.brushTerrainName = value
    }

    func setBrushFeature(to value: String) {

        self.brush.setFeature(to: value)
        self.brushFeatureName = value
    }

    func setBrushResource(to value: String) {

        self.brush.setResource(to: value)
        self.brushResourceName = value
    }

    func draw(at point: HexPoint) {

        guard let map = self.map else {
            return
        }

        let area: HexArea = point.areaWith(radius: self.brush.size.radius())
        let updateArea: HexArea = area

        switch self.brush.type {

        case .terrain:
            for pt in area {
                self.map?.set(terrain: self.brush.terrainValue, at: pt)
            }

            // check to make ocean to shore
            for pt in map.points() {
                if map.terrain(at: pt) == TerrainType.ocean && map.isAdjacentToLand(at: pt) {
                    self.map?.set(terrain: .shore, at: pt)
                    updateArea.add(point: pt)
                }
            }

            for pt in updateArea {
                // trigger redraw
                self.didChange?(pt)
            }

        case .feature:
            for pt in area {

                self.map?.set(feature: self.brush.featureValue, at: pt)

                // trigger redraw
                self.didChange?(pt)
            }

        case .resource:
            for pt in area {

                self.map?.set(resource: self.brush.resourceValue, at: pt)

                // trigger redraw
                self.didChange?(pt)
            }
        }
    }
}
