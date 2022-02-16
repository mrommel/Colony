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

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk, for: humanPlayer, unitMapType: .combat, canEmbark: false,
               canEnterOcean: false)

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

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )

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

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )

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

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: false,
            canEnterOcean: false
        )

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

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: true,
            canEnterOcean: false
        )

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

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: true,
            canEnterOcean: false
        )

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 6, y: 2))

        // THEN
        XCTAssertNotNil(path, "no path found (but we can embark)")
        if let path = path {
            XCTAssertEqual(path.count, 5)
            XCTAssertEqual(path.cost, 6.0)
        }
    }

    // unit embarks to avoid crossing river
    func testUnitAwarePathWithUseDirectPathInsteadOfEmbarking() {

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

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: humanPlayer,
            unitMapType: .combat,
            canEmbark: true,
            canEnterOcean: false
        )

        let city = City(name: "Berlin", at: HexPoint(x: 2, y: 2), owner: humanPlayer)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 2, y: 2), toTileCoord: HexPoint(x: 3, y: 1))

        // THEN
        XCTAssertNotNil(path, "no path found")
        if let path = path {
            XCTAssertEqual(path.count, 5)
            XCTAssertEqual(path.cost, 6.0)
        }
    }
}
