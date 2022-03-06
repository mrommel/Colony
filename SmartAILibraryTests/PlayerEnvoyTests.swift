//
//  PlayerEnvoyTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 05.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class PlayerEnvoyTests: XCTestCase {

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

    func testEnvoyEffects() {

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
        playerAlexander.doFirstContact(with: playerAmsterdam, in: gameModel)
        let effectsBefore = playerAlexander.envoyEffects(in: gameModel)

        // WHEN
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        playerAlexander.assignEnvoy(to: .amsterdam, in: gameModel)
        let effectsAfter = playerAlexander.envoyEffects(in: gameModel)

        // THEN
        XCTAssertEqual(effectsBefore.count, 0)
        XCTAssertEqual(effectsAfter.count, 3)

        guard let firstEffect = effectsAfter.first else {
            XCTFail("cant get first effect")
            return
        }
        XCTAssertEqual(firstEffect.cityState, .amsterdam)
        XCTAssertEqual(firstEffect.level, .first)

        guard let secondEffect = effectsAfter.second else {
            XCTFail("cant get second effect")
            return
        }
        XCTAssertEqual(secondEffect.cityState, .amsterdam)
        XCTAssertEqual(secondEffect.level, .third)

        guard let thirdEffect = effectsAfter.third else {
            XCTFail("cant get third effect")
            return
        }
        XCTAssertEqual(thirdEffect.cityState, .amsterdam)
        XCTAssertEqual(thirdEffect.level, .suzerain)
    }
}
