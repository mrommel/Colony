//
//  MapModelHelper.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

@testable import SmartAILibrary

class MapModelHelper {
    
    static func mapFilled(with terrain: TerrainType, sized size: MapSize) -> MapModel {
        
        let mapModel = MapModel(size: size)
        
        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {
            
            for y in 0..<mapSize.height() {
                
                mapModel.set(terrain: terrain, at: HexPoint(x: x, y: y))
            }
        }
        
        return mapModel
    }
    
    static func add(area: HexArea, with terrain: TerrainType, to mapModel: MapModel?) {
        
        for point in area {
            if mapModel?.valid(point: point) ?? false {
                mapModel?.set(terrain: terrain, at: point)
            }
        }
    }
    
    static func discover(mapModel: inout MapModel, by player: AbstractPlayer?) {
        
        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {
            
            for y in 0..<mapSize.height() {
                
                let tile = mapModel.tile(at: HexPoint(x: x, y: y))
                tile?.discover(by: player)
            }
        }
    }
}
