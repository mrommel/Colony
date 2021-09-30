//
//  HumanUserTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class UsecaseTests: XCTestCase {

    func testFirstCityBuild() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAugustus, playerBarbarian, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units
        /*let playerAlexanderSettler = Unit(at: HexPoint(x: 5, y: 5), type: .settler, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderSettler)*/

        let playerAlexanderWarrior = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)

        let playerAugustusSettler = Unit(at: HexPoint(x: 15, y: 15), type: .settler, owner: playerAugustus)
        gameModel.add(unit: playerAugustusSettler)

        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 16), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: playerAugustusWarrior)

        let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 10), type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerAugustus, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        let numCitiesBefore = gameModel.cities(of: playerAugustus).count
        let numOfUnitsBefore = gameModel.units(of: playerAugustus).count

        // WHEN
        gameModel.update()

        playerAlexander.finishTurn()
        playerAlexander.setAutoMoves(to: true)

        // THEN
        XCTAssertEqual(numCitiesBefore, 0)
        XCTAssertEqual(numOfUnitsBefore, 2)
        let numCitiesAfter = gameModel.cities(of: playerAugustus).count
        let numOfUnitsAfter = gameModel.units(of: playerAugustus).count
        XCTAssertEqual(numCitiesAfter, 1)
        XCTAssertEqual(numOfUnitsAfter, 1)

        XCTAssertEqual(playerAugustusWarrior.activityType(), .none) // warriro has skipped
        //XCTAssertEqual(playerAugustusWarrior.peekMission()!.buildType, BuildType.repair)
    }

    func testWarriorMoveToGarrison() {

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
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerBarbarian, playerTrajan, playerAlexander],
                                  on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units
        let playerTrajanWarrior = Unit(at: HexPoint(x: 15, y: 16), type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior)

        // initial cities
        let cityAlexandria = City(name: "Alexandria", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAlexander)
        cityAlexandria.initialize(in: gameModel)
        gameModel.add(city: cityAlexandria)

        let cityTrajania = City(name: "Trajania", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        cityTrajania.initialize(in: gameModel)
        gameModel.add(city: cityTrajania)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        let locationAfterTurn0 = playerTrajanWarrior.location

        // WHEN
        repeat {
            gameModel.update()

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.finishTurnButtonPressed())

        print("--- between turns ---")

        // record mission
        let locationAfterTurn1 = playerTrajanWarrior.location

        repeat {
            gameModel.update()

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.finishTurnButtonPressed())

        let locationAfterTurn2 = playerTrajanWarrior.location

        // THEN
        XCTAssertNotEqual(locationAfterTurn1, locationAfterTurn0)

        XCTAssertNotEqual(locationAfterTurn2, locationAfterTurn1)
        XCTAssertNotEqual(locationAfterTurn2, locationAfterTurn0)
    }

    func testScoutExplore() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)
        mapModel.tile(at: HexPoint(x: 18, y: 15))?.set(terrain: .ocean)

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                   handicap: .chieftain,
                                   turnsElapsed: 0,
                                   players: [playerAugustus, playerBarbarian, playerAlexander],
                                   on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units

        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 15), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: playerAugustusWarrior)

        let playerAugustusScout = Unit(at: HexPoint(x: 16, y: 15), type: .scout, owner: playerAugustus)
        gameModel.add(unit: playerAugustusScout)

        // initial city

        let cityAugustria = City(name: "Augustria", at: HexPoint(x: 15, y: 15), capital: true, owner: playerAugustus)
        cityAugustria.initialize(in: gameModel)
        gameModel.add(city: cityAugustria)

        playerAugustusWarrior.doGarrison(in: gameModel)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(area: HexPoint(x: 15, y: 15).areaWith(radius: 3), mapModel: &mapModel, by: playerAugustus, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        // WHEN
        gameModel.update()

        playerAlexander.finishTurn()
        playerAlexander.setAutoMoves(to: true)

        // THEN

        XCTAssertEqual(playerAugustusScout.location, HexPoint(x: 16, y: 12))
     }

    func testBuilderBuildsInPlace() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)
        mapModel.tile(at: HexPoint(x: 18, y: 15))?.set(terrain: .ocean)

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                   handicap: .chieftain,
                                   turnsElapsed: 0,
                                   players: [playerAugustus, playerBarbarian, playerAlexander],
                                   on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units
        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 15), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: playerAugustusWarrior)

        let playerAugustusBuilder = Unit(at: HexPoint(x: 16, y: 15), type: .builder, owner: playerAugustus)
        gameModel.add(unit: playerAugustusBuilder)

        // initial city
        let cityAugustria = City(name: "Augustria", at: HexPoint(x: 15, y: 15), capital: true, owner: playerAugustus)
        cityAugustria.initialize(in: gameModel)
        gameModel.add(city: cityAugustria)

        playerAugustusWarrior.doGarrison(in: gameModel)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(area: HexPoint(x: 15, y: 15).areaWith(radius: 3), mapModel: &mapModel, by: playerAugustus, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        // WHEN
        gameModel.update()

        playerAlexander.finishTurn()
        playerAlexander.setAutoMoves(to: true)

        // THEN
        XCTAssertEqual(mapModel.improvement(at: HexPoint(x: 16, y: 15)), .farm)
        /*if let buildMission = playerAugustusBuilder.peekMission() {
            XCTAssertEqual(buildMission.type, .build)
            XCTAssertEqual(buildMission.buildType, .farm)
        } else {
            XCTFail()
        }*/
    }

    func testBuilderBuildsSomewhere() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)
        mapModel.tile(at: HexPoint(x: 18, y: 15))?.set(terrain: .ocean)
        mapModel.set(improvement: .farm, at: HexPoint(x: 16, y: 15))

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                   handicap: .chieftain,
                                   turnsElapsed: 0,
                                   players: [playerAugustus, playerBarbarian, playerAlexander],
                                   on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units
        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 15), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: playerAugustusWarrior)

        let playerAugustusBuilder = Unit(at: HexPoint(x: 16, y: 15), type: .builder, owner: playerAugustus)
        gameModel.add(unit: playerAugustusBuilder)

        // initial city
        let cityAugustria = City(name: "Augustria", at: HexPoint(x: 15, y: 15), capital: true, owner: playerAugustus)
        cityAugustria.initialize(in: gameModel)
        gameModel.add(city: cityAugustria)

        playerAugustusWarrior.doGarrison(in: gameModel)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(area: HexPoint(x: 15, y: 15).areaWith(radius: 3), mapModel: &mapModel, by: playerAugustus, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        // WHEN
        gameModel.update()

        playerAlexander.finishTurn()
        playerAlexander.setAutoMoves(to: true)

        // THEN
        XCTAssertEqual(playerAugustusBuilder.location, HexPoint(x: 14, y: 14))
    }
}
