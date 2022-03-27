//
//  GossipTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 26.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

// swiftlint:disable type_body_length

class GossipTests: XCTestCase {

    // access level: none - City conquests
    func testCityConquestGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerVictoria.found(at: HexPoint(x: 12, y: 10), named: "Victoria City", in: gameModel)
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        let victoriaCity = gameModel.city(at: HexPoint(x: 12, y: 10))

        // WHEN
        playerTrajan.acquire(city: victoriaCity, conquest: true, gift: false, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .cityConquests(cityName: "Victoria City"))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: none - Pantheon created
    func testPantheonCreatedGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerVictoria.found(at: HexPoint(x: 12, y: 10), named: "Victoria City", in: gameModel)
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerTrajan.religion?.foundPantheon(with: .divineSpark, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .pantheonCreated(pantheonName: PantheonType.divineSpark.name()))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: none - Religions founded
    func testReligionFoundedGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerVictoria.found(at: HexPoint(x: 12, y: 10), named: "Victoria City", in: gameModel)
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)
        let victoriaCity = gameModel.city(at: HexPoint(x: 12, y: 10))

        // WHEN
        playerTrajan.doFound(religion: .buddhism, at: victoriaCity, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .religionsFounded(religionName: ReligionType.buddhism.name()))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: none - Declarations of war
    func testDeclarationOfWarGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerTrajan.doDeclareWar(to: playerVictoria, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .declarationsOfWar(leader: .victoria))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: limited - Alliances

    // access level: limited - Friendships
    func testFriendshipGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan)
        playerTrajan.diplomacyAI?.playerDict.updateApproachValue(towards: playerVictoria, to: 59)
        playerTrajan.diplomacyAI?.doDeclarationOfFriendship(with: playerVictoria, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .friendship(leader: .victoria))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: limited - Government changes
    func testGovernmentChangeGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan) // limited
        playerTrajan.government?.set(governmentType: .monarchy, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .governmentChange(government: .monarchy))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: limited - Denunciations
    func testDenunciationGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan)
        playerTrajan.diplomacyAI?.doDenounce(player: playerVictoria, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .denunciation(leader: .victoria))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: limited - City founded
    func testCityFoundedGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan)
        playerTrajan.found(at: HexPoint(x: 10, y: 10), named: "Berlin", in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .cityFounded(cityName: "Berlin"))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: limited - City liberated
    func testCityLiberatedGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // acquire city, so it can be liberated
        playerTrajan.found(at: HexPoint(x: 12, y: 10), named: "Rome", in: gameModel)
        let trajanCity = gameModel.city(at: HexPoint(x: 12, y: 10))
        playerVictoria.acquire(city: trajanCity, conquest: true, gift: false, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan)
        playerTrajan.acquire(city: trajanCity, conquest: true, gift: false, in: gameModel) // liberate
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .cityLiberated(cityName: "Rome", originalOwner: .trajan))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: limited - City razed
    func testCityRazedGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerVictoria.found(at: HexPoint(x: 25, y: 10), named: "Capital", in: gameModel)
        playerVictoria.found(at: HexPoint(x: 12, y: 10), named: "Rome", in: gameModel)
        let vicorianCity = gameModel.city(at: HexPoint(x: 12, y: 10))

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan)
        playerTrajan.raze(city: vicorianCity, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .cityRazed(cityName: "Rome", originalOwner: .victoria))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: limited - City besieged
    /* func testCityBesiegedGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan)
        // playerTrajan.diplomacyAI?.doDenounce(player: playerVictoria, in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .cityBesieged(cityName: ""))
        } else {
            XCTFail("no gossip")
        }
    } */

    // access level: limited - Trade deal enacted
    // access level: limited - Trade deal reneged

    // access level: limited - barbarian camp cleared
    func testBarbarianCampClearedGossip() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        // setup the map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan, .victoria],
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
            players: [barbarianPlayer, playerTrajan, playerVictoria, playerAlexander],
            on: mapModel
        )

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerTrajan.doFirstContact(with: playerVictoria, in: gameModel)
        let campTile = gameModel.tile(x: 5, y: 5)
        campTile?.set(improvement: .barbarianCamp)

        let trajanScout = Unit(at: HexPoint(x: 4, y: 5), type: .scout, owner: playerTrajan)
        gameModel.add(unit: trajanScout)

        // WHEN
        playerAlexander.diplomacyAI?.increaseAccessLevel(towards: playerTrajan)
        let _ = trajanScout.doMove(on: HexPoint(x: 5, y: 5), in: gameModel)
        let gossipItems: [GossipItem] = playerAlexander.diplomacyAI!.gossipItems(for: playerTrajan)

        // THEN
        XCTAssertEqual(playerAlexander.diplomacyAI?.accessLevel(towards: playerTrajan), .limited)
        XCTAssertEqual(gossipItems.count, 1)
        if let gossipItem = gossipItems.first {
            XCTAssertEqual(gossipItem.typeValue, .barbarianCampCleared(unit: .scout))
        } else {
            XCTFail("no gossip")
        }
    }

    // access level: open - Buildings constructed
    // access level: open - Districts constructed
    // access level: open - Great people recruited
    // access level: open - Wonders started
    // access level: open - Artifacts extracted
    // access level: open - Inquisition launched

    // access level: secret - City-states influenced
    // access level: secret - Civics completed
    // access level: secret - Technologies researched
    // access level: secret - Settlers trained

    // access level: top secret - Weapon of mass destruction built
    // access level: top secret - Attacks launched
    // access level: top secret - Projects started
    // access level: top secret - Victory strategy changed
    // access level: top secret - War preparations
}
