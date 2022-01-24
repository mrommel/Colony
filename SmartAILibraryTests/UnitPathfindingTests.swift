//
//  UnitPathfindingTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 23.01.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class UnitPathfindingTests: XCTestCase {

    func testNoPathForBuilderAcrossShoreWithoutSailing() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .shore, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerBuilder = Unit(at: HexPoint(x: 2, y: 2), type: .builder, owner: humanPlayer)
        gameModel.add(unit: humanPlayerBuilder)

        // WHEN
        let options = MoveOptions()
        let path = humanPlayerBuilder.path(towards: HexPoint(x: 6, y: 2), options: options, in: gameModel)

        // THEN
        XCTAssertNil(path)
    }

    func testPathForBuilderAcrossShoreWithSailing() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .shore, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        try humanPlayer.techs?.discover(tech: .sailing, in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerBuilder = Unit(at: HexPoint(x: 2, y: 2), type: .builder, owner: humanPlayer)
        gameModel.add(unit: humanPlayerBuilder)

        // WHEN
        let options = MoveOptions()
        let path = humanPlayerBuilder.path(towards: HexPoint(x: 6, y: 2), options: options, in: gameModel)

        // THEN
        XCTAssertEqual(path?.points(), [HexPoint(x: 2, y: 2), HexPoint(x: 3, y: 2), HexPoint(x: 4, y: 2), HexPoint(x: 5, y: 2), HexPoint(x: 6, y: 2)])
    }

    func testNoPathForBuilderAcrossOceanWithSailing() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        try humanPlayer.techs?.discover(tech: .sailing, in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerBuilder = Unit(at: HexPoint(x: 2, y: 2), type: .builder, owner: humanPlayer)
        gameModel.add(unit: humanPlayerBuilder)

        // WHEN
        let options = MoveOptions()
        let path = humanPlayerBuilder.path(towards: HexPoint(x: 6, y: 2), options: options, in: gameModel)

        // THEN
        XCTAssertNil(path)
    }

    func testNoPathForWarriorAcrossShoreWithoutShipBuilding() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .shore, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        try humanPlayer.techs?.discover(tech: .sailing, in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        gameModel.add(unit: humanPlayerWarrior)

        // WHEN
        let options = MoveOptions()
        let path = humanPlayerWarrior.path(towards: HexPoint(x: 6, y: 2), options: options, in: gameModel)

        // THEN
        XCTAssertNil(path)
    }

    func testNoPathForWarriorAcrossOceanWithoutShipBuilding() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        try humanPlayer.techs?.discover(tech: .sailing, in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        gameModel.add(unit: humanPlayerWarrior)

        // WHEN
        let options = MoveOptions()
        let path = humanPlayerWarrior.path(towards: HexPoint(x: 6, y: 2), options: options, in: gameModel)

        // THEN
        XCTAssertNil(path)
    }

    func testPathForWarriorAcrossOceanWithCartography() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        try humanPlayer.techs?.discover(tech: .sailing, in: gameModel)
        try humanPlayer.techs?.discover(tech: .cartography, in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        gameModel.add(unit: humanPlayerWarrior)

        // WHEN
        let options = MoveOptions()
        let path = humanPlayerWarrior.path(towards: HexPoint(x: 6, y: 2), options: options, in: gameModel)

        // THEN
        XCTAssertEqual(path?.points(), [HexPoint(x: 2, y: 2), HexPoint(x: 3, y: 2), HexPoint(x: 4, y: 2), HexPoint(x: 5, y: 2), HexPoint(x: 6, y: 2)])
    }
}
