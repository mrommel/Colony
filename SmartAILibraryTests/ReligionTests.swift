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

        self.grid = MapModel(width: 3, height: 3, seed: 42)
    }

    func testAIFoundingPantheon() {

        // GIVEN

        // players
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        playerTrajan.treasury?.changeGold(by: 200.0) // cheat

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

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
            victoryTypes: [.cultural],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbarian, playerTrajan, playerAlexander],
            on: mapModel
        )

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

        try! playerTrajan.techs?.discover(tech: .astrology, in: gameModel)

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        _ = playerTrajanCity.purchase(district: .holySite, with: .gold, at: HexPoint(x: 15, y: 14), in: gameModel)
        _ = playerTrajanCity.purchase(building: .shrine, with: .gold, in: gameModel)
        gameModel.add(city: playerTrajanCity)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        // WHEN
        var turnCounter = 0
        let initialPantheon: PantheonType = playerTrajan.religion!.pantheon()

        repeat {

            repeat {
                gameModel.update()

                if playerAlexander.isTurnActive() {
                    playerAlexander.finishTurn()
                    playerAlexander.setAutoMoves(to: true)
                }
            } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

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
