//
//  GovernmentTypeTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GovernmentTypeTests: XCTestCase {

    var objectToTest: AbstractGovernment?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testInitial() {
        
        // GIVEN
        let player = Player(leader: .alexander, isHuman: true)
        player.initialize()
        self.objectToTest = Government(player: player)
        
        // WHEN
        let initialGovernment = self.objectToTest?.currentGovernment()
        
        // THEN
        XCTAssertNil(initialGovernment)
    }
    
    func testCurrentGovernment() {
        
        // GIVEN
        let player = Player(leader: .alexander, isHuman: true)
        player.initialize()
        self.objectToTest = Government(player: player)
        self.objectToTest?.set(governmentType: .chiefdom)
        
        // WHEN
        let chiefdomGovernment = self.objectToTest?.currentGovernment()
        
        // THEN
        XCTAssertEqual(chiefdomGovernment, .chiefdom)
    }
    
    func testChooseBestGovernmentInitial() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.government
        
        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)
        
        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface
        
        // WHEN
        self.objectToTest?.chooseBestGovernment(in: gameModel)
        
        // THEN
        let chiefdomGovernment = self.objectToTest?.currentGovernment()
        XCTAssertEqual(chiefdomGovernment, nil)
    }
    
    func testChooseBestGovernmentCodeOfLaw() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.government
        
        try! playerAlexander.civics?.discover(civic: .codeOfLaws)
        
        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)
        
        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface
        
        // WHEN
        self.objectToTest?.chooseBestGovernment(in: gameModel)
        
        // THEN
        let chiefdomGovernment = self.objectToTest?.currentGovernment()
        XCTAssertEqual(chiefdomGovernment, .chiefdom)
        
        let hasSurvey = self.objectToTest?.has(card: .survey)
        let hasGodKing = self.objectToTest?.has(card: .godKing)
        XCTAssertEqual(hasSurvey, true)
        XCTAssertEqual(hasGodKing, true)
    }
}
