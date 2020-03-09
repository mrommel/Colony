//
//  GrandStrategyAITests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GrandStrategyAITests: XCTestCase {

    var objectToTest: GrandStrategyAI?
    
    override func setUp() {
    }

    override func tearDown() {
        
        self.objectToTest = nil
    }

    func testInitialStateIsConquestForAlexander() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        let playerElizabeth = Player(leader: .elizabeth)
        playerElizabeth.initialize()
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], turnsElapsed: 0, players: [playerAugustus, playerAlexander, playerElizabeth], on: mapModel)
        
        // augustus has met alexander
        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        
        // augustus has met elizabeth
        playerAugustus.doFirstContact(with: playerElizabeth, in: gameModel)
        
        // elizabeth and alexander never met
        
        self.objectToTest = GrandStrategyAI(player: playerAlexander)
        
        // WHEN
        self.objectToTest?.turn(with: gameModel)
        
        // THEN
        XCTAssertEqual(self.objectToTest!.activeStrategy, .conquest)
    }
    
    func testInitialStateIsConquestForAugustus() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        let playerElizabeth = Player(leader: .elizabeth)
        playerElizabeth.initialize()
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], turnsElapsed: 0, players: [playerAugustus, playerAlexander, playerElizabeth], on: mapModel)
        
        // augustus has met alexander
        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        
        // augustus has met elizabeth
        playerAugustus.doFirstContact(with: playerElizabeth, in: gameModel)
        
        // elizabeth and alexander never met
        
        self.objectToTest = GrandStrategyAI(player: playerAugustus)
        
        // WHEN
        //for i in 0..<100 {
        self.objectToTest?.turn(with: gameModel)
        //}
        
        // THEN
        XCTAssertEqual(self.objectToTest!.activeStrategy, .culture)
    }
}
