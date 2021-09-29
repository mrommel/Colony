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
        try! playerAlexander.techs?.discover(tech: .mining)

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [barbarianPlayer, playerAlexander], on: mapModel)

        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 1), in: gameModel)
        try! mapModel.set(owner: playerAlexander, at: HexPoint(x: 1, y: 1))
        mapModel.set(improvement: .farm, at: HexPoint(x: 1, y: 1))

        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 2), in: gameModel)
        try! mapModel.set(owner: playerAlexander, at: HexPoint(x: 1, y: 2))
        mapModel.set(improvement: .farm, at: HexPoint(x: 1, y: 2))

        // add the city to the map
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        mapModel.add(city: self.objectToTest, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)

        // WHEN
        gameModel.update() //.doTurn()
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
        try! playerAlexander.techs?.discover(tech: .mining)

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()
        playerAugustus.government?.set(governmentType: .autocracy)
        try! playerAugustus.techs?.discover(tech: .mining)

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel) //MapModel(size: .standard)

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [barbarianPlayer, playerAlexander, playerAugustus], on: mapModel)

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
            gameModel.update() //.doTurn()

            // manual input
            playerAlexander.endTurn(in: gameModel)
        }
        let messages = playerAlexander.advisorMessages()

        // THEN
        XCTAssertEqual(messages.count, 3)
    }

    func testMessagesAfter30TurnsWithMelees() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()
        playerAugustus.government?.set(governmentType: .autocracy)
        try! playerAugustus.techs?.discover(tech: .mining)

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [barbarianPlayer, playerAlexander, playerAugustus], on: mapModel)

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
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 1), type: .warrior, owner: playerAlexander), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 2), type: .warrior, owner: playerAlexander), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 3), type: .warrior, owner: playerAlexander), in: gameModel)

        // WHEN
        for _ in 0..<30 {
            gameModel.update() //.doTurn()

            playerAlexander.endTurn(in: gameModel)
        }
        let messages = playerAlexander.advisorMessages()

        // THEN
        XCTAssertEqual(messages.count, 3)
    }
}
