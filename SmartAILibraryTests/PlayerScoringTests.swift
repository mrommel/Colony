//
//  PlayerScoringTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class PlayerScoringTests: XCTestCase {

    var objectToTest: Player?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testScoreZero() {

        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .standard)

        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 0)
    }

    func testScore2CitiesOnStandard() {

        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .standard)

        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)
        
        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)
        
        let city2 = City(name: "Potsdam", at: HexPoint(x: 3, y: 5), owner: self.objectToTest)
        city2.initialize(in: gameModel)
        mapModel.add(city: city2, in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 42)
    }

    func testScore2CitiesOnTiny() {

        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .tiny)

        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)
        
        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)
        
        let city2 = City(name: "Potsdam", at: HexPoint(x: 3, y: 5), owner: self.objectToTest)
        city2.initialize(in: gameModel)
        mapModel.add(city: city2, in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 86)
    }
    
    func testScore1Tech() {
        
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        
        let mapModel = MapModel(size: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!], on: mapModel)
        
        try! self.objectToTest?.techs?.discover(tech: .pottery)
        
        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 4)
    }
    
    func testScore2Techs() {
        
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        
        let mapModel = MapModel(size: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!], on: mapModel)
        
        try! self.objectToTest?.techs?.discover(tech: .pottery)
        try! self.objectToTest?.techs?.discover(tech: .mining)
        
        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 8)
    }
    
    func testScore1Wonder() {
        
        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .tiny)

        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)
        
        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)
        
        try! city1.wonders?.build(wonder: .pyramids)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 82)
    }
    
    func testScore2Wonder() {
        
        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)
        
        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)

        try! city1.wonders?.build(wonder: .pyramids)
        try! city1.wonders?.build(wonder: .greatBath)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 122)
    }
    
    func testScoreLandStandard() {
        
        // GIVEN
        self.objectToTest = Player(leader: .alexander)
        self.objectToTest?.initialize()
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModel(size: .standard)
        
        let gameModel = GameModel(victoryTypes: [.cultural, .domination], handicap: .chieftain, turnsElapsed: 0, players: [self.objectToTest!, playerAugustus], on: mapModel)
        
        let city1 = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.objectToTest)
        city1.initialize(in: gameModel)
        mapModel.add(city: city1, in: gameModel)

        self.objectToTest?.updatePlots(in: gameModel)

        // WHEN
        let score = self.objectToTest!.score(for: gameModel)

        // THEN
        XCTAssertEqual(score, 21) // 10 + 4 from city
    }
}
