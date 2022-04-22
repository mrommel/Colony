//
//  CityDistrictTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 14.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class CityDistrictTests: XCTestCase {

    var objectToTest: AbstractCity?
    var gameModel: GameModel?
    var playerAlexander: AbstractPlayer?

    override func setUpWithError() throws {

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.playerAlexander = Player(leader: .alexander, isHuman: true)
        self.playerAlexander?.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny, seed: 42)

        mapModel.set(terrain: .shore, at: HexPoint(x: 2, y: 2)) // coast for harbor
        mapModel.set(feature: .mountains, at: HexPoint(x: 2, y: 0)) // mountains for aquaduct
        mapModel.set(feature: .mountains, at: HexPoint(x: 1, y: 3))

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

        self.gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAugustus, self.playerAlexander!],
            on: mapModel
        )

        self.objectToTest = City(name: "Berlin", at: HexPoint(x: 1, y: 1), owner: self.playerAlexander)
        self.objectToTest?.initialize(in: self.gameModel)
        self.objectToTest?.set(population: 12, reassignCitizen: true, in: self.gameModel)
        self.gameModel?.add(city: self.objectToTest)

        // buy some plots
        self.playerAlexander?.treasury?.changeGold(by: 1000)
        // self.objectToTest?.doBuyPlot(at: HexPoint(x: 2, y: 1), in: self.gameModel)
        self.objectToTest?.doBuyPlot(at: HexPoint(x: 3, y: 1), in: self.gameModel)
        self.objectToTest?.doBuyPlot(at: HexPoint(x: 4, y: 1), in: self.gameModel)

        // add some more money
        self.playerAlexander?.treasury?.changeGold(by: 1000)
    }

    override func tearDownWithError() throws {

        self.objectToTest = nil
        self.gameModel = nil
    }

    func testCantBuiltTwoDistrictsInSmallCity() throws {

        // GIVEN
        self.objectToTest?.set(population: 3, reassignCitizen: true, in: gameModel) // small city - 1 district = harbor
        try self.playerAlexander?.techs?.discover(tech: .celestialNavigation, in: self.gameModel)
        try self.playerAlexander?.techs?.discover(tech: .writing, in: self.gameModel)
        let canBuildHarbor = self.objectToTest!.canBuild(district: .harbor, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltHarbor = self.objectToTest!.purchase(district: .harbor, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildCampus = self.objectToTest!.canBuild(district: .campus, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildHarbor, true)
        XCTAssertEqual(hasBuiltHarbor, true)
        XCTAssertEqual(canBuildCampus, false)
    }

    func testCantBuiltThreeDistrictsInMediumCity() throws {

        // GIVEN
        self.objectToTest?.set(population: 6, reassignCitizen: true, in: gameModel) // medium city - districts = harbor, campus
        try self.playerAlexander?.techs?.discover(tech: .celestialNavigation, in: self.gameModel)
        try self.playerAlexander?.techs?.discover(tech: .writing, in: self.gameModel)
        try self.playerAlexander?.civics?.discover(civic: .dramaAndPoetry, in: self.gameModel)

        let canBuildHarbor = self.objectToTest!.canBuild(district: .harbor, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltHarbor = self.objectToTest!.purchase(district: .harbor, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let canBuildCampus = self.objectToTest!.canBuild(district: .campus, at: HexPoint(x: 3, y: 1), in: self.gameModel)
        let hasBuiltCampus = self.objectToTest!.purchase(district: .campus, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // WHEN
        let canBuildTheaterSquare = self.objectToTest!.canBuild(district: .theatherSquare, at: HexPoint(x: 4, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildHarbor, true)
        XCTAssertEqual(hasBuiltHarbor, true)
        XCTAssertEqual(canBuildCampus, true)
        XCTAssertEqual(hasBuiltCampus, true)
        XCTAssertEqual(canBuildTheaterSquare, false)
    }

    // check districts that can only be built once per city

    func testCantBuiltCampusTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .writing, in: self.gameModel)
        let canBuildFirstCampus = self.objectToTest!.canBuild(district: .campus, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstCampus = self.objectToTest!.purchase(district: .campus, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherCampus = self.objectToTest!.canBuild(district: .campus, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstCampus, true)
        XCTAssertEqual(hasBuiltFirstCampus, true)
        XCTAssertEqual(canBuildAnotherCampus, false)
    }

    func testCantBuiltTheatherSquareTwice() throws {

        // GIVEN
        try self.playerAlexander?.civics?.discover(civic: .dramaAndPoetry, in: self.gameModel)
        let canBuildFirstTheatherSquare = self.objectToTest!.canBuild(district: .theatherSquare, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstTheatherSquare = self.objectToTest!.purchase(district: .theatherSquare, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherTheatherSquare = self.objectToTest!.canBuild(district: .theatherSquare, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstTheatherSquare, true)
        XCTAssertEqual(hasBuiltFirstTheatherSquare, true)
        XCTAssertEqual(canBuildAnotherTheatherSquare, false)
    }

    func testCantBuiltHolySiteTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .astrology, in: self.gameModel)
        let canBuildFirstHolySite = self.objectToTest!.canBuild(district: .holySite, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstHolySite = self.objectToTest!.purchase(district: .holySite, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherHolySite = self.objectToTest!.canBuild(district: .holySite, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstHolySite, true)
        XCTAssertEqual(hasBuiltFirstHolySite, true)
        XCTAssertEqual(canBuildAnotherHolySite, false)
    }

    func testCantBuiltEncampmentTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .bronzeWorking, in: self.gameModel)
        let canBuildFirstEncampment = self.objectToTest!.canBuild(district: .encampment, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstEncampment = self.objectToTest!.purchase(district: .encampment, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherEncampment = self.objectToTest!.canBuild(district: .encampment, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstEncampment, true)
        XCTAssertEqual(hasBuiltFirstEncampment, true)
        XCTAssertEqual(canBuildAnotherEncampment, false)
    }

    func testCantBuiltHarborTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .celestialNavigation, in: self.gameModel)
        let canBuildFirstHarbor = self.objectToTest!.canBuild(district: .harbor, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstHarbor = self.objectToTest!.purchase(district: .harbor, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherHarbor = self.objectToTest!.canBuild(district: .harbor, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstHarbor, true)
        XCTAssertEqual(hasBuiltFirstHarbor, true)
        XCTAssertEqual(canBuildAnotherHarbor, false)
    }

    func testCantBuiltCommercialHubTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .currency, in: self.gameModel)
        let canBuildFirstCommercialHub = self.objectToTest!.canBuild(district: .commercialHub, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstCommercialHub = self.objectToTest!.purchase(district: .commercialHub, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherCommercialHub = self.objectToTest!.canBuild(district: .commercialHub, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstCommercialHub, true)
        XCTAssertEqual(hasBuiltFirstCommercialHub, true)
        XCTAssertEqual(canBuildAnotherCommercialHub, false)
    }

    func testCantBuiltIndustrialZoneTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .apprenticeship, in: self.gameModel)
        let canBuildFirstIndustrialZone = self.objectToTest!.canBuild(district: .industrialZone, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstIndustrialZone = self.objectToTest!.purchase(district: .industrialZone, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherIndustrialZone = self.objectToTest!.canBuild(district: .industrialZone, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstIndustrialZone, true)
        XCTAssertEqual(hasBuiltFirstIndustrialZone, true)
        XCTAssertEqual(canBuildAnotherIndustrialZone, false)
    }

    func testCantBuiltEntertainmentComplexTwice() throws {

        // GIVEN
        try self.playerAlexander?.civics?.discover(civic: .gamesAndRecreation, in: self.gameModel)
        let canBuildFirstEntertainment = self.objectToTest!.canBuild(district: .entertainmentComplex, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstEntertainment = self.objectToTest!.purchase(district: .entertainmentComplex, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherEntertainment = self.objectToTest!.canBuild(district: .entertainmentComplex, at: HexPoint(x: 3, y: 1), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstEntertainment, true)
        XCTAssertEqual(hasBuiltFirstEntertainment, true)
        XCTAssertEqual(canBuildAnotherEntertainment, false)
    }

    // check districts that can be built multiple times per city

    func testCanBuiltAqueductTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .engineering, in: self.gameModel)
        let canBuildFirstAqueduct = self.objectToTest!.canBuild(district: .aqueduct, at: HexPoint(x: 1, y: 0), in: self.gameModel)
        let hasBuiltFirstAqueduct = self.objectToTest!.purchase(district: .aqueduct, at: HexPoint(x: 1, y: 0), in: self.gameModel)

        // WHEN
        let canBuildAnotherAqueduct = self.objectToTest!.canBuild(district: .aqueduct, at: HexPoint(x: 0, y: 2), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstAqueduct, true)
        XCTAssertEqual(hasBuiltFirstAqueduct, true)
        XCTAssertEqual(canBuildAnotherAqueduct, true)
    }

    func testCanBuiltNeighborhoodTwice() throws {

        // GIVEN
        try self.playerAlexander?.civics?.discover(civic: .urbanization, in: self.gameModel)
        let canBuildFirstNeighborhood = self.objectToTest!.canBuild(district: .neighborhood, at: HexPoint(x: 1, y: 0), in: self.gameModel)
        let hasBuiltFirstNeighborhood = self.objectToTest!.purchase(district: .neighborhood, at: HexPoint(x: 1, y: 0), in: self.gameModel)

        // WHEN
        let canBuildAnotherNeighborhood = self.objectToTest!.canBuild(district: .neighborhood, at: HexPoint(x: 0, y: 2), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstNeighborhood, true)
        XCTAssertEqual(hasBuiltFirstNeighborhood, true)
        XCTAssertEqual(canBuildAnotherNeighborhood, true)
    }

    func testCanBuiltSpaceportTwice() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .rocketry, in: self.gameModel)
        let canBuildFirstSpaceport = self.objectToTest!.canBuild(district: .spaceport, at: HexPoint(x: 1, y: 0), in: self.gameModel)
        let hasBuiltFirstSpaceport = self.objectToTest!.purchase(district: .spaceport, at: HexPoint(x: 1, y: 0), in: self.gameModel)

        // WHEN
        let canBuildAnotherSpaceport = self.objectToTest!.canBuild(district: .spaceport, at: HexPoint(x: 0, y: 2), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstSpaceport, true)
        XCTAssertEqual(hasBuiltFirstSpaceport, true)
        XCTAssertEqual(canBuildAnotherSpaceport, true)
    }

    // check districts that can only be built once per civ

    func testCantBuiltGovernmentPlazaTwiceInEmpire() throws {

        // GIVEN
        let secondCity = City(name: "Second City", at: HexPoint(x: 12, y: 11), owner: self.playerAlexander)
        secondCity.initialize(in: self.gameModel)
        secondCity.set(population: 7, reassignCitizen: true, in: self.gameModel)
        self.gameModel?.add(city: secondCity)

        try self.playerAlexander?.civics?.discover(civic: .stateWorkforce, in: self.gameModel)
        let canBuildFirstGovernmentPlaza = self.objectToTest!.canBuild(district: .governmentPlaza, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        let hasBuiltFirstGovernmentPlaza = self.objectToTest!.purchase(district: .governmentPlaza, at: HexPoint(x: 2, y: 1), in: self.gameModel)

        // WHEN
        let canBuildAnotherGovernmentPlaza = secondCity.canBuild(district: .governmentPlaza, at: HexPoint(x: 11, y: 11), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildFirstGovernmentPlaza, true)
        XCTAssertEqual(hasBuiltFirstGovernmentPlaza, true)
        XCTAssertEqual(canBuildAnotherGovernmentPlaza, false)
    }

    func testCannotBuiltCampusOutsideCityBounds() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .writing, in: self.gameModel)

        // WHEN
        let canBuildCampus = self.objectToTest!.canBuild(district: .campus, at: HexPoint(x: 3, y: 2), in: self.gameModel)

        // THEN
        XCTAssertEqual(canBuildCampus, false)
    }
}
