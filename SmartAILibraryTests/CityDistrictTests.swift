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

    // entertainment

    // aqueduct
    // neighborhood

    // spaceport
    // governmentPlaza
}
