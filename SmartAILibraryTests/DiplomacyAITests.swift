//
//  DiplomacyAITests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 08.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class DiplomacyAITests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {

        
    }

    func testMilitaryStrengthPlayerNotMet() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander], on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface
        
        // WHEN
        gameModel.update() //.doTurn()
        let militaryStrength = playerAlexander.diplomacyAI!.militaryStrength(of: playerAugustus)

        // THEN
        XCTAssertEqual(militaryStrength, .average)
    }

    func testMilitaryStrengthPlayerMet() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 1), type: .warrior, owner: playerAugustus), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 2), type: .warrior, owner: playerAugustus), in: gameModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface
        
        playerAlexander.diplomacyAI?.doFirstContact(with: playerAugustus, in: gameModel)
        playerAugustus.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)

        // WHEN
        gameModel.update() //.doTurn()
        let militaryStrength = playerAlexander.diplomacyAI!.militaryStrength(of: playerAugustus)

        // THEN
        XCTAssertEqual(militaryStrength, .immense)
    }
    
    func testProximityNoCitiesClose() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        
        // WHEN
        gameModel.update() //.doTurn()
        let proximity = playerAlexander.diplomacyAI!.proximity(to: playerAugustus)
        
        // THEN
        XCTAssertEqual(proximity, .close)
    }
    
    func testProximityTwoCitiesFar() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 10), type: .warrior, owner: playerAlexander), in: gameModel)
        let cityAlexander = City(name: "Alexander", at: HexPoint(x: 0, y: 10), capital: true, owner: playerAlexander)
        cityAlexander.initialize(in: gameModel)
        mapModel.add(city: cityAlexander, in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 19, y: 10), type: .warrior, owner: playerAugustus), in: gameModel)
        let cityAugustus = City(name: "Augustus", at: HexPoint(x: 19, y: 10), capital: true, owner: playerAugustus)
        cityAugustus.initialize(in: gameModel)
        mapModel.add(city: cityAugustus, in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        
        // WHEN
        gameModel.update() //.doTurn()
        let proximity = playerAlexander.diplomacyAI!.proximity(to: playerAugustus)
        
        // THEN
        XCTAssertEqual(proximity, .far)
    }
    
    func testProximityTwoCitiesClose() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 8, y: 10), type: .warrior, owner: playerAlexander), in: gameModel)
        let cityAlexander = City(name: "Alexander", at: HexPoint(x: 8, y: 10), capital: true, owner: playerAlexander)
        cityAlexander.initialize(in: gameModel)
        mapModel.add(city: cityAlexander, in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 12, y: 10), type: .warrior, owner: playerAugustus), in: gameModel)
        let cityAugustus = City(name: "Augustus", at: HexPoint(x: 12, y: 10), capital: true, owner: playerAugustus)
        cityAugustus.initialize(in: gameModel)
        mapModel.add(city: cityAugustus, in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        
        // WHEN
        gameModel.update() //.doTurn()
        let proximity = playerAlexander.diplomacyAI!.proximity(to: playerAugustus)
        
        // THEN
        XCTAssertEqual(proximity, .close)
    }
    
    func testApproachInitially() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.diplomacyAI?.doFirstContact(with: playerAugustus, in: gameModel)
        playerAugustus.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)
        
        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        gameModel.update() //.doTurn()
        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        
        // THEN
        XCTAssertEqual(approachBefore, .none)
        XCTAssertEqual(approachAfter, .neutrally)
    }
    
    func testApproachAfterDeclarationOfFriendship() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.diplomacyAI?.doFirstContact(with: playerAugustus, in: gameModel)
        playerAugustus.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)
        
        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        playerAlexander.diplomacyAI?.doDeclarationOfFriendship(with: playerAugustus, in: gameModel)
        gameModel.update() //.doTurn()
        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        
        // THEN
        XCTAssertEqual(approachBefore, .none)
        XCTAssertEqual(approachAfter, .friendly)
    }
    
    func testApproachAfterDenouncement() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        
        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        playerAlexander.diplomacyAI?.doDenounce(player: playerAugustus, in: gameModel)
        gameModel.update() //.doTurn()
        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        
        // THEN
        XCTAssertEqual(approachBefore, .none)
        let resultList: [PlayerApproachType] = [.hostile, .war]
        XCTAssertTrue(resultList.contains(approachAfter))
    }
    
    func testApproachAfterDeclarationOfWar() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.diplomacyAI?.doFirstContact(with: playerAugustus, in: gameModel)
        playerAugustus.diplomacyAI?.doFirstContact(with: playerAlexander, in: gameModel)
        
        // WHEN
        let approachBefore = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        playerAlexander.diplomacyAI?.doDeclareWar(to: playerAugustus, in: gameModel)
        gameModel.update() //.doTurn()
        let approachAfter = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        
        // THEN
        XCTAssertEqual(approachBefore, .none)
        XCTAssertEqual(approachAfter, .war)
    }
    
    func testDefensivePact() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus], on: mapModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface
        
        // WHEN
        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        playerAlexander.doDefensivePact(with: playerAugustus, in: gameModel)
        let defensivePact1 = playerAlexander.isDefensivePactActive(with: playerAugustus)
        let defensivePact2 = playerAugustus.isDefensivePactActive(with: playerAlexander)
        
        // THEN
        XCTAssertEqual(defensivePact1, true)
        XCTAssertEqual(defensivePact2, true)
    }
    
    func testDeclarationOfWarTriggersDefensivePact() {
    
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        
        let playerElizabeth = Player(leader: .elizabeth)
        playerElizabeth.initialize()

        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAlexander, playerAugustus, playerElizabeth], on: mapModel)
        
        mapModel.add(unit: Unit(at: HexPoint(x: 1, y: 0), type: .warrior, owner: playerAlexander), in: gameModel)

        mapModel.add(unit: Unit(at: HexPoint(x: 0, y: 0), type: .warrior, owner: playerAugustus), in: gameModel)
        
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // all players have meet with another
        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)
        playerAugustus.doFirstContact(with: playerElizabeth, in: gameModel)
        playerElizabeth.doFirstContact(with: playerAlexander, in: gameModel)
        
        playerElizabeth.doDefensivePact(with: playerAugustus, in: gameModel)
        
        // WHEN
        playerAlexander.diplomacyAI?.doDeclareWar(to: playerAugustus, in: gameModel)
        //gameModel.turn()
        let approachAlexanderAugustus = playerAlexander.diplomacyAI!.approach(towards: playerAugustus)
        let approachAlexanderElizabeth = playerAlexander.diplomacyAI!.approach(towards: playerElizabeth)
        
        let approachAugustusAlexander = playerAugustus.diplomacyAI!.approach(towards: playerAlexander)
        let approachElizabethAlexander = playerElizabeth.diplomacyAI!.approach(towards: playerAlexander)
        
        // THEN
        XCTAssertEqual(approachAlexanderAugustus, .war)
        XCTAssertEqual(approachAlexanderElizabeth, .war)
        XCTAssertEqual(approachAugustusAlexander, .war) // has been declared war
        XCTAssertEqual(approachElizabethAlexander, .war) // defensive pact
    }
}
