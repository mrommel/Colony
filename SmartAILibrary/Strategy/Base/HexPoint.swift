//
//  HexPoint.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import CoreGraphics

class HexOrientation {

    let f0, f1, f2, f3: Double
    let b0, b1, b2, b3: Double
    let startAngle: Double // in multiples of 60°

    init(f0: Double, f1: Double, f2: Double, f3: Double, b0: Double, b1: Double, b2: Double, b3: Double, startAngle: Double) {

        self.f0 = f0
        self.f1 = f1
        self.f2 = f2
        self.f3 = f3
        self.b0 = b0
        self.b1 = b1
        self.b2 = b2
        self.b3 = b3
        self.startAngle = startAngle
    }

    // static pointy = HexOrientation(Math.sqrt(3.0), Math.sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, Math.sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
    static let flat = HexOrientation(f0: 3.0 / 2.0, f1: 0, f2: sqrt(3.0) / 2.0, f3: sqrt(3.0), b0: 2.0 / 3.0, b1: 0.0, b2: -1.0 / 3.0, b3: sqrt(3.0) / 3.0, startAngle: 0.0)
}

struct HexLayout {

    let orientation: HexOrientation
    let size: CGSize
    let origin: CGPoint

    // grid type: even-q
    
    // odd-q
}

public enum HexDirection: Int {

    case north
    case northeast
    case southeast
    case south
    case southwest
    case northwest

    public static var all: [HexDirection] {
        
        return [.north, .northeast, .southeast, .south, .southwest, .northwest]
    }

    public func short() -> String {
        
        switch self {
        case .north:
            return "n"
        case .northeast:
            return "ne"
        case .southeast:
            return "se"
        case .south:
            return "s"
        case .southwest:
            return "sw"
        case .northwest:
            return "nw"
        }
    }

    var description: String {
        
        switch self {
        case .north:
            return "North"
        case .northeast:
            return "North East"
        case .southeast:
            return "South East"
        case .south:
            return "South"
        case .southwest:
            return "South West"
        case .northwest:
            return "North West"
        }
    }

    var pickerImage: String {
        
        switch self {
        case .north:
            return "hex_neighbors_n"
        case .northeast:
            return "hex_neighbors_ne"
        case .southeast:
            return "hex_neighbors_se"
        case .south:
            return "hex_neighbors_s"
        case .southwest:
            return "hex_neighbors_sw"
        case .northwest:
            return "hex_neighbors_nw"
        }
    }
    
    var opposite: HexDirection {
        
        switch self {
        case .north:
            return .south
        case .northeast:
            return .southwest
        case .southeast:
            return .northwest
        case .south:
            return .north
        case .southwest:
            return .northeast
        case .northwest:
            return .southeast
        }
    }
}

import Foundation

public class HexPoint: Codable {
    
    static let zero = HexPoint(x: 0, y: 0)
    
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init(from json: String?) {
        
        let jsonDecoder = JSONDecoder()
        do {
            guard let jsonData = json?.data(using: .utf8) else {
                fatalError()
            }
            
            let tmpPoint = try jsonDecoder.decode(HexPoint.self, from: jsonData)
            self.x = tmpPoint.x
            self.y = tmpPoint.y
        }
        catch {
            fatalError()
        }
    }
    
    var jsonString: String? {
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        catch {
            fatalError()
        }
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
        self.init(q: hex.x - (hex.y + (hex.y&1)) / 2, s: hex.y) // even-q
        //self.init(q: hex.x - (hex.y - (hex.y&1)) / 2, s: hex.y) // odd-q
    }
    
    convenience init(screen: CGPoint) {

        let layout = HexLayout(orientation: HexOrientation.flat, size: CGSize(width: 24, height: 18), origin: CGPoint.zero)
        let orientationMatrix = layout.orientation
        let point = CGPoint(x: (Double(screen.x) - Double(layout.origin.x)) / Double(layout.size.width),
            y: (Double(screen.y) - Double(layout.origin.y)) / Double(layout.size.height))
        let q = orientationMatrix.b0 * Double(point.x) + orientationMatrix.b1 * Double(point.y)
        let r = orientationMatrix.b2 * Double(point.x) + orientationMatrix.b3 * Double(point.y)
        
        self.init(qDouble: q, rDouble: r, sDouble: -q - r)
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
        self.init(x: cube.q + (cube.s + (cube.s&1)) / 2, y: cube.s) // even-q

        //self.init(x: cube.q + (cube.s - (cube.s&1)) / 2, y: cube.s) // odd-q
    }
    
    public convenience init(screen: CGPoint) {
    
        var screenPoint = screen
        
        // FIXME: hm, not sure why this is needed
        screenPoint.x -= 20
        screenPoint.y -= 15
        
        self.init(cube: HexCube(screen: screenPoint))
    }
    
    /*func neighbor(in direction: HexDirection) -> HexPoint {
        let parity = self.x & 1
        return self + (parity == 0 ? direction.axialDirectionOdd : direction.axialDirectionEven)
    }*/
    
    func isNeighbor(of point: HexPoint) -> Bool {
        
        return self.distance(to: point) == 1
    }
    
    public func neighbor(in direction: HexDirection) -> HexPoint {
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
    
    func areaWith(radius: Int) -> HexArea {
        return HexArea(center: self, radius: radius)
    }
    
    // based on: https://www.redblobgames.com/grids/hexagons/#rings
    func ringWith(radius: Int) -> HexArea {
        
        var points: [HexPoint] = []
        var cursor: HexPoint = HexPoint(x: self.x, y: self.y)
        
        // find start location
        for _ in 0..<radius {
            cursor = cursor.neighbor(in: .southwest)
        }
        
        // loop through all directions clockwise starting with north
        for dir in HexDirection.all {
            for _ in 0..<radius {
                points.append(cursor)
                cursor = cursor.neighbor(in: dir)
            }
        }
        
        return HexArea(points: points)
    }
    
    func distance(to hex: HexPoint) -> Int {
        let selfCube = HexCube(hex: self)
        let hexCube = HexCube(hex: hex)
        return selfCube.distance(to: hexCube)
    }
    
    // returns the direction of the neighbor (or nil when this is not a neighbor)
    public func direction(towards hex: HexPoint) -> HexDirection? {
        
        for direction in HexDirection.all {
            if self.neighbor(in: direction) == hex {
                return direction
            }
        }
        
        let angle = HexPoint.screenAngle(from: self, towards: hex)
        return HexPoint.degreesToDirection(degrees: angle)
    }

    static func degreesToDirection(degrees: Int) -> HexDirection {

        var degrees = degrees
        if (degrees < 0) {
            degrees += 360
        }

        if 30 < degrees && degrees <= 90 {
            return .northeast
        } else if 90 < degrees && degrees <= 150 {
            return .southeast
        } else if 150 < degrees && degrees <= 210 {
            return .south
        } else if 210 < degrees && degrees <= 270 {
            return .southwest
        } else if 270 < degrees && degrees <= 330 {
            return .northwest
        } else {
            return .north
        }
    }
    
    static func toScreen(cube: HexCube) -> CGPoint {

        let layout = HexLayout(orientation: HexOrientation.flat, size: CGSize(width: 24, height: 18), origin: CGPoint.zero)
        let orientationMatrix = layout.orientation
        let x = (orientationMatrix.f0 * Double(cube.q) + orientationMatrix.f1 * Double(cube.r)) * Double(layout.size.width)
        let y = (orientationMatrix.f2 * Double(cube.q) + orientationMatrix.f3 * Double(cube.r)) * Double(layout.size.height)
        return CGPoint(x: x + Double(layout.origin.x), y: y + Double(layout.origin.y))
    }

    public static func toScreen(hex: HexPoint) -> CGPoint {

        return toScreen(cube: HexCube(hex: hex))
    }
    
    public static func screenAngle(from: HexPoint, towards: HexPoint) -> Int {

        let fromScreenPoint = HexPoint.self.toScreen(hex: from)
        let towardsScreenPoint = HexPoint.self.toScreen(hex: towards)

        let deltax = towardsScreenPoint.x - fromScreenPoint.x
        let deltay = towardsScreenPoint.y - fromScreenPoint.y

        return Int(atan2(deltax, deltay) * (180.0 / CGFloat(Double.pi)))
    }

    func degreesToDirection(degrees: Int) -> HexDirection {

        var degrees = degrees
        if (degrees < 0) {
            degrees += 360
        }

        if 30 < degrees && degrees <= 90 {
            return .northeast
        } else if 90 < degrees && degrees <= 150 {
            return .southeast
        } else if 150 < degrees && degrees <= 210 {
            return .south
        } else if 210 < degrees && degrees <= 270 {
            return .southwest
        } else if 270 < degrees && degrees <= 330 {
            return .northwest
        } else {
            return .north
        }
    }

    public static func screenDirection(from: HexPoint, towards: HexPoint) -> HexDirection {

        let angle = HexPoint.screenAngle(from: from, towards: towards)
        return degreesToDirection(degrees: angle)
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
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
public func == (first: HexPoint, second: HexPoint) -> Bool {
    
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
