//
//  TileTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class TileTests: XCTestCase {

    var objectToTest: AbstractTile?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }
    
    func testImprovementsOnDesertWithoutHills() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .desert, hills: false)
        try! self.objectToTest?.set(owner: playerAlexander)
        
        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()
        
        // THEN
        XCTAssertFalse(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertFalse(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }
    
    func testImprovementsOnDesertWithHills() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .desert, hills: true)
        try! self.objectToTest?.set(owner: playerAlexander)
        
        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()
        
        // THEN
        XCTAssertFalse(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertFalse(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }
    
    func testImprovementsOnDesertWithHillsAndMiningEnabled() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        try! playerAlexander.techs!.discover(tech: .mining)
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .desert, hills: true)
        try! self.objectToTest?.set(owner: playerAlexander)
        
        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()
        
        // THEN
        XCTAssertFalse(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertTrue(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }
    
    func testImprovementsOnGrasslandWithoutHills() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        self.objectToTest = Tile(point: HexPoint(x: 0, y: 0), terrain: .grass, hills: false)
        try! self.objectToTest?.set(owner: playerAlexander)
        
        // WHEN
        let improvements = self.objectToTest?.possibleImprovements()
        
        // THEN
        XCTAssertTrue(improvements!.contains(.farm))
        XCTAssertFalse(improvements!.contains(.camp))
        XCTAssertFalse(improvements!.contains(.mine))
        XCTAssertFalse(improvements!.contains(.pasture))
        XCTAssertFalse(improvements!.contains(.quarry))
    }
}
