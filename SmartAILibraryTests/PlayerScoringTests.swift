//
//  PlayerScoringTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class PlayerScoringTests: XCTestCase {

    var objectToTest: Player?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testScoreZero() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapModel(size: .standard, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!, playerTrajan],
            on: mapModel
        )

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 0)
    }

    func testScore2CitiesOnStandard() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapModel(size: .standard, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!, playerTrajan],
            on: mapModel
        )

        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)

        let city2 = City(name: "Potsdam", at: HexPoint(x: 3, y: 5), owner: self.objectToTest)
        city2.initialize(in: gameModel)
        mapModel.add(city: city2, in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 40)
    }

    func testScore2CitiesOnTiny() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapModel(size: .tiny, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!, playerTrajan],
            on: mapModel
        )

        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)

        let city2 = City(name: "Potsdam", at: HexPoint(x: 3, y: 5), owner: self.objectToTest)
        city2.initialize(in: gameModel)
        mapModel.add(city: city2, in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 96)
    }

    func testScore1Tech() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander, isHuman: true)
        self.objectToTest?.initialize()

        let mapModel = MapModel(size: .tiny, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!],
            on: mapModel
        )

        try! self.objectToTest?.techs?.discover(tech: .pottery, in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 6)
    }

    func testScore2Techs() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander, isHuman: true)
        self.objectToTest?.initialize()

        let mapModel = MapModel(size: .tiny, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!],
            on: mapModel
        )

        try! self.objectToTest?.techs?.discover(tech: .pottery, in: gameModel)
        try! self.objectToTest?.techs?.discover(tech: .mining, in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 12)
    }

    func testScore1Wonder() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapModel(size: .tiny, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!, playerTrajan],
            on: mapModel
        )

        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)

        try! city1.wonders?.build(wonder: .pyramids)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 63)
    }

    func testScore2Wonder() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapModel(size: .tiny, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!, playerTrajan],
            on: mapModel
        )

        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)

        try! city1.wonders?.build(wonder: .pyramids)
        try! city1.wonders?.build(wonder: .oracle)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 78)
    }

    func testScoreLandStandard() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapModel(size: .standard, seed: 42)

        let gameModel = GameModel(
            victoryTypes: [.cultural, .domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, self.objectToTest!, playerTrajan],
            on: mapModel
        )

        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)

        self.objectToTest?.updatePlots(in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 20) // 10 + 4 from city
    }
}
