//
//  PlayerTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 29.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class PlayerTests: XCTestCase {

    func testSpawnProphet() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units
        let playerAlexanderWarrior = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)

        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 16), type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerAugustusWarrior)

        // cities
        let cityAlexandria = City(name: "Alexandria", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAlexander)
        cityAlexandria.initialize(in: gameModel)
        gameModel.add(city: cityAlexandria)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: barbarianPlayer, in: gameModel)

        let greatPersonPoints = GreatPersonPoints(
            greatGeneral: 0,
            greatAdmiral: 0,
            greatEngineer: 0,
            greatMerchant: 0,
            greatProphet: 200,
            greatScientist: 0,
            greatWriter: 0,
            greatArtist: 0,
            greatMusician: 0
        )
        playerAlexander.greatPeople?.add(points: greatPersonPoints)
        playerAlexander.religion?.foundPantheon(with: .cityPatronGoddess, in: gameModel)
        let numProphetsBefore = gameModel.units(of: playerAlexander).filter { $0?.type == .prophet }.count

        // WHEN
        repeat {
            gameModel.update()

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.finishTurnButtonPressed())

        // THEN
        XCTAssertEqual(numProphetsBefore, 0)
        let numProphetsAfter = gameModel.units(of: playerAlexander).filter { $0?.type == .prophet }.count
        XCTAssertEqual(numProphetsAfter, 1)
    }
}
