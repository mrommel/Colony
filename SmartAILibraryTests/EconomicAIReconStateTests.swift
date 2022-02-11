//
//  EconomicAIReconStateTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class EconomicAIReconStateTests: XCTestCase {

    var objectToTest: EconomicAI?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testReconStateNeeded() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        self.objectToTest = EconomicAI(player: playerAlexander)

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerAlexander],
            on: mapModel
        )

        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 1), in: gameModel)
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 2), in: gameModel)
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 0, y: 0), in: gameModel)
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 0), in: gameModel)
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 2, y: 1), in: gameModel)
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 0, y: 2), in: gameModel)
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 0, y: 1), in: gameModel)

        // WHEN
        self.objectToTest?.updateReconState(in: gameModel)

        // THEN
        XCTAssertEqual(self.objectToTest!.reconState(), .needed)
    }

    func testReconStateEnough() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        self.objectToTest = EconomicAI(player: playerAlexander)

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerAlexander],
            on: mapModel
        )

        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)

        // WHEN
        self.objectToTest?.updateReconState(in: gameModel)

        // THEN
        XCTAssertEqual(self.objectToTest!.reconState(), .enough)
    }
}
