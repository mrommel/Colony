//
//  TileArray2D.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TileArray2D: Codable {

    enum CodingKeys: CodingKey {

        case width
        case height
        case array
    }

    public let width: Int
    public let height: Int
    fileprivate var array: [AbstractTile?] = [AbstractTile?]()

    // MARK: constructors

    init(size: MapSize) {

        self.width = size.width()
        self.height = size.height()
        self.array = [AbstractTile?](repeating: nil, count: self.height * self.width)
    }

    public init(width: Int, height: Int) {

        self.width = width
        self.height = height
        self.array = [AbstractTile?](repeating: nil, count: height * width)
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.array = try container.decode([Tile?].self, forKey: .array)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.width, forKey: .width)
        try container.encode(self.height, forKey: .height)

        let wrappedTiles: [Tile?] = self.array.map { $0 as? Tile }
        try container.encode(wrappedTiles, forKey: .array)
    }

    // MARK: methods

    public subscript(column: Int, row: Int) -> AbstractTile? {
        get {
            precondition(column < self.width, "Column \(column) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            precondition(row < self.height, "Row \(row) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            return self.array[row * self.width + column]
        }
        set {
            precondition(column < self.width, "Column \(column) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            precondition(row < self.height, "Row \(row) Index is out of range. Array<T>(columns: \(self.width), rows:\(self.height))")
            self.array[row * self.width + column] = newValue
        }
    }
}

// MARK: fill methods

extension TileArray2D {

    func fill(with value: AbstractTile) {

        for x in 0..<self.width {
            for y in 0..<self.height {
                self[x, y] = value
            }
        }
    }

    func fill(with function: (Int, Int) -> AbstractTile) {

        for x in 0..<self.width {
            for y in 0..<self.height {
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

// swiftlint:disable implicit_getter
extension TileArray2D {

    subscript(gridPoint: HexPoint) -> AbstractTile? {

        get {
            return self.array[(gridPoint.y * self.width) + gridPoint.x]
        }

        set(newValue) {
            self.array[(gridPoint.y * self.width) + gridPoint.x] = newValue
        }
    }
}
