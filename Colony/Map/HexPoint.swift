//
//  HexPoint.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class HexPoint {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

class HexCube {
    
    let q: Int
    let r: Int
    let s: Int
    
    init(q: Int, r: Int, s: Int) {
        self.q = q
        self.r = r
        self.s = s
    }
    
    init(q: Int, s: Int) {
        self.q = q
        self.s = s
        self.r = -q - s
    }
    
    convenience init(hex: HexPoint) {
        self.init(q: hex.x - (hex.y + (hex.y&1)) / 2, s: hex.y)
    }
    
    func distance(to cube: HexCube) -> Int {
        return max(abs(self.q - cube.q), abs(self.r - cube.r), abs(self.s - cube.s))
    }
}

func + (left: HexCube, right: HexCube) -> HexCube {
    return HexCube(q: left.q + right.q, r: left.r + right.r, s: left.s + right.s)
}

extension HexDirection {
    
    var cubeDirection: HexCube {
        switch self {
        case .north:
            return HexCube(q: 0, r: 1, s: -1)
        case .northeast:
            return HexCube(q: 1, r: 0, s: -1)
        case .southeast:
            return HexCube(q: 1, r: -1, s: 0)
        case .south:
            return HexCube(q: 0, r: -1, s: 1)
        case .southwest:
            return HexCube(q: -1, r: 0, s: 1)
        case .northwest:
            return HexCube(q: -1, r: 1, s: 0)
        }
    }
    
    var axialDirectionEven: HexPoint {
        switch self {
        case .north:
            return HexPoint(x: 0, y: -1)
        case .northeast:
            return HexPoint(x: 1, y: 0)
        case .southeast:
            return HexPoint(x: 1, y: 1)
        case .south:
            return HexPoint(x: 0, y: 1)
        case .southwest:
            return HexPoint(x: -1, y: 1)
        case .northwest:
            return HexPoint(x: -1, y: 0)
        }
    }
    
    var axialDirectionOdd: HexPoint {
        switch self {
        case .north:
            return HexPoint(x: 0, y: -1)
        case .northeast:
            return HexPoint(x: 1, y: -1)
        case .southeast:
            return HexPoint(x: 1, y: 0)
        case .south:
            return HexPoint(x: 0, y: 1)
        case .southwest:
            return HexPoint(x: -1, y: 0)
        case .northwest:
            return HexPoint(x: -1, y: -1)
        }
    }
}

func + (left: HexPoint, right: HexPoint) -> HexPoint {
    return HexPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: HexPoint, right: HexPoint) -> HexPoint {
    return HexPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: HexPoint, scalar: HexPoint) -> HexPoint {
    return HexPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: HexPoint, scalar: HexPoint) -> HexPoint {
    return HexPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

func lerp(minimum: Double, maximum: Double, weight: Double) -> Double {
    return minimum * (1.0 - weight) + maximum * weight
}

func lerp(minimum: Int, maximum: Int, weight: Double) -> Double {
    return Double(minimum) * (1.0 - weight) + Double(maximum) * weight
}

extension HexPoint {
    
    convenience init(cube: HexCube) {
        self.init(x: cube.q + (cube.s + (cube.s&1)) / 2, y: cube.s)
    }
    
    /*func neighbor(in direction: HexDirection) -> HexPoint {
     let parity = self.x & 1
     return self + (parity == 1 ? direction.axialDirectionOdd : direction.axialDirectionEven)
     }*/
    func neighbor(in direction: HexDirection) -> HexPoint {
        let cubeNeighbor = HexCube(hex: self) + direction.cubeDirection
        return HexPoint(cube: cubeNeighbor)
    }
    
    func neighbors() -> [HexPoint] {
        
        var neighboring = [HexPoint]()
        
        neighboring.append(self.neighbor(in: .north))
        neighboring.append(self.neighbor(in: .northeast))
        neighboring.append(self.neighbor(in: .southeast))
        neighboring.append(self.neighbor(in: .south))
        neighboring.append(self.neighbor(in: .southwest))
        neighboring.append(self.neighbor(in: .northwest))
        
        return neighboring
    }
    
    func distance(to hex: HexPoint) -> Int {
        let selfCube = HexCube(hex: self)
        let hexCube = HexCube(hex: hex)
        return selfCube.distance(to: hexCube)
    }
    
    // returns the direction of the neighbor (or nil when this is not a neighbor)
    func direction(towards hex: HexPoint) -> HexDirection? {
        
        for direction in HexDirection.all {
            if self.neighbor(in: direction) == hex {
                return direction
            }
        }
        
        return nil
    }
    
    func adjacentPoints(of corner: HexPointCorner) -> [HexPoint] {
        
        var neighboring = [HexPoint]()
        
        neighboring.append(self)
        
        switch corner {
        case .northeast:
            neighboring.append(self.neighbor(in: .north))
            neighboring.append(self.neighbor(in: .northeast))
        case .east:
            neighboring.append(self.neighbor(in: .northeast))
            neighboring.append(self.neighbor(in: .southeast))
        case .southeast:
            neighboring.append(self.neighbor(in: .southeast))
            neighboring.append(self.neighbor(in: .south))
        case .southwest:
            neighboring.append(self.neighbor(in: .south))
            neighboring.append(self.neighbor(in: .southwest))
        case .west:
            neighboring.append(self.neighbor(in: .southwest))
            neighboring.append(self.neighbor(in: .northwest))
        case .northwest:
            neighboring.append(self.neighbor(in: .northwest))
            neighboring.append(self.neighbor(in: .north))
        }
        
        return neighboring
    }
}

extension HexPoint: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
func == (first: HexPoint, second: HexPoint) -> Bool {
    return first.x == second.x && first.y == second.y
}

extension HexPoint: CustomStringConvertible {
    
    public var description: String {
        return "HexPoint(\(self.x), \(self.y))"
        
    }
}

extension HexCube {
    
    ///
    /// double value constructor
    /// values are rounded
    ///
    convenience init(qDouble: Double, rDouble: Double, sDouble: Double) {
        
        var qRounded: Int = lround(qDouble)
        var rRounded: Int = lround(rDouble)
        var sRounded: Int = lround(sDouble)
        
        let qDiff = abs(Double(qRounded) - qDouble)
        let rDiff = abs(Double(rRounded) - rDouble)
        let sDiff = abs(Double(sRounded) - sDouble)
        
        if qDiff > rDiff && qDiff > sDiff {
            qRounded = -rRounded - sRounded
        } else if rDiff > sDiff {
            rRounded = -qRounded - sRounded
        } else {
            sRounded = -qRounded - rRounded
        }
        
        self.init(q: qRounded, r: rRounded, s: sRounded)
    }
    
    func line(to target: HexCube) -> [HexCube] {
        let length = self.distance(to: target)
        var result: [HexCube] = []
        
        for index in 0..<(length + 1) {
            let weigth = (1.0 / Double(length)) * Double(index)
            let cube = HexCube(qDouble: lerp(minimum: Double(self.q) + 1e-6, maximum: Double(target.q) + 1e-6, weight: weigth),
                               rDouble: lerp(minimum: Double(self.r) + 1e-6, maximum: Double(target.r) + 1e-6, weight: weigth),
                               sDouble: lerp(minimum: Double(self.s) + 1e-6, maximum: Double(target.s) + 1e-6, weight: weigth))
            result.append(cube)
        }
        
        return result
    }
}

extension HexCube: CustomStringConvertible {
    
    public var description: String {
        return "HexCube(\(self.q), \(self.r), \(self.s))"
    }
}
