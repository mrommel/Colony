//
//  AdvisorTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class AdvisorTests: XCTestCase {

    var objectToTest: AbstractCity?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testMessagesAfterInitialTurn() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()
        playerTrajan.government?.set(governmentType: .autocracy)

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

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
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        try! playerAlexander.techs?.discover(tech: .mining, in: gameModel)

        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 1), in: gameModel)
        try! mapModel.set(owner: playerAlexander, at: HexPoint(x: 1, y: 1))
        mapModel.set(improvement: .farm, at: HexPoint(x: 1, y: 1))

        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 2), in: gameModel)
        try! mapModel.set(owner: playerAlexander, at: HexPoint(x: 1, y: 2))
        mapModel.set(improvement: .farm, at: HexPoint(x: 1, y: 2))

        gameModel.add(unit: Unit(at: HexPoint(x: 5, y: 8), type: .warrior, owner: playerTrajan))

        // add the city to the map
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        gameModel.add(city: self.objectToTest)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)

        // WHEN
        repeat {
            gameModel.update()

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let messages = playerAlexander.advisorMessages()

        // THEN
        XCTAssertEqual(messages.count, 0)
    }

    func testMessagesAfter30Turns() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()
        playerTrajan.government?.set(governmentType: .autocracy)

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

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
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        try! playerAlexander.techs?.discover(tech: .mining, in: gameModel)
        try! playerTrajan.techs?.discover(tech: .mining, in: gameModel)

        gameModel.add(unit: Unit(at: HexPoint(x: 5, y: 8), type: .warrior, owner: playerTrajan))

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        mapModel.add(city: self.objectToTest, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)

        // center
        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        centerTile?.set(improvement: .farm)

        // another
        let anotherTile = mapModel.tile(at: HexPoint(x: 1, y: 2))
        anotherTile?.set(terrain: .plains)
        anotherTile?.set(hills: true)
        anotherTile?.set(improvement: .mine)

        // WHEN
        for _ in 0..<30 {
            repeat {
                gameModel.update()

                if playerAlexander.isTurnActive() {
                    playerAlexander.finishTurn()
                    playerAlexander.setAutoMoves(to: true)
                }
            } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())
        }

        // THEN
        let messages = playerAlexander.advisorMessages()
        XCTAssertEqual(gameModel.currentTurn, 30)
        XCTAssertEqual(messages.count, 3)
    }

    func testMessagesAfter30TurnsWithMelees() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()
        playerTrajan.government?.set(governmentType: .autocracy)

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

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
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        try! playerAlexander.techs?.discover(tech: .mining, in: gameModel)
        try! playerTrajan.techs?.discover(tech: .mining, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)
        mapModel.add(city: self.objectToTest, in: gameModel)

        // center
        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        centerTile?.set(improvement: .farm)

        // another
        let anotherTile = mapModel.tile(at: HexPoint(x: 1, y: 2))
        anotherTile?.set(terrain: .plains)
        anotherTile?.set(hills: true)
        anotherTile?.set(improvement: .mine)

        // units
        gameModel.add(unit: Unit(at: HexPoint(x: 5, y: 8), type: .warrior, owner: playerTrajan))
        gameModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAlexander))
        gameModel.add(unit: Unit(at: HexPoint(x: 0, y: 1), type: .warrior, owner: playerAlexander))
        gameModel.add(unit: Unit(at: HexPoint(x: 0, y: 2), type: .warrior, owner: playerAlexander))
        gameModel.add(unit: Unit(at: HexPoint(x: 0, y: 3), type: .warrior, owner: playerAlexander))

        // WHEN
        for _ in 0..<30 {
            repeat {
                gameModel.update()

                if playerAlexander.isTurnActive() {
                    playerAlexander.finishTurn()
                    playerAlexander.setAutoMoves(to: true)
                }
            } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())
        }
        let messages = playerAlexander.advisorMessages()

        // THEN
        XCTAssertEqual(gameModel.currentTurn, 30)
        XCTAssertEqual(messages.count, 3)
    }
}
