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

// swiftlint:disable force_try type_body_length
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
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        // WHEN
        _ = self.objectToTest?.doTurn(in: gameModel)
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

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny, seed: 42)

        let centerTile = mapModel.tile(at: HexPoint(x: 1, y: 1))
        centerTile?.set(terrain: .grass)
        centerTile?.set(hills: false)
        centerTile?.set(improvement: .farm)

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
            players: [barbarianPlayer, playerAugustus, playerAlexander],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        self.objectToTest?.set(foodBasket: 20)

        // WHEN
        _ = self.objectToTest?.doTurn(in: gameModel)
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

        playerAlexander.government?.set(governmentType: .autocracy, in: gameModel)

        try! playerAlexander.techs?.discover(tech: .mining, in: gameModel)

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

    func testBuildAncientWalls() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

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
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.government?.set(governmentType: .autocracy, in: gameModel)

        try! playerAlexander.techs?.discover(tech: .mining, in: gameModel)
        try! playerAlexander.techs?.discover(tech: .pottery, in: gameModel)
        try! playerAlexander.techs?.discover(tech: .masonry, in: gameModel)

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)

        self.objectToTest?.set(population: 1, reassignCitizen: false, in: gameModel)
        try self.objectToTest?.buildings?.build(building: .monument)
        try self.objectToTest?.buildings?.build(building: .granary)

        let warriorUnit = Unit(at: HexPoint(x: 1, y: 2), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: warriorUnit)

        // WHEN
        _ = self.objectToTest?.doTurn(in: gameModel)
        let current = self.objectToTest!.currentBuildableItem()

        // THEN
        XCTAssertEqual(current?.type, .building)
        XCTAssertEqual(current?.buildingType, .ancientWalls)
    }

    func testBuildWalls() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

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
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.government?.set(governmentType: .autocracy, in: gameModel)

        try! playerAlexander.techs?.discover(tech: .mining, in: gameModel)
        try! playerAlexander.techs?.discover(tech: .pottery, in: gameModel)
        try! playerAlexander.techs?.discover(tech: .masonry, in: gameModel)

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        try! self.objectToTest?.buildings?.build(building: .monument)
        try! self.objectToTest?.buildings?.build(building: .granary)

        self.objectToTest?.set(population: 2, reassignCitizen: false, in: gameModel)

        // WHEN
        _ = self.objectToTest?.doTurn(in: gameModel)
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

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

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
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.government?.set(governmentType: .autocracy, in: gameModel)

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

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

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
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.government?.set(governmentType: .autocracy, in: gameModel)

        try! playerAlexander.techs?.discover(tech: .masonry, in: gameModel)

        let cityLocation = HexPoint(x: 10, y: 1)
        let wonderLocation = cityLocation.neighbor(in: .south)

        mapModel.set(terrain: .desert, at: wonderLocation) // needed for pyramids

        let city = City(name: "Potsdam", at: HexPoint(x: 1, y: 1), owner: playerAlexander)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        self.objectToTest = City(name: "Berlin", at: cityLocation, capital: true, owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        gameModel.add(city: self.objectToTest)

        let canBuildBefore = self.objectToTest?.canBuild(wonder: .pyramids, at: wonderLocation, in: gameModel)

        // WHEN
        city.startBuilding(wonder: .pyramids, at: wonderLocation, in: gameModel)
        let canBuildMiddle = self.objectToTest?.canBuild(wonder: .pyramids, at: wonderLocation, in: gameModel)
        city.startBuilding(building: .granary)
        let canBuildAfter = self.objectToTest?.canBuild(wonder: .pyramids, at: wonderLocation, in: gameModel)

        // THEN
        XCTAssertEqual(canBuildBefore, true)
        XCTAssertEqual(canBuildMiddle, false)
        XCTAssertEqual(canBuildAfter, false)
    }

    func testCityVeryLowLoyalty() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

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
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        self.objectToTest = City(name: "Potsdam", at: HexPoint(x: 5, y: 5), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        gameModel.add(city: self.objectToTest)

        let enemyCity1 = City(name: "Enemy1", at: HexPoint(x: 8, y: 5), owner: playerTrajan)
        enemyCity1.initialize(in: gameModel)
        enemyCity1.set(population: 10, in: gameModel)
        gameModel.add(city: enemyCity1)

        let enemyCity2 = City(name: "Enemy2", at: HexPoint(x: 2, y: 5), owner: playerTrajan)
        enemyCity2.initialize(in: gameModel)
        enemyCity2.set(population: 10, in: gameModel)
        gameModel.add(city: enemyCity2)

        let loyaltyBefore = self.objectToTest?.loyalty()

        // WHEN
        self.objectToTest?.doTurn(in: gameModel)
        let loyaltyAfter = self.objectToTest?.loyalty()
        let playerAfter = self.objectToTest?.player

        // THEN
        XCTAssertEqual(loyaltyBefore, 100)
        XCTAssertEqual(loyaltyAfter, 80)
        XCTAssertEqual(playerAfter?.leader, .alexander)
    }

    // because barracks are built
    func testCantBuildStableButCanBuildArmory() throws {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

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
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        self.objectToTest = City(name: "Potsdam", at: HexPoint(x: 5, y: 5), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        gameModel.add(city: self.objectToTest)

        // fake some requirements
        playerAlexander.treasury?.changeGold(by: 1000)
        try playerAlexander.techs?.discover(tech: .bronzeWorking, in: gameModel)
        try playerAlexander.techs?.discover(tech: .horsebackRiding, in: gameModel)
        try playerAlexander.techs?.discover(tech: .militaryEngineering, in: gameModel)
        self.objectToTest?.purchase(district: .encampment, with: .gold, at: HexPoint(x: 6, y: 5), in: gameModel)

        let canBuildStableBefore = self.objectToTest!.canBuild(building: .stable, in: gameModel)
        let canBuildArmoryBefore = self.objectToTest!.canBuild(building: .armory, in: gameModel)

        // WHEN
        self.objectToTest!.purchase(building: .barracks, with: .gold, in: gameModel)
        let canBuildStableAfter = self.objectToTest!.canBuild(building: .stable, in: gameModel)
        let canBuildArmoryAfter = self.objectToTest!.canBuild(building: .armory, in: gameModel)

        // THEN
        XCTAssertEqual(canBuildStableBefore, true)
        XCTAssertEqual(canBuildArmoryBefore, false)
        XCTAssertEqual(canBuildStableAfter, false)
        XCTAssertEqual(canBuildArmoryAfter, true)
    }

    func testNearbyPopulationPressure() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .custom(width: 20, height: 20), seed: 42)

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
            players: [barbarianPlayer, playerAlexander, playerTrajan],
            on: mapModel
        )

        playerAlexander.currentAgeVal = .dark

        // domestic cities
        self.objectToTest = City(name: "Kinchassa", at: HexPoint(x: 9, y: 5), owner: playerAlexander)
        self.objectToTest?.initialize(in: gameModel)
        gameModel.add(city: self.objectToTest)
        self.objectToTest?.set(population: 5, reassignCitizen: false, in: gameModel)

        let cityMbanzaMbata = City(name: "MbanzaMbata", at: HexPoint(x: 5, y: 5), owner: playerAlexander)
        cityMbanzaMbata.initialize(in: gameModel)
        gameModel.add(city: cityMbanzaMbata)
        cityMbanzaMbata.set(population: 2, reassignCitizen: false, in: gameModel)

        // foreign cities
        let cityManchester = City(name: "Manchester", at: HexPoint(x: 13, y: 5), owner: playerTrajan)
        cityManchester.initialize(in: gameModel)
        gameModel.add(city: cityManchester)
        cityManchester.set(population: 2, reassignCitizen: false, in: gameModel)

        let cityLiverpool = City(name: "Liverpool", at: HexPoint(x: 16, y: 5), owner: playerTrajan)
        cityLiverpool.initialize(in: gameModel)
        gameModel.add(city: cityLiverpool)
        cityLiverpool.set(population: 11, reassignCitizen: false, in: gameModel)

        // WHEN
        let distanceKinchassaToMbanzaMbata = cityMbanzaMbata.location.distance(to: self.objectToTest?.location ?? HexPoint.invalid)
        let distanceKinchassaToManchester = cityManchester.location.distance(to: self.objectToTest?.location ?? HexPoint.invalid)
        let distanceKinchassaToLiverpool = cityLiverpool.location.distance(to: self.objectToTest?.location ?? HexPoint.invalid)

        let pressureKinchassa = self.objectToTest?.loyaltyPressureFromNearbyCitizen(in: gameModel)

        // THEN
        // https://civilization.fandom.com/wiki/Loyalty_(Civ6)#Loyalty_lens
        // Example of pressure from nearby citizens
        //
        // The image to the right contains a small island with 5 cities, 1 city-state which we ignore,
        // 2 English cities (experiencing a Normal Age) and 2 Kongolese cities (experiencing a Dark Age).
        // If we calculate the pressure for the city of Kinchassa:
        //
        // Domestic = 0.5 * [ 5 * (10-0) + 2 * (10-4) ] = 31
        // Foreign = [ 1 * 11 * (10-7) + 1 * 2 * (10-4) ] = 45
        // Pressure = 10 * (31 - 45) / (min[31,45] + 0.5) = -4.4

        // prechecks
        XCTAssertEqual(self.objectToTest?.population(), 5)
        XCTAssertEqual(distanceKinchassaToMbanzaMbata, 4)
        XCTAssertEqual(cityMbanzaMbata.population(), 2)

        XCTAssertEqual(distanceKinchassaToManchester, 4)
        XCTAssertEqual(cityManchester.population(), 2)

        XCTAssertEqual(distanceKinchassaToLiverpool, 7)
        XCTAssertEqual(cityLiverpool.population(), 11)

        XCTAssertEqual(pressureKinchassa, -4.444444444444445)
    }
}
