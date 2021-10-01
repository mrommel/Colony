//
//  TechTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class TechTests: XCTestCase {

    var objectToTest: AbstractTechs?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testPossibleTechs() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let possibleTechs = self.objectToTest?.possibleTechs()

        // THEN
        XCTAssertFalse(possibleTechs!.contains(.animalHusbandry))
        XCTAssertFalse(possibleTechs!.contains(.pottery))
        XCTAssertTrue(possibleTechs!.contains(.mining))
        XCTAssertTrue(possibleTechs!.contains(.sailing))
        XCTAssertTrue(possibleTechs!.contains(.astrology))
        XCTAssertTrue(possibleTechs!.contains(.irrigation))
        XCTAssertTrue(possibleTechs!.contains(.writing))
        XCTAssertTrue(possibleTechs!.contains(.archery))
        XCTAssertTrue(possibleTechs!.contains(.horsebackRiding))
    }

    func testChooseNextTechAlexander() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()

        // THEN
        //print("nextTech: \(nextTech)")
        XCTAssertTrue([.mining, .writing, .sailing].contains(nextTech))
    }

    func testChooseNextTechAugustusInitial() {

        // GIVEN
        let playerAlexander = Player(leader: .trajan)
        self.objectToTest = Techs(player: playerAlexander)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()

        // THEN
        XCTAssertTrue([.mining, .pottery, .animalHusbandry].contains(nextTech))
    }

    func testChooseNextTechAugustusLater() {

        // GIVEN
        let playerAlexander = Player(leader: .trajan)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()

        // THEN
        //print("nextTech: \(nextTech)")
        XCTAssertTrue([.mining, .sailing, .writing].contains(nextTech))
    }

    func testChooseNextTechElizabeth() {

        // GIVEN
        let playerAlexander = Player(leader: .victoria)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()

        // THEN
        //print("nextTech: \(nextTech)")
        XCTAssertTrue([.mining, .writing, .sailing].contains(nextTech))
    }

    func testEurekaOfIrrigation() {

        // GIVEN
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        let playerAlexander = Player(leader: .victoria, isHuman: true)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.techs
        try! self.objectToTest?.discover(tech: .pottery)

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbarian, playerAlexander],
            on: mapModel
        )

        let tile = mapModel.tile(at: HexPoint(x: 0, y: 0))
        tile?.set(resource: .wheat)
        try! tile?.set(owner: playerAlexander)

        // WHEN
        let beforeEureka = self.objectToTest?.eurekaTriggered(for: .irrigation)
        tile?.changeBuildProgress(of: BuildType.farm, change: 1000, for: playerAlexander, in: gameModel)
        let afterEureka = self.objectToTest?.eurekaTriggered(for: .irrigation)

        // THEN
        XCTAssertEqual(beforeEureka, false)
        XCTAssertEqual(afterEureka, true)
    }

    func testEurekaOfWriting() {

        // GIVEN
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.techs

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbarian, playerAlexander, playerTrajan],
            on: mapModel
        )

        // WHEN
        let beforeEureka = self.objectToTest?.eurekaTriggered(for: .writing)
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        let afterEureka = self.objectToTest?.eurekaTriggered(for: .writing)

        // THEN
        XCTAssertEqual(beforeEureka, false)
        XCTAssertEqual(afterEureka, true)
    }

    func testEurekaOfAstrology() {

        // GIVEN
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.techs

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.set(feature: .greatBarrierReef, at: HexPoint(x: 0, y: 0))

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbarian, playerAlexander],
            on: mapModel
        )

        // WHEN
        let beforeEureka = self.objectToTest?.eurekaTriggered(for: .astrology)
        mapModel.discover(by: playerAlexander, at: HexPoint(x: 0, y: 0), in: gameModel)
        let afterEureka = self.objectToTest?.eurekaTriggered(for: .astrology)

        // THEN
        XCTAssertEqual(beforeEureka, false)
        XCTAssertEqual(afterEureka, true)
    }

    func testEurekaOfSailing() {

        // GIVEN
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.techs

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.set(terrain: .ocean, at: HexPoint(x: 0, y: 0))

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbarian, playerAlexander],
            on: mapModel
        )

        let playerAlexanderSettler = Unit(at: HexPoint(x: 0, y: 1), type: .settler, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderSettler)

        // WHEN
        let beforeEureka = self.objectToTest?.eurekaTriggered(for: .sailing)
        playerAlexanderSettler.doFound(in: gameModel)
        let afterEureka = self.objectToTest?.eurekaTriggered(for: .sailing)

        // THEN
        XCTAssertEqual(beforeEureka, false)
        XCTAssertEqual(afterEureka, true)
    }
}
