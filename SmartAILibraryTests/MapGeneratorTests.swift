//
//  MapGeneratorTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 31.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class MapGeneratorTests: XCTestCase {

    let baseHandler = BaseMapHandler()
    var map: MapModel?

    override func setUp() {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "duel_no_resources", ofType: "map")
        let url = URL(fileURLWithPath: path!)

        let jsonData = try! Data(contentsOf: url, options: .mappedIfSafe)

        self.map = try! JSONDecoder().decode(MapModel.self, from: jsonData)
    }

    func testBasic() {

        // GIVEN
        let options = MapOptions(withSize: .custom(width: 20, height: 20), leader: .alexander, handicap: .settler)

        let mapGenerator = MapGenerator(with: options)
        mapGenerator.progressHandler = { progress, text in
            print("progress: \(progress) - \(text)")
        }

        // WHEN
        let map = mapGenerator.generate()

        // THEN
        XCTAssertEqual(map!.size.width(), 20)
        XCTAssertEqual(map!.size.height(), 20)
    }

    func testCountFishAlreadyAdded() {

        // GIVEN

        // WHEN
        let fishCount = baseHandler.numOfResources(for: .fish, on: self.map)

        // THEN
        XCTAssertEqual(fishCount.alreadyPlaced, 0)
    }

    func testCountingFishToAdd() {

        // GIVEN

        // WHEN
        let fishCount = baseHandler.numOfResourcesToAdd(for: .fish, on: self.map)

        // THEN
        XCTAssertEqual(fishCount, 7)
    }

    func testCountingCitrusToAdd() {

        // GIVEN

        // WHEN
        let citrusCount = baseHandler.numOfResourcesToAdd(for: .citrus, on: self.map)

        // THEN
        XCTAssertEqual(citrusCount, 1)
    }

    func testCountingCocoaToAdd() {

        // GIVEN

        // WHEN
        let cocoaCount = baseHandler.numOfResourcesToAdd(for: .cocoa, on: self.map)

        // THEN
        XCTAssertEqual(cocoaCount, 1)
    }

    func testCountingGemsToAdd() {

        // GIVEN

        // WHEN
        let gemsCount = baseHandler.numOfResourcesToAdd(for: .gems, on: self.map)

        // THEN
        XCTAssertEqual(gemsCount, 1)
    }

    func testCountingRiceToAdd() {

        // GIVEN

        // WHEN
        let riceCount = baseHandler.numOfResourcesToAdd(for: .rice, on: self.map)

        // THEN
        XCTAssertEqual(riceCount, 2)
    }

    func testCountingSaltToAdd() {

        // GIVEN

        // WHEN
        let saltCount = baseHandler.numOfResourcesToAdd(for: .salt, on: self.map)

        // THEN
        XCTAssertEqual(saltCount, 1)
    }

    func testCountingSilverToAdd() {

        // GIVEN

        // WHEN
        let silverCount = baseHandler.numOfResourcesToAdd(for: .silver, on: self.map)

        // THEN
        XCTAssertEqual(silverCount, 2)
    }

    func testCountingStoneToAdd() {

        // GIVEN

        // WHEN
        let stoneCount = baseHandler.numOfResourcesToAdd(for: .stone, on: self.map)

        // THEN
        XCTAssertEqual(stoneCount, 2)
    }

    func testCountingResourcesToAdd() {

        // GIVEN

        for resource in ResourceType.all {

            // WHEN
            let resourceCount = baseHandler.numOfResourcesToAdd(for: resource, on: self.map)

            // THEN
            XCTAssertTrue(resourceCount > 0, "no \(resource) to add")
        }
    }
}
