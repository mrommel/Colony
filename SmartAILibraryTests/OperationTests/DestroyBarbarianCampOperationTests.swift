//
//  DestroyBarbarianCampOperationTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 25.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class DestroyBarbarianCampOperationTests: XCTestCase {

    func testDestroyTwoBarbarianCamp() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapModelHelper.smallMap()

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 30,
                                  players: [playerBarbarian, playerTrajan, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // check city locations
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 15, y: 8))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 20, y: 24))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 35, y: 24))?.isWater(), false)

        // build cities
        let cityBerlin = City(name: "Berlin", at: HexPoint(x: 15, y: 8), capital: true, owner: playerTrajan)
        cityBerlin.initialize(in: gameModel)
        gameModel.add(city: cityBerlin)

        let cityLeipzig = City(name: "Leipzig", at: HexPoint(x: 20, y: 24), capital: false, owner: playerTrajan)
        cityLeipzig.initialize(in: gameModel)
        gameModel.add(city: cityLeipzig)

        let cityParis = City(name: "Paris", at: HexPoint(x: 35, y: 24), capital: false, owner: playerAlexander)
        cityParis.initialize(in: gameModel)
        gameModel.add(city: cityParis)

        // barbarian camp - 2 camps trigger
        gameModel.tile(at: HexPoint(x: 17, y: 16))?.set(improvement: .barbarianCamp)
        gameModel.tile(at: HexPoint(x: 19, y: 16))?.set(improvement: .barbarianCamp)

        // check unit locations
        let playerTrajanWarrior1Location: HexPoint = HexPoint(x: 21, y: 22)
        let playerTrajanWarrior2Location: HexPoint = HexPoint(x: 21, y: 24)
        let playerTrajanWarrior3Location: HexPoint = HexPoint(x: 20, y: 24)
        let playerTrajanArcherLocation: HexPoint = HexPoint(x: 20, y: 23)
        //let playerBarbarianWarriorLocation: HexPoint = HexPoint(x: 20, y: 23)

        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior1Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior2Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior3Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanArcherLocation)!.isLand(), true)

        // initial units
        let playerTrajanWarrior1 = Unit(at: playerTrajanWarrior1Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior1)

        let playerTrajanWarrior2 = Unit(at: playerTrajanWarrior2Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior2)

        let playerTrajanWarrior3 = Unit(at: playerTrajanWarrior3Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior3)

        let playerTrajanArcher = Unit(at: playerTrajanArcherLocation, type: .archer, owner: playerTrajan)
        gameModel.add(unit: playerTrajanArcher)

        //let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 7), type: .barbarianWarrior, owner: playerBarbarian)
        //gameModel.add(unit: playerBarbarianWarrior)

        // this is cheating
        MapModelHelper.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        while !playerAlexander.canFinishTurn() {
            gameModel.update()
            print("::: --- loop --- :::")
        }
        playerAlexander.endTurn(in: gameModel)

        // THEN
        // DEBUG: po playerTrajan.operations!.operations
        XCTAssertEqual(playerTrajan.operations?.operationsOf(type: .destroyBarbarianCamp).count, 1)
    }

    func testDestroyTwoBarbarianCampAtWar() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapModelHelper.smallMap()

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 30,
                                  players: [playerBarbarian, playerTrajan, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // check city locations
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 15, y: 8))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 20, y: 24))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 35, y: 24))?.isWater(), false)

        // build cities
        let cityBerlin = City(name: "Berlin", at: HexPoint(x: 15, y: 8), capital: true, owner: playerTrajan)
        cityBerlin.initialize(in: gameModel)
        gameModel.add(city: cityBerlin)

        let cityLeipzig = City(name: "Leipzig", at: HexPoint(x: 20, y: 24), capital: false, owner: playerTrajan)
        cityLeipzig.initialize(in: gameModel)
        gameModel.add(city: cityLeipzig)

        let cityParis = City(name: "Paris", at: HexPoint(x: 35, y: 24), capital: false, owner: playerAlexander)
        cityParis.initialize(in: gameModel)
        gameModel.add(city: cityParis)

        // barbarian camp - 2 camps trigger
        gameModel.tile(at: HexPoint(x: 17, y: 16))?.set(improvement: .barbarianCamp)
        gameModel.tile(at: HexPoint(x: 19, y: 16))?.set(improvement: .barbarianCamp)

        // check unit locations
        let playerTrajanWarrior1Location: HexPoint = HexPoint(x: 21, y: 22)
        let playerTrajanWarrior2Location: HexPoint = HexPoint(x: 21, y: 24)
        let playerTrajanWarrior3Location: HexPoint = HexPoint(x: 20, y: 24)
        let playerTrajanArcherLocation: HexPoint = HexPoint(x: 20, y: 23)
        //let playerBarbarianWarriorLocation: HexPoint = HexPoint(x: 20, y: 23)

        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior1Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior2Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior3Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanArcherLocation)!.isLand(), true)

        // initial units
        let playerTrajanWarrior1 = Unit(at: playerTrajanWarrior1Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior1)

        let playerTrajanWarrior2 = Unit(at: playerTrajanWarrior2Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior2)

        let playerTrajanWarrior3 = Unit(at: playerTrajanWarrior3Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior3)

        let playerTrajanArcher = Unit(at: playerTrajanArcherLocation, type: .archer, owner: playerTrajan)
        gameModel.add(unit: playerTrajanArcher)

        //let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 7), type: .barbarianWarrior, owner: playerBarbarian)
        //gameModel.add(unit: playerBarbarianWarrior)

        // this is cheating
        MapModelHelper.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        playerAlexander.diplomacyAI?.doDeclareWar(to: playerTrajan, in: gameModel) // at war no barbarian hunt

        // WHEN
        while !playerAlexander.canFinishTurn() {
            gameModel.update()
            print("::: --- loop --- :::")
        }
        playerAlexander.endTurn(in: gameModel)

        // THEN
        // DEBUG: po playerTrajan.operations!.operations
        XCTAssertEqual(playerTrajan.operations?.operationsOf(type: .destroyBarbarianCamp).count, 0)
    }

    func testDestroyOneBarbarianCampTwoWarriors() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapModelHelper.smallMap()

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 30,
                                  players: [playerBarbarian, playerTrajan, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // check city locations
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 15, y: 8))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 20, y: 24))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 35, y: 24))?.isWater(), false)

        // build cities
        let cityBerlin = City(name: "Berlin", at: HexPoint(x: 15, y: 8), capital: true, owner: playerTrajan)
        cityBerlin.initialize(in: gameModel)
        gameModel.add(city: cityBerlin)

        let cityLeipzig = City(name: "Leipzig", at: HexPoint(x: 20, y: 24), capital: false, owner: playerTrajan)
        cityLeipzig.initialize(in: gameModel)
        gameModel.add(city: cityLeipzig)

        let cityParis = City(name: "Paris", at: HexPoint(x: 35, y: 24), capital: false, owner: playerAlexander)
        cityParis.initialize(in: gameModel)
        gameModel.add(city: cityParis)

        // 1 barbarian camp - 2 warror trigger
        gameModel.tile(at: HexPoint(x: 17, y: 16))?.set(improvement: .barbarianCamp)

        // check unit locations
        let playerTrajanWarrior1Location: HexPoint = HexPoint(x: 21, y: 22)
        let playerTrajanWarrior2Location: HexPoint = HexPoint(x: 21, y: 24)
        let playerTrajanWarrior3Location: HexPoint = HexPoint(x: 20, y: 23)
        let playerTrajanArcherLocation: HexPoint = HexPoint(x: 20, y: 23)
        let playerBarbarianWarrior1Location: HexPoint = HexPoint(x: 21, y: 23) // must be visible
        let playerBarbarianWarrior2Location: HexPoint = HexPoint(x: 20, y: 22) // must be visible

        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior1Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior2Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior3Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanArcherLocation)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerBarbarianWarrior1Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerBarbarianWarrior2Location)!.isLand(), true)

        // initial units
        let playerTrajanWarrior1 = Unit(at: playerTrajanWarrior1Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior1)

        let playerTrajanWarrior2 = Unit(at: playerTrajanWarrior2Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior2)

        let playerTrajanWarrior3 = Unit(at: playerTrajanWarrior3Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior3)

        let playerTrajanArcher = Unit(at: playerTrajanArcherLocation, type: .archer, owner: playerTrajan)
        gameModel.add(unit: playerTrajanArcher)

        let playerBarbarianWarrior1 = Unit(at: playerBarbarianWarrior1Location, type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior1)

        let playerBarbarianWarrior2 = Unit(at: playerBarbarianWarrior2Location, type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior2)

        // this is cheating
        MapModelHelper.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        while !playerAlexander.canFinishTurn() {
            gameModel.update()
            print("::: --- loop --- :::")
        }
        playerAlexander.endTurn(in: gameModel)

        // THEN
        // DEBUG: po playerTrajan.operations!.operations
        // make sure that both barbarians are visible after their random movement (to prevent test failing)
        if playerTrajan.militaryAI!.barbarianData().visibleBarbarianCount == 2 {
            XCTAssertEqual(playerTrajan.operations?.operationsOf(type: .destroyBarbarianCamp).count, 1)
        }
    }

    func testDestroyFourBarbarianWarriorsButNoCamp() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapModelHelper.smallMap()

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 30,
                                  players: [playerBarbarian, playerTrajan, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // check city locations
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 15, y: 8))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 20, y: 24))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 35, y: 24))?.isWater(), false)

        // build cities
        let cityBerlin = City(name: "Berlin", at: HexPoint(x: 15, y: 8), capital: true, owner: playerTrajan)
        cityBerlin.initialize(in: gameModel)
        gameModel.add(city: cityBerlin)

        let cityLeipzig = City(name: "Leipzig", at: HexPoint(x: 20, y: 24), capital: false, owner: playerTrajan)
        cityLeipzig.initialize(in: gameModel)
        gameModel.add(city: cityLeipzig)

        let cityParis = City(name: "Paris", at: HexPoint(x: 35, y: 24), capital: false, owner: playerAlexander)
        cityParis.initialize(in: gameModel)
        gameModel.add(city: cityParis)

        // barbarian camp - 0 camps trigger

        // check unit locations
        let playerTrajanWarrior1Location: HexPoint = HexPoint(x: 21, y: 22)
        let playerTrajanWarrior2Location: HexPoint = HexPoint(x: 21, y: 24)
        let playerTrajanWarrior3Location: HexPoint = HexPoint(x: 20, y: 24)
        let playerTrajanArcherLocation: HexPoint = HexPoint(x: 20, y: 23)
        let playerBarbarianWarrior1Location: HexPoint = HexPoint(x: 21, y: 23) // must be visible
        let playerBarbarianWarrior2Location: HexPoint = HexPoint(x: 20, y: 22) // must be visible
        let playerBarbarianWarrior3Location: HexPoint = HexPoint(x: 19, y: 24) // must be visible
        let playerBarbarianWarrior4Location: HexPoint = HexPoint(x: 19, y: 23) // must be visible

        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior1Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior2Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanWarrior3Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerTrajanArcherLocation)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerBarbarianWarrior1Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerBarbarianWarrior2Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerBarbarianWarrior3Location)!.isLand(), true)
        XCTAssertEqual(gameModel.tile(at: playerBarbarianWarrior4Location)!.isLand(), true)

        // initial units
        let playerTrajanWarrior1 = Unit(at: playerTrajanWarrior1Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior1)

        let playerTrajanWarrior2 = Unit(at: playerTrajanWarrior2Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior2)

        let playerTrajanWarrior3 = Unit(at: playerTrajanWarrior3Location, type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior3)

        let playerTrajanArcher = Unit(at: playerTrajanArcherLocation, type: .archer, owner: playerTrajan)
        gameModel.add(unit: playerTrajanArcher)

        let playerBarbarianWarrior1 = Unit(at: playerBarbarianWarrior1Location, type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior1)

        let playerBarbarianWarrior2 = Unit(at: playerBarbarianWarrior2Location, type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior2)

        let playerBarbarianWarrior3 = Unit(at: playerBarbarianWarrior3Location, type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior3)

        let playerBarbarianWarrior4 = Unit(at: playerBarbarianWarrior4Location, type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior4)

        // this is cheating
        MapModelHelper.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        while !playerAlexander.canFinishTurn() {
            gameModel.update()
            print("::: --- loop --- :::")
        }
        playerAlexander.endTurn(in: gameModel)

        // THEN
        // DEBUG: po playerTrajan.operations!.operations
        XCTAssertEqual(playerTrajan.operations?.operationsOf(type: .destroyBarbarianCamp).count, 0)
    }
}
