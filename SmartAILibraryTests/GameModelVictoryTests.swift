//
//  GameModelVictoryTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 04.11.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GameModelVictoryTests: XCTestCase {

    func testNoVictory() {

        // GIVEN
        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerElizabeth, playerTrajan, playerAlexander],
            on: mapModel
        )

        // WHEN
        gameModel.doTestVictory()
        let winnerVictory = gameModel.winnerVictory()

        // THEN
        XCTAssertEqual(winnerVictory, nil)
    }

    func testScoreVictory() {

        // GIVEN
        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerElizabeth = Player(leader: .victoria)
        playerElizabeth.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerElizabeth, playerTrajan, playerAlexander],
            on: mapModel
        )

        let humanCapital = City(name: "Human Capital", at: HexPoint(x: 17, y: 7), capital: true, owner: playerAlexander)
        humanCapital.initialize(in: gameModel)
        gameModel.add(city: humanCapital)

        gameModel.currentTurn = 500

        // WHEN
        gameModel.doTestVictory()
        let winnerVictory = gameModel.winnerVictory()
        let winnerLeader = gameModel.winnerLeader()

        // THEN
        XCTAssertEqual(winnerVictory, .score)
        XCTAssertEqual(winnerLeader, .alexander)
    }

    func testScienceVictory() {

        // GIVEN
        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .science, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerVictoria, playerTrajan, playerAlexander],
            on: mapModel
        )

        let humanCapital = City(name: "Human Capital", at: HexPoint(x: 17, y: 7), capital: true, owner: playerAlexander)
        humanCapital.initialize(in: gameModel)
        gameModel.add(city: humanCapital)

        _ = humanCapital.purchase(project: .launchEarthSatellite, in: gameModel)
        _ = humanCapital.purchase(project: .launchMoonLanding, in: gameModel)
        _ = humanCapital.purchase(project: .launchMarsColony, in: gameModel)
        _ = humanCapital.purchase(project: .exoplanetExpedition, in: gameModel)
        _ = humanCapital.purchase(project: .terrestrialLaserStation, in: gameModel)

        // cheating
        for _ in 0...50 {
            playerAlexander.doSpaceRace(in: gameModel)
        }

        // WHEN
        gameModel.doTestVictory()
        let winnerVictory = gameModel.winnerVictory()
        let winnerLeader = gameModel.winnerLeader()

        // THEN
        XCTAssertEqual(winnerVictory, .science)
        XCTAssertEqual(winnerLeader, .alexander)
    }

    func testCultureVictory() {

        // GIVEN
        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .science, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerVictoria, playerTrajan, playerAlexander],
            on: mapModel
        )

        let alexanderCapital = City(name: "Alexander Capital", at: HexPoint(x: 17, y: 17), capital: true, owner: playerAlexander)
        alexanderCapital.initialize(in: gameModel)
        gameModel.add(city: alexanderCapital)

        let trajanCapital = City(name: "Trajan Capital", at: HexPoint(x: 17, y: 7), capital: true, owner: playerTrajan)
        trajanCapital.initialize(in: gameModel)
        gameModel.add(city: trajanCapital)

        let victoriaCapital = City(name: "Victoria Capital", at: HexPoint(x: 7, y: 17), capital: true, owner: playerVictoria)
        victoriaCapital.initialize(in: gameModel)
        gameModel.add(city: victoriaCapital)

        // tourism
        playerAlexander.tourism?.set(lifetimeCulture: 1000)
        playerAlexander.tourism?.set(lifetimeTourism: 2000, for: .trajan)
        playerAlexander.tourism?.set(lifetimeTourism: 3000, for: .victoria)

        // WHEN
        gameModel.doTestVictory()
        let winnerVictory = gameModel.winnerVictory()
        let winnerLeader = gameModel.winnerLeader()

        // THEN
        XCTAssertEqual(winnerVictory, .cultural)
        XCTAssertEqual(winnerLeader, .alexander)
    }

    func testDominationVictory() {

        // GIVEN
        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .science, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerVictoria, playerTrajan, playerAlexander],
            on: mapModel
        )

        let alexanderCapital = City(name: "Alexander Capital", at: HexPoint(x: 17, y: 17), capital: true, owner: playerAlexander)
        alexanderCapital.initialize(in: gameModel)
        gameModel.add(city: alexanderCapital)

        let trajanCapital = City(name: "Trajan Capital", at: HexPoint(x: 17, y: 7), capital: true, owner: playerTrajan)
        trajanCapital.initialize(in: gameModel)
        gameModel.add(city: trajanCapital)

        let victoriaCapital = City(name: "Victoria Capital", at: HexPoint(x: 7, y: 17), capital: true, owner: playerVictoria)
        victoriaCapital.initialize(in: gameModel)
        gameModel.add(city: victoriaCapital)

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerAlexander.doFirstContact(with: playerVictoria, in: gameModel)

        // conquer cities
        playerAlexander.acquire(city: trajanCapital, conquest: true, gift: false, in: gameModel)
        playerAlexander.acquire(city: victoriaCapital, conquest: true, gift: false, in: gameModel)

        // WHEN
        gameModel.doTestVictory()
        let winnerVictory = gameModel.winnerVictory()
        let winnerLeader = gameModel.winnerLeader()

        // THEN
        XCTAssertEqual(winnerVictory, .domination)
        XCTAssertEqual(winnerLeader, .alexander)
    }

    func testReligiousVictory() {

        // GIVEN
        // players
        let playerBarbar = Player(leader: .barbar)
        playerBarbar.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerVictoria = Player(leader: .victoria)
        playerVictoria.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination, .science, .cultural, .diplomatic, .religious],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbar, playerVictoria, playerTrajan, playerAlexander],
            on: mapModel
        )

        let alexanderCapital = City(name: "Alexander Capital", at: HexPoint(x: 17, y: 17), capital: true, owner: playerAlexander)
        alexanderCapital.initialize(in: gameModel)
        gameModel.add(city: alexanderCapital)

        let trajanCapital = City(name: "Trajan Capital", at: HexPoint(x: 17, y: 7), capital: true, owner: playerTrajan)
        trajanCapital.initialize(in: gameModel)
        gameModel.add(city: trajanCapital)

        let victoriaCapital = City(name: "Victoria Capital", at: HexPoint(x: 7, y: 17), capital: true, owner: playerVictoria)
        victoriaCapital.initialize(in: gameModel)
        gameModel.add(city: victoriaCapital)

        playerAlexander.doFirstContact(with: playerTrajan, in: gameModel)
        playerAlexander.doFirstContact(with: playerVictoria, in: gameModel)
        playerAlexander.religion?.found(religion: .catholicism, at: alexanderCapital, in: gameModel)

        // convert cities
        trajanCapital.cityReligion?.addReligiousPressure(reason: .followerChangeAdoptFully, pressure: 20000, for: .catholicism, in: gameModel)
        victoriaCapital.cityReligion?.addReligiousPressure(reason: .followerChangeAdoptFully, pressure: 20000, for: .catholicism, in: gameModel)

        // WHEN
        gameModel.doTestVictory()
        let winnerVictory = gameModel.winnerVictory()
        let winnerLeader = gameModel.winnerLeader()

        // THEN
        XCTAssertEqual(winnerVictory, .religious)
        XCTAssertEqual(winnerLeader, .alexander)
    }
}
