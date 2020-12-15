//
//  MapBrush.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 15.12.20.
//

import Foundation
import SmartAILibrary

class MapBrush {

    var type: MapBrushType = .terrain
    var size: MapBrushSize = .small
    var terrainValue: TerrainType = .ocean
    var featureValue: FeatureType = .none
    var resourceValue: ResourceType = .none
    
    func setType(to typeName: String) {

        if let newType = MapBrushType.from(name: typeName) {
            self.type = newType
        }
    }
    
    func setSize(to sizeName: String) {

        if let newSize = MapBrushSize.from(name: sizeName) {
            self.size = newSize
        }
    }
    
    func setTerrain(to terrainName: String) {
        
        if let newTerrain = TerrainType.from(name: terrainName) {
            self.terrainValue = newTerrain
        }
    }
    
    func setFeature(to featureName: String) {
        
        if let newFeature = FeatureType.from(name: featureName) {
            self.featureValue = newFeature
        }
    }
    
    func setResource(to resourceName: String) {
        
        if let newResource = ResourceType.from(name: resourceName) {
            self.resourceValue = newResource
        }
    }
}
