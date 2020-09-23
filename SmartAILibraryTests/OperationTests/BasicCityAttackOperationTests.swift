//
//  BasicCityAttackOperationTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 22.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class BasicCityAttackOperationTests: XCTestCase {
    
    func testAbc() {
        
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
                                  turnsElapsed: 0,
                                  players: [playerBarbarian, playerTrajan, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface
        
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
        
        // check
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 15, y: 8))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 20, y: 24))?.isWater(), false)
        XCTAssertEqual(gameModel.tile(at: HexPoint(x: 35, y: 24))?.isWater(), false)
        
        // initial units
        let playerTrajanWarrior = Unit(at: HexPoint(x: 20, y: 25), type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior)
        
        let playerTrajanArcher = Unit(at: HexPoint(x: 20, y: 25), type: .archer, owner: playerTrajan)
        gameModel.add(unit: playerTrajanArcher)
        
        let playerTrajanSettler = Unit(at: HexPoint(x: 21, y: 25), type: .settler, owner: playerTrajan)
        gameModel.add(unit: playerTrajanSettler)
        
        let playerAlexanderWarrior = Unit(at: HexPoint(x: 35, y: 20), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)
        
        let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 7), type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior)
        
        // this is cheating
        MapModelHelper.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapModelHelper.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)
        
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        
        playerAlexander.diplomacyAI?.doDeclareWar(to: playerTrajan, in: gameModel)
        
        // WHEN
        while !playerAlexander.canFinishTurn() {
            gameModel.update()
            print("::: --- loop --- :::")
        }
        playerAlexander.endTurn(in: gameModel)
        
        // THEN
        // DEBUG: po playerAlexander.operations!.operations
        XCTAssertEqual(playerAlexander.operations?.operationsOf(type: .basicCityAttack).count, 1)
    }
}
