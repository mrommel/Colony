//
//  Civ5MapHeader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.08.19.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import BinarySwift

struct Civ5MapHeader {
    
    let type: UInt8
    let width: Int32
    let height: Int32
    let numOfPlayers: UInt8
    let wrap: Int32
    
    let lengthOfTerrainTypeList: Int32 //int -- Length of Terrain type list
    let lengthOf1StFeatureTypeList: Int32 //int -- Length of 1st Feature type list
    let lengthOf2NdFeatureTypeList: Int32 //int -- Length of 2nd Feature type list
    let lengthOfResourceTypeList: Int32 //int -- Length of Resource type list
    let unknown: Int32 //int -- Unknown
    let lengthOfMapName: Int32 //int -- Length of Map Name string
    let lengthOfDescription: Int32 //int -- Length of Description string
    
    let terrainTypes: [String]
    let featureTypes: [String]
    let feature2ndTypes: [String]
    let resourceTypes: [String]
    
    let mapName: String //string -- Map Name string
    let summary: String //string -- Description string
    
    init(reader: BinaryDataReader) throws {
        
        // first block
        self.type = try reader.read()
        self.width = try reader.read()
        self.height = try reader.read()
        self.numOfPlayers = try reader.read()
        self.wrap = try reader.read()
        self.lengthOfTerrainTypeList = try reader.read()
        self.lengthOf1StFeatureTypeList = try reader.read()
        self.lengthOf2NdFeatureTypeList = try reader.read()
        self.lengthOfResourceTypeList = try reader.read()
        self.unknown = try reader.read()
        self.lengthOfMapName = try reader.read()
        self.lengthOfDescription = try reader.read()
        
        // second block
        let terrainTypesStr = try reader.readUTF8(Int(self.lengthOfTerrainTypeList))
        self.terrainTypes = terrainTypesStr.split(separator: "\0").map({ String($0) })
        
        let featureTypesStr = try reader.readUTF8(Int(self.lengthOf1StFeatureTypeList))
        self.featureTypes = featureTypesStr.split(separator: "\0").map({ String($0) })
        
        let feature2ndTypesStr = try reader.readUTF8(Int(self.lengthOf2NdFeatureTypeList))
        self.feature2ndTypes = feature2ndTypesStr.split(separator: "\0").map({ String($0) })
        
        let resourceTypesStr = try reader.readUTF8(Int(self.lengthOfResourceTypeList))
        self.resourceTypes = resourceTypesStr.split(separator: "\0").map({ String($0) })
        
        self.mapName = try reader.readNullTerminatedUTF8() //string -- Map Name string
        self.summary = try reader.readNullTerminatedUTF8() //string -- Description string
        
        // buffer
        if (self.type > 135) {
            let lengthOfStr: Int32 = try reader.read() //int -- Length of String3 (only present in version xB or later)
            _ = try reader.readUTF8(Int(lengthOfStr)) //string -- String3 (only present in version xB or later)
        }
    }
}

