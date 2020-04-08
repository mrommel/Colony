//
//  HexPath.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class HexPath: Decodable {
    
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
    
    required public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.points = try values.decode([HexPoint].self, forKey: .points)
        self.costs = try values.decode([Double].self, forKey: .costs)
    }
    
    // MARK: properties
    
    public var count: Int {
        return self.points.count
    }
    
    var cost: Double {
        
        return self.costs.reduce(0.0, +)
    }
    
    public var isEmpty: Bool {
        return self.points.isEmpty
    }
    
    public var first: (HexPoint, Double)? {
        
        if let firstPoint = self.points.first, let firstCost = self.costs.first {
            return (firstPoint, firstCost)
        }
        
        return nil
    }
    
    var second: (HexPoint, Double)? {
        
        if self.count < 2 {
            return nil
        }
        
        return (self.points[1], self.costs[1])
    }
    
    public var last: (HexPoint, Double)? {
        
        if let lastPoint = self.points.last, let lastCost = self.costs.last {
            return (lastPoint, lastCost)
        }
        
        return nil
    }
    
    func firstSegment(for moves: Int) -> HexPath {
        
        let result: HexPath = HexPath()
        var index = 0
        
        repeat {
            result.append(point: self.points[index], cost: self.costs[index])
            index += 1
        } while result.cost <= Double(moves) && index < self.count
        
        return result
    }
    
    // MARK: methods
    
    func append(point: HexPoint, cost: Double) {
        self.points.append(point)
        self.costs.append(cost)
    }
    
    func prepend(point: HexPoint, cost: Double) {
        self.points.prepend(point)
        self.costs.prepend(cost)
    }
    
    public func pathWithoutFirst() -> HexPath {
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

public struct HexPathIterator: IteratorProtocol {
    
    private let path: HexPath
    private var index = 0
    
    init(path: HexPath) {
        self.path = path
    }
    
    mutating public func next() -> HexPoint? {
        
        guard 0 <= index else {
            return nil
        }
        
        // prevent out of bounds
        guard index < self.path.points.count else {
            return nil
        }
        
        let point = self.path.points[index]
        index += 1
        return point
    }
}

extension HexPath: Sequence {
    
    public func makeIterator() -> HexPathIterator {
        return HexPathIterator(path: self)
    }
}

extension HexPath: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.points, forKey: .points)
        try container.encode(self.costs, forKey: .costs)
    }
}
