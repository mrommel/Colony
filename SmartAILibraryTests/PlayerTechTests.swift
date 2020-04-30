//
//  PlayerTechTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class PlayerTechTests: XCTestCase {

    var objectToTest: AbstractPlayer?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    /*func testScienceDiscoveredNotification() {
        
        // GIVEN
        self.objectToTest = Player(leader: .alexander, isHuman: true)
        self.objectToTest?.initialize()
        try! self.objectToTest?.techs?.setCurrent(tech: .mining, in: <#GameModel?#>)
        
        let mapModel = MapModel(size: .standard)
        let gameModel = GameModel(victoryTypes: [], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!], on: mapModel)
        
        // WHEN
        self.objectToTest?.techs?.add(science: 300)
        try! self.objectToTest?.techs?.checkScienceProgress(in: gameModel)
        let messages = gameModel.messages()
        
        // THEN
        XCTAssertTrue(self.objectToTest!.has(tech: .mining))
        XCTAssertEqual(messages.count, 1) // notify user about new science
    }
    
    func testEraReachedNotification() {
        
        // GIVEN
        self.objectToTest = Player(leader: .alexander, isHuman: true)
        self.objectToTest?.initialize()
        try! self.objectToTest?.techs?.discover(tech: .pottery)
        try! self.objectToTest?.techs?.discover(tech: .writing)
        try! self.objectToTest?.techs?.setCurrent(tech: .currency)
        
        let mapModel = MapModel(size: .standard)
        let gameModel = GameModel(victoryTypes: [], turnsElapsed: 0, players: [self.objectToTest!], on: mapModel)
        
        // WHEN
        self.objectToTest?.techs?.add(science: 300)
        try! self.objectToTest?.techs?.checkScienceProgress(in: gameModel)
        let messages = gameModel.messages()
        
        // THEN
        XCTAssertTrue(self.objectToTest!.has(tech: .currency))
        XCTAssertEqual(self.objectToTest!.currentEra(), .classical)
        XCTAssertEqual(self.objectToTest?.techs?.currentTech(), nil)
        XCTAssertEqual(messages.count, 2) // notify user about new science and new era
    }*/
}
