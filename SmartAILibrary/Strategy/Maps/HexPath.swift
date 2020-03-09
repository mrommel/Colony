//
//  HexPath.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import Foundation

class HexPath: Decodable {
    
    fileprivate var points: [HexPoint]
    fileprivate var costs: [Double]
    
    enum CodingKeys: String, CodingKey {
        case points
        case costs
    }
    
    // MARK: constructors
    
    init() {
        self.points = []
        self.costs = []
    }
    
    init(point: HexPoint, cost: Double, path: HexPath) {
        self.points = [point] + path.points
        self.costs = [cost] + path.costs
    }
    
    init(points: [HexPoint], costs: [Double]) {
        
        self.points = points
        self.costs = costs
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.points = try values.decode([HexPoint].self, forKey: .points)
        self.costs = try values.decode([Double].self, forKey: .costs)
    }
    
    // MARK: properties
    
    var count: Int {
        return self.points.count
    }
    
    var isEmpty: Bool {
        return self.points.isEmpty
    }
    
    var first: (HexPoint, Double)? {
        
        if let firstPoint = self.points.first, let firstCost = self.costs.first {
            return (firstPoint, firstCost)
        }
        
        return nil
    }
    
    // MARK: methods
    
    func prepend(point: HexPoint, cost: Double) {
        self.points.prepend(point)
        self.costs.prepend(cost)
    }
    
    func pathWithoutFirst() -> HexPath {
        let newPoints = Array(self.points.suffix(from: 1))
        let newCosts = Array(self.costs.suffix(from: 1))
        
        return HexPath(points: newPoints, costs: newCosts)
    }
    
    public subscript(index: Int) -> (HexPoint, Double) {
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
