//
//  HexPath.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct HexPath: Decodable {

    fileprivate var pointsValue: [HexPoint]
    fileprivate var costsValue: [Double]

    enum CodingKeys: String, CodingKey {
        case points
        case costs
    }

    // MARK: constructors

    public init() {

        self.pointsValue = []
        self.costsValue = []
    }

    public init(point: HexPoint, cost: Double, path: HexPath) {

        self.pointsValue = [point] + path.pointsValue
        self.costsValue = [cost] + path.costsValue
    }

    public init(points: [HexPoint], costs: [Double]) {

        self.pointsValue = points
        self.costsValue = costs
    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.pointsValue = try values.decode([HexPoint].self, forKey: .points)
        self.costsValue = try values.decode([Double].self, forKey: .costs)
    }

    // MARK: properties

    public var count: Int {
        return self.pointsValue.count
    }

    public var cost: Double {

        return self.costsValue.reduce(0.0, +)
    }

    public var costs: [Double] {

        return self.costsValue
    }

    public var isEmpty: Bool {

        return self.pointsValue.isEmpty
    }

    public func startsWith(point: HexPoint) -> Bool {

        guard let firstPoint = self.pointsValue.first else {
            return false
        }

        return firstPoint == point
    }

    public var first: (HexPoint, Double)? {

        if let firstPoint = self.pointsValue.first, let firstCost = self.costsValue.first {
            return (firstPoint, firstCost)
        }

        return nil
    }

    public var second: (HexPoint, Double)? {

        if self.count < 2 {
            return nil
        }

        return (self.pointsValue[1], self.costsValue[1])
    }

    public var last: (HexPoint, Double)? {

        if let lastPoint = self.pointsValue.last, let lastCost = self.costsValue.last {
            return (lastPoint, lastCost)
        }

        return nil
    }

    public func firstSegment(for moves: Int) -> HexPath {

        var result: HexPath = HexPath()
        var index = 0

        repeat {
            result.append(point: self.pointsValue[index], cost: self.costsValue[index])
            index += 1
        } while result.cost <= Double(moves) && index < self.count

        return result
    }

    public func contains(point: HexPoint) -> Bool {

        return self.pointsValue.contains(point)
    }

    public mutating func cropPoints(until point: HexPoint) {

        guard self.pointsValue.contains(point) else {
            return
        }

        var cropIndex: Int = 0

        for (index, pt) in self.pointsValue.enumerated() where pt == point {
            cropIndex = index
        }

        var index = 0
        repeat {
            let newPoints = Array(self.pointsValue.suffix(from: 1))
            let newCosts = Array(self.costsValue.suffix(from: 1))
            self.pointsValue = newPoints
            self.costsValue = newCosts
            index += 1
        } while index < cropIndex
    }

    // MARK: methods

    public mutating func append(point: HexPoint, cost: Double) {

        self.pointsValue.append(point)
        self.costsValue.append(cost)
    }

    public mutating func prepend(point: HexPoint, cost: Double) {

        self.pointsValue.prepend(point)
        self.costsValue.prepend(cost)
    }

    public func pathWithoutFirst() -> HexPath {

        let newPoints = Array(self.pointsValue.suffix(from: 1))
        let newCosts = Array(self.costsValue.suffix(from: 1))

        return HexPath(points: newPoints, costs: newCosts)
    }

    public func pathWithoutLast() -> HexPath {

        let newPoints = Array(self.pointsValue.prefix(upTo: self.count - 1))
        let newCosts = Array(self.costsValue.prefix(upTo: self.count - 1))

        return HexPath(points: newPoints, costs: newCosts)
    }

    public func path(without items: Int) -> HexPath? {

        if self.count <= items {
            return nil
        }

        let newPoints = Array(self.pointsValue.prefix(upTo: self.count - items))
        let newCosts = Array(self.costsValue.prefix(upTo: self.count - items))

        return HexPath(points: newPoints, costs: newCosts)
    }

    public func points() -> [HexPoint] {

        return self.pointsValue
    }

    public func reversed() -> HexPath {

        return HexPath(points: self.pointsValue.reversed(), costs: self.costsValue.reversed())
    }

    func endTurnPlot(for unit: AbstractUnit?) -> HexPoint? {

        guard let unit = unit else {
            fatalError("cant get gameModel")
        }

        assert(unit.location == self.pointsValue[0])

        var moves: Double = Double(unit.movesLeft())
        var index = 0

        while moves > 0 {

            moves -= self.costsValue[index]
            index += 1
        }

        return self.pointsValue[index]
    }

    public subscript(index: Int) -> (HexPoint, Double) {

        precondition(index < self.pointsValue.count, "Index \(index) is out of range")
        return (self.pointsValue[index], self.costsValue[index])
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
        guard index < self.path.pointsValue.count else {
            return nil
        }

        let point = self.path.pointsValue[index]
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

        try container.encode(self.pointsValue, forKey: .points)
        try container.encode(self.costsValue, forKey: .costs)
    }
}

extension HexPath: CustomDebugStringConvertible {

    public var debugDescription: String {

        let str = self.points().map { "(\($0.x), \($0.y)), " }.reduce("", +)
        return "HexPath: [\(str)]"
    }
}

extension HexPath: CustomStringConvertible {

    public var description: String {

        let str = self.points().map { "(\($0.x), \($0.y)), " }.reduce("", +)
        return "HexPath: [\(str)]"
    }
}
