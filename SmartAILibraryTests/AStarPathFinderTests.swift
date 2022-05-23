//
//  AStarPathFinderTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 04.10.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable type_body_length
class AStarPathFinderTests: XCTestCase {

    func testUnitUnawarePathWithoutObstacle() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 3, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 2)
            XCTAssertEqual(path.cost, 2.0)
        }
    }

    func testUnitUnawarePathWithObstacle() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // obstacle
        let unit = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        gameModel.add(unit: unit)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 3, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 2)
            XCTAssertEqual(path.cost, 2.0)
        }
    }

    func testUnitAwarePathWithOwnObstacle() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // obstacle
        let unit = Unit(at: HexPoint(x: 2, y: 2), type: .builder, owner: humanPlayer)
        gameModel.add(unit: unit)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 3, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found (but we can move thru own units)")
        if let path = path {
            XCTAssertEqual(path.count, 2)
            XCTAssertEqual(path.cost, 2.0)
        }
    }

    func testUnitAwarePathWithForeignObstacle() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // obstacle
        let unit = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: aiPlayer)
        gameModel.add(unit: unit)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 3, y: 2))

        // THEN
        XCTAssertNil(path, "path found - should not happen")
    }

    func testUnitAwarePathWithEmbarking() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .shore, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: true,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 4, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found (but we can embark")
        if let path = path {
            XCTAssertEqual(path.count, 3)
            XCTAssertEqual(path.cost, 4.0)
        }
    }

    // Embarked Units cant move in water #67
    func testUnitAwarePathWithEmbarkingAndMovingToAnotherIsland() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .shore, sized: .small, seed: 42)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: true,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 6, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found (but we can embark)")
        if let path = path {
            XCTAssertEqual(path.count, 5)
            XCTAssertEqual(path.cost, 7.0)
        }
    }

    // unit embarks to avoid crossing river #178
    func testUnitAwarePathWithUseDirectPathInsteadOfEmbarking() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        // terrain
        mapModel.set(terrain: .shore, at: HexPoint(x: 4, y: 1))
        mapModel.set(terrain: .shore, at: HexPoint(x: 3, y: 2))
        mapModel.set(terrain: .shore, at: HexPoint(x: 4, y: 0))
        mapModel.set(terrain: .shore, at: HexPoint(x: 4, y: 3))
        mapModel.set(terrain: .shore, at: HexPoint(x: 4, y: 2))
        mapModel.set(terrain: .shore, at: HexPoint(x: 5, y: 1))

        // features
        mapModel.set(hills: true, at: HexPoint(x: 2, y: 2))
        mapModel.set(feature: .forest, at: HexPoint(x: 3, y: 1))
        mapModel.set(hills: true, at: HexPoint(x: 3, y: 1))
        mapModel.set(feature: .mountains, at: HexPoint(x: 1, y: 2))
        mapModel.set(feature: .mountains, at: HexPoint(x: 2, y: 1))

        // river
        let river = River(
            with: "Elbe",
            and: [
                HexPointWithCorner(with: HexPoint(x: 2, y: 1), andCorner: .northeast),
                HexPointWithCorner(with: HexPoint(x: 2, y: 1), andCorner: .east),
                HexPointWithCorner(with: HexPoint(x: 2, y: 2), andCorner: .northeast),
                HexPointWithCorner(with: HexPoint(x: 2, y: 2), andCorner: .east)
            ]
        )
        try mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(river: river, with: .southEast)
        try mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(river: river, with: .southWest)
        try mapModel.tile(at: HexPoint(x: 2, y: 2))?.set(river: river, with: .southEast)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: true,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        let city = City(name: "Berlin", at: HexPoint(x: 2, y: 2), owner: humanPlayer)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 2, y: 2), toTileCoord: HexPoint(x: 3, y: 1))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 1)
            XCTAssertEqual(path.cost, 2.0)
        }
    }

    func testUnitIgnorePathWithoutWrapping() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .plains, sized: .duel, seed: 42, wrapX: false)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 0, y: 2), toTileCoord: HexPoint(x: 31, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 31)
            XCTAssertEqual(path.cost, 31.0)
        }
    }

    func testUnitAwarePathWithoutWrapping() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .plains, sized: .duel, seed: 42, wrapX: false)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 0, y: 2), toTileCoord: HexPoint(x: 31, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 31)
            XCTAssertEqual(path.cost, 31.0)
        }
    }

    func testUnitIgnorePathWithWrapping() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .plains, sized: .duel, seed: 42, wrapX: true)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 0, y: 2), toTileCoord: HexPoint(x: 31, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 1)
            XCTAssertEqual(path.cost, 1.0)
        }
    }

    func testUnitAwarePathWithWrapping() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .plains, sized: .duel, seed: 42, wrapX: true)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 0, y: 2), toTileCoord: HexPoint(x: 31, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 1)
            XCTAssertEqual(path.cost, 1.0)
        }
    }
}
