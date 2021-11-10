//
//  CityTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

// swiftlint:disable force_try

class CityTests: XCTestCase {

    var objectToTest: AbstractCity?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testNoCityGrowth() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        // WHEN
        _ = self.objectToTest?.turn(in: gameModel)
        let notifications = playerAlexander.notifications()?.notifications()

        // THEN
        XCTAssertEqual(self.objectToTest!.population(), 1)
        XCTAssertEqual(notifications?.count, 1) // don't notify user about any change
    }

    func testOneCityGrowth() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        centerTile?.set(improvement: .farm)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        self.objectToTest?.set(foodBasket: 20)

        // WHEN
        _ = self.objectToTest?.turn(in: gameModel)
        let notifications = playerAlexander.notifications()?.notifications()

        // THEN
        XCTAssertEqual(self.objectToTest!.population(), 2)
        XCTAssertEqual(notifications?.count, 2) // notify user about growth
    }

    func testYields() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)

        // center
        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        centerTile?.set(improvement: .farm)

        // another
        let anotherTile = mapModel.tile(at: HexPoint(x: 1, y: 2))
        anotherTile?.set(terrain: .plains)
        anotherTile?.set(hills: true)
        anotherTile?.set(improvement: .mine)

        // WHEN
        let foodYield = self.objectToTest?.foodPerTurn(in: gameModel)
        let productionYield = self.objectToTest?.productionPerTurn(in: gameModel)
        let goldYield = self.objectToTest?.goldPerTurn(in: gameModel)

        // THEN
        XCTAssertEqual(foodYield, 4.0)
        XCTAssertEqual(productionYield, 4.0)
        XCTAssertEqual(goldYield, 11.0)

        /*XCTAssertEqual(yields?.culture, 2.6)
        XCTAssertEqual(yields?.science, 4.0)
        XCTAssertEqual(yields?.faith, 1.0)
        
        XCTAssertEqual(yields?.housing, 1.0)*/
    }

    func testBuildGranary() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        try! playerAlexander.techs?.discover(tech: .pottery)
        try! playerAlexander.techs?.discover(tech: .masonry)

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        self.objectToTest?.set(population: 1, reassignCitizen: false, in: gameModel)

        let warriorUnit = Unit(at: HexPoint(x: 1, y: 2), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: warriorUnit)

        // WHEN
        _ = self.objectToTest?.turn(in: gameModel)
        let current = self.objectToTest!.currentBuildableItem()

        // THEN
        XCTAssertEqual(current?.type, .building)
        XCTAssertEqual(current?.buildingType, .granary)
    }

    func testBuildWalls() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        try! playerAlexander.techs?.discover(tech: .mining)
        try! playerAlexander.techs?.discover(tech: .pottery)
        try! playerAlexander.techs?.discover(tech: .masonry)

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        try! self.objectToTest?.buildings?.build(building: .monument)
        try! self.objectToTest?.buildings?.build(building: .granary)

        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)

        // WHEN
        _ = self.objectToTest?.turn(in: gameModel)
        let current = self.objectToTest!.currentBuildableItem()

        // THEN
        XCTAssertEqual(current?.type, .building)
        XCTAssertEqual(current?.buildingType, .ancientWalls)
    }

    func testCityAquiredTiles() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        // WHEN
        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        mapModel.add(city: self.objectToTest, in: gameModel)

        // THEN
        for cityPoint in HexPoint(x: 1, y: 1).areaWith(radius: 1) {

            guard let tile = mapModel.tile(at: cityPoint) else {
                fatalError("cant get tile")
            }

            XCTAssertEqual(tile.hasOwner(), true, "for \(cityPoint)")
            XCTAssertEqual(tile.owner()?.leader, playerAlexander.leader)
        }
    }

    func testCityCannotBuildWonderCurrentlyBuildingInAnotherCity() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        playerAlexander.government?.set(governmentType: .autocracy)
        do {
            try playerAlexander.techs?.discover(tech: .masonry)
        } catch {
            fatalError("cant discover masonry")
        }

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20))
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        let city = City(name: "Potsdam", at: HexPoint(x: 10, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        gameModel.add(city: self.objectToTest)

        let canBuildBefore = self.objectToTest?.canBuild(wonder: .pyramids, in: gameModel)

        // WHEN
        city.startBuilding(wonder: .pyramids)
        let canBuildMiddle = self.objectToTest?.canBuild(wonder: .pyramids, in: gameModel)
        city.startBuilding(building: .granary)
        let canBuildAfter = self.objectToTest?.canBuild(wonder: .pyramids, in: gameModel)

        // THEN
        XCTAssertEqual(canBuildBefore, true)
        XCTAssertEqual(canBuildMiddle, false)
        XCTAssertEqual(canBuildAfter, false)
    }
}
