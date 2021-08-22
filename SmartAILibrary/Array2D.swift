//
//  Array2D.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

open class Array2D<T: Equatable & Codable>: Codable {

    public let width: Int
    public let height: Int
    fileprivate var array: [T?] = [T?]()

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.array = [T?](repeating: nil, count: self.height * self.width)
    }

    public subscript(x: Int, y: Int) -> T? {
        get {
            precondition(x < self.width, "Column \(x) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            precondition(y < self.height, "Row \(y) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            return array[y * self.width + x]
        }
        set {
            precondition(x < self.width, "Column \(x) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            precondition(y < self.height, "Row \(y) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            array[y * self.width + x] = newValue
        }
    }
}

extension Array2D where T: Comparable {

    var minimum: T {
        var minimumValue: T = self[0, 0]!

        for x in 0..<self.width {
            for y in 0..<self.height {
                if minimumValue > self[x, y]! {
                    minimumValue = self[x, y]!
                }
            }
        }

        return minimumValue
    }

    var maximum: T {
        var maximumValue: T = self[0, 0]!

        for x in 0..<self.width {
            for y in 0..<self.height {
                if maximumValue < self[x, y]! {
                    maximumValue = self[x, y]!
                }
            }
        }

        return maximumValue
    }
}

// MARK: fill methods

extension Array2D {

    func fill(with value: T) {
        for x in 0..<self.width {
            for y in 0..<self.height {
                self[x, y] = value
            }
        }
    }

    func fill(with function: (Int, Int) -> T) {
        for x in 0..<self.width {
            for y in 0..<self.height {
                self[x, y] = function(x, y)
            }
        }
    }

    func filter(where condition: @escaping (T?) -> Bool) -> [T?] {
        return self.array.filter(condition)
    }

    func count(where condition: @escaping (T?) -> Bool) -> Int {
        return self.array.count(where: condition)
    }
}

// MARK: grid methods

extension Array2D {

    subscript(gridPoint: HexPoint) -> T? {

        get {
            return array[(gridPoint.y * self.width) + gridPoint.x]
        }

        set(newValue) {
            array[(gridPoint.y * self.width) + gridPoint.x] = newValue
        }
    }
}
