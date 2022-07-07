//
//  GovernorEffectTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.07.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

// swiftlint:disable inclusive_language
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
        mapModel.set(feature: .forest, at: HexPoint(x: 3, y: 1))

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
    // - Acquire new tiles in the city faster. <= cannot be tested
    // - +3 [Gold] Gold per turn from each foreign [TradeRoute] Trade Route passing through the city.
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
    // - Double adjacency bonuses from Commercial Hubs and Harbors in the city.
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
    // - This city receives +2 [Gold] Gold for each unimproved feature.
    // - Tiles adjacent to unimproved features receive +1 Appeal in this city.
    func testGovernorReynaForestryManagement() throws {

        // GIVEN
        let neightbor = HexPoint(x: 3, y: 1).neighbor(in: .northwest)
        self.objectToTest?.cityCitizens?.forceWorkingPlot(at: HexPoint(x: 3, y: 1), force: true, in: self.gameModel)
        let beforeGold = self.objectToTest?.goldPerTurn(in: self.gameModel)
        let appealNexToForestBefore = self.gameModel?.tile(at: neightbor)?.appeal(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .reyna, in: self.gameModel)
        self.objectToTest?.assign(governor: .reyna)
        self.objectToTest?.governor()?.promote(with: .forestryManagement)

        let afterGold = self.objectToTest?.goldPerTurn(in: self.gameModel)
        let appealNexToForestafter = self.gameModel?.tile(at: neightbor)?.appeal(in: self.gameModel)

        // THEN
        XCTAssertEqual(beforeGold, 0)
        XCTAssertEqual(afterGold, 2)
        XCTAssertEqual(appealNexToForestBefore, 3)
        XCTAssertEqual(appealNexToForestafter, 4)
    }

    // taxCollector
    // - +2 [Gold] Gold per turn for each Citizen in the city.
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
    // - Allows city to purchase Districts with [Gold] Gold. - cannot be tested
    func testGovernorReynaContractor() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // renewableSubsidizer
    // - All Offshore Wind Farms, Solar Farms, Wind Farms, Geothermal Plants and Hydroelectric Dams in this city receive +2 [Power] Power and +2 [Gold] Gold. // #
    func testGovernorReynaRenewableSubsidizer() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // MARK: governor Victor tests

    // redoubt
    // - Increase city garrison [Strength] Combat Strength by 5.
    func testGovernorReynaRedoubt() throws {

        // GIVEN
        let cityStrengthBefore = self.objectToTest?.defensiveStrength(against: nil, on: nil, ranged: false, in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .victor, in: self.gameModel)
        self.objectToTest?.assign(governor: .victor)

        let cityStrengthAfter = self.objectToTest?.defensiveStrength(against: nil, on: nil, ranged: false, in: self.gameModel)

        // THEN
        XCTAssertEqual(cityStrengthBefore, 10)
        XCTAssertEqual(cityStrengthAfter, 15)
    }

    // garrisonCommander
    // - Units defending within the city's territory get +5 [Strength] Combat Strength.
    // - Your other cities within 9 tiles gain +4 Loyalty per turn towards your civilization.
    func testGovernorReynaGarrisonCommander() throws {

        // GIVEN
        let secondCity = City(name: "Potsdam", at: HexPoint(x: 6, y: 6), owner: self.playerAlexander)
        secondCity.initialize(in: self.gameModel)
        self.gameModel?.userInterface?.show(city: secondCity)

        let trajanCity = City(name: "Cottbus", at: HexPoint(x: 12, y: 4), owner: self.playerTrajan)
        trajanCity.initialize(in: self.gameModel)
        self.gameModel?.add(city: trajanCity)

        let centerTile = self.gameModel?.tile(x: 1, y: 1)
        self.objectToTest?.purchase(unit: .warrior, with: .gold, in: self.gameModel)
        guard let warriorBefore = self.gameModel?.units(at: HexPoint(x: 1, y: 1)).first else {
            XCTFail("cant get unit before")
            return
        }

        let defenseModifierBefore = warriorBefore?.defenseModifier(against: nil, or: nil, on: centerTile, ranged: false, in: self.gameModel)
        let loyaltyBefore = secondCity.loyalty()

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .victor, in: self.gameModel)
        self.objectToTest?.assign(governor: .victor)
        self.objectToTest?.governor()?.promote(with: .garrisonCommander)

        self.objectToTest?.purchase(unit: .warrior, with: .gold, in: self.gameModel)
        guard let warriorAfter = self.gameModel?.units(at: HexPoint(x: 1, y: 1)).first else {
            XCTFail("cant get unit before")
            return
        }

        let defenseModifierAfter = warriorAfter?.defenseModifier(against: nil, or: nil, on: centerTile, ranged: false, in: self.gameModel)
        let loyaltyAfter = secondCity.loyalty()

        // THEN
        XCTAssertEqual(defenseModifierBefore, 2)
        XCTAssertEqual(defenseModifierAfter, 7)
        XCTAssertEqual(loyaltyBefore, 100)
        XCTAssertEqual(loyaltyAfter, 100)
    }

    // defenseLogistics
    // - City cannot be put under siege. // #
    // - Accumulating Strategic resources gain an additional +1 per turn.
    func testGovernorReynaDefenseLogistics() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // embrasure
    // - City gains an additional Ranged Strike per turn.
    // - Military units trained in this city start with a free promotion that do not already start with a free promotion.
    func testGovernorReynaEmbrasure() throws {

        // GIVEN
        let cityAttacksBefore = self.objectToTest?.numberOfAttacksPerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .victor, in: self.gameModel)
        self.objectToTest?.assign(governor: .victor)
        self.objectToTest?.governor()?.promote(with: .embrasure)

        let cityAttacksAfter = self.objectToTest?.numberOfAttacksPerTurn(in: self.gameModel)

        self.objectToTest?.purchase(unit: .warrior, with: .gold, in: self.gameModel)
        guard self.gameModel?.units(at: HexPoint(x: 1, y: 1)).first != nil else {
            XCTFail("cant get unit before")
            return
        }
        let hasPromotionsAfter = self.playerAlexander?.notifications()?
            .notifications().contains(where: { $0.type == .unitPromotion(location: HexPoint.zero) })

        // THEN
        XCTAssertEqual(cityAttacksBefore, 1)
        XCTAssertEqual(cityAttacksAfter, 2)
        XCTAssertEqual(hasPromotionsAfter, true)
    }

    // airDefenseInitiative
    // - +25 [Strength] Combat Strength to anti-air support units within the city's territory when defending against aircraft and ICBMs. // #
    func testGovernorReynaAirDefenseInitiative() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // armsRaceProponent
    // - 30% [Production] Production increase to all nuclear armament projects in the city. // #
    func testGovernorReynaArmsRaceProponent() throws {

        // GIVEN
        // WHEN
        // THEN
    }
}
