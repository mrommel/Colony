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

// swiftlint:disable force_try

class CombatTests: XCTestCase {

    func testCombatWarriorAgainstWarrior() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let defender = Unit(at: HexPoint(x: 6, y: 6), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: attacker)

        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: defender, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 26)
        XCTAssertEqual(result.defenderDamage, 33)
    }

    func testCombatWarriorAgainstWarriorWithFlanking() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        try! playerAlexander.civics?.discover(civic: .militaryTradition, in: gameModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let flanking = Unit(at: HexPoint(x: 5, y: 5), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: flanking)

        let defender = Unit(at: HexPoint(x: 6, y: 5), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: attacker)

        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: defender, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 24)
        XCTAssertEqual(result.defenderDamage, 36)
    }

    func testCombatWarriorAgainstCity() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let city = City(name: "Berlin", at: HexPoint(x: 5, y: 5), owner: playerAugustus)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 22)
        XCTAssertEqual(result.defenderDamage, 48)
        XCTAssertEqual(city.maxHealthPoints(), 200)
    }

    func testCombatWarriorAgainstCityWithWalls() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        try! playerAugustus.techs?.discover(tech: .masonry, in: gameModel)

        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)

        let city = City(name: "Berlin", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAugustus)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        city.startBuilding(building: .ancientWalls)
        city.updateProduction(for: 200, in: gameModel)

        for _ in 0..<30 {
            city.doTurn(in: gameModel)
        }

        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)

        // THEN
        XCTAssertEqual(result.attackerDamage, 22)
        XCTAssertEqual(result.defenderDamage, 17)
        XCTAssertEqual(city.maxHealthPoints(), 300)
    }

    func testCombatCityRangedAgainstWarrior() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

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

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

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

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

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

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

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
