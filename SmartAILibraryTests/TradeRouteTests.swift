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

    // https://github.com/mrommel/Colony/issues/66
    func testTradeRouteWorkingWithin20Turns() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.victoria],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

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
        try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        humanPlayer.government?.set(governmentType: .chiefdom, in: gameModel)
        try! humanPlayer.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.append(item: BuildableItem(buildingType: .granary))
        }

        let traderUnit = Unit(at: HexPoint(x: 2, y: 4), type: .trader, owner: humanPlayer)
        traderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit, at: HexPoint(x: 2, y: 4))

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        traderUnit.unitMoved = self

        humanPlayer.doFirstContact(with: aiPlayer, in: gameModel)

        // WHEN
        traderUnit.doEstablishTradeRoute(to: aiCity, in: gameModel)

        var turnCounter = 0
        self.hasVisited = false

        repeat {

            repeat {
                gameModel.update()

                if humanPlayer.isTurnActive() {
                    humanPlayer.finishTurn()
                    humanPlayer.setAutoMoves(to: true)
                }
            } while !(humanPlayer.hasProcessedAutoMoves() && humanPlayer.turnFinished())

            turnCounter += 1
        } while turnCounter < 20 && !self.hasVisited

        // THEN
        XCTAssertEqual(self.hasVisited, true, "not visited trade city within first 20 turns")
    }

    func testTradeRouteWorkingBothCitiesHomeland() { // check foreign too?

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.victoria],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // Human - setup
        try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        humanPlayer.government?.set(governmentType: .chiefdom, in: gameModel)
        try! humanPlayer.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))

        // AI units
        let warriorUnit = Unit(at: HexPoint(x: 25, y: 5), type: .warrior, owner: aiPlayer)
        gameModel.add(unit: warriorUnit)

        // Human - city 1
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)

        if let humanCapital = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCapital.buildQueue.append(item: BuildableItem(buildingType: .granary))
        }

        // Human - city 2
        humanPlayer.found(at: HexPoint(x: 8, y: 5), named: "Human City", in: gameModel)
        let humanCity = gameModel.city(at: HexPoint(x: 8, y: 5))
        humanCity?.buildQueue.append(item: BuildableItem(buildingType: .granary))

        let traderUnit = Unit(at: HexPoint(x: 4, y: 5), type: .trader, owner: humanPlayer)
        traderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit, at: HexPoint(x: 4, y: 5))

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

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

            repeat {
                gameModel.update()

                if humanPlayer.isTurnActive() {
                    humanPlayer.finishTurn()
                    humanPlayer.setAutoMoves(to: true)
                }
            } while !(humanPlayer.hasProcessedAutoMoves() && humanPlayer.turnFinished())

            if !traderUnit.isTrading() {
                self.hasExpired = true
            }

            turnCounter += 1
        } while turnCounter < 35 && !self.hasExpired

        // THEN
        XCTAssertEqual(self.hasVisited, true, "not visited trade city within first 30 turns")
        XCTAssertEqual(self.targetVisited, 3)
        XCTAssertEqual(self.sourceVisited, 3)
        XCTAssertEqual(self.hasExpired, true)
    }

    func testCanEstablishTradeRouteWithCityState() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let cityStatePlayer = Player(leader: .cityState(type: .akkad), isHuman: false)
        cityStatePlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.victoria],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, cityStatePlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // Human - setup
        try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        humanPlayer.government?.set(governmentType: .chiefdom, in: gameModel)
        try! humanPlayer.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))

        // Human - city 1
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)

        if let humanCapital = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCapital.buildQueue.append(item: BuildableItem(buildingType: .granary))
        }

        // City State - city 2
        cityStatePlayer.found(at: HexPoint(x: 8, y: 5), named: "City State City", in: gameModel)
        let cityStateCity = gameModel.city(at: HexPoint(x: 8, y: 5))

        let traderUnit = Unit(at: HexPoint(x: 4, y: 5), type: .trader, owner: humanPlayer)
        traderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit, at: HexPoint(x: 4, y: 5))

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // WHEN
        let established = traderUnit.canEstablishTradeRoute(to: cityStateCity, in: gameModel)

        // THEN
        XCTAssertEqual(established, true)
    }

    func testFollowTradeRouteAcrossWarppedMap() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let cityStatePlayer = Player(leader: .cityState(type: .akkad), isHuman: false)
        cityStatePlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.victoria],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, cityStatePlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // Human - setup
        try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)
        humanPlayer.government?.set(governmentType: .chiefdom, in: gameModel)
        try! humanPlayer.government?.set(policyCardSet: PolicyCardSet(cards: [.godKing, .discipline]))

        humanPlayer.doFirstContact(with: aiPlayer, in: gameModel)

        // Human - city 1
        humanPlayer.found(at: HexPoint(x: 30, y: 5), named: "Human Capital", in: gameModel)

        if let humanCapital = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCapital.buildQueue.append(item: BuildableItem(buildingType: .granary))
        }

        // AI - city 2
        aiPlayer.found(at: HexPoint(x: 3, y: 5), named: "City State City", in: gameModel)
        let aiPlayerCity = gameModel.city(at: HexPoint(x: 3, y: 5))

        let traderUnit = Unit(at: HexPoint(x: 30, y: 5), type: .trader, owner: humanPlayer)
        traderUnit.origin = HexPoint(x: 30, y: 5)
        gameModel.add(unit: traderUnit)
        gameModel.userInterface?.show(unit: traderUnit, at: HexPoint(x: 30, y: 5))

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        traderUnit.unitMoved = self

        // WHEN
        traderUnit.doEstablishTradeRoute(to: aiPlayerCity, in: gameModel)

        self.sourceLocation = HexPoint(x: 30, y: 5)
        self.targetLocation = HexPoint(x: 3, y: 5)

        var turnCounter = 0
        self.hasVisited = false
        self.targetVisited = 0
        self.sourceVisited = 0
        self.hasExpired = false

        repeat {

            repeat {
                gameModel.update()

                if humanPlayer.isTurnActive() {
                    humanPlayer.finishTurn()
                    humanPlayer.setAutoMoves(to: true)
                }
            } while !(humanPlayer.hasProcessedAutoMoves() && humanPlayer.turnFinished())

            if !traderUnit.isTrading() {
                self.hasExpired = true
            }

            turnCounter += 1
        } while turnCounter < 10 && !self.hasExpired

        // THEN
        XCTAssertEqual(self.hasVisited, true, "not visited trade city within first 10 turns")
        XCTAssertEqual(self.targetVisited, 1)
        XCTAssertEqual(self.sourceVisited, 1)
        XCTAssertEqual(self.hasExpired, false)
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
