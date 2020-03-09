//
//  HexPointWithCorner.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 18.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

/// class that holds a `HexPoint` as well as a `HexPointCorner`
public class HexPointWithCorner {

    let point: HexPoint
    let corner: HexPointCorner

    init(with point: HexPoint, andCorner corner: HexPointCorner) {
        self.point = point
        self.corner = corner
    }

    public func adjacentCorners() -> [HexPointWithCorner] {

        var corners: [HexPointWithCorner] = []
        let northNeighor = self.point.neighbor(in: .north)
        let northEastNeighor = self.point.neighbor(in: .northeast)
        let southEastNeighbor = self.point.neighbor(in: .southeast)
        let southNeighbor = self.point.neighbor(in: .south)
        let southWestNeighbor = self.point.neighbor(in: .southwest)
        let northWestNeighbor = self.point.neighbor(in: .northwest)

        switch self.corner {
        case .northeast:
            corners.append(HexPointWithCorner(with: northNeighor, andCorner: .east))
            corners.append(HexPointWithCorner(with: self.point, andCorner: .east)) // 1
            corners.append(HexPointWithCorner(with: self.point, andCorner: .northwest)) // 5
        case .east:
            corners.append(HexPointWithCorner(with: northEastNeighor, andCorner: .southeast))
            corners.append(HexPointWithCorner(with: self.point, andCorner: .southeast)) // 2
            corners.append(HexPointWithCorner(with: self.point, andCorner: .northeast)) // 0
        case .southeast:
            corners.append(HexPointWithCorner(with: self.point, andCorner: .east)) // 1
            corners.append(HexPointWithCorner(with: southEastNeighbor, andCorner: .southwest))
            corners.append(HexPointWithCorner(with: self.point, andCorner: .southwest)) // 3
        case .southwest:
            corners.append(HexPointWithCorner(with: self.point, andCorner: .southeast)) // 2
            corners.append(HexPointWithCorner(with: southNeighbor, andCorner: .west))
            corners.append(HexPointWithCorner(with: self.point, andCorner: .west)) // 4
        case .west:
            corners.append(HexPointWithCorner(with: self.point, andCorner: .northwest)) // 5
            corners.append(HexPointWithCorner(with: self.point, andCorner: .southwest)) // 3
            corners.append(HexPointWithCorner(with: southWestNeighbor, andCorner: .northwest))
        case .northwest:
            corners.append(HexPointWithCorner(with: self.point, andCorner: .northeast)) // 0
            corners.append(HexPointWithCorner(with: self.point, andCorner: .west)) // 4
            corners.append(HexPointWithCorner(with: northWestNeighbor, andCorner: .northeast))
        }

        return corners
    }
}

extension HexPointWithCorner: Hashable {
    
    /// Returns a unique number that represents this location.
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.point)
        hasher.combine(self.corner.rawValue)
    }
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
public func == (first: HexPointWithCorner, second: HexPointWithCorner) -> Bool {
    return first.point.x == second.point.x && first.point.y == second.point.y && first.corner == second.corner
}

extension HexPointWithCorner: CustomDebugStringConvertible {

    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return "HexPointWithCorner(\(self.point.x),\(self.point.y) / \(self.corner))"
    }
}

extension HexPointWithCorner: CustomStringConvertible {

    /// A textual representation of this instance, suitable for debugging.
    public var description: String {
        return "HexPointWithCorner(\(self.point.x),\(self.point.y) / \(self.corner))"
    }
}

extension HexPointWithCorner: Equatable {

}
