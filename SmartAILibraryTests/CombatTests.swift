//
//  CombatTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class CombatTests: XCTestCase {

    func testCombatWarriorAgainstWarrior() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let defender = Unit(at: HexPoint(x: 6, y: 6), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: attacker)

        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: defender, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 27)
        XCTAssertEqual(result.defenderDamage, 31)
    }

    func testCombatWarriorAgainstCity() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let city = City(name: "Berlin", at: HexPoint(x: 5, y: 5), owner: playerAugustus)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 22)
        XCTAssertEqual(result.defenderDamage, 44)
        XCTAssertEqual(city.maxHealthPoints(), 200)
    }

    func testCombatWarriorAgainstCityWithWalls() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        try! playerAugustus.techs?.discover(tech: .masonry)

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let city = City(name: "Berlin", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAugustus)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        city.startBuilding(building: .ancientWalls)
        city.updateProduction(for: 200, in: gameModel)

        for _ in 0..<30 {
            city.turn(in: gameModel)
        }

        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 22)
        XCTAssertEqual(result.defenderDamage, 16)
        XCTAssertEqual(city.maxHealthPoints(), 300)
    }

    func testCombatCityRangedAgainstWarrior() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)

        let attacker = City(name: "Berlin", at: HexPoint(x: 5, y: 5), owner: playerAugustus)
        attacker.initialize(in: gameModel)
        gameModel.add(city: attacker)

        let defender = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: defender)

        // WHEN
        let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 0)
        XCTAssertEqual(result.defenderDamage, 22)
    }

    func testCombatRangeArcherAgainstCity() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .archer, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let city = City(name: "Berlin", at: HexPoint(x: 5, y: 5), owner: playerAugustus)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        // WHEN
        let result = Combat.predictRangedAttack(between: attacker, and: city, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 0)
        XCTAssertEqual(result.defenderDamage, 30)
        XCTAssertEqual(city.maxHealthPoints(), 200)
    }

    func testCombatRangeOneArcherAgainstWarrior() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .archer, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let defender = Unit(at: HexPoint(x: 6, y: 6), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: defender)

        // WHEN
        let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 0)
        XCTAssertEqual(result.defenderDamage, 41)
    }

    func testCombatRangeTwoArcherAgainstWarrior() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .archer, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let defender = Unit(at: HexPoint(x: 7, y: 6), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: defender)

        // WHEN
        let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 0)
        XCTAssertEqual(result.defenderDamage, 41)
    }
}
