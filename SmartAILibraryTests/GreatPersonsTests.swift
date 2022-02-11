//
//  GreatPersonsTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 02.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GreatPersonsTests: XCTestCase {

    func testFillCurrentAncient() {

        // GIVEN
        let greatPersons = GreatPersons()

        // WHEN

        // THEN
        XCTAssertEqual(greatPersons.current.count, 6)
    }

    func testFillCurrentClassical() {

        // GIVEN
        let greatPersons = GreatPersons()

        // WHEN
        greatPersons.fillCurrent(in: .classical)

        // THEN
        XCTAssertEqual(greatPersons.current.count, 7)
        XCTAssertNil(greatPersons.person(of: .greatMusician))
    }

    func testFillCurrentMedieval() {

        // GIVEN
        let greatPersons = GreatPersons()

        // WHEN
        greatPersons.fillCurrent(in: .medieval)

        // THEN
        XCTAssertEqual(greatPersons.current.count, 8)
        XCTAssertNil(greatPersons.person(of: .greatMusician))
    }

    func testInvalidate() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerElizabeth, playerAugustus, playerAlexander],
            on: mapModel
        )

        playerAlexander.set(era: .classical, in: gameModel)
        playerAugustus.set(era: .medieval, in: gameModel)
        playerElizabeth.set(era: .medieval, in: gameModel)

        let greatPersons = GreatPersons()
        let person = greatPersons.person(of: GreatPersonType.greatGeneral)

        // WHEN
        greatPersons.invalidate(greatPerson: person!, in: gameModel)

        // THEN
        let person2 = greatPersons.person(of: GreatPersonType.greatGeneral)
        XCTAssertNotEqual(person, person2)
    }

    func testCostSameEra() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerElizabeth, playerAugustus, playerAlexander],
            on: mapModel
        )

        playerAlexander.set(era: .classical, in: gameModel)
        playerAugustus.set(era: .medieval, in: gameModel)
        playerElizabeth.set(era: .medieval, in: gameModel)

        // WHEN
        let cost = gameModel.cost(of: .greatGeneral, for: playerAlexander)

        // THEN
        XCTAssertEqual(cost, 60)
    }

    func testCostNextEra() {

        // GIVEN

        // players
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // player 2
        let playerAugustus = Player(leader: .trajan)
        playerAugustus.initialize()

        // player 3
        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, playerElizabeth, playerAugustus, playerAlexander],
            on: mapModel
        )

        playerAlexander.set(era: .classical, in: gameModel)
        playerAugustus.set(era: .medieval, in: gameModel)
        playerElizabeth.set(era: .medieval, in: gameModel)

        // WHEN
        //playerAlexander.greatPeople?.add(points: GreatPersonPoints(greatGeneral: 61))
        //playerAlexander.doGreatPeople(in: gameModel)
        guard let person = gameModel.greatPerson(of: GreatPersonType.greatGeneral, points: 100, for: playerAlexander) else {
            fatalError("abc")
        }
        gameModel.invalidate(greatPerson: person)
        let cost = gameModel.cost(of: .greatGeneral, for: playerAlexander)

        // THEN
        XCTAssertEqual(cost, 156)
    }
}
