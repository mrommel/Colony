//
//  AccessLevelTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 26.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class AccessLevelTests: XCTestCase {

    func testAccessLevelInitialNoContact() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // WHEN
        let accessLevel = playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan)

        // THEN
        XCTAssertEqual(accessLevel, AccessLevel.none)
    }

    func testAccessLevelInitialAfterFirstContact() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // WHEN
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        let accessLevel = playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan)

        // THEN
        XCTAssertEqual(accessLevel, AccessLevel.none)
    }

    func testAccessLevelLimitedAfterDelegation() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let playerTrajanCapital = City(name: "Capital", at: HexPoint(x: 5, y: 5), capital: true, owner: playerTrajan)
        playerTrajanCapital.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCapital)

        playerAlexander.treasury?.changeGold(by: 50)
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.doSendDelegation(to: playerTrajan, in: gameModel)
        let accessLevel = playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan)

        // THEN
        XCTAssertEqual(accessLevel, AccessLevel.limited)
    }

    func testAccessLevelOpenAfterDelegationAndTradeRoute() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // setup the map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.treasury?.changeGold(by: 50)
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // AI
        playerTrajan.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)
        playerTrajan.found(at: HexPoint(x: 12, y: 10), named: "AI City", in: gameModel)
        let aiCity = gameModel.city(at: HexPoint(x: 12, y: 10))

        // Human
        playerAlexander.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! playerAlexander.techs?.discover(tech: .pottery, in: gameModel)
        try! playerAlexander.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! playerAlexander.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! playerAlexander.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! playerAlexander.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        playerAlexander.government?.set(governmentType: .chiefdom, in: gameModel)
        try! playerAlexander.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
        }

        let traderUnit = Unit(at: HexPoint(x: 2, y: 4), type: .trader, owner: playerAlexander)
        traderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit, at: HexPoint(x: 2, y: 4))

        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.doSendDelegation(to: playerTrajan, in: gameModel)

        traderUnit.doEstablishTradeRoute(to: aiCity, in: gameModel)

        let accessLevel = playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan)

        // THEN
        XCTAssertEqual(accessLevel, AccessLevel.open)
    }

    func testAccessLevelSecretAfterDelegationAndTradeRouteAndPrinting() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // setup the map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.treasury?.changeGold(by: 50)
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // AI
        playerTrajan.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)
        playerTrajan.found(at: HexPoint(x: 12, y: 10), named: "AI City", in: gameModel)
        let aiCity = gameModel.city(at: HexPoint(x: 12, y: 10))

        // Human
        playerAlexander.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! playerAlexander.techs?.discover(tech: .pottery, in: gameModel)
        try! playerAlexander.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! playerAlexander.techs?.discover(tech: .printing, in: gameModel)
        try! playerAlexander.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! playerAlexander.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! playerAlexander.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        playerAlexander.government?.set(governmentType: .chiefdom, in: gameModel)
        try! playerAlexander.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
        }

        let traderUnit = Unit(at: HexPoint(x: 2, y: 4), type: .trader, owner: playerAlexander)
        traderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit, at: HexPoint(x: 2, y: 4))

        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.doSendDelegation(to: playerTrajan, in: gameModel)

        traderUnit.doEstablishTradeRoute(to: aiCity, in: gameModel)

        let accessLevel = playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan)

        // THEN
        XCTAssertEqual(accessLevel, AccessLevel.secret)
    }
}
