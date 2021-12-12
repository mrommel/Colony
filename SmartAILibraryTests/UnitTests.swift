//
//  UnitTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 16.08.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class UnitTests: XCTestCase {

    // Embarked Units cant move in water #67
    func testUnitMovesEmbarked() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        do {
            try humanPlayer.techs?.discover(tech: .sailing)
        } catch {}

        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .small)

        // start island
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 2))

        // target island
        mapModel.set(terrain: .plains, at: HexPoint(x: 6, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 7, y: 2))

        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .king,
                                  turnsElapsed: 0,
                                  players: [barbarianPlayer, aiPlayer, humanPlayer],
                                  on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        gameModel.add(unit: humanPlayerWarrior)

        let warriorMission = UnitMission(type: .moveTo, at: HexPoint(x: 6, y: 2))
        humanPlayerWarrior.push(mission: warriorMission, in: gameModel)

        // WHEN
        var turnCounter = 0
        var hasVisited = false
        repeat {

            repeat {
                gameModel.update()

                if humanPlayer.isTurnActive() {
                    humanPlayer.finishTurn()
                    humanPlayer.setAutoMoves(to: true)
                }
            } while !(humanPlayer.hasProcessedAutoMoves() && humanPlayer.turnFinished())

            hasVisited = humanPlayerWarrior.location == HexPoint(x: 6, y: 2)
            turnCounter += 1
        } while turnCounter < 10 && !hasVisited

        // THEN
        XCTAssertEqual(humanPlayerWarrior.location, HexPoint(x: 6, y: 2))
    }

    func testUnitScoutAutomation() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .king,
                                  turnsElapsed: 0,
                                  players: [barbarianPlayer, aiPlayer, humanPlayer],
                                  on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        gameModel.add(unit: humanPlayerScout)

        // WHEN
        humanPlayerScout.automate(with: .explore)

        var turnCounter = 0
        var hasStayed = true
        repeat {

            repeat {
                gameModel.update()

                if humanPlayer.isTurnActive() {
                    humanPlayer.finishTurn()
                    humanPlayer.setAutoMoves(to: true)
                }
            } while !(humanPlayer.hasProcessedAutoMoves() && humanPlayer.turnFinished())

            hasStayed = humanPlayerScout.location == HexPoint(x: 2, y: 2)
            turnCounter += 1
        } while turnCounter < 4 && hasStayed

        // THEN
        XCTAssertNotEqual(humanPlayerScout.location, HexPoint(x: 2, y: 2))
    }

    func testUnitCanTransferToAnotherCity() {

        // GIVEN
        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        // civilians ------------------------------
        let unitSettler = Unit(at: HexPoint(x: 2, y: 2), type: .settler, owner: humanPlayer)
        let unitBuilder = Unit(at: HexPoint(x: 2, y: 2), type: .builder, owner: humanPlayer)
        let unitTrader = Unit(at: HexPoint(x: 2, y: 2), type: .trader, owner: humanPlayer)

        // recon ------------------------------
        let unitScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)

        // melee ------------------------------
        let unitWarrior = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        let unitSwordman = Unit(at: HexPoint(x: 2, y: 2), type: .swordman, owner: humanPlayer)

        // ranged ------------------------------
        let unitSlinger = Unit(at: HexPoint(x: 2, y: 2), type: .slinger, owner: humanPlayer)
        let unitArcher = Unit(at: HexPoint(x: 2, y: 2), type: .archer, owner: humanPlayer)

        // anti-cavalry ------------------------------
        let unitSpearman = Unit(at: HexPoint(x: 2, y: 2), type: .spearman, owner: humanPlayer)

        // light cavalry ------------------------------
        let unitHorseman = Unit(at: HexPoint(x: 2, y: 2), type: .horseman, owner: humanPlayer)

        // heavy cavalry ------------------------------
        let unitHeavyChariot = Unit(at: HexPoint(x: 2, y: 2), type: .heavyChariot, owner: humanPlayer)

        // siege ------------------------------
        let unitCatapult = Unit(at: HexPoint(x: 2, y: 2), type: .catapult, owner: humanPlayer)

        // naval melee ------------------------------
        let unitGalley = Unit(at: HexPoint(x: 2, y: 2), type: .galley, owner: humanPlayer)

        // naval ranged ------------------------------
        let unitQuadrireme = Unit(at: HexPoint(x: 2, y: 2), type: .quadrireme, owner: humanPlayer)

        // support ------------------------------
        let unitMedic = Unit(at: HexPoint(x: 2, y: 2), type: .medic, owner: humanPlayer)

        // great people ------------------------------
        let unitArtist = Unit(at: HexPoint(x: 2, y: 2), type: .artist, owner: humanPlayer)
        let unitAdmiral = Unit(at: HexPoint(x: 2, y: 2), type: .admiral, owner: humanPlayer)
        let unitEngineer = Unit(at: HexPoint(x: 2, y: 2), type: .engineer, owner: humanPlayer)
        let unitGeneral = Unit(at: HexPoint(x: 2, y: 2), type: .general, owner: humanPlayer)
        let unitMerchant = Unit(at: HexPoint(x: 2, y: 2), type: .merchant, owner: humanPlayer)
        let unitMusician = Unit(at: HexPoint(x: 2, y: 2), type: .musician, owner: humanPlayer)
        let unitProphet = Unit(at: HexPoint(x: 2, y: 2), type: .prophet, owner: humanPlayer)
        let unitScientist = Unit(at: HexPoint(x: 2, y: 2), type: .scientist, owner: humanPlayer)
        let unitWriter = Unit(at: HexPoint(x: 2, y: 2), type: .writer, owner: humanPlayer)

        // WHEN
        // civilians ------------------------------
        let canSettlerTransfer = unitSettler.canTransferToAnotherCity()
        let canBuilderTransfer = unitBuilder.canTransferToAnotherCity()
        let canTraderTransfer = unitTrader.canTransferToAnotherCity()

        // recon ------------------------------
        let canScoutTransfer = unitScout.canTransferToAnotherCity()

        // melee ------------------------------
        let canWarriorTransfer = unitWarrior.canTransferToAnotherCity()
        let canSwordmanTransfer = unitSwordman.canTransferToAnotherCity()

        // ranged ------------------------------
        let canSlingerTransfer = unitSlinger.canTransferToAnotherCity()
        let canArcherTransfer = unitArcher.canTransferToAnotherCity()

        // anti-cavalry ------------------------------
        let canSpearmanTransfer = unitSpearman.canTransferToAnotherCity()

        // light cavalry ------------------------------
        let canHorsemanTransfer = unitHorseman.canTransferToAnotherCity()

        // heavy cavalry ------------------------------
        let canHeavyChariotTransfer = unitHeavyChariot.canTransferToAnotherCity()

        // siege ------------------------------
        let canCatapultTransfer = unitCatapult.canTransferToAnotherCity()

        // naval melee ------------------------------
        let canGalleyTransfer = unitGalley.canTransferToAnotherCity()

        // naval ranged ------------------------------
        let canQuadriremeTransfer = unitQuadrireme.canTransferToAnotherCity()

        // support ------------------------------
        let canMedicTransfer = unitMedic.canTransferToAnotherCity()

        // great people ------------------------------
        let canArtistTransfer = unitArtist.canTransferToAnotherCity()
        let canAdmiralTransfer = unitAdmiral.canTransferToAnotherCity()
        let canEngineerTransfer = unitEngineer.canTransferToAnotherCity()
        let canGeneralTransfer = unitGeneral.canTransferToAnotherCity()
        let canMerchantTransfer = unitMerchant.canTransferToAnotherCity()
        let canMusicianTransfer = unitMusician.canTransferToAnotherCity()
        let canProphetTransfer = unitProphet.canTransferToAnotherCity()
        let canScientistTransfer = unitScientist.canTransferToAnotherCity()
        let canWriterTransfer = unitWriter.canTransferToAnotherCity()

        // THEN
        // civilians ------------------------------
        XCTAssertFalse(canSettlerTransfer)
        XCTAssertFalse(canBuilderTransfer)
        XCTAssertTrue(canTraderTransfer)

        // recon ------------------------------
        XCTAssertFalse(canScoutTransfer)

        // melee ------------------------------
        XCTAssertFalse(canWarriorTransfer)
        XCTAssertFalse(canSwordmanTransfer)

        // ranged ------------------------------
        XCTAssertFalse(canSlingerTransfer)
        XCTAssertFalse(canArcherTransfer)

        // anti-cavalry ------------------------------
        XCTAssertFalse(canSpearmanTransfer)

        // light cavalry ------------------------------
        XCTAssertFalse(canHorsemanTransfer)

        // heavy cavalry ------------------------------
        XCTAssertFalse(canHeavyChariotTransfer)

        // siege ------------------------------
        XCTAssertFalse(canCatapultTransfer)

        // naval melee ------------------------------
        XCTAssertFalse(canGalleyTransfer)

        // naval ranged ------------------------------
        XCTAssertFalse(canQuadriremeTransfer)

        // support ------------------------------
        XCTAssertFalse(canMedicTransfer)

        // great people ------------------------------
        XCTAssertTrue(canArtistTransfer)
        XCTAssertTrue(canAdmiralTransfer)
        XCTAssertTrue(canEngineerTransfer)
        XCTAssertTrue(canGeneralTransfer)
        XCTAssertTrue(canMerchantTransfer)
        XCTAssertTrue(canMusicianTransfer)
        XCTAssertTrue(canProphetTransfer)
        XCTAssertTrue(canScientistTransfer)
        XCTAssertTrue(canWriterTransfer)
    }

    func testUnitRenaming() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .king,
                                  turnsElapsed: 0,
                                  players: [barbarianPlayer, aiPlayer, humanPlayer],
                                  on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .scout, owner: humanPlayer)
        gameModel.add(unit: humanPlayerScout)

        // WHEN
        let beforeRenaming = humanPlayerScout.name()
        humanPlayerScout.rename(to: "Flamingo")
        let afterRenaming = humanPlayerScout.name()

        // THEN
        XCTAssertNotEqual(beforeRenaming, afterRenaming)
        XCTAssertEqual(beforeRenaming, "Scout")
        XCTAssertEqual(afterRenaming, "Flamingo")
    }

    func testUnitUpgrade() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        do {
            try humanPlayer.techs?.discover(tech: .ironWorking)
        } catch {}
        humanPlayer.treasury?.changeGold(by: 1000.0)

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        let gameModel = GameModel(victoryTypes: [.domination],
                                  handicap: .king,
                                  turnsElapsed: 0,
                                  players: [barbarianPlayer, aiPlayer, humanPlayer],
                                  on: mapModel)

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        let humanPlayerScout = Unit(at: HexPoint(x: 2, y: 2), type: .warrior, owner: humanPlayer)
        gameModel.add(unit: humanPlayerScout)

        let humanCapital = City(name: "Human Capital", at: HexPoint(x: 2, y: 1), capital: true, owner: humanPlayer)
        humanCapital.initialize(in: gameModel)
        gameModel.add(city: humanCapital)

        // WHEN
        let canUpgradeBefore = humanPlayerScout.canUpgrade(to: .swordman, in: gameModel)
        humanPlayerScout.doUpgrade(to: .swordman, in: gameModel) // <= will crash on failure

        // THEN
        XCTAssertEqual(canUpgradeBefore, true)
    }
}
