//
//  PlayerCityStateQuestTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class PlayerCityStateQuestTests: XCTestCase {

    func testQuestAfterMeetingCityState() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        let questsBefore = playerTrajan.ownQuests(in: gameModel)

        // WHEN
        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        let questsAfter = playerTrajan.ownQuests(in: gameModel)

        // THEN
        XCTAssertEqual(questsBefore.count, 0)
        XCTAssertEqual(questsAfter.count, 1)
    }

    func testTrainUnitQuestFulfilled() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        try playerTrajan.techs?.discover(tech: .horsebackRiding, in: gameModel)
        playerTrajan.treasury?.changeGold(by: 1000)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .trainUnit(type: .horseman)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        let unitBought = playerTrajanCity.purchase(unit: .horseman, with: .gold, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore, .trainUnit(type: .horseman))
        XCTAssertTrue(unitBought)
        XCTAssertNotEqual(questAfter, .trainUnit(type: .horseman))
    }

    func testTrainUnitQuestObsolete() throws {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        try playerTrajan.techs?.discover(tech: .wheel, in: gameModel)
        playerTrajan.treasury?.changeGold(by: 1000)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(
            quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .trainUnit(type: .heavyChariot)),
            for: playerTrajan.leader
        )

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        try playerTrajan.techs?.discover(tech: .stirrups, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore, .trainUnit(type: .heavyChariot))
        XCTAssertNotEqual(questAfter, .trainUnit(type: .heavyChariot))
    }

    func testSendTradeRouteQuestFulfilled() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAmsterdam = Player(leader: .cityState(type: .amsterdam))
        playerAmsterdam.initialize()

        let playerAkkad = Player(leader: .cityState(type: .akkad))
        playerAkkad.initialize()

        let playerAlexander = Player(leader: .alexander)
        playerAlexander.initialize()

        let playerTrajan = Player(leader: .trajan, isHuman: true)
        playerTrajan.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerAmsterdam, playerAkkad, playerAlexander, playerTrajan],
            on: mapModel
        )

        // initial cities

        let playerTrajanCity = City(name: "Trajan City", at: HexPoint(x: 15, y: 15), capital: true, owner: playerTrajan)
        playerTrajanCity.initialize(in: gameModel)
        gameModel.add(city: playerTrajanCity)

        let playerAmsterdamCity = City(name: "Amsterdam", at: HexPoint(x: 5, y: 5), capital: true, owner: playerAmsterdam)
        playerAmsterdamCity.initialize(in: gameModel)
        gameModel.add(city: playerAmsterdamCity)

        // initial units

        let playerTrajanTrader = Unit(at: HexPoint(x: 15, y: 15), name: "Trader", type: .trader, owner: playerTrajan)
        gameModel.add(unit: playerTrajanTrader)

        playerTrajan.doFirstContact(with: playerAmsterdam, in: gameModel)
        playerAmsterdam.set(quest: CityStateQuest(cityState: .amsterdam, leader: .trajan, type: .sendTradeRoute), for: playerTrajan.leader)

        let questBefore = playerAmsterdam.quest(for: .trajan)

        // WHEN
        _ = playerTrajan.doEstablishTradeRoute(from: playerTrajanCity, to: playerAmsterdamCity, with: playerTrajanTrader, in: gameModel)
        let questAfter = playerAmsterdam.quest(for: .trajan)

        // THEN
        XCTAssertEqual(questBefore, .sendTradeRoute)
        XCTAssertNotEqual(questAfter, .sendTradeRoute)
    }
}
