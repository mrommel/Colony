//
//  TradeRouteTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 24.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class TradeRouteTests: XCTestCase {

    var targetLocation: HexPoint = HexPoint.invalid
    var sourceLocation: HexPoint = HexPoint.invalid
    var hasVisited: Bool = false
    var sourceVisited: Int = 0
    var targetVisited: Int = 0
    var hasExpired: Bool = false

    static func mapFilled(with terrain: TerrainType, sized size: MapSize) -> MapModel {

        let mapModel = MapModel(size: size)

        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {

            for y in 0..<mapSize.height() {

                mapModel.set(terrain: terrain, at: HexPoint(x: x, y: y))
            }
        }

        return mapModel
    }

    static func discover(mapModel: inout MapModel, by player: AbstractPlayer?, in gameModel: GameModel?) {

        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {

            for y in 0..<mapSize.height() {

                let tile = mapModel.tile(at: HexPoint(x: x, y: y))
                tile?.discover(by: player, in: gameModel)
            }
        }
    }

    // https://github.com/mrommel/Colony/issues/66
    func testTradeRouteWorkingWithin10Turns() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = TradeRouteTests.mapFilled(with: .grass, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // AI
        aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)
        aiPlayer.found(at: HexPoint(x: 12, y: 10), named: "AI City", in: gameModel)
        let aiCity = gameModel.city(at: HexPoint(x: 12, y: 10))
        self.targetLocation = HexPoint(x: 12, y: 10)

        // Human
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! humanPlayer.techs?.discover(tech: .pottery)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws)
        try! humanPlayer.civics?.discover(civic: .foreignTrade)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        humanPlayer.government?.set(governmentType: .chiefdom)
        try! humanPlayer.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
        }

        let traderUnit = Unit(at: HexPoint(x: 2, y: 4), type: .trader, owner: humanPlayer)
        traderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit)

        TradeRouteTests.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        traderUnit.unitMoved = self

        // WHEN
        traderUnit.doEstablishTradeRoute(to: aiCity, in: gameModel)

        var turnCounter = 0
        self.hasVisited = false

        repeat {

            while !humanPlayer.canFinishTurn() {

                gameModel.update()
            }

            humanPlayer.endTurn(in: gameModel)

            turnCounter += 1
        } while turnCounter < 10 && !self.hasVisited

        // THEN
        XCTAssertEqual(self.hasVisited, true, "not visited trade city within first 10 turns")
    }
    
    func testTradeRouteWorkingBothCitiesHomeland() { // check foreign too?

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = TradeRouteTests.mapFilled(with: .grass, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // Human - setup
        try! humanPlayer.techs?.discover(tech: .pottery)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws)
        try! humanPlayer.civics?.discover(civic: .foreignTrade)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        humanPlayer.government?.set(governmentType: .chiefdom)
        try! humanPlayer.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))
        
        // Human - city 1
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)

        if let humanCapital = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCapital.buildQueue.add(item: BuildableItem(buildingType: .granary))
        }
        
        // Human - city 2
        humanPlayer.found(at: HexPoint(x: 8, y: 5), named: "Human City", in: gameModel)
        let humanCity = gameModel.city(at: HexPoint(x: 8, y: 5))
        humanCity?.buildQueue.add(item: BuildableItem(buildingType: .granary))

        let traderUnit = Unit(at: HexPoint(x: 4, y: 5), type: .trader, owner: humanPlayer)
        traderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit)

        TradeRouteTests.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        traderUnit.unitMoved = self

        // WHEN
        traderUnit.doEstablishTradeRoute(to: humanCity, in: gameModel)
        
        self.sourceLocation = HexPoint(x: 3, y: 5)
        self.targetLocation = HexPoint(x: 8, y: 5)

        var turnCounter = 0
        self.hasVisited = false
        self.targetVisited = 0
        self.sourceVisited = 0
        self.hasExpired = false

        repeat {

            while !humanPlayer.canFinishTurn() {

                gameModel.update()
            }

            humanPlayer.endTurn(in: gameModel)
            
            if !traderUnit.isTrading() {
                self.hasExpired = true
            }

            turnCounter += 1
        } while turnCounter < 30 && !self.hasExpired

        // THEN
        XCTAssertEqual(self.hasVisited, true, "not visited trade city within first 30 turns")
        XCTAssertEqual(self.targetVisited, 6)
        XCTAssertEqual(self.sourceVisited, 6)
        XCTAssertEqual(self.hasExpired, true)
    }
}

extension TradeRouteTests: UnitMovedDelegate {

    func moved(to location: HexPoint) {

        if location == self.targetLocation {
            self.hasVisited = true
            self.targetVisited += 1
        }
        
        if location == self.sourceLocation {
            self.sourceVisited += 1
        }
    }
}
