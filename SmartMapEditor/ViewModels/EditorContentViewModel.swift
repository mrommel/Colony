//
//  ContentViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 06.12.20.
//

import Foundation
import SmartAILibrary

class EditorContentViewModel: ObservableObject {

    @Published var map: MapModel? = nil
    @Published var zoom: CGFloat
    private var focus: AbstractTile? // input, leads to:
    @Published var focusedPoint: String
    @Published var focusedTerrainName: String
    @Published var focusedHillsValue: String
    @Published var focusedRiverValue: String
    @Published var focusedFeatureName: String
    @Published var focusedResourceName: String
    @Published var focusedStartLocationName: String
    @Published var selectedZoomName: String
    @Published var brush: MapBrush
    @Published var brushTypeName: String
    @Published var brushSizeName: String
    @Published var brushTerrainName: String
    @Published var brushFeatureName: String
    @Published var brushResourceName: String

    var didChange: ((HexPoint) -> ())? = nil

    init() {

        self.zoom = 1.0
        self.focus = Tile(point: HexPoint(x: -1, y: -1), terrain: TerrainType.ocean)
        self.focusedPoint = "---"
        self.focusedTerrainName = TerrainType.ocean.name()
        self.focusedHillsValue = "no"
        self.focusedRiverValue = "---"
        self.focusedFeatureName = FeatureType.none.name()
        self.focusedResourceName = ResourceType.none.name()
        self.focusedStartLocationName = "---"

        self.selectedZoomName = "1.0"

        self.brush = MapBrush()
        self.brushTypeName = MapBrushType.terrain.name()
        self.brushSizeName = MapBrushSize.small.name()
        self.brushTerrainName = TerrainType.ocean.name()
        self.brushFeatureName = FeatureType.none.name()
        self.brushResourceName = ResourceType.none.name()
    }

    func setFocus(to tile: AbstractTile?) {

        self.focus = tile

        if let tile = tile {

            self.focusedPoint = "\(tile.point.x), \(tile.point.y)"

            self.focusedTerrainName = tile.terrain().name()

            self.focusedHillsValue = tile.hasHills() ? "yes" : "no"

            self.focusedRiverValue = self.riverName(for: tile)

            if tile.feature() == .none {
                self.focusedFeatureName = FeatureType.none.name()
            } else {
                self.focusedFeatureName = tile.feature().name()
            }

            if tile.resource(for: nil) == .none {
                self.focusedResourceName = ResourceType.none.name()
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
    
    // MARK: iterate map
    
    func initTribes() {
        
        guard let map = self.map else {
            return
        }

        let startLocations = map.startLocations.map({ $0.point })
        self.map?.setupTribes(at: startLocations)
    }
    
    func iterateTribes() {
        
        self.map?.updateTribes()
    }
    
    // MARK: terrain functions

    func terrainOptionNames() -> [String] {
        
        return TerrainType.all.map({ $0.name() })
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
    
    // MARK: hill functions
    
    func hillsOptionNames() -> [String] {
        
        return  ["yes", "no"]
    }

    func setHills(to value: String) {

        let newHills = value == "yes"
        if let focusTile = self.focus {
            focusTile.set(hills: newHills)

            // trigger redraw
            self.didChange?(focusTile.point)
        }
    }
    
    // MARK: river functions
    
    func riverOptionNames() -> [String] {
        
        return ["---", "n", "n-ne", "n-se", "ne", "ne-se", "n-ne-se", "se"]
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
                } else if value == "ne" {
                    focusTile.resetRiver()
                    try focusTile.set(river: river, with: FlowDirection.northWest)
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
    
    // MARK: feature functions
    
    func featureOptionNames() -> [String] {
        
        return [FeatureType.none.name()] + FeatureType.all.map({ $0.name() })
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
    
    // MARK: resource functions
    
    func resourceOptionNames() -> [String] {
        
        return [ResourceType.none.name()] + ResourceType.all.map({ $0.name() })
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
    
    func clearResources() {
        
        guard let map = self.map else {
            return
        }
        
        var ptsToUpdate: [HexPoint] = []
        
        for pt in map.points() {
            
            guard let tile = map.tile(at: pt) else {
                continue
            }
            
            if tile.hasAnyResource(for: nil) {
                
                // remove resource
                tile.set(resource: .none)
                
                // mark spot for update
                ptsToUpdate.append(pt)
            }
        }
        
        // update
        for ptToUpdate in ptsToUpdate {
            
            // trigger redraw
            self.didChange?(ptToUpdate)
        }
    }
    
    func scatterResources() {
        
        guard let map = self.map else {
            return
        }
        
        var ptsToUpdate: [HexPoint] = []
        
        for pt in map.points() {
            
            guard let tile = map.tile(at: pt) else {
                continue
            }
            
            if tile.hasAnyResource(for: nil) {
                
                // remove resource
                tile.set(resource: .none)
                
                // mark spot for update
                ptsToUpdate.append(pt)
            }
        }
        
        // place new resources
        let handler = BaseMapHandler()
        handler.placeResources(on: self.map)
        
        for pt in map.points() {
            
            guard let tile = map.tile(at: pt) else {
                continue
            }
            
            if tile.hasAnyResource(for: nil) {
                // mark spot for update
                ptsToUpdate.append(pt)
            }
        }
        
        // update
        for ptToUpdate in ptsToUpdate {
            
            // trigger redraw
            self.didChange?(ptToUpdate)
        }
    }
    
    // MARK: start location functions

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
    
    // MARK: zoom functions
    
    func zoomOptionNames() -> [String] {
        
        return ["0.5", "1.0", "2.0"]
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
