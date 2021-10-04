//
//  GrandStrategyAITests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GrandStrategyAITests: XCTestCase {

    var objectToTest: GrandStrategyAI?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testInitialStateIsConquestForAlexander() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerElizabeth = Player(leader: .victoria, isHuman: true)
        playerElizabeth.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander, playerElizabeth],
            on: mapModel
        )

        // augustus has met alexander
        playerAlexander.doFirstContact(with: playerAugustus, in: gameModel)

        // augustus has met elizabeth
        playerAugustus.doFirstContact(with: playerElizabeth, in: gameModel)

        // elizabeth and alexander never met

        self.objectToTest = GrandStrategyAI(player: playerAlexander)

        // WHEN
        self.objectToTest?.turn(with: gameModel)

        // THEN
        XCTAssertEqual(self.objectToTest!.activeStrategy, .culture)
    }

    func testInitialStateIsConquestForAugustus() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerElizabeth = Player(leader: .victoria, isHuman: true)
        playerElizabeth.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander, playerElizabeth],
            on: mapModel
        )

        // augustus has met alexander
        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)

        // augustus has met elizabeth
        playerTrajan.doFirstContact(with: playerElizabeth, in: gameModel)

        // elizabeth and alexander never met

        self.objectToTest = GrandStrategyAI(player: playerTrajan)

        // WHEN
        //for i in 0..<100 {
        self.objectToTest?.turn(with: gameModel)
        //}

        // THEN
        XCTAssertEqual(self.objectToTest!.activeStrategy, .culture)
    }
}
