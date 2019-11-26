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
    fileprivate var costs: [Float]
    
    enum CodingKeys: String, CodingKey {
        case points
        case costs
    }
    
    // MARK: constructors
    
    init() {
        self.points = []
        self.costs = []
    }
    
    init(point: HexPoint, cost: Float, path: HexPath) {
        self.points = [point] + path.points
        self.costs = [cost] + path.costs
    }
    
    init(points: [HexPoint], costs: [Float]) {
        
        self.points = points
        self.costs = costs
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.points = try values.decode([HexPoint].self, forKey: .points)
        self.costs = try values.decode([Float].self, forKey: .costs)
    }
    
    // MARK: properties
    
    var count: Int {
        return self.points.count
    }
    
    var isEmpty: Bool {
        return self.points.isEmpty
    }
    
    var first: (HexPoint, Float)? {
        
        if let firstPoint = self.points.first, let firstCost = self.costs.first {
            return (firstPoint, firstCost)
        }
        
        return nil
    }
    
    // MARK: methods
    
    func prepend(point: HexPoint, cost: Float) {
        self.points.prepend(point)
        self.costs.prepend(cost)
    }
    
    func pathWithoutFirst() -> HexPath {
        let newPoints = Array(self.points.suffix(from: 1))
        let newCosts = Array(self.costs.suffix(from: 1))
        
        return HexPath(points: newPoints, costs: newCosts)
    }
    
    public subscript(index: Int) -> (HexPoint, Float) {
        get {
            precondition(index < self.points.count, "Index \(index) is out of range")
            
            return (self.points[index], self.costs[index])
        }
    }
}

extension HexPath: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.points, forKey: .points)
        try container.encode(self.costs, forKey: .costs)
    }
}
