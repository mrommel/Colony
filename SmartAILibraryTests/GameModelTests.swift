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

    private var downloadsFolder: URL = {
        let fileManager = FileManager.default
        let folder = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fileManager.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            do {
                try fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
            } catch { }
        }
        return folder
    }()

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
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

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
        gameModel.doWorldEra()
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
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

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
        gameModel.doWorldEra()
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
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

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
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

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

    func testArchaeologySitesCreatedNoEvents() throws {

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
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)
        MapUtils.add(area: HexArea(center: HexPoint(x: 10, y: 10), radius: 8), with: .shore, to: mapModel)

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
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        let numberOfShipWrecksBefore = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .shipwreck })
        let numberOfAntiquitySitesBefore = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .antiquitySite })

        // WHEN
        try playerTrajan.civics?.discover(civic: .naturalHistory, in: gameModel)
        try playerTrajan.civics?.discover(civic: .culturalHeritage, in: gameModel)

        // THEN
        let numberOfShipWrecksAfter = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .shipwreck })
        let numberOfAntiquitySitesAfter = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .antiquitySite })

        XCTAssertEqual(numberOfShipWrecksBefore, 0)
        XCTAssertEqual(numberOfAntiquitySitesBefore, 0)
        XCTAssertNotEqual(numberOfShipWrecksAfter, 0)
        XCTAssertNotEqual(numberOfAntiquitySitesAfter, 0)
    }

    func testArchaeologySitesCreatedFromEvents() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)
        MapUtils.add(area: HexArea(center: HexPoint(x: 10, y: 10), radius: 6), with: .shore, to: mapModel)

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
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        // add some events
        gameModel.tile(at: HexPoint(x: 0, y: 0))?
            .addArchaeologicalRecord(with: .battleMelee, era: .ancient, leader1: .alexander, leader2: .trajan)
        gameModel.tile(at: HexPoint(x: 10, y: 10))?
            .addArchaeologicalRecord(with: .battleSeaMelee, era: .ancient, leader1: .alexander, leader2: .trajan)

        let numberOfShipWrecksBefore = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .shipwreck })
        let numberOfAntiquitySitesBefore = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .antiquitySite })

        // WHEN
        try playerTrajan.civics?.discover(civic: .naturalHistory, in: gameModel)
        try playerTrajan.civics?.discover(civic: .culturalHeritage, in: gameModel)

        // THEN
        let numberOfShipWrecksAfter = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .shipwreck })
        let numberOfAntiquitySitesAfter = gameModel.numberOfPlots(where: { $0?.resource(for: nil) == .antiquitySite })
        let antiquitySiteThere = gameModel.tile(at: HexPoint(x: 0, y: 0))!.has(resource: .antiquitySite, for: playerTrajan)
        let shipWreckThere = gameModel.tile(at: HexPoint(x: 10, y: 10))!.has(resource: .shipwreck, for: playerTrajan)

        XCTAssertEqual(numberOfShipWrecksBefore, 0)
        XCTAssertEqual(numberOfAntiquitySitesBefore, 0)
        XCTAssertNotEqual(numberOfShipWrecksAfter, 0)
        XCTAssertNotEqual(numberOfAntiquitySitesAfter, 0)
        XCTAssert(antiquitySiteThere)
        XCTAssert(shipWreckThere)
    }

    func testSerialization() throws {

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
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)
        MapUtils.add(area: HexArea(center: HexPoint(x: 10, y: 10), radius: 6), with: .shore, to: mapModel)

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
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerTrajan, playerAlexander],
            on: mapModel
        )

        let url = downloadsFolder.appendingPathComponent("tmp.clny")

        let writer = GameWriter()
        let reader = GameLoader()

        // WHEN
        let written = writer.write(game: gameModel, to: url)
        let tmpGameModel = reader.load(from: url)

        // THEN
        XCTAssertTrue(written)
        XCTAssertEqual(tmpGameModel?.mapSize(), .duel)
    }
}
