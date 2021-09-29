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

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // player 3
        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerElizabeth, playerAugustus, playerAlexander],
                                  on: mapModel)

        let visibleBefore = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerAugustus)

        // WHEN
        gameModel.sight(at: HexPoint(x: 2, y: 2), sight: 1, for: playerAugustus)

        // THEN
        let visibleAfter = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerAugustus)
        XCTAssertEqual(visibleBefore, false)
        XCTAssertEqual(visibleAfter, true)
    }

    func testComplexSight() {
        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // player 3
        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerElizabeth, playerAugustus, playerAlexander],
                                  on: mapModel)

        let visibleBefore = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerAugustus)

        // WHEN
        gameModel.sight(at: HexPoint(x: 2, y: 3), sight: 1, for: playerAugustus)
        gameModel.conceal(at: HexPoint(x: 2, y: 1), sight: 1, for: playerAugustus)

        // THEN
        let visibleAfter = gameModel.tile(at: HexPoint(x: 2, y: 2))?.isVisible(to: playerAugustus)
        XCTAssertEqual(visibleBefore, false)
        XCTAssertEqual(visibleAfter, false)
    }
}
