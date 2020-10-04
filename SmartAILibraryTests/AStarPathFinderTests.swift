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

        let mapModel = TradeRouteTests.mapFilled(with: .ocean, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(victoryTypes: [.domination], handicap: .king, turnsElapsed: 0, players: [barbarianPlayer, aiPlayer, humanPlayer], on: mapModel)
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: humanPlayer)
        
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

        let mapModel = TradeRouteTests.mapFilled(with: .ocean, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(victoryTypes: [.domination], handicap: .king, turnsElapsed: 0, players: [barbarianPlayer, aiPlayer, humanPlayer], on: mapModel)
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: humanPlayer)
        
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

        let mapModel = TradeRouteTests.mapFilled(with: .ocean, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(victoryTypes: [.domination], handicap: .king, turnsElapsed: 0, players: [barbarianPlayer, aiPlayer, humanPlayer], on: mapModel)
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(for: .walk, for: humanPlayer, unitMapType: .combat)
        
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

        let mapModel = TradeRouteTests.mapFilled(with: .ocean, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(victoryTypes: [.domination], handicap: .king, turnsElapsed: 0, players: [barbarianPlayer, aiPlayer, humanPlayer], on: mapModel)
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(for: .walk, for: humanPlayer, unitMapType: .combat)
        
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

        let mapModel = TradeRouteTests.mapFilled(with: .ocean, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(victoryTypes: [.domination], handicap: .king, turnsElapsed: 0, players: [barbarianPlayer, aiPlayer, humanPlayer], on: mapModel)
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.unitAwarePathfinderDataSource(for: .walk, for: humanPlayer, unitMapType: .combat)
        
        // WHEN
        let path = pathFinder.shortestPath(fromTileCoord: HexPoint(x: 1, y: 2), toTileCoord: HexPoint(x: 4, y: 2))
        
        // THEN
        XCTAssertNotNil(path, "no path found (but we can embark")
        if let path = path {
            XCTAssertEqual(path.count, 3)
            XCTAssertEqual(path.cost, 3.0)
        }
    }
}
