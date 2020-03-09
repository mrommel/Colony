//
//  TileArray2D.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TileArray2D {
    
    public let columns: Int
    public let rows: Int
    fileprivate var array: [AbstractTile?] = [AbstractTile?]()

    init(size: MapSize) {
        
        self.columns = size.width()
        self.rows = size.height()
        
        self.array = [AbstractTile?](repeating: nil, count: self.rows * self.columns)
    }
    
    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        self.array = [AbstractTile?](repeating: nil, count: rows * columns)
    }

    public subscript(column: Int, row: Int) -> AbstractTile? {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row * columns + column]
        }
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row * columns + column] = newValue
        }
    }
}

extension TileArray2D {

    /*var minimum: AbstractTile {
        var minimumValue: AbstractTile = self[0, 0]!

        for x in 0..<self.columns {
            for y in 0..<self.rows {
                if minimumValue > self[x, y]! {
                    minimumValue = self[x, y]!
                }
            }
        }

        return minimumValue
    }

    var maximum: AbstractTile {
        var maximumValue: AbstractTile = self[0, 0]!

        for x in 0..<self.columns {
            for y in 0..<self.rows {
                if maximumValue < self[x, y]! {
                    maximumValue = self[x, y]!
                }
            }
        }

        return maximumValue
    }*/
}

// MARK: fill methods

extension TileArray2D {

    func fill(with value: AbstractTile) {
        for x in 0..<self.columns {
            for y in 0..<self.rows {
                self[x, y] = value
            }
        }
    }

    func fill(with function: (Int, Int) -> AbstractTile) {
        for x in 0..<self.columns {
            for y in 0..<self.rows {
                self[x, y] = function(x, y)
            }
        }
    }

    func filter(where condition: @escaping (AbstractTile?) -> Bool) -> [AbstractTile?] {
        return self.array.filter(condition)
    }

    func count(where condition: @escaping (AbstractTile?) -> Bool) -> Int {
        return self.array.count(where: condition)
    }
}

// MARK: grid methods

extension TileArray2D {

    subscript(gridPoint: HexPoint) -> AbstractTile? {
        
        get {
            return array[(gridPoint.y * columns) + gridPoint.x]
        }
        
        set(newValue) {
            array[(gridPoint.y * columns) + gridPoint.x] = newValue
        }
    }
}
