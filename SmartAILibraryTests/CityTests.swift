//
//  CityTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class CityTests: XCTestCase {

    var objectToTest: AbstractCity?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testNoCityGrowth() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAugustus, playerAlexander], on: mapModel)
        
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        
        // WHEN
        let _ = self.objectToTest?.turn(in: gameModel)
        let notifications = playerAlexander.notifications()?.notifications()
        
        // THEN
        XCTAssertEqual(self.objectToTest!.population(), 1)
        XCTAssertEqual(notifications?.count, 1) // don't notify user about any change
    }
    
    func testOneCityGrowth() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        centerTile?.set(improvement: .farm)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAugustus, playerAlexander], on: mapModel)
        
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        self.objectToTest?.set(foodBasket: 20)
        
        // WHEN
        let _ = self.objectToTest?.turn(in: gameModel)
        let notifications = playerAlexander.notifications()?.notifications()
        
        // THEN
        XCTAssertEqual(self.objectToTest!.population(), 2)
        XCTAssertEqual(notifications?.count, 2) // notify user about growth
    }
    
    func testYields() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        
        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)
        
        // center
        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        centerTile?.set(improvement: .farm)
        
        // another
        let anotherTile = mapModel.tile(at: HexPoint(x: 1, y: 2))
        anotherTile?.set(terrain: .plains)
        anotherTile?.set(hills: true)
        anotherTile?.set(improvement: .mine)
        
        // WHEN
        let foodYield = self.objectToTest?.foodPerTurn(in: gameModel)
        let productionYield = self.objectToTest?.productionPerTurn(in: gameModel)
        let goldYield = self.objectToTest?.goldPerTurn(in: gameModel)
        
        // THEN
        XCTAssertEqual(foodYield, 4.0)
        XCTAssertEqual(productionYield, 2.0)
        XCTAssertEqual(goldYield, 6.0)
        
        /*XCTAssertEqual(yields?.culture, 2.6)
        XCTAssertEqual(yields?.science, 4.0)
        XCTAssertEqual(yields?.faith, 1.0)
        
        XCTAssertEqual(yields?.housing, 1.0)*/
    }
    
    func testBuildGranary() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        try! playerAlexander.techs?.discover(tech: .pottery)
        try! playerAlexander.techs?.discover(tech: .masonry)
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        
        self.objectToTest?.set(population: 1, reassignCitizen: false, in: gameModel)
        
        // WHEN
        let _ = self.objectToTest?.turn(in: gameModel)
        let current = self.objectToTest!.currentBuildableItem()
        
        // THEN
        XCTAssertEqual(current?.type, .building)
        XCTAssertEqual(current?.buildingType, .granary)
    }
    
    func testBuildWalls() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        try! playerAlexander.techs?.discover(tech: .pottery)
        try! playerAlexander.techs?.discover(tech: .masonry)
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        try! self.objectToTest?.buildings?.build(building: .monument)
        try! self.objectToTest?.buildings?.build(building: .granary)
        
        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)
        
        // WHEN
        let _ = self.objectToTest?.turn(in: gameModel)
        let current = self.objectToTest!.currentBuildableItem()
        
        // THEN
        XCTAssertEqual(current?.type, .building)
        XCTAssertEqual(current?.buildingType, .ancientWalls)
    }
    
    func testCityAquiredTiles() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        // WHEN
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        mapModel.add(city: self.objectToTest, in: gameModel)

        // THEN
        for cityPoint in HexPoint(x: 1, y: 1).areaWith(radius: 1) {
            
            guard let tile = mapModel.tile(at: cityPoint) else {
                fatalError("cant get tile")
            }
            
            XCTAssertEqual(tile.hasOwner(), true, "for \(cityPoint)")
            XCTAssertEqual(tile.owner()?.leader, playerAlexander.leader)
        }
    }
}
