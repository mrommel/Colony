//
//  DiplomacyAITests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 08.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable type_body_length
class DiplomacyAITests: XCTestCase {

    func testMilitaryStrengthPlayerNotMet() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // WHEN
        gameModel.update() // .doTurn()
        let militaryStrength = playerAlexander.diplomacyAI!.militaryStrength(of: playerTrajan)

        // THEN
        XCTAssertEqual(militaryStrength, .average)
    }

    func testMilitaryStrengthPlayerMet() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerTrajan), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 1), type: .warrior, owner: playerTrajan), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 2), type: .warrior, owner: playerTrajan), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.diplomacyAI?.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)

        // WHEN
        gameModel.update() // .doTurn()
        let militaryStrength = playerAlexander.diplomacyAI!.militaryStrength(of: playerTrajan)

        // THEN
        XCTAssertEqual(militaryStrength, .immense)
    }

    func testProximityNoCitiesClose() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerTrajan), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        repeat {
            gameModel.update() // this runs one player at a time

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let proximity = playerAlexander.diplomacyAI!.proximity(to: playerTrajan)

        // THEN
        XCTAssertEqual(proximity, .far)
    }

    func testProximityTwoCitiesFar() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 10), type: .warrior, owner: playerAlexander), in: gameModel)
        let cityAlexander = City(name: "Alexander", at: HexPoint(x: 0, y: 10), capital: true, owner: playerAlexander)
        cityAlexander.initialize(in: gameModel)
        mapModel.add(city: cityAlexander, in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 19, y: 10), type: .warrior, owner: playerTrajan), in: gameModel)
        let cityAugustus = City(name: "Augustus", at: HexPoint(x: 19, y: 10), capital: true, owner: playerTrajan)
        cityAugustus.initialize(in: gameModel)
        mapModel.add(city: cityAugustus, in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        repeat {
            gameModel.update() // this runs one player at a time

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let proximity = playerAlexander.diplomacyAI!.proximity(to: playerTrajan)

        // THEN
        XCTAssertEqual(proximity, .far)
    }

    func testProximityTwoCitiesClose() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 8, y: 10), type: .warrior, owner: playerAlexander), in: gameModel)
        let cityAlexander = City(name: "Alexander", at: HexPoint(x: 8, y: 10), capital: true, owner: playerAlexander)
        cityAlexander.initialize(in: gameModel)
        mapModel.add(city: cityAlexander, in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 12, y: 10), type: .warrior, owner: playerTrajan), in: gameModel)
        let cityAugustus = City(name: "Augustus", at: HexPoint(x: 12, y: 10), capital: true, owner: playerTrajan)
        cityAugustus.initialize(in: gameModel)
        mapModel.add(city: cityAugustus, in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        repeat {
            gameModel.update() // this runs one player at a time

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let proximity = playerAlexander.diplomacyAI!.proximity(to: playerTrajan)

        // THEN
        XCTAssertEqual(proximity, .far)
    }

    func testApproachInitially() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerTrajan), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.diplomacyAI?.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)

        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)

        repeat {
            gameModel.update() // this runs one player at a time

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)

        // THEN
        XCTAssertEqual(approachBefore, .none)
        XCTAssertEqual(approachAfter, .neutrally)
    }

    func testApproachAfterDeclarationOfFriendship() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerTrajan), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.diplomacyAI?.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)

        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)
        playerAlexander.diplomacyAI?.doDeclarationOfFriendship(with: playerTrajan, in: gameModel)

        repeat {
            gameModel.update() // this runs one player at a time

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)

        // THEN
        XCTAssertEqual(approachBefore, .none)
        XCTAssertEqual(approachAfter, .friendly)
    }

    func testApproachAfterDenouncement() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerTrajan), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)
        playerAlexander.diplomacyAI?.doDenounce(player: playerTrajan, in: gameModel)

        repeat {
            gameModel.update() // this runs one player at a time

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)

        // THEN
        XCTAssertEqual(approachBefore, .none)
        let resultList: [PlayerApproachType] = [.hostile, .war]
        XCTAssertTrue(resultList.contains(approachAfter))
    }

    func testApproachAfterDeclarationOfWar() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerTrajan), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.diplomacyAI?.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)

        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)
        playerAlexander.doDeclareWar(to: playerTrajan, in: gameModel)

        repeat {
            gameModel.update() // this runs one player at a time

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerTrajan)

        // THEN
        XCTAssertEqual(approachBefore, .none)
        XCTAssertEqual(approachAfter, .war)
    }

    func testDefensivePact() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // WHEN
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerAlexander.doDefensivePact(with: playerTrajan, in: gameModel)
        let defensivePact1 = playerAlexander.isDefensivePactActive(with: playerTrajan)
        let defensivePact2 = playerTrajan.isDefensivePactActive(with: playerAlexander)

        // THEN
        XCTAssertEqual(defensivePact1, true)
        XCTAssertEqual(defensivePact2, true)
    }

    func testDeclarationOfWarTriggersDefensivePact() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerVictoria = Player(leader: .victoria, isHuman: true)
        playerVictoria.initialize()

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
            players: [playerBarbar, playerAlexander, playerAugustus, playerVictoria],
            on: mapModel
        )

        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // all players have meet with another
        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        playerAugustus.doFirstContact(with: playerVictoria, in: gameModel)
        playerVictoria.doFirstContact(with: playerAlexander, in: gameModel)

        playerVictoria.doDefensivePact(with: playerAugustus, in: gameModel)

        // WHEN
        playerAlexander.doDeclareWar(to: playerAugustus, in: gameModel)
        // gameModel.turn()
        let approachAlexanderAugustus = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        let approachAlexanderElizabeth = playerAlexander.diplomacyAI!.approach(towards: playerVictoria)

        let approachAugustusAlexander = playerAugustus.diplomacyAI!.approach(towards: playerAlexander)
        let approachElizabethAlexander = playerVictoria.diplomacyAI!.approach(towards: playerAlexander)

        // THEN
        XCTAssertEqual(approachAlexanderAugustus, .war)
        XCTAssertEqual(approachAlexanderElizabeth, .war)
        XCTAssertEqual(approachAugustusAlexander, .war) // has been declared war
        XCTAssertEqual(approachElizabethAlexander, .war) // defensive pact
    }

    func testDeclarationOfWar() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

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
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // all players have meet with another
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        playerAlexander.doDeclareWar(to: playerTrajan, in: gameModel)

        // THEN
        let isAtWar = playerAlexander.isAtWar(with: playerTrajan)
        XCTAssertEqual(isAtWar, true)
    }
}
