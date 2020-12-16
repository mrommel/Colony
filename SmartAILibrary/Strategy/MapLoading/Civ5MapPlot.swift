//
//  Civ5MapPlot.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.08.19.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import BinarySwift

// Civ5 ArtStyle
enum ArtStyle: Int, Codable {
    
    case none = 0
    
    case americas = 1
    case asia = 2
    case africa = 3
    case europe = 4
}

struct Civ5MapPlot: Codable {
    
    var terrain: TerrainType //byte 0 -- Terrain type ID (index into list of Terrain types read from header)
    var hills: Bool = false
    let ressourceType: ResourceType? //byte 1 -- Resource type ID; 0xFF if none
    var feature1stType: FeatureType? //byte 2 -- 1st Feature type ID; 0xFF if none
    let river: UInt8 //byte 3 -- River indicator (non-zero if tile borders a river; actual value probably indicates direction)
    let elevation: UInt8 //byte 4 -- Elevation (0 = Flat, 1 = Hill, 2 = Mountain)
    let artStyle: ArtStyle //byte 5 -- Unknown (possibly related to continent art style)
    let feature2ndType: FeatureType? //byte 6 -- 2nd Feature type ID; 0xFF if none
    let resourceQuantity: UInt8 //byte 7 -- resource amount
    
    init(reader: BinaryDataReader, header: Civ5MapHeader) throws {
        
        let terrainTypeIndex: UInt8 = try reader.read()
        self.terrain = TerrainType.fromCiv5String(value: header.terrainTypes[Int(terrainTypeIndex)])!
        
        let ressourceIndex: UInt8 = try reader.read()
        if ressourceIndex != 255 {
            self.ressourceType = ResourceType.fromCiv5String(value: header.resourceTypes[Int(ressourceIndex)])
        } else {
            self.ressourceType = nil
        }
        
        let feature1stTypeIndex: UInt8 = try reader.read()
        if feature1stTypeIndex != 255 {
            self.feature1stType = FeatureType.fromCiv5String(value: header.featureTypes[Int(feature1stTypeIndex)])
        } else {
            self.feature1stType = nil
        }
        self.river = try reader.read()
        self.elevation = try reader.read()
        
        // hills + mountains
        if self.elevation == 1 {
            self.hills = true
        } else if self.elevation == 2 {
            if let currentFeature = self.feature1stType {
                print("warning: setting mountain removes \(currentFeature)")
            }
            
            self.feature1stType = .mountains
        }
        
        let artStyleValue: UInt8 = try reader.read()
        self.artStyle = ArtStyle(rawValue: Int(artStyleValue)) ?? ArtStyle.none
        let feature2stTypeIndex: UInt8 = try reader.read()
        if feature2stTypeIndex != 255 {
            guard let featureType = FeatureType.fromCiv5String(value: header.feature2ndTypes[Int(feature2stTypeIndex)]) else {
                fatalError("feature type not handled: \(header.feature2ndTypes[Int(feature2stTypeIndex)])")
            }
            self.feature2ndType = featureType
        } else {
            self.feature2ndType = nil
        }
        self.resourceQuantity = try reader.read()
    }
}

extension Civ5MapPlot: Equatable {
    
}
