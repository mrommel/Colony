//
//  GovernorEffectTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.07.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

// swiftlint:disable inclusive_language type_body_length
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
    func testGovernorVictorRedoubt() throws {

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
    func testGovernorVictorGarrisonCommander() throws {

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
        let loyaltyBefore = secondCity.loyaltyFromGovernors(in: self.gameModel)

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
        let loyaltyAfter = secondCity.loyaltyFromGovernors(in: self.gameModel)

        // THEN
        XCTAssertEqual(defenseModifierBefore, 2)
        XCTAssertEqual(defenseModifierAfter, 7)
        XCTAssertEqual(loyaltyBefore, 0)
        XCTAssertEqual(loyaltyAfter, 4)
    }

    // defenseLogistics
    // - City cannot be put under siege. // #
    // - Accumulating Strategic resources gain an additional +1 per turn.
    func testGovernorVictorDefenseLogistics() throws {

        // GIVEN
        self.playerAlexander?.changeNumberOfAvailable(resource: .iron, change: 1)
        (self.playerAlexander as? Player)?.doResourceStockpile(in: self.gameModel)

        let availableIronBefore = self.playerAlexander?.numberOfItemsInStockpile(of: .iron)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .victor, in: self.gameModel)
        self.objectToTest?.assign(governor: .victor)
        self.objectToTest?.governor()?.promote(with: .defenseLogistics)

        (self.playerAlexander as? Player)?.doResourceStockpile(in: self.gameModel)

        let availableIronAfter = self.playerAlexander?.numberOfItemsInStockpile(of: .iron)

        // THEN
        XCTAssertEqual(availableIronBefore, 1)
        XCTAssertEqual(availableIronAfter, 3)
    }

    // embrasure
    // - City gains an additional Ranged Strike per turn.
    // - Military units trained in this city start with a free promotion that do not already start with a free promotion.
    func testGovernorVictorEmbrasure() throws {

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
    func testGovernorVictorAirDefenseInitiative() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // armsRaceProponent
    // - 30% [Production] Production increase to all nuclear armament projects in the city. // #
    func testGovernorVictorArmsRaceProponent() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // MARK: governor Amani tests

    // messenger
    // - Can be assigned to a City-state, where she acts as 2 [Envoy] Envoys. // #
    func testGovernorAmaniMessenger() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // emissary
    // - Other cities within 9 tiles and not owned by you gain +2 Loyalty per turn towards your civilization.
    func testGovernorAmaniEmissary() throws {

        // GIVEN
        let trajanCity = City(name: "Cottbus", at: HexPoint(x: 6, y: 4), owner: self.playerTrajan)
        trajanCity.initialize(in: self.gameModel)
        self.gameModel?.add(city: trajanCity)

        let loyaltyBefore = trajanCity.loyaltyFromGovernors(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .amani, in: self.gameModel)
        self.objectToTest?.assign(governor: .amani)
        self.objectToTest?.governor()?.promote(with: .emissary)

        let loyaltyAfter = trajanCity.loyaltyFromGovernors(in: self.gameModel)

        // THEN
        XCTAssertEqual(loyaltyBefore, 0)
        XCTAssertEqual(loyaltyAfter, -2)
    }

    // affluence
    // - While established in a city-state, provides a copy of its Luxury resources to you. // #
    func testGovernorAmaniAffluence() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // localInformants
    // Enemy Spies operate at 3 levels below normal in this city. // #
    func testGovernorAmaniLocalInformants() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // foreignInvestor
    // - While established in a city-state, accumulate its Strategic resources. // #
    // - When suzerain receive double the amount of accumulated strategic resources. // #
    func testGovernorAmaniForeignInvestor() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // puppeteer
    // - While established in a city-state, doubles the number of [Envoy] Envoys you have there. // #
    func testGovernorAmaniPuppeteer() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // MARK: governor Magnus tests

    // groundbreaker
    // - +50% yields from plot harvests and feature removals in the city. // #
    func testGovernorMagnusGroundbreaker() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // surplusLogistics
    // - +20% [Food] Food Growth in the city.
    // - Your [TradeRoute] Trade Routes ending here provide +2 [Food] Food to their starting city.
    func testGovernorMagnusSurplusLogistics() throws {

        // GIVEN
        let secondCity = City(name: "Cottbus", at: HexPoint(x: 6, y: 4), owner: self.playerAlexander)
        secondCity.initialize(in: self.gameModel)
        self.gameModel?.add(city: secondCity)

        try self.playerAlexander?.civics?.discover(civic: .foreignTrade, in: self.gameModel)

        let traderPurchased = secondCity.purchase(unit: .trader, with: .gold, in: self.gameModel)
        XCTAssertEqual(traderPurchased, true, "could not purchase trader")
        guard let trader = self.gameModel?.units(at: HexPoint(x: 6, y: 4)).first else {
            XCTFail("trader not found")
            return
        }

        let tradeRouteEstablished = trader?.doEstablishTradeRoute(to: self.objectToTest, in: self.gameModel)
        XCTAssertEqual(tradeRouteEstablished, true, "could not established trade route")

        let foodBefore = self.objectToTest?.foodPerTurn(in: self.gameModel)
        let foodTradeCityBefore = secondCity.foodPerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .magnus, in: self.gameModel)
        self.objectToTest?.assign(governor: .magnus)
        self.objectToTest?.governor()?.promote(with: .surplusLogistics)

        let foodAfter = self.objectToTest?.foodPerTurn(in: self.gameModel)
        let foodTradeCityAfter = secondCity.foodPerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(foodBefore, 2.0)
        XCTAssertEqual(foodAfter, 2.4)
        XCTAssertEqual(foodTradeCityBefore, 3.0)
        XCTAssertEqual(foodTradeCityAfter, 5.0)
    }

    // provision
    // - Settlers trained in the city do not consume a [Citizen] Citizen Population.
    func testGovernorMagnusProvision() throws {

        // GIVEN
        let populationBefore = self.objectToTest?.population()

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .magnus, in: self.gameModel)
        self.objectToTest?.assign(governor: .magnus)
        self.objectToTest?.governor()?.promote(with: .provision)

        self.objectToTest?.purchase(unit: .settler, with: .gold, in: self.gameModel)
        let populationAfter = self.objectToTest?.population()

        // THEN
        XCTAssertEqual(populationBefore, 12)
        XCTAssertEqual(populationAfter, 12)
    }

    // industrialist
    // - Increase the Power provided by each resource of the Coal Power Plant, Oil Power Plant and Nuclear Power Plant by 1 and the [Production] Production by 2. // #
    func testGovernorMagnusIndustrialist() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // blackMarketeer
    // - Strategic resources for units are discounted 80%.
    func testGovernorMagnusBlackMarketeer() throws {

        // GIVEN
        self.playerAlexander?.changeNumberOfItemsInStockpile(of: .iron, by: 2)
        let ironBefore = self.playerAlexander?.numberOfItemsInStockpile(of: .iron)

        try self.playerAlexander?.techs?.discover(tech: .ironWorking, in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .magnus, in: self.gameModel)
        self.objectToTest?.assign(governor: .magnus)
        self.objectToTest?.governor()?.promote(with: .blackMarketeer)

        let swordmanPurchased = self.objectToTest?.purchase(unit: .swordman, with: .gold, in: self.gameModel)
        XCTAssertEqual(swordmanPurchased, true, "could not purchase swordman")
        let ironAfter = self.playerAlexander?.numberOfItemsInStockpile(of: .iron)

        // THEN
        XCTAssertEqual(ironBefore, 2)
        XCTAssertEqual(ironAfter, 1.8)
    }

    // verticalIntegration
    // - This city receives [Production] Production from any number of Industrial Zones within 6 tiles, not just the first. // #
    func testGovernorMagnusVerticalIntegration() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // MARK: governor Moksha tests

    // bishop
    // - Religious pressure to adjacent cities is 100% stronger from this city. // #
    // - +2 [Faith] Faith per specialty district in this city.
    func testGovernorMokshaX() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .writing, in: self.gameModel)

        self.objectToTest?.purchase(district: .campus, with: .gold, at: HexPoint(x: 3, y: 1), in: self.gameModel)
        XCTAssertEqual(self.objectToTest?.has(district: .campus), true)
        let faithBefore = self.objectToTest?.faithPerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .moksha, in: self.gameModel)
        self.objectToTest?.assign(governor: .moksha)
        // self.objectToTest?.governor()?.promote(with: .bishop)

        let faithAfter = self.objectToTest?.faithPerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(faithBefore, 0)
        XCTAssertEqual(faithAfter, 2)
    }

    // grandInquisitor
    // - +10 [ReligiousStrength] Religious Strength in theological combat in tiles of this city. // #
    func testGovernorMokshaGrandInquisitor() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // layingOnOfHands
    // - All Governor's units heal fully in one turn in tiles of this city.
    func testGovernorMokshaLayingOnOfHands() throws {

        // GIVEN
        let warriorPurchased = self.objectToTest?.purchase(unit: .warrior, with: .gold, in: self.gameModel)
        XCTAssertEqual(warriorPurchased, true, "could not purchase warrior")
        guard let warrior = self.gameModel?.units(at: HexPoint(x: 1, y: 1)).first else {
            XCTFail("warrior not found")
            return
        }

        warrior?.set(healthPoints: 10)
        let healthBefore = warrior?.healthPoints()

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .moksha, in: self.gameModel)
        self.objectToTest?.assign(governor: .moksha)
        self.objectToTest?.governor()?.promote(with: .layingOnOfHands)

        warrior?.doHeal(in: self.gameModel)
        let healthAfter = warrior?.healthPoints()

        // THEN
        XCTAssertEqual(healthBefore, 10)
        XCTAssertEqual(healthAfter, 100)
    }

    // citadelOfGod
    // - City ignores pressure and combat effects from Religions not founded by the Governor's player. // #
    // - Gain [Faith] Faith equal to 25% of the construction cost when finishing buildings. // #
    func testGovernorMokshaCitadelOfGod() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // patronSaint
    // - Apostles and Warrior Monks trained in the city receive 1 extra Promotion when receiving their first promotion. // #
    func testGovernorMokshaPatronSaint() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // divineArchitect
    // - Allows city to purchase Districts with [Faith] Faith. - cannot be tested
    func testGovernorMokshaDivineArchitect() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // MARK: governor Liang tests

    // guildmaster
    // - All Builders trained in city get +1 build charge.
    func testGovernorLiangGuildmaster() throws {

        // GIVEN
        let builderBeforePurchased = self.objectToTest?.purchase(unit: .builder, with: .gold, in: self.gameModel)
        XCTAssertEqual(builderBeforePurchased, true, "could not purchase builder")
        guard let builderBefore = self.gameModel?.units(at: HexPoint(x: 1, y: 1)).first else {
            XCTFail("builder not found")
            return
        }

        let chargesBefore = builderBefore?.buildCharges()
        builderBefore?.doKill(delayed: false, by: nil, in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .liang, in: self.gameModel)
        self.objectToTest?.assign(governor: .liang)
        // self.objectToTest?.governor()?.promote(with: .guildmaster) - default

        let builderAfterPurchased = self.objectToTest?.purchase(unit: .builder, with: .gold, in: self.gameModel)
        XCTAssertEqual(builderAfterPurchased, true, "could not purchase builder")
        guard let builderAfter = self.gameModel?.units(at: HexPoint(x: 1, y: 1)).first else {
            XCTFail("builder not found")
            return
        }

        let chargesAfter = builderAfter?.buildCharges()

        // THEN
        XCTAssertEqual(chargesBefore, 3)
        XCTAssertEqual(chargesAfter, 4)
    }

    // zoningCommissioner
    // - +20% [Production] Production towards constructing Districts in the city.
    func testGovernorLiangZoningCommissioner() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .writing, in: self.gameModel)

        self.objectToTest?.startBuilding(district: .campus, at: HexPoint(x: 3, y: 1), in: self.gameModel)
        self.objectToTest?.doTurn(in: self.gameModel)

        let productionBefore = self.objectToTest?.currentBuildableItem()?.production

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .liang, in: self.gameModel)
        self.objectToTest?.assign(governor: .liang)
        self.objectToTest?.governor()?.promote(with: .zoningCommissioner)

        self.objectToTest?.doTurn(in: self.gameModel)

        let productionAfter = self.objectToTest?.currentBuildableItem()?.production

        // THEN
        XCTAssertEqual(productionBefore, 2.0)
        XCTAssertEqual(productionAfter, 4.4) // 4.0 without governor bonus
    }

    // aquaculture
    // - The Fishery unique improvement can be built in the city on coastal plots. // #
    // - Yields 1 [Food] Food, +1 [Food] Food for each adjacent sea resource. // #
    // - Fisheries provide +1 [Production] Production if Liang is in the city. // #
    func testGovernorLiangAquaculture() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // reinforcedMaterials
    // - This city's improvements, buildings and Districts cannot be damaged by Environmental Effects. // #
    func testGovernorLiangReinforcedMaterials() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // waterWorks
    // - +2 [Housing] Housing for every Neighborhood and Aqueduct district in this city.
    // - +1 [Amenity] Amenity for every Canal and Dam district in this city. // #
    func testGovernorLiangWaterWorks() throws {

        // GIVEN
        try self.playerAlexander?.civics?.discover(civic: .urbanization, in: self.gameModel)

        self.objectToTest?.purchase(district: .neighborhood, with: .gold, at: HexPoint(x: 3, y: 1), in: self.gameModel)
        XCTAssertEqual(self.objectToTest?.has(district: .neighborhood), true)
        let housingBefore = self.objectToTest?.housingPerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .liang, in: self.gameModel)
        self.objectToTest?.assign(governor: .liang)
        self.objectToTest?.governor()?.promote(with: .waterWorks)

        let housingAfter = self.objectToTest?.housingPerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(housingBefore, 7)
        XCTAssertEqual(housingAfter, 9)
    }

    // parksAndRecreation:
    // - The City Park unique improvement can be built in the city. // #
    // - Yields 2 Appeal and 1 [Culture] Culture. // #
    // - +1 [Amenity] Amenity if adjacent to water. // #
    // - City Parks provide 3 [Culture] Culture if Liang is in the city. // #
    func testGovernorLiangParksAndRecreation() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // MARK: governor Pingala tests

    // librarian
    // - +15% increase in [Science] Science and [Culture] Culture generated by the city.
    func testGovernorPingalaLibrarian() throws {

        // GIVEN
        let scienceBefore = self.objectToTest?.sciencePerTurn(in: self.gameModel)
        let cultureBefore = self.objectToTest?.culturePerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .pingala, in: self.gameModel)
        self.objectToTest?.assign(governor: .pingala)
        // self.objectToTest?.governor()?.promote(with: .librarian) - default

        let scienceAfter = self.objectToTest?.sciencePerTurn(in: self.gameModel)
        let cultureAfter = self.objectToTest?.culturePerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(scienceBefore, 6.0)
        XCTAssertEqual(scienceAfter, 6.8999999999999995)
        XCTAssertEqual(cultureBefore, 5.6)
        XCTAssertEqual(cultureAfter, 6.4399999999999995)
    }

    // connoisseur
    // - +1 [Culture] Culture per turn for each Citizen in the city.
    func testGovernorPingalaConnoisseur() throws {

        // GIVEN
        let cultureBefore = self.objectToTest?.culturePerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .pingala, in: self.gameModel)
        self.objectToTest?.assign(governor: .pingala)
        self.objectToTest?.governor()?.promote(with: .connoisseur)

        let cultureAfter = self.objectToTest?.culturePerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(cultureBefore, 5.6)
        XCTAssertEqual(cultureAfter, 20.24) // ???
    }

    // researcher
    // - +1 [Science] Science per turn for each Citizen in the city.
    func testGovernorPingalaResearcher() throws {

        // GIVEN
        let scienceBefore = self.objectToTest?.sciencePerTurn(in: self.gameModel)

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .pingala, in: self.gameModel)
        self.objectToTest?.assign(governor: .pingala)
        self.objectToTest?.governor()?.promote(with: .researcher)

        let scienceAfter = self.objectToTest?.sciencePerTurn(in: self.gameModel)

        // THEN
        XCTAssertEqual(scienceBefore, 6.0)
        XCTAssertEqual(scienceAfter, 20.7) // ???
    }

    // grants
    // - +100% [GreatPeople] Great People points generated per turn in the city.
    func testGovernorPingalaGrants() throws {

        // GIVEN
        try self.playerAlexander?.techs?.discover(tech: .writing, in: self.gameModel)

        self.objectToTest?.purchase(district: .campus, with: .gold, at: HexPoint(x: 3, y: 1), in: self.gameModel)
        XCTAssertEqual(self.objectToTest?.has(district: .campus), true)

        let greatScientistPointsBefore = self.objectToTest?.greatPeoplePointsPerTurn(in: self.gameModel).greatScientist

        // WHEN
        self.playerAlexander?.governors?.addTitle()
        self.playerAlexander?.governors?.appoint(governor: .pingala, in: self.gameModel)
        self.objectToTest?.assign(governor: .pingala)
        self.objectToTest?.governor()?.promote(with: .grants)

        let greatScientistPointsAfter = self.objectToTest?.greatPeoplePointsPerTurn(in: self.gameModel).greatScientist

        // THEN
        XCTAssertEqual(greatScientistPointsBefore, 1)
        XCTAssertEqual(greatScientistPointsAfter, 2)
    }

    // spaceInitiative
    // - 30% [Production] Production increase to all space-program projects in the city. // #
    func testGovernorPingalaSpaceInitiative() throws {

        // GIVEN
        // WHEN
        // THEN
    }

    // curator
    // - +100% [Tourism] Tourism from Great Works of Art, Music, and Writing in the city. // #
    func testGovernorPingalaCurator() throws {

        // GIVEN
        // WHEN
        // THEN
    }
}
