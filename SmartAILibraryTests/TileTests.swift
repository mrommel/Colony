//
//  TileTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class TileTests: XCTestCase {

    var objectToTest: AbstractTile?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testImprovementsOnDesertWithoutHills() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .desert, hills: false)
        try! self.objectToTest?.set(owner: playerAlexander)

        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()

        // THEN
        XCTAssertFalse(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertFalse(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }

    func testImprovementsOnDesertWithHills() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .desert, hills: true)
        try! self.objectToTest?.set(owner: playerAlexander)

        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()

        // THEN
        XCTAssertFalse(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertFalse(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }

    func testImprovementsOnDesertWithHillsAndMiningEnabled() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        try! playerAlexander.techs!.discover(tech: .mining, in: nil)
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .desert, hills: true)
        try! self.objectToTest?.set(owner: playerAlexander)

        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()

        // THEN
        XCTAssertFalse(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertTrue(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }

    func testImprovementsOnGrasslandWithoutHills() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .grass, hills: false)
        try! self.objectToTest?.set(owner: playerAlexander)

        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()

        // THEN
        XCTAssertTrue(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertFalse(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }

    func testContinentAssigned() {

        // GIVEN
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .grass, hills: false)

        let mapModel = MapModel(size: MapSize.duel, seed: 42)

        let continent = Continent(identifier: 1, name: "Europa", on: mapModel)
        continent.add(point: HexPoint(x: 0, y: 0))

        // WHEN
        self.objectToTest?.set(continent: continent)
        let isOnContinent = self.objectToTest?.isOn(continent: continent)

        // THEN
        XCTAssertEqual(isOnContinent, true)
    }

    func testLineOfSightBlocked() {

        // GIVEN
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 16, height: 12), seed: 42)

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        self.objectToTest = mapModel.tile(at: HexPoint(x: 2, y: 2))
        let tileBehindForest = mapModel.tile(at: HexPoint(x: 4, y: 2))
        let tileBehindMountains = mapModel.tile(at: HexPoint(x: 2, y: 4))
        let tileNotBlocked = mapModel.tile(at: HexPoint(x: 2, y: 0))

        // add forests + hills / mountains to block sight
        mapModel.set(feature: .forest, at: HexPoint(x: 3, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 3, y: 2))
        mapModel.set(feature: .mountains, at: HexPoint(x: 2, y: 3))

        // WHEN
        let canSeeThruHillsAndForest = self.objectToTest?.canSee(
            tile: tileBehindForest,
            for: playerAlexander,
            range: 2,
            hasSentry: false,
            in: gameModel
        )
        let canSeeThruMountains = self.objectToTest?.canSee(
            tile: tileBehindMountains,
            for: playerAlexander,
            range: 2,
            hasSentry: false,
            in: gameModel
        )
        let canSeeUnblocked = self.objectToTest?.canSee(
            tile: tileNotBlocked,
            for: playerAlexander,
            range: 2,
            hasSentry: false,
            in: gameModel
        )

        // THEN
        XCTAssertEqual(canSeeThruHillsAndForest, false)
        XCTAssertEqual(canSeeThruMountains, false)
        XCTAssertEqual(canSeeUnblocked, true)
    }
}
