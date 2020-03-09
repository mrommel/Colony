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

class HumanUserTests: XCTestCase {

    func testReal() {
        
        // GIVEN
        
        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        
        // player 2
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()
        
        // map
        var mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)
        
        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  turnsElapsed: 0,
                                  players: [playerAlexander, playerAugustus, playerBarbarian],
                                  on: mapModel)
        
        // initial units
        let playerAlexanderSettler = Unit(at: HexPoint(x: 5, y: 5), type: .settler, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderSettler)
        
        let playerAlexanderWarrior = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)
        
        let playerAugustusSettler = Unit(at: HexPoint(x: 15, y: 15), type: .settler, owner: playerAugustus)
        gameModel.add(unit: playerAugustusSettler)
        
        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 16), type: .warrior, owner: playerAugustus)
        gameModel.add(unit: playerAugustusWarrior)
        
        let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 10), type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior)
        
        // this is cheating
        MapModelHelper.discover(mapModel: &mapModel, by: playerAlexander)
        MapModelHelper.discover(mapModel: &mapModel, by: playerAugustus)
        MapModelHelper.discover(mapModel: &mapModel, by: playerBarbarian)
        
        // WHEN
        gameModel.turn()
        let numCities = gameModel.cities(of: playerAugustus).count
        
        // THEN
        XCTAssertEqual(numCities, 1)
    }
}
