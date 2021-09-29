//
//  UnitTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 16.08.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class UnitTests: XCTestCase {

    // Embarked Units cant move in water #67
    func testUnitMovesEmbarked() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        do {
            try humanPlayer.techs?.discover(tech: .sailing)
        } catch {}

        let mapModel = TradeRouteTests.mapFilled(with: .ocean, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .king,
                                  turnsElapsed: 0,
                                  players: [barbarianPlayer, aiPlayer, humanPlayer],
                                  on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        gameModel.add(unit: humanPlayerWarrior)

        let warriorMission = UnitMission(type: .moveTo, at: HexPoint(x: 6, y: 2))
        humanPlayerWarrior.push(mission: warriorMission, in: gameModel)

        // WHEN
        var turnCounter = 0
        var hasVisited = false
        repeat {
            repeat {
                gameModel.update()
                gameModel.update()
                gameModel.update()

                humanPlayer.finishTurn()
                humanPlayer.setAutoMoves(to: true)
            } while humanPlayer.canFinishTurn()
            humanPlayer.endTurn(in: gameModel)

            hasVisited = humanPlayerWarrior.location == HexPoint(x: 6, y: 2)
            turnCounter += 1
        } while turnCounter < 10 && !hasVisited

        // THEN
        XCTAssertEqual(humanPlayerWarrior.location, HexPoint(x: 6, y: 2))
    }

    func testUnitScoutAutomation() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = TradeRouteTests.mapFilled(with: .grass, sized: .small)

        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .king,
                                  turnsElapsed: 0,
                                  players: [barbarianPlayer, aiPlayer, humanPlayer],
                                  on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        gameModel.add(unit: humanPlayerScout)

        // WHEN
        humanPlayerScout.automate(with: .explore)

        var turnCounter = 0
        var hasStayed = true
        repeat {

            repeat {
                gameModel.update()
                gameModel.update()
                gameModel.update()

                humanPlayer.finishTurn()
                humanPlayer.setAutoMoves(to: true)
            } while humanPlayer.canFinishTurn()
            humanPlayer.endTurn(in: gameModel)

            hasStayed = humanPlayerScout.location == HexPoint(x: 2, y: 2)
            turnCounter += 1
        } while turnCounter < 4 && hasStayed

        // THEN
        XCTAssertNotEqual(humanPlayerScout.location, HexPoint(x: 2, y: 2))
    }
}
