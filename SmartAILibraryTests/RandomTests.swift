//
//  RandomTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 14.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class RandomTests: XCTestCase {

    // swiftlint:disable legacy_random
    func testRandomNumbers() {

        srand48(42)

        XCTAssertEqual(drand48(), 0.7445250000610066)
        XCTAssertEqual(drand48(), 0.342701478718908)
        XCTAssertEqual(drand48(), 0.11108528244416149)
        XCTAssertEqual(drand48(), 0.422338957988309)
        XCTAssertEqual(drand48(), 0.08111117117831057)

        srand48(42)

        XCTAssertEqual(drand48(), 0.7445250000610066)
        XCTAssertEqual(drand48(), 0.342701478718908)
        XCTAssertEqual(drand48(), 0.11108528244416149)
        XCTAssertEqual(drand48(), 0.422338957988309)
        XCTAssertEqual(drand48(), 0.08111117117831057)
    }

    func testShuffleNumbers() {

        let arr = [1, 4, 2, 8, 5]

        srand48(42)
        let shuffled = arr.shuffled

        XCTAssertEqual(shuffled[0], 8)
        XCTAssertEqual(shuffled[1], 2)
        XCTAssertEqual(shuffled[2], 4)
        XCTAssertEqual(shuffled[3], 1)
        XCTAssertEqual(shuffled[4], 5)

        srand48(42)
        let shuffled2 = arr.shuffled

        XCTAssertEqual(shuffled2[0], 8)
        XCTAssertEqual(shuffled2[1], 2)
        XCTAssertEqual(shuffled2[2], 4)
        XCTAssertEqual(shuffled2[3], 1)
        XCTAssertEqual(shuffled2[4], 5)
    }

    func testChooseNumbers() {

        let arr = [1, 4, 2, 8, 5]

        srand48(42)
        let choosen = arr.choose(3)

        XCTAssertEqual(choosen[0], 8)
        XCTAssertEqual(choosen[1], 2)
        XCTAssertEqual(choosen[2], 4)

        srand48(42)
        let choosen2 = arr.choose(3)

        XCTAssertEqual(choosen2[0], 8)
        XCTAssertEqual(choosen2[1], 2)
        XCTAssertEqual(choosen2[2], 4)
    }

    func testNewRandomNumbers() {

        srand48(42)

        XCTAssertEqual(Int.random(number: 10), 7)
        XCTAssertEqual(Int.random(number: 10), 3)
        XCTAssertEqual(Int.random(number: 10), 1)

        XCTAssertEqual(Double.random, 0.422338957988309)
        XCTAssertEqual(Double.random, 0.08111117117831057)
        XCTAssertEqual(Double.random, 0.856440708026625)

        srand48(42)

        XCTAssertEqual(Int.random(number: 10), 7)
        XCTAssertEqual(Int.random(number: 10), 3)
        XCTAssertEqual(Int.random(number: 10), 1)

        XCTAssertEqual(Double.random, 0.422338957988309)
        XCTAssertEqual(Double.random, 0.08111117117831057)
        XCTAssertEqual(Double.random, 0.856440708026625)
    }

    func testMapGenerator() {

        let mapOptions = MapOptions(withSize: MapSize.duel, type: .continents, leader: .alexander, handicap: .settler, seed: 79)

        let generator = MapGenerator(with: mapOptions)
        let map = generator.generate()

        XCTAssertEqual(map?.tile(x: 5, y: 5)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 5, y: 6)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 5, y: 7)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 6, y: 5)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 6, y: 6)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 6, y: 7)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 7, y: 5)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 7, y: 6)?.terrain(), TerrainType.plains)
        XCTAssertEqual(map?.tile(x: 7, y: 7)?.terrain(), TerrainType.shore)

        XCTAssertEqual(map?.tile(x: 5, y: 5)?.feature(), FeatureType.forest)
        XCTAssertEqual(map?.tile(x: 5, y: 6)?.feature(), FeatureType.forest)
        XCTAssertEqual(map?.tile(x: 5, y: 7)?.feature(), FeatureType.rainforest)
        XCTAssertEqual(map?.tile(x: 6, y: 5)?.feature(), FeatureType.rainforest)
        XCTAssertEqual(map?.tile(x: 6, y: 6)?.feature(), FeatureType.rainforest)
        XCTAssertEqual(map?.tile(x: 6, y: 7)?.feature(), FeatureType.forest)
        XCTAssertEqual(map?.tile(x: 7, y: 5)?.feature(), FeatureType.rainforest)
        XCTAssertEqual(map?.tile(x: 7, y: 6)?.feature(), FeatureType.rainforest)
        XCTAssertEqual(map?.tile(x: 7, y: 7)?.feature(), FeatureType.none)

        XCTAssertEqual(map?.tile(x: 5, y: 5)?.resource(for: nil), ResourceType.none)
        XCTAssertEqual(map?.tile(x: 5, y: 6)?.resource(for: nil), ResourceType.none)
        XCTAssertEqual(map?.tile(x: 5, y: 7)?.resource(for: nil), ResourceType.sheep)
        XCTAssertEqual(map?.tile(x: 6, y: 5)?.resource(for: nil), ResourceType.none)
        XCTAssertEqual(map?.tile(x: 6, y: 6)?.resource(for: nil), ResourceType.none)
        XCTAssertEqual(map?.tile(x: 6, y: 7)?.resource(for: nil), ResourceType.none)
        XCTAssertEqual(map?.tile(x: 7, y: 5)?.resource(for: nil), ResourceType.none)
        XCTAssertEqual(map?.tile(x: 7, y: 6)?.resource(for: nil), ResourceType.none)
        XCTAssertEqual(map?.tile(x: 7, y: 7)?.resource(for: nil), ResourceType.none)

        XCTAssertEqual(map?.tile(x: 19, y: 6)?.continentIdentifier(), "3")
        XCTAssertEqual(map?.tile(x: 0, y: 14)?.continentIdentifier(), "5")

        XCTAssertEqual(map?.rivers.count, 3)
        XCTAssertEqual(map?.rivers[0].points[0].point, HexPoint(x: 17, y: 9))
        XCTAssertEqual(map?.rivers[1].points[0].point, HexPoint(x: 17, y: 12))

        XCTAssertEqual(map?.startLocations[0].point, HexPoint(x: 20, y: 6))
        XCTAssertEqual(map?.startLocations[1].point, HexPoint(x: 0, y: 14))
    }
}
