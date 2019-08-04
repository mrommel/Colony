//
//  Civ5MapReader.swift
//  Colony
//
//  Created by Michael Rommel on 02.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
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

struct Civ5MapPlot: Codable {
    
    var terrain: Terrain //byte 0 -- Terrain type ID (index into list of Terrain types read from header)
    let ressourceType: UInt8 //byte 1 -- Resource type ID; 0xFF if none
    let feature1stType: Feature? //byte 2 -- 1st Feature type ID; 0xFF if none
    let river: UInt8 //byte 3 -- River indicator (non-zero if tile borders a river; actual value probably indicates direction)
    let elevation: UInt8 //byte 4 -- Elevation (0 = Flat, 1 = Hill, 2 = Mountain)
    let artStyle: UInt8 //byte 5 -- Unknown (possibly related to continent art style)
    let feature2ndType: Feature? //byte 6 -- 2nd Feature type ID; 0xFF if none
    let unused2: UInt8 //byte 7 -- Unknown
    
    init(reader: BinaryDataReader, header: Civ5MapHeader) throws {
        
        let terrainTypeIndex: UInt8 = try reader.read()
        self.terrain = Terrain.fromCiv5String(value: header.terrainTypes[Int(terrainTypeIndex)])!
        
        self.ressourceType = try reader.read()
        
        let feature1stTypeIndex: UInt8 = try reader.read()
        if feature1stTypeIndex != 255 {
            self.feature1stType = Feature.fromCiv5String(value: header.featureTypes[Int(feature1stTypeIndex)])
        } else {
            self.feature1stType = nil
        }
        self.river = try reader.read()
        self.elevation = try reader.read()
        
        // hills + mountains
        if self.elevation == 1 {
            self.terrain = .hill
        } else if self.elevation == 2 {
            self.terrain = .mountain
        }
        
        self.artStyle = try reader.read()
        let feature2stTypeIndex: UInt8 = try reader.read()
        if feature2stTypeIndex != 255 {
            self.feature2ndType = Feature.fromCiv5String(value: header.feature2ndTypes[Int(feature2stTypeIndex)])
        } else {
            self.feature2ndType = nil
        }
        self.unused2 = try reader.read()
    }
}

extension Civ5MapPlot: Equatable {
    
}

class Civ5Map {
    
    let header: Civ5MapHeader
    let plots: Array2D<Civ5MapPlot>
    
    init(header: Civ5MapHeader, plots: Array2D<Civ5MapPlot>) {
        self.header = header
        self.plots = plots
    }
    
    func toMap() -> HexagonTileMap? {
        
        let map = HexagonTileMap(width: Int(header.width), height: Int(header.height))

        for y in 0..<Int(header.height) {
            for x in 0..<Int(header.width) {
                
                guard let plot = self.plots[x, y] else {
                    fatalError("Can't get plot")
                }
                
                let point = HexPoint(x: x, y: y)
                
                let tile = Tile(at: point, with: plot.terrain)
                
                if let feature1st = plot.feature1stType {
                    tile.set(feature: feature1st)
                }
                
                if let feature2nd = plot.feature2ndType {
                    tile.set(feature: feature2nd)
                }
                
                map.set(tile: tile, at: point)
            }
        }
        
        return map
    }
}

class Civ5MapReader {

    init() {
    }

    func load(from url: URL?) -> Civ5Map? {
        
        if let civ5MapUrl = url {
            
            do {
                let binaryData = try Data(contentsOf: civ5MapUrl, options: .mappedIfSafe)
                
                return self.load(from: binaryData)
            } catch {
                print("Error reading \(error)")
            }
        }
        
        return nil
    }
    
    private func load(from data: Data) -> Civ5Map? {

        let binaryData = BinaryData(data: data, bigEndian: false)
        let reader = BinaryDataReader(binaryData)

        do {
            let header = try Civ5MapHeader(reader: reader)
            //print("success: type=\(header.type)")
            
            let plots: Array2D<Civ5MapPlot> = Array2D<Civ5MapPlot>(columns: Int(header.width), rows: Int(header.height))
            
            for y in 0..<Int(header.height) {
                for x in 0..<Int(header.width) {
                    
                    let ry = Int(header.height) - y - 1
                    
                    let plot = try Civ5MapPlot(reader: reader, header: header)
                    plots[x, ry] = plot
                }
            }
            
            return Civ5Map(header: header, plots: plots)
            
        } catch {
            print("error while reading Civ5Map: \(error)")
        }
        
        return nil
    }
}
