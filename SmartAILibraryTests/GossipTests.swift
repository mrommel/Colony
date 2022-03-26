//
//  GossipTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 26.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

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

    // access level: none - Declarations of war
}
