//
//  FoundCityOperationtests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 02.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class FoundCityOperationtests: XCTestCase {

    func testFoundCityOperation() {

        // GIVEN

        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        // map
        var mapModel = MapModelHelper.smallMap()

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
        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .chieftain,
                                  turnsElapsed: 30,
                                  players: [playerBarbarian, playerTrajan, playerAlexander],
                                  on: mapModel)
        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // check city locations
        let playerTrajanCityLocation: HexPoint = HexPoint(x: 15, y: 8)

        XCTAssertEqual(gameModel.tile(at: playerTrajanCityLocation)!.isLand(), true)

        // build cities
        let cityBerlin = City(name: "Berlin", at: playerTrajanCityLocation, capital: true, owner: playerTrajan)
        cityBerlin.initialize(in: gameModel)
        gameModel.add(city: cityBerlin)

        // check unit locations
        let playerTrajanSettlerLocation: HexPoint = HexPoint(x: 20, y: 24)

        XCTAssertEqual(gameModel.tile(at: playerTrajanSettlerLocation)!.isLand(), true)

        // initial units
        let playerTrajanSettler = Unit(at: playerTrajanSettlerLocation, type: .settler, owner: playerTrajan)
        gameModel.add(unit: playerTrajanSettler)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)

        // WHEN
        gameModel.update()
        gameModel.update()

        playerAlexander.finishTurn()
        playerAlexander.setAutoMoves(to: true)

        // THEN
        // DEBUG: po playerTrajan.operations!.operations
        XCTAssertEqual(playerTrajan.operations?.operationsOf(type: .foundCity).count, 1)
    }
}
