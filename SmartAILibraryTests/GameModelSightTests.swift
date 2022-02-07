//
//  GameModelSightTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 04.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class GameModelSightTests: XCTestCase {

    func testSimpleSight() {
        // GIVEN

        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

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

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerElizabeth, playerTrajan, playerAlexander],
            on: mapModel
        )

        let visibleBefore = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerTrajan)

        // WHEN
        gameModel.sight(at: HexPoint(x: 2, y: 2), sight: 1, for: playerTrajan)

        // THEN
        let visibleAfter = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerTrajan)
        XCTAssertEqual(visibleBefore, false)
        XCTAssertEqual(visibleAfter, true)
    }

    func testComplexSight() {
        // GIVEN

        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

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

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerElizabeth, playerTrajan, playerAlexander],
            on: mapModel
        )

        let visibleBefore = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerTrajan)

        // WHEN
        gameModel.sight(at: HexPoint(x: 2, y: 3), sight: 1, for: playerTrajan)
        gameModel.conceal(at: HexPoint(x: 2, y: 1), sight: 1, for: playerTrajan)

        // THEN
        let visibleAfter = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerTrajan)
        XCTAssertEqual(visibleBefore, false)
        XCTAssertEqual(visibleAfter, false)
    }
}
