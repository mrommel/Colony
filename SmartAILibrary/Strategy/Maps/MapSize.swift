//
//  MapSize.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum MapSize {

    case duel
    case tiny
    case small
    case standard
    case large
    case huge
    case custom(width: Int, height: Int)

    public static var all: [MapSize] {
        return [.duel, .tiny, .small, .standard, .large, .huge]
    }

    // public methods

    public func name() -> String {

        return self.data().name
    }

    public func width() -> Int {

        return self.data().width
    }

    public func height() -> Int {

        return self.data().height
    }

    func numberOfTiles() -> Int {

        switch self {

        case .duel, .tiny, .small, .standard, .large, .huge:
            return self.width() * self.height()

        case .custom(let width, let height):
            return width * height
        }
    }

    func fogTilesPerBarbarianCamp() -> Int {

        return self.data().fogTilesPerBarbarianCamp
    }

    func maxActiveReligions() -> Int {

        return self.data().maxActiveReligions
    }

    func targetNumCities() -> Int {

        return self.data().targetNumCities
    }

    func numberOfPlayers() -> Int {

        return self.data().numberOfPlayers
    }

    func numberOfNaturalWonders() -> Int {

        return self.data().numberOfNaturalWonders
    }

    func numberOfCityStates() -> Int {

        return self.data().numberOfCityStates
    }

    // private inner class

    private struct MapSizeData {

        let name: String
        let width: Int
        let height: Int

        let fogTilesPerBarbarianCamp: Int
        let maxActiveReligions: Int
        let targetNumCities: Int
        let numberOfPlayers: Int
        let numberOfNaturalWonders: Int
        let numberOfCityStates: Int
    }

    private func data() -> MapSizeData {

        switch self {

        case .duel:
            return MapSizeData(
                name: "TXT_KEY_MAP_SIZE_DUEL_NAME",
                width: 32,
                height: 22,
                fogTilesPerBarbarianCamp: 13,
                maxActiveReligions: 2,
                targetNumCities: 8,
                numberOfPlayers: 2,
                numberOfNaturalWonders: 2,
                numberOfCityStates: 3
            )

        case .tiny:
            return MapSizeData(
                name: "TXT_KEY_MAP_SIZE_TINY_NAME",
                width: 42,
                height: 32,
                fogTilesPerBarbarianCamp: 18,
                maxActiveReligions: 4,
                targetNumCities: 10,
                numberOfPlayers: 3,
                numberOfNaturalWonders: 3,
                numberOfCityStates: 6
            )

        case .small:
            return MapSizeData(
                name: "TXT_KEY_MAP_SIZE_SMALL_NAME",
                width: 52,
                height: 42,
                fogTilesPerBarbarianCamp: 23,
                maxActiveReligions: 5,
                targetNumCities: 15,
                numberOfPlayers: 4,
                numberOfNaturalWonders: 4,
                numberOfCityStates: 9
            )

        case .standard:
            return MapSizeData(
                name: "TXT_KEY_MAP_SIZE_STANDARD_NAME",
                width: 62,
                height: 52,
                fogTilesPerBarbarianCamp: 27,
                maxActiveReligions: 7,
                targetNumCities: 20,
                numberOfPlayers: 6,
                numberOfNaturalWonders: 5,
                numberOfCityStates: 12
            )

        case .large:
            return MapSizeData(
                name: "TXT_KEY_MAP_SIZE_LARGE_NAME",
                width: 72,
                height: 62,
                fogTilesPerBarbarianCamp: 30,
                maxActiveReligions: 9,
                targetNumCities: 30,
                numberOfPlayers: 8,
                numberOfNaturalWonders: 6,
                numberOfCityStates: 15
            )

        case .huge:
            return MapSizeData(
                name: "TXT_KEY_MAP_SIZE_HUGE_NAME",
                width: 82,
                height: 72,
                fogTilesPerBarbarianCamp: 35,
                maxActiveReligions: 11,
                targetNumCities: 45,
                numberOfPlayers: 10,
                numberOfNaturalWonders: 7,
                numberOfCityStates: 18
            )

        case .custom(width: let width, height: let height):
            let bestMatch = MapSize.bestMatch(for: width, and: height)
            return MapSizeData(
                name: "TXT_KEY_MAP_SIZE_CUSTOM_NAME",
                width: width,
                height: height,
                fogTilesPerBarbarianCamp: bestMatch.fogTilesPerBarbarianCamp(),
                maxActiveReligions: bestMatch.maxActiveReligions(),
                targetNumCities: bestMatch.targetNumCities(),
                numberOfPlayers: bestMatch.numberOfPlayers(),
                numberOfNaturalWonders: bestMatch.numberOfNaturalWonders(),
                numberOfCityStates: bestMatch.numberOfCityStates()
            )
        }
    }

    private static func bestMatch(for width: Int, and height: Int) -> MapSize {

        for size in MapSize.all where size.numberOfTiles() >= width * height {
            return size
        }

        return .standard
    }
}

extension MapSize: Codable {

    enum CodingKeys: CodingKey {
        case rawValue
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rawValue = try container.decode(Int.self, forKey: .rawValue)

        switch rawValue {

        case 0: self = .duel
        case 1: self = .tiny
        case 2: self = .small
        case 3: self = .standard
        case 4: self = .large
        case 5: self = .huge
        default:
            let width = rawValue - ((rawValue / 1000) * 1000)
            let height = rawValue / 1000

            self = .custom(width: width, height: height)
        }
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {

        case .duel:
            try container.encode(0, forKey: .rawValue)
        case .tiny:
            try container.encode(1, forKey: .rawValue)
        case .small:
            try container.encode(2, forKey: .rawValue)
        case .standard:
            try container.encode(3, forKey: .rawValue)
        case .large:
            try container.encode(4, forKey: .rawValue)
        case .huge:
            try container.encode(5, forKey: .rawValue)
        case .custom(width: let width, height: let height):
            try container.encode(width + height * 1000, forKey: .rawValue)
        }
    }
}

extension MapSize: Equatable {

}
