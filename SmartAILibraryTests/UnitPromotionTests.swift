//
//  UnitPromotionTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 20.06.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class UnitPromotionTests: XCTestCase {

    var gameModel: GameModel?

    override func setUpWithError() throws {

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        self.gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        self.gameModel?.userInterface = userInterface
    }

    override func tearDownWithError() throws {

        self.gameModel = nil
    }

    // MARK: recon promotions

    // ranger - Faster Movement in Woods and Jungle terrain.
    func testReconPromotionRanger() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        // add forest and block alternative route
        self.gameModel?.tile(at: HexPoint(x: 2, y: 3))?.set(feature: .forest)
        self.gameModel?.tile(at: HexPoint(x: 3, y: 3))?.set(terrain: .ocean)

        let options = MoveOptions()
        let pathNoPromotion = humanPlayerScout.path(towards: HexPoint(x: 2, y: 4), options: options, in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .ranger)
        let pathPromotion = humanPlayerScout.path(towards: HexPoint(x: 2, y: 4), options: options, in: self.gameModel)

        // THEN
        XCTAssertEqual(pathNoPromotion?.cost, 3.0)
        XCTAssertEqual(pathPromotion?.cost, 2.0)
    }

    // alpine - Faster Movement on Hill terrain.
    func testReconPromotionAlpine() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        // add hill and block alternative route
        self.gameModel?.tile(at: HexPoint(x: 2, y: 3))?.set(hills: true)
        self.gameModel?.tile(at: HexPoint(x: 3, y: 3))?.set(terrain: .ocean)

        let options = MoveOptions()
        let pathNoPromotion = humanPlayerScout.path(towards: HexPoint(x: 2, y: 4), options: options, in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .alpine)
        let pathPromotion = humanPlayerScout.path(towards: HexPoint(x: 2, y: 4), options: options, in: self.gameModel)

        // THEN
        XCTAssertEqual(pathNoPromotion?.cost, 3.0)
        XCTAssertEqual(pathPromotion?.cost, 2.0)
    }

    // sentry - Can see through Woods and Jungle.
    func testReconPromotionSentry() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 1), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        // add hill and block alternative route
        self.gameModel?.tile(at: HexPoint(x: 2, y: 3))?.set(hills: true)
        self.gameModel?.tile(at: HexPoint(x: 2, y: 3))?.set(feature: .forest)
        self.gameModel?.tile(at: HexPoint(x: 3, y: 3))?.set(hills: true)
        self.gameModel?.tile(at: HexPoint(x: 3, y: 3))?.set(feature: .forest)

        let targetTile = self.gameModel?.tile(at: HexPoint(x: 2, y: 4))!

        let canSeeBefore = targetTile?.isVisible(to: humanPlayer)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .sentry)
        _ = humanPlayerScout.doMove(on: HexPoint(x: 2, y: 2), in: self.gameModel)
        let canSeeAfter = targetTile?.isVisible(to: humanPlayer)

        // THEN
        XCTAssertEqual(canSeeBefore, false)
        XCTAssertEqual(canSeeAfter, true)
    }

    // guerrilla - Can move after attacking.
    func testReconPromotionGuerrilla() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 1), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let barbarianPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerWarrior)

        humanPlayer.startTurn(in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .guerrilla)
        _ = humanPlayerScout.doAttack(into: HexPoint(x: 2, y: 2), steps: 1, in: self.gameModel)
        let canAttack = humanPlayerScout.canMove()

        // THEN
        XCTAssertEqual(canAttack, true)
    }

    // spyglass - +1 sight range.
    func testReconPromotionSpyglass() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 1), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let sightBefore = humanPlayerScout.sight()

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .spyglass)
        let sightAfter = humanPlayerScout.sight()

        // THEN
        XCTAssertEqual(sightBefore, 2)
        XCTAssertEqual(sightAfter, 3)
    }

    // ambush - +20 Combat Strength in all situations.
    func testReconPromotionAmbush() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 1), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let barbarianPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerWarrior)

        humanPlayer.startTurn(in: self.gameModel)

        let attModWarBefore = humanPlayerScout.attackModifier(against: barbarianPlayerWarrior, or: nil, in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .ambush)
        let attModWarAfter = humanPlayerScout.attackModifier(against: barbarianPlayerWarrior, or: nil, in: self.gameModel)

        // THEN
        XCTAssertEqual(attModWarBefore, 0)
        XCTAssertEqual(attModWarAfter, 20)
    }

    // camouflage - Only adjacent enemy units can reveal this unit.
    func testReconPromotionCamouflage() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 1), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let barbarianPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerWarrior)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .camouflage)

        // THEN
    }
}
