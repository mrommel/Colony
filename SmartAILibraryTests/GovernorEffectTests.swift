//
//  GovernorEffectTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.07.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

// swiftlint:disable type_body_length inclusive_language
class GovernorEffectTests: XCTestCase {

    var objectToTest: AbstractCity?
    var gameModel: GameModel?
    var playerAlexander: AbstractPlayer? // human
    var playerTrajan: AbstractPlayer?

    override func setUpWithError() throws {

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        self.playerAlexander = Player(leader: .alexander, isHuman: true)
        self.playerAlexander?.initialize()

        self.playerTrajan = Player(leader: .trajan)
        self.playerTrajan?.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

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
            players: [barbarianPlayer, self.playerTrajan!, self.playerAlexander!],
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

        // let them meet
        self.playerAlexander?.doFirstContact(with: self.playerTrajan, in: self.gameModel)
    }

    override func tearDownWithError() throws {

        self.objectToTest = nil
        self.gameModel = nil
        self.playerAlexander = nil
        self.playerTrajan = nil
    }

    // MARK: governor Reyna tests

    // landAcquisition
    // Acquire new tiles in the city faster. <= cannot be tested
    // +3 [Gold] Gold per turn from each foreign [TradeRoute] Trade Route passing through the city.
    func testGovernorReynaLandAcquisition() throws {

        // GIVEN
        try self.playerAlexander?.civics?.discover(civic: .foreignTrade, in: self.gameModel)

        let trajanCity = City(name: "Cottbus", at: HexPoint(x: 5, y: 1), owner: self.playerTrajan)
        trajanCity.initialize(in: self.gameModel)
        self.gameModel?.add(city: trajanCity)

        // build trade route
        let traderPurchased = self.objectToTest?.purchase(unit: .trader, with: .gold, in: self.gameModel)
        XCTAssertEqual(traderPurchased, true, "could not purchase trader")
        guard let trader = self.gameModel?.units(at: HexPoint(x: 1, y: 1)).first else {
            XCTFail("trader not found")
            return
        }

        let tradeRouteEstablished = trader?.doEstablishTradeRoute(to: trajanCity, in: self.gameModel)
        XCTAssertEqual(tradeRouteEstablished, true, "could not established trade route")

        let beforeGold = self.objectToTest?.goldPerTurn(in: self.gameModel)

        // WHEN
        self.objectToTest?.assign(governor: .reyna)
        self.objectToTest?.governor()?.promote(with: .landAcquisition) // this is the default title

        let afterGold = self.objectToTest?.goldPerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(self.playerAlexander?.numberOfTradeRoutes(), 1)
        XCTAssertEqual(beforeGold, 3)
        XCTAssertEqual(afterGold, 6)
    }

    // harbormaster
    // Double adjacency bonuses from Commercial Hubs and Harbors in the city.
    func testGovernorReynaHarbormaster() throws {

        // GIVEN
        let river = River(with: "Spree", and: [HexPointWithCorner(with: HexPoint(x: 2, y: 1), andCorner: .east)])
        try gameModel?.tile(x: 2, y: 1)?.set(river: river, with: .northEast)

        try self.playerAlexander?.techs?.discover(tech: .currency, in: self.gameModel)

        self.objectToTest?.purchase(district: .commercialHub, with: .gold, at: HexPoint(x: 2, y: 1), in: self.gameModel)
        XCTAssertEqual(self.objectToTest?.has(district: .commercialHub), true)

        let beforeGold = self.objectToTest?.goldPerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .reyna, in: self.gameModel)
        self.objectToTest?.assign(governor: .reyna)
        self.objectToTest?.governor()?.promote(with: .harbormaster)

        let afterGold = self.objectToTest?.goldPerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(beforeGold, 2.5)
        XCTAssertEqual(afterGold, 5)
    }

    // forestryManagement
    // This city receives +2 [Gold] Gold for each unimproved feature.
    // Tiles adjacent to unimproved features receive +1 Appeal in this city.
    func testGovernorReynaForestryManagement() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // taxCollector
    // +2 [Gold] Gold per turn for each Citizen in the city.
    func testGovernorReynaTaxCollector() throws {

        // GIVEN
        let beforeGold = self.objectToTest?.goldPerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .reyna, in: self.gameModel)
        self.objectToTest?.assign(governor: .reyna)
        self.objectToTest?.governor()?.promote(with: .taxCollector)

        let afterGold = self.objectToTest?.goldPerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(beforeGold, 0)
        XCTAssertEqual(afterGold, 24) // Berlin has 12 citizen
    }

    // contractor
    // Allows city to purchase Districts with [Gold] Gold. - cannot be tested
    func testGovernorReynaContractor() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // renewableSubsidizer
    // All Offshore Wind Farms, Solar Farms, Wind Farms, Geothermal Plants and Hydroelectric Dams in this city receive +2 [Power] Power and +2 [Gold] Gold.
    func testGovernorReynaRenewableSubsidizer() throws {

        // GIVEN
        // WHEN
        // THEN
    }
}
