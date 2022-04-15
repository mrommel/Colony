//
//  TacticalAnalysisMapTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 30.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class TacticalAnalysisMapTests: XCTestCase {

    func testPerformanceExample() throws {

        // GIVEN

        // players
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
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
            players: [playerBarbarian, playerTrajan, playerAlexander],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let playerAlexanderWarrior = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)

        let playerAugustusSettler = Unit(at: HexPoint(x: 15, y: 15), type: .settler, owner: playerTrajan)
        gameModel.add(unit: playerAugustusSettler)

        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 16), type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerAugustusWarrior)

        let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 10), type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior)

        // WHEN + THEN
        self.measure {
            gameModel.updateTacticalAnalysisMap(for: playerAlexander)
            gameModel.tacticalAnalysisMap().invalidate()
        }
    }
}
