//
//  EconomicAITests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 04.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class EconomicAITests: XCTestCase {

    func testOneOrFewerCoastalCities() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
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
            players: [playerBarbar, playerAlexander],
            on: mapModel
        )

        // WHEN
        playerAlexander.economicAI?.doTurn(in: gameModel)

        // THEN
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .oneOrFewerCoastalCities), true)
    }

    func testIslandStart() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        var mapModel = MapUtils.mapFilled(with: .shore, sized: .duel, seed: 42)

        HexPoint(x: 8, y: 8).areaWith(radius: 4).points
            .forEach { mapModel.set(terrain: .grass, at: $0) }
        HexPoint(x: 18, y: 8).areaWith(radius: 4).points
            .forEach { mapModel.set(terrain: .grass, at: $0) }

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
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
            players: [playerBarbar, playerAlexander],
            on: mapModel
        )

        MapUtils.discover(
            area: HexPoint(x: 8, y: 8).areaWith(radius: 4),
            mapModel: &mapModel,
            by: playerAlexander,
            in: gameModel
        )

        MapUtils.discover(
            area: HexPoint(x: 18, y: 8).areaWith(radius: 4),
            mapModel: &mapModel,
            by: playerAlexander,
            in: gameModel
        )

        // WHEN
        gameModel.currentTurn = 24
        playerAlexander.economicAI?.doTurn(in: gameModel)

        // THEN
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .enoughRecon), true)
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .enoughReconSea), true)
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .oneOrFewerCoastalCities), true)
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .islandStart), true)
    }

    func testEarlyGame() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .shore, sized: .duel, seed: 42)

        HexPoint(x: 8, y: 8).areaWith(radius: 4).points
            .forEach { mapModel.set(terrain: .grass, at: $0) }
        HexPoint(x: 18, y: 8).areaWith(radius: 4).points
            .forEach { mapModel.set(terrain: .grass, at: $0) }

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
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
            players: [playerBarbar, playerAlexander],
            on: mapModel
        )

        // WHEN
        gameModel.currentTurn = 50
        playerAlexander.economicAI?.doTurn(in: gameModel)

        // THEN
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .needRecon), true)
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .enoughReconSea), true)
        XCTAssertEqual(playerAlexander.economicAI!.adopted(economicStrategy: .oneOrFewerCoastalCities), true)
    }
}
