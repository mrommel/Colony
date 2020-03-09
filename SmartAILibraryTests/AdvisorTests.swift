//
//  AdvisorTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class AdvisorTests: XCTestCase {

    var objectToTest: AbstractCity?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testMessagesAfterInitialTurn() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        
        // setup the map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .small)
        
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 1))
        try! mapModel.set(owner: playerAlexander, at: HexPoint(x: 1, y: 1))
        try! mapModel.build(improvement: .farm, at: HexPoint(x: 1, y: 1))
        
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 1, y: 2))
        try! mapModel.set(owner: playerAlexander, at: HexPoint(x: 1, y: 2))
        try! mapModel.build(improvement: .farm, at: HexPoint(x: 1, y: 2))
        
        // add the city to the map
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize()
        self.objectToTest?.set(population: 2)
        
        try! mapModel.setWorked(by: self.objectToTest, at: HexPoint(x: 1, y: 2))
        
        mapModel.add(city: self.objectToTest)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        // WHEN
        gameModel.turn()
        let messages = playerAlexander.advisorMessages()
        
        // THEN
        XCTAssertEqual(messages.count, 0)
    }
    
    func testMessagesAfter30Turns() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        playerAugustus.government?.set(governmentType: .autocracy)
        try! playerAugustus.techs?.discover(tech: .mining)
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel) //MapModel(size: .standard)
        
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize()
        self.objectToTest?.set(population: 2)
        
        mapModel.add(city: self.objectToTest)
        
        // center
        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        try! centerTile?.set(owner: playerAlexander)
        try! centerTile?.build(improvement: .farm)
        
        // another
        let anotherTile = mapModel.tile(at: HexPoint(x: 1, y: 2))
        anotherTile?.set(terrain: .plains)
        anotherTile?.set(hills: true)
        try! anotherTile?.set(owner: playerAlexander)
        try! self.objectToTest?.work(tile: anotherTile!)
        try! anotherTile?.build(improvement: .mine)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        // WHEN
        for _ in 0..<30 {
            gameModel.turn()
        }
        let messages = playerAlexander.advisorMessages()
        
        // THEN
        XCTAssertEqual(messages.count, 3)
    }
    
    func testMessagesAfter30TurnsWithMelees() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        playerAugustus.government?.set(governmentType: .autocracy)
        try! playerAugustus.techs?.discover(tech: .mining)
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .standard)
        
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize()
        self.objectToTest?.set(population: 2)
        
        mapModel.add(city: self.objectToTest)
        
        // center
        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        try! centerTile?.set(owner: playerAlexander)
        try! centerTile?.build(improvement: .farm)
        
        // another
        let anotherTile = mapModel.tile(at: HexPoint(x: 1, y: 2))
        anotherTile?.set(terrain: .plains)
        anotherTile?.set(hills: true)
        try! anotherTile?.set(owner: playerAlexander)
        try! self.objectToTest?.work(tile: anotherTile!)
        try! anotherTile?.build(improvement: .mine)
        
        // units
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAlexander))
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 1), type: .warrior, owner: playerAlexander))
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 2), type: .warrior, owner: playerAlexander))
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 3), type: .warrior, owner: playerAlexander))
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        // WHEN
        for _ in 0..<30 {
            gameModel.turn()
        }
        let messages = playerAlexander.advisorMessages()
        
        // THEN
        XCTAssertEqual(messages.count, 4)
    }
}
