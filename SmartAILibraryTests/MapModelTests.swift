//
//  MapModelTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class MapModelTests: XCTestCase {

    var objectToTest: MapModel?
    
    override func setUp() {
    }

    override func tearDown() {
        
        self.objectToTest = nil
    }

    func testNoContinents() {
        
        // GIVEN
        self.objectToTest = MapModelHelper.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12))
        
        // WHEN
        self.objectToTest?.analyze()
        let continents = self.objectToTest!.continents
        let oceans = self.objectToTest!.oceans
        
        // THEN
        XCTAssertEqual(continents.count, 0)
        XCTAssertEqual(oceans.count, 1)
    }
    
    func testNoOceans() {
        
        // GIVEN
        self.objectToTest = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 16, height: 12))
        
        // WHEN
        self.objectToTest?.analyze()
        let continents = self.objectToTest!.continents
        let oceans = self.objectToTest!.oceans
        
        // THEN
        XCTAssertEqual(continents.count, 1)
        XCTAssertEqual(oceans.count, 0)
    }
    
    func testTwoContinents() {
        
        // GIVEN
        self.objectToTest = MapModelHelper.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12))
        
        // continent 1
        let continentOneArea = HexArea(center: HexPoint(x: 1, y: 9), radius: 2)
        MapModelHelper.add(area: continentOneArea, with: .grass, to: self.objectToTest)
        
        // continent 2
        let continentTwoArea = HexArea(center: HexPoint(x: 14, y: 8), radius: 2)
        MapModelHelper.add(area: continentTwoArea, with: .grass, to: self.objectToTest)
        
        // WHEN
        self.objectToTest?.analyze()
        let continents = self.objectToTest!.continents
        let oceans = self.objectToTest!.oceans
        
        // THEN
        XCTAssertEqual(continents.count, 2)
        XCTAssertEqual(oceans.count, 1)
    }
    
    func testCanSeeThru() {
        
        // GIVEN
        self.objectToTest = MapModelHelper.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12))
        
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let tile = Tile(point: HexPoint(x: 0, y: 0), terrain: .grass, hills: false)
        self.objectToTest!.set(tile: tile, at: HexPoint(x: 0, y: 0))
        
        let target = Tile(point: HexPoint(x: 3, y: 2), terrain: .grass, hills: false)
        self.objectToTest!.set(tile: tile, at: HexPoint(x: 3, y: 2))
        
        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  turnsElapsed: 0,
                                  players: [playerAlexander],
                                  on: self.objectToTest!)
        
        // WHEN
        let canSee = tile.canSee(tile: target, for: playerAlexander, range: 4, in: gameModel)
        
        // THEN
        XCTAssertEqual(canSee, true)
    }
    
    func testCantSeeThru() {
        
        // GIVEN
        self.objectToTest = MapModelHelper.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12))
        
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let tile = Tile(point: HexPoint(x: 0, y: 0), terrain: .grass, hills: false)
        self.objectToTest!.set(tile: tile, at: HexPoint(x: 0, y: 0))
        
        // obstacle
        let obstacle1 = Tile(point: HexPoint(x: 1, y: 1), terrain: .grass, hills: false)
        obstacle1.set(feature: .mountains)
        self.objectToTest!.set(tile: obstacle1, at: HexPoint(x: 1, y: 1))
        
        let obstacle2 = Tile(point: HexPoint(x: 0, y: 1), terrain: .grass, hills: false)
        obstacle2.set(feature: .mountains)
        self.objectToTest!.set(tile: obstacle2, at: HexPoint(x: 0, y: 1))
        
        let obstacle3 = Tile(point: HexPoint(x: 1, y: 0), terrain: .grass, hills: false)
        obstacle3.set(feature: .mountains)
        self.objectToTest!.set(tile: obstacle3, at: HexPoint(x: 1, y: 0))
        
        let target = Tile(point: HexPoint(x: 3, y: 2), terrain: .grass, hills: false)
        self.objectToTest!.set(tile: tile, at: HexPoint(x: 3, y: 2))
        
        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  turnsElapsed: 0,
                                  players: [playerAlexander],
                                  on: self.objectToTest!)
        
        // WHEN
        let canSee = tile.canSee(tile: target, for: playerAlexander, range: 4, in: gameModel)
        
        // THEN
        XCTAssertEqual(canSee, false)
    }
    
    func testAquireTileDirectly() {
        
        // GIVEN
        self.objectToTest = MapModelHelper.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12))
        
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let tile = Tile(point: HexPoint(x: 0, y: 0), terrain: .grass, hills: false)
        self.objectToTest!.set(tile: tile, at: HexPoint(x: 0, y: 0))
        
        // WHEN
        try! tile.set(owner: playerAlexander)
        
        // THEN
        XCTAssertEqual(tile.hasOwner(), true)
        XCTAssertEqual(tile.owner()?.leader, playerAlexander.leader)
    }
    
    func testAquireTileIndirectly() {
        
        // GIVEN
        self.objectToTest = MapModelHelper.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12))
        
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let tile = Tile(point: HexPoint(x: 0, y: 0), terrain: .grass, hills: false)
        self.objectToTest!.set(tile: tile, at: HexPoint(x: 0, y: 0))
        
        // WHEN
        try! self.objectToTest?.set(owner: playerAlexander, at: HexPoint(x: 0, y: 0))
        
        // THEN
        XCTAssertEqual(tile.hasOwner(), true)
        XCTAssertEqual(tile.owner()?.leader, playerAlexander.leader)
    }
}
