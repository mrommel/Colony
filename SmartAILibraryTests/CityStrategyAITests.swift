//
//  CityStrategyAITests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 19.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class CityStrategyAITests: XCTestCase {

    var objectToTest: CityStrategyAI?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    // population 1
    func testTinyCityActive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)
        city.set(population: 1, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .tinyCity)

        // THEN
        XCTAssertTrue(strategyActive)
    }

    // population 2-4
    func testSmallCityActive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)

        city.set(population: 3, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .smallCity)

        // THEN
        XCTAssertTrue(strategyActive)
    }

    // population 5-11
    func testMediumCityActive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .standard)
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)

        city.set(population: 7, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .mediumCity)

        // THEN
        XCTAssertTrue(strategyActive)
    }

    // population 12+
    func testLargeCityActive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .standard)
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)

        city.set(population: 12, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .largeCity)

        // THEN
        XCTAssertTrue(strategyActive)
    }

    func testLandlockedActive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .standard)
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)

        city.set(population: 12, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .landLocked)

        // THEN
        XCTAssertTrue(strategyActive)
    }

    func testLandlockedInactive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .standard)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)
        city.set(population: 12, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .landLocked)

        // THEN
        XCTAssertFalse(strategyActive)
    }

    func testNeedTileImproversEarlyInactive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .standard)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)
        city.set(population: 12, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .needTileImprovers)

        // THEN
        XCTAssertFalse(strategyActive)
    }

    func testNeedTileImproversActive() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .standard)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 31,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)
        city.set(population: 12, reassignCitizen: false, in: gameModel)

        // WHEN
        city.turn(in: gameModel)
        let strategyActive = city.cityStrategy!.adopted(cityStrategy: .needTileImprovers)

        // THEN
        XCTAssertTrue(strategyActive)
    }

}
