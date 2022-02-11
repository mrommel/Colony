//
//  TileAppealTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 23.11.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class TileAppealTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testAverageAppeal() {

        // GIVEN
        let map = MapUtils.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12), seed: 42)

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: map
        )

        let tile = gameModel.tile(at: HexPoint(x: 3, y: 3))

        // WHEN
        let appeal = tile!.appeal(in: gameModel)
        let appealLevel = tile!.appealLevel(in: gameModel)

        // THEN
        XCTAssertEqual(appeal, 0)
        XCTAssertEqual(appealLevel, .average)
    }

    func testBreathtakingAppeal() {

        // GIVEN
        let map = MapUtils.mapFilled(with: .ocean, sized: .custom(width: 16, height: 12), seed: 42)

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: map
        )

        let pt = HexPoint(x: 3, y: 3)
        gameModel.tile(at: pt.neighbor(in: .north))?.set(feature: .cliffsOfDover)

        let tile = gameModel.tile(at: pt)

        // WHEN
        let appeal = tile!.appeal(in: gameModel)
        let appealLevel = tile!.appealLevel(in: gameModel)

        // THEN
        XCTAssertEqual(appeal, 4)
        XCTAssertEqual(appealLevel, .breathtaking)
    }
}
