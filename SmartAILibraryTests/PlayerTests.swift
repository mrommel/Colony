//
//  PlayerTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 29.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class PlayerTests: XCTestCase {

    func testSpawnProphet() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

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

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units
        let playerAlexanderWarrior = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)

        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 16), type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerAugustusWarrior)

        // cities
        let cityAlexandria = City(name: "Alexandria", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAlexander)
        cityAlexandria.initialize(in: gameModel)
        gameModel.add(city: cityAlexandria)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: barbarianPlayer, in: gameModel)

        let greatPersonPoints = GreatPersonPoints(
            greatGeneral: 0,
            greatAdmiral: 0,
            greatEngineer: 0,
            greatMerchant: 0,
            greatProphet: 200,
            greatScientist: 0,
            greatWriter: 0,
            greatArtist: 0,
            greatMusician: 0
        )
        playerAlexander.greatPeople?.add(points: greatPersonPoints)
        playerAlexander.religion?.foundPantheon(with: .cityPatronGoddess, in: gameModel)
        let numProphetsBefore = gameModel.units(of: playerAlexander).filter { $0?.type == .prophet }.count

        // WHEN
        repeat {
            gameModel.update()

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        // THEN
        XCTAssertEqual(numProphetsBefore, 0)
        let numProphetsAfter = gameModel.units(of: playerAlexander).filter { $0?.type == .prophet }.count
        XCTAssertEqual(numProphetsAfter, 1)
    }

    func testWarWearinessDistribution() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // cities
        let cityRome = City(name: "Rome", at: HexPoint(x: 2, y: 8), capital: true, owner: playerTrajan)
        cityRome.initialize(in: gameModel)
        gameModel.add(city: cityRome)

        let cityPompeij = City(name: "Pompeij", at: HexPoint(x: 8, y: 8), capital: false, owner: playerTrajan)
        cityPompeij.initialize(in: gameModel)
        gameModel.add(city: cityPompeij)

        let cityBrunsidi = City(name: "Brunsidi", at: HexPoint(x: 8, y: 8), capital: false, owner: playerTrajan)
        cityBrunsidi.initialize(in: gameModel)
        gameModel.add(city: cityBrunsidi)

        cityRome.set(population: 8, in: gameModel)
        cityPompeij.set(population: 3, in: gameModel)
        cityBrunsidi.set(population: 2, in: gameModel)

        playerTrajan.doFirstContact(with: playerAlexander, in: gameModel)
        playerTrajan.changeWarWeariness(with: playerAlexander, by: 1700) // => 4 amenities needed

        // WHEN
        playerTrajan.doCityAmenities(in: gameModel)

        // THEN
        XCTAssertEqual(cityRome.amenitiesForWarWeariness(), 2)
        XCTAssertEqual(cityPompeij.amenitiesForWarWeariness(), 1)
        XCTAssertEqual(cityBrunsidi.amenitiesForWarWeariness(), 1)
    }

    func testAssignEnvoyAndBecomeSuzerain() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerTrajan.changeEnvoys(by: 3)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainBefore = playerAmsterdam.suzerain()

        // WHEN
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainAfter = playerAmsterdam.suzerain()

        // THEN
        XCTAssertNil(suzerainBefore)
        XCTAssertEqual(suzerainAfter, .trajan)
    }

    func testAssignEnvoyAndDontBecomeSuzerain() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.changeEnvoys(by: 3)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)

        playerTrajan.changeEnvoys(by: 3)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainBefore = playerAmsterdam.suzerain()

        // WHEN
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainAfter = playerAmsterdam.suzerain()

        // THEN
        XCTAssertEqual(suzerainBefore, .alexander)
        XCTAssertNil(suzerainAfter)
    }

    func testAssignEnvoyAndReplaceSuzerain() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.changeEnvoys(by: 3)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)

        playerTrajan.changeEnvoys(by: 4)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainBefore = playerAmsterdam.suzerain()

        // WHEN
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainAfter = playerAmsterdam.suzerain()

        // THEN
        XCTAssertEqual(suzerainBefore, .alexander)
        XCTAssertEqual(suzerainAfter, .trajan)
    }

    func testUnassignEnvoyAndLooseSuzerain() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerTrajan.changeEnvoys(by: 3)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainBefore = playerAmsterdam.suzerain()

        // WHEN
        playerTrajan.unassignEnvoy(from: .amsterdam, in: gameModel)
        let suzerainAfter = playerAmsterdam.suzerain()

        // THEN
        XCTAssertEqual(suzerainBefore, .trajan)
        XCTAssertNil(suzerainAfter)
    }

    func testUnassignEnvoyAndGetReplacedSuzerain() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.changeEnvoys(by: 3)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)

        playerTrajan.changeEnvoys(by: 4)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        playerTrajan.assignEnvoy(to: .amsterdam, in: gameModel)
        let suzerainBefore = playerAmsterdam.suzerain()

        // WHEN
        playerTrajan.unassignEnvoy(from: .amsterdam, in: gameModel)
        playerTrajan.unassignEnvoy(from: .amsterdam, in: gameModel)
        let suzerainAfter = playerAmsterdam.suzerain()

        // THEN
        XCTAssertEqual(suzerainBefore, .trajan)
        XCTAssertEqual(suzerainAfter, .alexander)
    }
}
