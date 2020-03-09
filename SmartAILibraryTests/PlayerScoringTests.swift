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

class PlayerScoringTests: XCTestCase {

    var objectToTest: Player?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testScoreZero() {

        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .standard)

        let gameModel = GameModel(victoryTypes: [.cultural, .domination], turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 0)
    }

    func testScore2CitiesOnStandard() {

        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .standard)
        mapModel.add(city: City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest))
        mapModel.add(city: City(name: "Potsdam", at: HexPoint(x: 3, y: 5), owner: self.objectToTest))

        let gameModel = GameModel(victoryTypes: [.cultural, .domination], turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 28)
    }

    func testScore2CitiesOnTiny() {

        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .tiny)
        mapModel.add(city: City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest))
        mapModel.add(city: City(name: "Potsdam", at: HexPoint(x: 3, y: 5), owner: self.objectToTest))

        let gameModel = GameModel(victoryTypes: [.cultural, .domination], turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 57)
    }
}
