//
//  DiplomaticDealAITests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 25.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class DiplomaticDealAITests: XCTestCase {

    var objectToTest: DiplomaticDealAI?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testOfferValueGiveGoldInsulting() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .trajan)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .give, amount: 2))

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)

        // THEN
        XCTAssertEqual(response, .insulting)
    }

    func testOfferValueReceiveGoldAcceptable() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .trajan)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .receive, amount: 2))

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)

        // THEN
        XCTAssertEqual(response, .acceptable)
    }

    func testOfferValueAcceptableGoldAndGold() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .trajan)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .give, amount: 4))
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .receive, amount: 4))

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)

        // THEN
        XCTAssertEqual(response, .acceptable)
    }

    func testOfferValueAccepableGoldAndGoldPerTurn() {

        // GIVEN
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .trajan)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .give, amount: 4))
        // gold per turn is valued only 80% because of the risk
        deal.tradeItems.append(DiplomaticGoldPerTurnDealItem(direction: .receive, amount: 1, duration: 5))

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .tiny)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerAlexander, playerTrajan],
            on: mapModel
        )

        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)

        // THEN
        XCTAssertEqual(response, .acceptable)
    }
}
