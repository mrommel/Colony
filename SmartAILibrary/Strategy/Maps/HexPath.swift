//
//  HexPath.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class HexPath: Decodable {

    fileprivate var pointsValue: [HexPoint]
    fileprivate var costs: [Double]

    enum CodingKeys: String, CodingKey {
        case points
        case costs
    }

    // MARK: constructors

    public init() {
        self.pointsValue = []
        self.costs = []
    }

    public init(point: HexPoint, cost: Double, path: HexPath) {
        self.pointsValue = [point] + path.pointsValue
        self.costs = [cost] + path.costs
    }

    public init(points: [HexPoint], costs: [Double]) {

        self.pointsValue = points
        self.costs = costs
    }

    required public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.pointsValue = try values.decode([HexPoint].self, forKey: .points)
        self.costs = try values.decode([Double].self, forKey: .costs)
    }

    // MARK: properties

    public var count: Int {
        return self.pointsValue.count
    }

    var cost: Double {

        return self.costs.reduce(0.0, +)
    }

    public var isEmpty: Bool {
        return self.pointsValue.isEmpty
    }

    public var first: (HexPoint, Double)? {

        if let firstPoint = self.pointsValue.first, let firstCost = self.costs.first {
            return (firstPoint, firstCost)
        }

        return nil
    }

    public var second: (HexPoint, Double)? {

        if self.count < 2 {
            return nil
        }

        return (self.pointsValue[1], self.costs[1])
    }

    public var last: (HexPoint, Double)? {

        if let lastPoint = self.pointsValue.last, let lastCost = self.costs.last {
            return (lastPoint, lastCost)
        }

        return nil
    }

    public func firstSegment(for moves: Int) -> HexPath {

        let result: HexPath = HexPath()
        var index = 0

        repeat {
            result.append(point: self.pointsValue[index], cost: self.costs[index])
            index += 1
        } while result.cost <= Double(moves) && index < self.count

        return result
    }

    // MARK: methods

    public func append(point: HexPoint, cost: Double) {

        self.pointsValue.append(point)
        self.costs.append(cost)
    }

    public func prepend(point: HexPoint, cost: Double) {

        self.pointsValue.prepend(point)
        self.costs.prepend(cost)
    }

    public func pathWithoutFirst() -> HexPath {

        let newPoints = Array(self.pointsValue.suffix(from: 1))
        let newCosts = Array(self.costs.suffix(from: 1))

        return HexPath(points: newPoints, costs: newCosts)
    }

    public func pathWithoutLast() -> HexPath {

        let newPoints = Array(self.pointsValue.prefix(upTo: self.count - 1))
        let newCosts = Array(self.costs.prefix(upTo: self.count - 1))

        return HexPath(points: newPoints, costs: newCosts)
    }

    public func path(without items: Int) -> HexPath? {

        if self.count <= items {
            return nil
        }

        let newPoints = Array(self.pointsValue.prefix(upTo: self.count - items))
        let newCosts = Array(self.costs.prefix(upTo: self.count - items))

        return HexPath(points: newPoints, costs: newCosts)
    }

    public func points() -> [HexPoint] {

        return self.pointsValue
    }

    public func reversed() -> HexPath {

        return HexPath(points: self.pointsValue.reversed(), costs: self.costs.reversed())
    }

    func endTurnPlot(for unit: AbstractUnit?) -> HexPoint? {

        guard let unit = unit else {
            fatalError("cant get gameModel")
        }

        assert(unit.location == self.pointsValue[0])

        var moves: Double = Double(unit.movesLeft())
        var index = 0

        while moves > 0 {

            moves -= self.costs[index]
            index += 1
        }

        return self.pointsValue[index]
    }

    public subscript(index: Int) -> (HexPoint, Double) {

        precondition(index < self.pointsValue.count, "Index \(index) is out of range")
        return (self.pointsValue[index], self.costs[index])
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
        try container.encode(self.costs, forKey: .costs)
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
