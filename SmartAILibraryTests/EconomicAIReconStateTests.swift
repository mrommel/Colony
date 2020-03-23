//
//  EconomicAIReconStateTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class EconomicAIReconStateTests: XCTestCase {

    var objectToTest: EconomicAI?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testReconStateNeeded() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        
        self.objectToTest = EconomicAI(player: playerAlexander)
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 1))
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 2))
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 0, y: 0))
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 0))
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 2, y: 1))
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 0, y: 2))
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 0, y: 1))
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        // WHEN
        self.objectToTest?.updateReconState(in: gameModel)
        
        // THEN
        XCTAssertEqual(self.objectToTest!.reconState(), .needed)
    }
    
    func testReconStateEnough() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        
        self.objectToTest = EconomicAI(player: playerAlexander)
        
        var mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        MapModelHelper.discover(mapModel: &mapModel, by: playerAlexander)
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        // WHEN
        self.objectToTest?.updateReconState(in: gameModel)
        
        // THEN
        XCTAssertEqual(self.objectToTest!.reconState(), .enough)
    }
}
