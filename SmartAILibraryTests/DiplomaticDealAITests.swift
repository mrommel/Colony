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
        let playerAlexander = Player(leader: .alexander)
        let playerAugustus = Player(leader: .augustus)
        
        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .augustus)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .give, amount: 2))
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAugustus, playerAlexander], on: mapModel)
        
        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)
        
        // THEN
        XCTAssertEqual(response, .insulting)
    }
    
    func testOfferValueReceiveGoldAcceptable() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        let playerAugustus = Player(leader: .augustus)
        
        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .augustus)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .receive, amount: 2))
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAugustus, playerAlexander], on: mapModel)
        
        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)
        
        // THEN
        XCTAssertEqual(response, .acceptable)
    }
    
    func testOfferValueAcceptableGoldAndGold() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        let playerAugustus = Player(leader: .augustus)
        
        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .augustus)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .give, amount: 4))
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .receive, amount: 4))
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAugustus, playerAlexander], on: mapModel)
        
        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)
        
        // THEN
        XCTAssertEqual(response, .acceptable)
    }
    
    func testOfferValueAccepableGoldAndGoldPerTurn() {
        
        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        let playerAugustus = Player(leader: .augustus)
        
        self.objectToTest = DiplomaticDealAI(player: playerAlexander)
        let deal = DiplomaticDeal(from: .alexander, to: .augustus)
        deal.tradeItems.append(DiplomaticGoldDealItem(direction: .give, amount: 4))
        deal.tradeItems.append(DiplomaticGoldPerTurnDealItem(direction: .receive, amount: 1, duration: 5)) // gold per turn is valued only 80% because of the risk
        
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .tiny)
        
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic], handicap: .chieftain, turnsElapsed: 0, players: [playerAugustus, playerAlexander], on: mapModel)
        
        // WHEN
        let response = self.objectToTest!.offer(deal: deal, with: gameModel)
        
        // THEN
        XCTAssertEqual(response, .acceptable)
    }
}
