//
//  HexArea.swift
//  Colony
//
//  Created by Michael Rommel on 03.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class BoundingBox: Codable {
    
    var minX, maxX: Int
    var minY, maxY: Int
    
    var width: Int {
        return self.maxX - self.minX
    }
    
    var height: Int {
        return self.maxY - self.minY
    }
    
    init(points: [HexPoint]) {
        
        self.minX = points[0].x
        self.maxX = points[0].x
        self.minY = points[0].y
        self.maxY = points[0].y
        
        for i in 1..<points.count {
            self.minX = min(self.minX, points[i].x)
            self.maxX = max(self.maxX, points[i].x)
            self.minY = min(self.minY, points[i].y)
            self.maxY = max(self.maxY, points[i].y)
        }
    }
}

class HexArea: Codable {
    
    var points: [HexPoint]
    private var value: Int = 0
    private(set) var boundingBox: BoundingBox
    
    var size: Int {
        return self.points.count
    }
    
    var width: Int {
        return self.boundingBox.width
    }
    
    var height: Int {
        return self.boundingBox.height
    }
    
    // MARK: constructors
    
    init(center: HexPoint, radius: Int) {
        
        var tmp = Set([center])
        
        for _ in 0..<radius {
            
            var newTmp = Set<HexPoint>()
            for elem in tmp {
                newTmp = newTmp.union(elem.neighbors())
            }
            tmp = tmp.union(newTmp)
        }
        
        let tmpPoints = Array(tmp)
        self.points = tmpPoints
        self.boundingBox = BoundingBox(points: tmpPoints)
    }
    
    init(points: [HexPoint]) {
        self.points = points
        self.boundingBox = BoundingBox(points: points)
    }
    
    // MARK: methods
    
    func add(point: HexPoint) {
        self.points.append(point)
    }
    
    func contains(where predicate: (HexPoint) throws -> Bool) rethrows -> Bool {
        
        return try self.points.contains(where: predicate)
    }
    
    func set(value: Int) {
        self.value = value
    }
    
    func getValue() -> Int {
        return self.value
    }
    
    /// puts all points left of dx in first area and all points right of dx in second area
    func divideHorizontally(at dx: Int) -> (HexArea, HexArea) {
        
        var pointsFirst: [HexPoint] = []
        var pointsSecond: [HexPoint] = []
        
        for point in self.points {
            if point.x < dx {
                pointsFirst.append(point)
            } else {
                pointsSecond.append(point)
            }
        }
        
        return (HexArea(points: pointsFirst), HexArea(points: pointsSecond))
    }
    
    /// puts all points above of dy in first area and all points below of dy in second area
    func divideVertically(at dy: Int) -> (HexArea, HexArea) {
        
        var pointsFirst: [HexPoint] = []
        var pointsSecond: [HexPoint] = []
        
        for point in self.points {
            if point.y < dy {
                pointsFirst.append(point)
            } else {
                pointsSecond.append(point)
            }
        }
        
        return (HexArea(points: pointsFirst), HexArea(points: pointsSecond))
    }
}

extension HexArea: Sequence {
    
    func makeIterator() -> HexAreaIterator {
        return HexAreaIterator(area: self)
    }
}

struct HexAreaIterator: IteratorProtocol {
    
    private let area: HexArea
    private var index = 0
    
    init(area: HexArea) {
        self.area = area
    }
    
    mutating func next() -> HexPoint? {
        
        guard 0 <= index else {
            return nil
        }
        
        // prevent out of bounds
        guard index < self.area.points.count else {
            return nil
        }
        
        let model = area.points[index]
        index += 1
        return model
    }
}
