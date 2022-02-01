//
//  PlayerMomentsTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.01.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class PlayerMomentsTests: XCTestCase {

    func testMetCivilizationMoment() throws {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // WHEN
        playerTrajan.doFirstContact(with: playerAlexander, in: gameModel)

        // THEN
        XCTAssertEqual(playerTrajan.hasMoment(of: MomentType.metNewCivilization(civilization: .greek)), true)
    }
}
