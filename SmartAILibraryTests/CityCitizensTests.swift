//
//  CityCitizensTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 30.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class CityCitizensTests: XCTestCase {

    func testAssignCitizenFromUnassigned() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny, seed: 42)

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
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        let city = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)

        // WHEN
        city.cityCitizens?.doTurn(with: gameModel)

        let numUnassignedCitizens = city.cityCitizens!.numberOfUnassignedCitizens()
        let numCitizensWorkingPlots = city.cityCitizens!.numberOfCitizensWorkingPlots()

        var count = 0
        for pt in city.cityCitizens!.workingTileLocations() {
            if city.cityCitizens!.isWorked(at: pt) {
                count += 1
            }
        }

        // THEN
        XCTAssertEqual(numUnassignedCitizens, 0)
        XCTAssertEqual(numCitizensWorkingPlots, 1)
        XCTAssertEqual(count, 1)
    }
}
