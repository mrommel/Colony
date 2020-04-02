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

public class Ocean: Codable {
    
    enum CodingKeys: CodingKey {
        
        case identifier
        case name
        case points
    }
    
    var identifier: Int
    var name: String
    var points: [HexPoint]
    var map: MapModel? // reference
    
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
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier =  try container.decode(Int.self, forKey: .identifier)
        self.name =  try container.decode(String.self, forKey: .name)
        self.points =  try container.decode([HexPoint].self, forKey: .points)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.points, forKey: .points)
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
    
    public static func == (lhs: Ocean, rhs: Ocean) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
