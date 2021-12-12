//
//  CivicEurekaTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 10.12.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation
import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class CivicEurekaTests: XCTestCase {

    var objectToTest: AbstractCivics?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testEurekaOfCraftsmanship() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .victoria)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.civics
        try! self.objectToTest?.discover(civic: .codeOfLaws)

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        let tile0 = mapModel.tile(at: HexPoint(x: 0, y: 0))
        try! tile0?.set(owner: playerAlexander)
        let tile1 = mapModel.tile(at: HexPoint(x: 1, y: 0))
        try! tile1?.set(owner: playerAlexander)
        let tile2 = mapModel.tile(at: HexPoint(x: 0, y: 1))
        try! tile2?.set(owner: playerAlexander)

        // WHEN
        let beforeEureka = self.objectToTest?.eurekaTriggered(for: .craftsmanship)
        tile0?.changeBuildProgress(of: BuildType.farm, change: 1000, for: playerAlexander, in: gameModel)
        tile1?.changeBuildProgress(of: BuildType.farm, change: 1000, for: playerAlexander, in: gameModel)
        tile2?.changeBuildProgress(of: BuildType.farm, change: 1000, for: playerAlexander, in: gameModel)
        let afterEureka = self.objectToTest?.eurekaTriggered(for: .craftsmanship)

        // THEN
        XCTAssertEqual(beforeEureka, false)
        XCTAssertEqual(afterEureka, true)
    }

    func testEurekaOfForeignTrade() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .victoria)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()
        self.objectToTest = playerTrajan.civics

        // map
        let mapModel = MapUtils.simple()

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        let humanCapital = City(name: "Berlin", at: HexPoint(x: 5, y: 3), capital: true, owner: playerTrajan)
        humanCapital.initialize(in: gameModel)
        gameModel.add(city: humanCapital)

        let galleyUnit = Unit(at: HexPoint(x: 5, y: 6), type: .galley, owner: playerTrajan)
        gameModel.add(unit: galleyUnit)

        // pre-test
        let humanContinent = gameModel.continent(at: HexPoint(x: 5, y: 2))?.type()
        XCTAssertNotNil(humanContinent)
        let discoveredContinent = gameModel.continent(at: HexPoint(x: 5, y: 12))?.type()
        XCTAssertNotNil(discoveredContinent)

        // WHEN
        let beforeEureka = self.objectToTest!.eurekaTriggered(for: .foreignTrade)
        _ = galleyUnit.doMoveOnPath(towards: HexPoint(x: 5, y: 8), previousETA: 0, buildingRoute: false, in: gameModel)
        let afterEureka = self.objectToTest!.eurekaTriggered(for: .foreignTrade)

        // THEN
        XCTAssertEqual(beforeEureka, false)
        XCTAssertEqual(afterEureka, true)
    }
}
