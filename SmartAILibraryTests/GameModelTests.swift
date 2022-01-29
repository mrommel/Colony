//
//  GameModelTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 04.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try
class GameModelTests: XCTestCase {

    func testWorldEraMedieval() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerElizabeth, playerAugustus, playerAlexander],
            on: mapModel
        )

        playerAlexander.set(era: .classical, in: gameModel)
        playerAugustus.set(era: .medieval, in: gameModel)
        playerElizabeth.set(era: .medieval, in: gameModel)

        // WHEN
        let worldEra = gameModel.worldEra()

        // THEN
        XCTAssertEqual(worldEra, .medieval)
    }

    func testWorldEraMedieval2() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // player 3
        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerElizabeth, playerAugustus, playerAlexander],
            on: mapModel
        )

        playerAlexander.set(era: .classical, in: gameModel)
        playerAugustus.set(era: .medieval, in: gameModel)
        playerElizabeth.set(era: .renaissance, in: gameModel)

        // WHEN
        let worldEra = gameModel.worldEra()

        // THEN
        XCTAssertEqual(worldEra, .medieval)
    }

    func testWonderCantBeBuiltTwice() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        try! playerAlexander.techs?.discover(tech: .masonry, in: gameModel)

        playerAlexander.set(era: .classical, in: gameModel)
        playerTrajan.set(era: .medieval, in: gameModel)

        let cityLocation = HexPoint(x: 1, y: 2)
        let wonderLocation = cityLocation.neighbor(in: .south)

        mapModel.set(terrain: .desert, at: wonderLocation)

        // city
        let city = City(name: "Berlin", at: cityLocation, owner: playerAlexander)
        city.initialize(in: gameModel)
        gameModel.add(city: city)
        let canBuildBefore = city.canBuild(wonder: .pyramids, in: gameModel)
        let canBuildAtBefore = city.canBuild(wonder: .pyramids, at: wonderLocation, in: gameModel)

        // WHEN
        city.startBuilding(wonder: .pyramids, at: wonderLocation, in: gameModel)
        city.updateProduction(for: 2000, in: gameModel)
        let canBuildAfter = city.canBuild(wonder: .pyramids, in: gameModel)
        let canBuildAtAfter = city.canBuild(wonder: .pyramids, at: wonderLocation, in: gameModel)

        // THEN
        XCTAssertEqual(canBuildBefore, true)
        XCTAssertEqual(canBuildAtBefore, true)
        XCTAssertEqual(canBuildAfter, false)
        XCTAssertEqual(canBuildAtAfter, false)
    }

    // https://github.com/mrommel/Colony/issues/68
    func testWonderCantBeBuiltWhenBuiltByAnotherPlayer() {
        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        try! playerAlexander.techs?.discover(tech: .masonry, in: gameModel)
        try! playerTrajan.techs?.discover(tech: .masonry, in: gameModel)

        playerAlexander.set(era: .classical, in: gameModel)
        playerTrajan.set(era: .classical, in: gameModel)

        let cityLocation = HexPoint(x: 20, y: 20)
        let wonderLocation = cityLocation.neighbor(in: .south)
        mapModel.set(terrain: .desert, at: wonderLocation)

        // city 1
        let city1 = City(name: "Berlin", at: HexPoint.zero, owner: playerAlexander)
        city1.initialize(in: gameModel)
        gameModel.add(city: city1)

        // city 2
        let city2 = City(name: "Potsdam", at: cityLocation, owner: playerTrajan)
        city2.initialize(in: gameModel)
        gameModel.add(city: city2)
        let canBuildBefore = city2.canBuild(wonder: .pyramids, in: gameModel)

        // WHEN
        city1.startBuilding(wonder: .pyramids, at: wonderLocation, in: gameModel)
        city1.updateProduction(for: 2000, in: gameModel)
        let canBuildAfter = city2.canBuild(wonder: .pyramids, in: gameModel)

        // THEN
        XCTAssertEqual(canBuildBefore, true)
        XCTAssertEqual(canBuildAfter, false)
    }

    func testArchaeologySitesCreated() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)
        MapUtils.add(area: HexArea(center: HexPoint(x: 10, y: 10), radius: 8), with: .shore, to: mapModel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        // WHEN
        let numberOfShipWrecksBefore = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .shipwreck })
        let numberOfAntiquitySitesBefore = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .antiquitySite })

        try playerTrajan.civics?.discover(civic: .naturalHistory, in: gameModel)
        try playerTrajan.civics?.discover(civic: .culturalHeritage, in: gameModel)

        let numberOfShipWrecksAfter = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .shipwreck })
        let numberOfAntiquitySitesAfter = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .antiquitySite })

        // THEN
        XCTAssertEqual(numberOfShipWrecksBefore, 0)
        XCTAssertEqual(numberOfAntiquitySitesBefore, 0)
        XCTAssertNotEqual(numberOfShipWrecksAfter, 0)
        XCTAssertNotEqual(numberOfAntiquitySitesAfter, 0)
    }
}
