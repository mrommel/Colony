//
//  GameModelTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 04.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GameModelTests: XCTestCase {

    func testWorldEraMedieval() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.set(era: .classical)

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()
        playerAugustus.set(era: .medieval)

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()
        playerElizabeth.set(era: .medieval)

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerElizabeth, playerAugustus, playerAlexander],
            on: mapModel
        )

        // WHEN
        let worldEra = gameModel.worldEra()

        // THEN
        XCTAssertEqual(worldEra, .medieval)
    }

    func testWorldEraMedieval2() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.set(era: .classical)

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()
        playerAugustus.set(era: .medieval)

        // player 3
        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()
        playerElizabeth.set(era: .renaissance)

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerElizabeth, playerAugustus, playerAlexander],
            on: mapModel
        )

        // WHEN
        let worldEra = gameModel.worldEra()

        // THEN
        XCTAssertEqual(worldEra, .medieval)
    }

    func testWonderCantBeBuiltTwice() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.set(era: .classical)
        do {
            try playerAlexander.techs?.discover(tech: .masonry)
        } catch {
            fatalError("cant discover masonry")
        }

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()
        playerTrajan.set(era: .medieval)

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.set(terrain: .desert, at: HexPoint(x: 1, y: 2))

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        // city
        let city = City(name: "Berlin", at: HexPoint.zero, owner: playerAlexander)
        city.initialize(in: gameModel)
        gameModel.add(city: city)
        let canBuildBefore = city.canBuild(wonder: .pyramids, in: gameModel)

        // WHEN
        city.startBuilding(wonder: .pyramids, at: HexPoint(x: 0, y: 1), in: gameModel)
        city.updateProduction(for: 2000, in: gameModel)
        let canBuildAfter = city.canBuild(wonder: .pyramids, in: gameModel)

        // THEN
        XCTAssertEqual(canBuildBefore, true)
        XCTAssertEqual(canBuildAfter, false)
    }

    // https://github.com/mrommel/Colony/issues/68
    func testWonderCantBeBuiltWhenBuiltByAnotherPlayer() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.set(era: .classical)
        do {
            try playerAlexander.techs?.discover(tech: .masonry)
        } catch {
            fatalError("cant discover masonry")
        }

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()
        playerTrajan.set(era: .classical)
        do {
            try playerTrajan.techs?.discover(tech: .masonry)
        } catch {
            fatalError("cant discover masonry")
        }

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.set(terrain: .desert, at: HexPoint(x: 19, y: 19))

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        // city 1
        let city1 = City(name: "Berlin", at: HexPoint.zero, owner: playerAlexander)
        city1.initialize(in: gameModel)
        gameModel.add(city: city1)

        // city 2
        let city2 = City(name: "Potsdam", at: HexPoint(x: 20, y: 20), owner: playerTrajan)
        city2.initialize(in: gameModel)
        gameModel.add(city: city2)
        let canBuildBefore = city2.canBuild(wonder: .pyramids, in: gameModel)

        // WHEN
        city1.startBuilding(wonder: .pyramids, at: HexPoint(x: 1, y: 0), in: gameModel)
        city1.updateProduction(for: 2000, in: gameModel)
        let canBuildAfter = city2.canBuild(wonder: .pyramids, in: gameModel)

        // THEN
        XCTAssertEqual(canBuildBefore, true)
        XCTAssertEqual(canBuildAfter, false)
    }
}
