//
//  Ocean.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum OceanConstants {
    
    static let kNotAnalyzed: Int = 254
    static let kNoOcean: Int = 255
}

class Ocean {
    
    var identifier: Int
    var name: String
    var points: [HexPoint]
    var map: MapModel?
    
    init() {
        
        self.identifier = OceanConstants.kNotAnalyzed
        self.name = "NoName"
        self.points = []
        self.map = nil
    }
    
    init(identifier: Int, name: String, on map: MapModel?) {
        
        self.identifier = identifier
        self.name = name
        self.points = []
        self.map = map
    }
    
    func add(point: HexPoint) {
        self.points.append(point)
    }
    
    func isAdjacent(to position: HexPoint) -> Bool {
        
        for point in self.points {
            if point.neighbors().contains(position) {
                return true
            }
        }
        
        return false
    }
}

extension Ocean: Equatable {
    
    static func == (lhs: Ocean, rhs: Ocean) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
