//
//  River.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 18.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// taken from here: https://en.wikipedia.org/wiki/List_of_rivers_by_length
let riverNames = [
    "Amazon", "Nile", "Yangtze", "Mississippi", "Yenisei", "Huang He", "Ob", "Río de la Plata",
    "Congo", "Amur", "Lena", "Mekong", "Mackenzie", "Niger", "Murray", "Tocantins", "Volga",
    "Euphrates", "Madeira", "Purús", "Yukon", "Indus", "São Francisco", "Syr Darya", "Salween",
    "Saint Lawrence", "Rio Grande", "Lower Tunguska", "Brahmaputra", "Donau"
]

/// a `River` holds the complete list of `RiverEdge`s and his name
public class River: Codable {

    enum CodingKeys: CodingKey {
        case name
        case points
    }

    var name: String = ""
    var points: [RiverEdge] = []

    /// constructor of the `River`
    ///
    /// - Parameters:
    ///   - name: name of the `River`
    ///   - cornerPoints: list of corners that generate the edges of the river
    public init(with name: String, and cornerPoints: [HexPointWithCorner]) {

        self.name = name

        if !cornerPoints.isEmpty {
            var prev = cornerPoints.first
            for point in cornerPoints.suffix(from: 1) {

                self.points.append(self.generateRiverEdge(from: prev!, to: point))

                prev = point
            }
        }
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name =  try container.decode(String.self, forKey: .name)
        self.points =  try container.decode([RiverEdge].self, forKey: .points)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.name, forKey: .name)
        try container.encode(self.points, forKey: .points)
    }

    /// generates a RiverEdge
    ///
    /// - Parameters:
    ///   - from: start point of the edge
    ///   - to: end point of the edge
    /// - Returns: `RiverPoint`, which is the edge of point `from` and `to`
    private func generateRiverEdge(from source: HexPointWithCorner, to target: HexPointWithCorner) -> RiverEdge {

        if source.point == target.point {
            return self.generateRiverEdgeSameTile(from: source, to: target)
        } else {
            return self.generateRiverEdgeForeignTile(from: source, to: target)
        }
    }

    /// generates a RiverEdge, when points are on the same tile
    ///
    /// - Parameters:
    ///   - from: start point of the edge
    ///   - to: end point of the edge
    /// - Returns: `RiverPoint`, which is the edge of point `from` and `to`
    private func generateRiverEdgeSameTile(from source: HexPointWithCorner, to target: HexPointWithCorner) -> RiverEdge {

        if source.corner == .northeast && target.corner == .east {
            return RiverEdge(with: source.point, and: .southEast)
        } else if source.corner == .east && target.corner == .northeast {
            return RiverEdge(with: source.point, and: .northWest)
        }

        if source.corner == .east && target.corner == .southeast {
            return RiverEdge(with: source.point, and: .southWest)
        } else if source.corner == .southeast && target.corner == .east {
            return RiverEdge(with: source.point, and: .northEast)
        }

        if source.corner == .northeast && target.corner == .northwest {
            return RiverEdge(with: source.point, and: .west)
        } else if source.corner == .northwest && target.corner == .northeast {
            return RiverEdge(with: source.point, and: .east)
        }

        // we need to move to the northWest neighboring tile
        let northWestNeighbor = source.point.neighbor(in: .northwest)
        if source.corner == .northwest && target.corner == .west {
            return RiverEdge(with: northWestNeighbor, and: .southWest)
        } else if source.corner == .west && target.corner == .northwest {
            return RiverEdge(with: northWestNeighbor, and: .northEast)
        }

        // we need to move to the south neighboring tile
        let southNeighbor = source.point.neighbor(in: .south)
        if source.corner == .southwest && target.corner == .southeast {
            return RiverEdge(with: southNeighbor, and: .east)
        } else if source.corner == .southeast && target.corner == .southwest {
            return RiverEdge(with: southNeighbor, and: .west)
        }

        // we need to move to the southWest neighboring tile
        let southWestNeighbor = source.point.neighbor(in: .southwest)
        if source.corner == .west && target.corner == .southwest {
            return RiverEdge(with: southWestNeighbor, and: .southEast)
        } else if source.corner == .southwest && target.corner == .west {
            return RiverEdge(with: southWestNeighbor, and: .northWest)
        }

        assert(false, "Condition from: \(source), to: \(target) not handled")
    }

    /// generates a RiverEdge, when points are not on the same tile
    ///
    /// - Parameters:
    ///   - from: start point of the edge
    ///   - to: end point of the edge
    /// - Returns: `RiverPoint`, which is the edge of point `from` and `to`
    private func generateRiverEdgeForeignTile(from source: HexPointWithCorner, to target: HexPointWithCorner) -> RiverEdge {

        let direction = source.point.direction(towards: target.point)

        switch direction! {
        case .northeast:
            if source.corner == .east && target.corner == .southeast {
                let southEastNeighbor = source.point.neighbor(in: .southeast)
                return RiverEdge(with: southEastNeighbor, and: .east)
            }
        case .southeast:
            if source.corner == .southeast && target.corner == .southwest {
                let southNeighbor = source.point.neighbor(in: .south)
                return RiverEdge(with: southNeighbor, and: .southEast)
            }
        case .south:
            if source.corner == .southwest && target.corner == .west {
                let southWestNeighbor = source.point.neighbor(in: .southwest)
                return RiverEdge(with: southWestNeighbor, and: .southWest)
            }
        case .southwest:
            if source.corner == .west && target.corner == .northwest {
                return RiverEdge(with: target.point, and: .west)
            }
        case .northwest:
            if source.corner == .northwest && target.corner == .northeast {
                return RiverEdge(with: target.point, and: .northWest)
            }
        case .north:
            if source.corner == .northeast && target.corner == .east {
                return RiverEdge(with: target.point, and: .northEast)
            }
        }

        assert(false, "Condition from: \(source), to: \(target) not handled")
    }
}
