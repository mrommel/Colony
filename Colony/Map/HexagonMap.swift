//
//  HexagonMap.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreGraphics

class HexagonMap<T: Equatable & Codable>: Codable {
    
    var tiles: Array2D<T>
    
    init(width: Int, height: Int) {
        self.tiles = Array2D<T>(columns: width, rows: height)
    }
    
    init(with size: CGSize) {
        self.tiles = Array2D<T>(columns: Int(size.width), rows: Int(size.height))
    }
    
    func valid(point: HexPoint) -> Bool {
        return 0 <= point.x && point.x < self.tiles.columns &&
            0 <= point.y && point.y < self.tiles.rows
    }
    
    func valid(x: Int, y: Int) -> Bool {
        return 0 <= x && x < self.tiles.columns &&
            0 <= y && y < self.tiles.rows
    }
    
    func tile(at point: HexPoint) -> T? {
        if !self.valid(x: point.x, y: point.y) {
            return nil
        }
        
        return self.tiles[point.x, point.y]
    }
    
    func tile(x: Int, y: Int) -> T? {
        if !self.valid(x: x, y: y) {
            return nil
        }
        
        return self.tiles[x, y]
    }
    
    func set(tile: T, at hex: HexPoint) {
        self.tiles[hex.x, hex.y] = tile
    }
}
