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

    func testCombatWarriorAgainstCity() {
        
        // GIVEN
        
        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        
        // player 2
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)
        
        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)
        
        let city = City(name: "Berlin", at: HexPoint(x: 5, y: 5), owner: playerAugustus)
        city.initialize()
        gameModel.add(city: city)
        
        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)
        
        // THEN
        XCTAssertEqual(result.defenderDamage, 39)
        XCTAssertEqual(city.maxHealthPoints(), 200)
    }
    
    func testCombatWarriorAgainstCityWithWalls() {
        
        // GIVEN
        
        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        
        // player 2
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)
        
        let attacker = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: attacker)
        
        let city = City(name: "Berlin", at: HexPoint(x: 5, y: 5), owner: playerAugustus)
        city.initialize()
        city.build(building: .ancientWalls)
        gameModel.add(city: city)
        
        // WHEN
        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)
        
        // THEN
        XCTAssertEqual(result.defenderDamage, 39)
        XCTAssertEqual(city.maxHealthPoints(), 300)
    }
    
    func testCombatCityRangedAgainstWarrior() {
        
        // GIVEN
        
        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        
        // player 2
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus],
                                  on: mapModel)
        
        let attacker = City(name: "Berlin", at: HexPoint(x: 5, y: 5), owner: playerAugustus)
        attacker.initialize()
        gameModel.add(city: attacker)
        
        let defender = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: defender)
        
        // WHEN
        let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)
        
        // THEN
        XCTAssertEqual(result.defenderDamage, 27)
    }
}
