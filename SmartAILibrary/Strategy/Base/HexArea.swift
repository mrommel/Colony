//
//  HexArea.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
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
        
        if points.count > 0 {
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
        } else {
            self.minX = -1
            self.minY = -1
            self.maxX = -1
            self.maxY = -1
        }
    }
}

public class HexArea: Codable {
    
    let identifier: String
    var points: [HexPoint]
    private var value: Double = 0.0
    private(set) var boundingBox: BoundingBox
    
    private var improvements: ImprovementCountList
    
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
        
        self.identifier = UUID().uuidString
        
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
        
        // it is assumed, that there are no improvements
        self.improvements = ImprovementCountList()
        self.improvements.fill()
    }
    
    init(points: [HexPoint]) {
        
        self.identifier = UUID().uuidString
        self.points = points
        self.boundingBox = BoundingBox(points: points)
        
        // it is assumed, that there are no improvements
        self.improvements = ImprovementCountList()
        self.improvements.fill()
    }
    
    // MARK: methods
    
    func add(point: HexPoint) {
        self.points.append(point)
    }
    
    func contains(where predicate: (HexPoint) throws -> Bool) rethrows -> Bool {
        
        return try self.points.contains(where: predicate)
    }
    
    func set(value: Double) {
        self.value = value
    }
    
    func getValue() -> Double {
        return self.value
    }
    
    func center() -> HexPoint {
        
        var sx = 0
        var sy = 0
        var num = 0
        
        for point in self.points {
            
            sx += point.x
            sy += point.y
            
            num += 1
        }
        
        if num == 0 {
            return HexPoint.invalid
        }
        
        return HexPoint(x: sx / num, y: sy / num)
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
    
    var first: HexPoint {
        
        return self.points[0]
    }
    
    func updateNumber(of improvement: ImprovementType, by amount: Int) {
        
        self.improvements.add(weight: amount, for: improvement)
    }
    
    func number(of improvement: ImprovementType) -> Int {
        
        return Int(self.improvements.weight(of: improvement))
    }
}

extension HexArea: Equatable {
    
    public static func == (lhs: HexArea, rhs: HexArea) -> Bool {
        
        //return lhs.points.elementsEqual(rhs.points)
        return lhs.identifier == rhs.identifier
    }
}

extension HexArea: Sequence {
    
    public func makeIterator() -> HexAreaIterator {
        return HexAreaIterator(area: self)
    }
}

public struct HexAreaIterator: IteratorProtocol {
    
    private let area: HexArea
    private var index = 0
    
    init(area: HexArea) {
        self.area = area
    }
    
    mutating public func next() -> HexPoint? {
        
        guard 0 <= index else {
            return nil
        }
        
        // prevent out of bounds
        guard index < self.area.points.count else {
            return nil
        }
        
        let point = self.area.points[index]
        index += 1
        return point
    }
}
