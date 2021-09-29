//
//  ReligionTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 31.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class ReligionTests: XCTestCase {

    private var grid: MapModel?

    override func setUp() {

        self.grid = MapModel(width: 3, height: 3)
    }

    func testAIFoundingPantheon() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        playerTrajan.treasury?.changeGold(by: 200.0) // cheat

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

        // game
        let gameModel = GameModel(victoryTypes: [.cultural],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerTrajan, playerBarbarian, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units

        let playerAlexanderWarrior = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)

        let playerTrajanWarrior = Unit(at: HexPoint(x: 15, y: 15), type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerTrajanWarrior)

        let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 10), type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior)

        // science

        try! playerTrajan.techs?.discover(tech: .astrology)

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        playerTrajanCity.purchase(district: .holySite, in: gameModel)
        playerTrajanCity.purchase(building: .shrine, with: .gold, in: gameModel)
        gameModel.add(city: playerTrajanCity)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        // WHEN
        var turnCounter = 0
        let initialPantheon: PantheonType = playerTrajan.religion!.pantheon()

        repeat {

            while !playerAlexander.canFinishTurn() {

                gameModel.update()
            }

            playerAlexander.endTurn(in: gameModel)

            print("faith: \(playerTrajan.religion!.faith())")

            turnCounter += 1
        } while turnCounter < 15

        let foundedPantheon: PantheonType = playerTrajan.religion!.pantheon()
        print("AI founded: \(foundedPantheon)")

        // THEN
        XCTAssertEqual(initialPantheon, .none)
        XCTAssertNotEqual(foundedPantheon, .none)
        XCTAssertEqual(playerTrajanWarrior.activityType(), .none) // warrior has skipped
    }
}
