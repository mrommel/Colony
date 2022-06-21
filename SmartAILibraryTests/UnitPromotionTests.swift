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
        let canMove = humanPlayerScout.canMove()

        // THEN
        XCTAssertEqual(canMove, true)
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

    // MARK: melee promotions

    // battlecry - +7 Combat Strength vs. melee and ranged units.
    func testMeleePromotionBattlecry() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let barbarianPlayerMelee = Unit(at: HexPoint(x: 2, y: 1), type: .warrior, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerMelee)

        let barbarianPlayerRecon = Unit(at: HexPoint(x: 2, y: 3), type: .scout, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerRecon)

        humanPlayer.startTurn(in: self.gameModel)

        let attModMeleeBefore = humanPlayerScout.attackModifier(against: barbarianPlayerMelee, or: nil, in: self.gameModel)
        let defModMeleeBefore = humanPlayerScout.defenseModifier(against: barbarianPlayerMelee, or: nil, on: nil, ranged: true, in: self.gameModel)
        let attModReconBefore = humanPlayerScout.attackModifier(against: barbarianPlayerRecon, or: nil, in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .battlecry)
        let attModMeleeAfter = humanPlayerScout.attackModifier(against: barbarianPlayerMelee, or: nil, in: self.gameModel)
        let defModMeleeAfter = humanPlayerScout.defenseModifier(against: barbarianPlayerMelee, or: nil, on: nil, ranged: true, in: self.gameModel)
        let attModReconAfter = humanPlayerScout.attackModifier(against: barbarianPlayerRecon, or: nil, in: self.gameModel)

        // THEN
        XCTAssertEqual(attModMeleeBefore, 0)
        XCTAssertEqual(defModMeleeBefore, 0)
        XCTAssertEqual(attModReconBefore, 0)
        XCTAssertEqual(attModMeleeAfter, 7) // melee or ranged
        XCTAssertEqual(defModMeleeAfter, 7) // same here
        XCTAssertEqual(attModReconAfter, 0) // but not recon
    }

    // tortoise - +10 Combat Strength when defending against ranged attacks.
    func testMeleePromotionTortoise() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let barbarianPlayerRanged = Unit(at: HexPoint(x: 2, y: 3), type: .slinger, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerRanged)

        humanPlayer.startTurn(in: self.gameModel)

        let defModMeleeBefore = humanPlayerScout.defenseModifier(against: barbarianPlayerRanged, or: nil, on: nil, ranged: true, in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .tortoise)
        let defModMeleeAfter = humanPlayerScout.defenseModifier(against: barbarianPlayerRanged, or: nil, on: nil, ranged: true, in: self.gameModel)

        // THEN
        XCTAssertEqual(defModMeleeBefore, 0)
        XCTAssertEqual(defModMeleeAfter, 10) // ranged defense
    }

    // commando - Can scale Cliff walls. +1 Movement.
    func testMeleePromotionCommando() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let scoutMovesBefore = humanPlayerScout.maxMoves(in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .commando)
        let scoutMovesAfter = humanPlayerScout.maxMoves(in: self.gameModel)

        // THEN
        XCTAssertEqual(scoutMovesBefore, 3)
        XCTAssertEqual(scoutMovesAfter, 4)
    }

    // amphibious - No Combat Strength and Movement penalty when attacking from Sea or over a River.

    // zweihander - +7 Combat Strength vs. anti-cavalry units.
    func testMeleePromotionZweihander() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let barbarianPlayerAntiCavalry = Unit(at: HexPoint(x: 2, y: 3), type: .spearman, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerAntiCavalry)

        humanPlayer.startTurn(in: self.gameModel)

        let attModMeleeBefore = humanPlayerScout.attackModifier(against: barbarianPlayerAntiCavalry, or: nil, on: nil, in: self.gameModel)
        let defModMeleeBefore = humanPlayerScout.defenseModifier(
            against: barbarianPlayerAntiCavalry, or: nil, on: nil, ranged: false, in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .zweihander)
        let attModMeleeAfter = humanPlayerScout.attackModifier(against: barbarianPlayerAntiCavalry, or: nil, on: nil, in: self.gameModel)
        let defModMeleeAfter = humanPlayerScout.defenseModifier(
            against: barbarianPlayerAntiCavalry, or: nil, on: nil, ranged: true, in: self.gameModel)

        // THEN
        XCTAssertEqual(attModMeleeBefore, 0)
        XCTAssertEqual(defModMeleeBefore, 0)
        XCTAssertEqual(attModMeleeAfter, 7)
        XCTAssertEqual(defModMeleeAfter, 7)
    }

    // urbanWarfare - +10 Combat Strength when fighting in a district.

    // eliteGuard - +1 additional attack per turn if Movement allows. Can move after attacking.
    func testMeleePromotionEliteGuard() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerScout)

        let barbarianPlayerAntiCavalry = Unit(at: HexPoint(x: 2, y: 3), type: .spearman, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerAntiCavalry)

        humanPlayer.startTurn(in: self.gameModel)

        // WHEN
        try humanPlayerScout.promotions?.earn(promotion: .eliteGuard)
        _ = humanPlayerScout.doAttack(into: HexPoint(x: 2, y: 3), steps: 1, in: self.gameModel)
        let canMove = humanPlayerScout.canMove()
        let canAttack = humanPlayerScout.canAttack()

        // THEN
        XCTAssertEqual(canMove, true)
        XCTAssertEqual(canAttack, true)
    }

    // MARK: ranged promotions

    // volley - +5 Ranged Strength vs. land units.
    func testRangedPromotionVolley() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerArcher = Unit(at: HexPoint(x: 2, y: 2), type: .archer, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerArcher)

        let barbarianPlayerAntiCavalry = Unit(at: HexPoint(x: 2, y: 3), type: .spearman, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerAntiCavalry)

        let attModRangedBefore = humanPlayerArcher.attackModifier(against: barbarianPlayerAntiCavalry, or: nil, on: nil, in: self.gameModel)

        // WHEN
        try humanPlayerArcher.promotions?.earn(promotion: .volley)
        let attModRangedAfter = humanPlayerArcher.attackModifier(against: barbarianPlayerAntiCavalry, or: nil, on: nil, in: self.gameModel)

        // THEN
        XCTAssertEqual(attModRangedBefore, 0)
        XCTAssertEqual(attModRangedAfter, 5)
    }

    // garrison - +10 Combat Strength when occupying a district or Fort.

    // arrowStorm - +7 Ranged Strength vs. land and naval units.
    func testRangedPromotionArrowStorm() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        self.gameModel?.tile(at: HexPoint(x: 1, y: 2))?.set(terrain: .shore)

        let humanPlayerArcher = Unit(at: HexPoint(x: 2, y: 2), type: .archer, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerArcher)

        let barbarianPlayerAntiCavalry = Unit(at: HexPoint(x: 2, y: 3), type: .spearman, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerAntiCavalry)

        let barbarianPlayerShip = Unit(at: HexPoint(x: 1, y: 2), type: .galley, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerShip)

        let attModRangedLandBefore = humanPlayerArcher.attackModifier(against: barbarianPlayerAntiCavalry, or: nil, on: nil, in: self.gameModel)
        let attModRangedNavalBefore = humanPlayerArcher.attackModifier(against: barbarianPlayerShip, or: nil, on: nil, in: self.gameModel)

        // WHEN
        try humanPlayerArcher.promotions?.earn(promotion: .arrowStorm)
        let attModRangedLandAfter = humanPlayerArcher.attackModifier(against: barbarianPlayerAntiCavalry, or: nil, on: nil, in: self.gameModel)
        let attModRangedNavalAfter = humanPlayerArcher.attackModifier(against: barbarianPlayerShip, or: nil, on: nil, in: self.gameModel)

        // THEN
        XCTAssertEqual(attModRangedLandBefore, 0)
        XCTAssertEqual(attModRangedNavalBefore, -17) // base penalty is -17
        XCTAssertEqual(attModRangedLandAfter, 7)
        XCTAssertEqual(attModRangedNavalAfter, -10) // base penalty is -17+7=-10
    }

    // incendiaries - +7 Ranged Strength vs. district defenses.

    // suppression - Exercise zone of control.
    func testRangedPromotionSuppression() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        let humanPlayerArcher = Unit(at: HexPoint(x: 2, y: 2), type: .archer, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerArcher)

        let hasZoneOfControlBefore = humanPlayerArcher.isExertingZoneOfControl()

        // WHEN
        try humanPlayerArcher.promotions?.earn(promotion: .suppression)
        let hasZoneOfControlAfter = humanPlayerArcher.isExertingZoneOfControl()

        // THEN
        XCTAssertEqual(hasZoneOfControlBefore, false)
        XCTAssertEqual(hasZoneOfControlAfter, true)
    }

    // emplacement - +10 Combat Strength when defending vs. city attacks.

    // expertMarksman - +1 additional attack per turn if unit has not moved.
    func testMeleePromotionExpertMarksman() throws {

        // GIVEN
        guard let humanPlayer = self.gameModel?.humanPlayer() else {
            XCTFail("cant get human")
            return
        }

        guard let barbarianPlayer = self.gameModel?.barbarianPlayer() else {
            XCTFail("cant get barbarian")
            return
        }

        let humanPlayerArcher = Unit(at: HexPoint(x: 2, y: 2), type: .archer, owner: humanPlayer)
        self.gameModel?.add(unit: humanPlayerArcher)

        let barbarianPlayerAntiCavalry = Unit(at: HexPoint(x: 2, y: 3), type: .spearman, owner: barbarianPlayer)
        self.gameModel?.add(unit: barbarianPlayerAntiCavalry)

        humanPlayer.startTurn(in: self.gameModel)

        // WHEN
        try humanPlayerArcher.promotions?.earn(promotion: .expertMarksman)
        _ = humanPlayerArcher.doAttack(into: HexPoint(x: 2, y: 3), steps: 1, in: self.gameModel)
        let canMove = humanPlayerArcher.canMove()
        let canAttack = humanPlayerArcher.canAttack()

        // THEN
        XCTAssertEqual(canMove, true)
        XCTAssertEqual(canAttack, true)
    }
}
