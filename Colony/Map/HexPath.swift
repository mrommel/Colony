//
//  HexPath.swift
//  Colony
//
//  Created by Michael Rommel on 09.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class HexPath: Decodable {
    
    fileprivate var points: [HexPoint]
    
    enum CodingKeys: String, CodingKey {
        case points
    }
    
    // MARK: constructors
    
    init() {
        self.points = []
    }
    
    init(point: HexPoint, path: HexPath) {
        self.points = [point] + path.points
    }
    
    init(points: [HexPoint]) {
        self.points = points
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.points = try values.decode([HexPoint].self, forKey: .points)
    }
    
    // MARK: properties
    
    var count: Int {
        return self.points.count
    }
    
    var isEmpty: Bool {
        return self.points.isEmpty
    }
    
    var first: HexPoint? {
        return self.points.first
    }
    
    // MARK: methods
    
    func prepend(point: HexPoint) {
        self.points.prepend(point)
    }
    
    func pathWithoutFirst() -> HexPath {
        let newPoints = Array(self.points.suffix(from: 1))
        
        return HexPath(points: newPoints)
    }
    
    public subscript(index: Int) -> HexPoint {
        get {
            precondition(index < self.points.count, "Index \(index) is out of range")
            
            return self.points[index]
        }
    }
}

extension HexPath: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.points, forKey: .points)
    }
}
