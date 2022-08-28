//
//  main.swift
//  SmartAILibraryPerformance
//
//  Created by Michael Rommel on 23.08.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
import SmartAILibrary

class TestUI: UserInterfaceDelegate {

    func update(gameState: GameStateType) {}
    func update(activePlayer: AbstractPlayer?) {}

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData? = nil) {}

    func showLeaderMessage(
        from fromPlayer: AbstractPlayer?,
        to toPlayer: AbstractPlayer?,
        deal: DiplomaticDeal?,
        state: DiplomaticRequestState,
        message: DiplomaticRequestMessage,
        emotion: LeaderEmotionType
    ) {}

    func showPopup(popupType: PopupType) {}

    func showScreen(screenType: ScreenType, city: AbstractCity?) {}

    func isShown(screen: ScreenType) -> Bool {
        return false
    }

    func add(notification: NotificationItem) {}
    func remove(notification: NotificationItem) {}

    func select(unit: AbstractUnit?) {}
    func unselect() {}

    func show(unit: AbstractUnit?) {}
    func hide(unit: AbstractUnit?) {}
    func move(unit: AbstractUnit?, on points: [HexPoint]) {}
    func refresh(unit: AbstractUnit?) {}
    func animate(unit: AbstractUnit?, animation: UnitAnimationType) {}
    func animate(city: AbstractCity?, animation: CityAnimationType) {}

    func clearAttackFocus() {}

    func showAttackFocus(at point: HexPoint) {}

    func askForConfirmation(title: String, question: String, confirm: String, cancel: String?, completion: @escaping (Bool) -> Void) {}
    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> Void) {}
    func askForSelection(title: String, items: [SelectableItem], completion: @escaping (Int) -> Void) {}
    func askForInput(title: String, summary: String, value: String, confirm: String, cancel: String, completion: @escaping (String) -> Void) {}

    func select(tech: TechType) {}
    func select(civic: CivicType) {}

    func show(unit: AbstractUnit?, at location: HexPoint) {}
    func hide(unit: AbstractUnit?, at location: HexPoint) {}
    func enterCity(unit: AbstractUnit?, at location: HexPoint) {}
    func leaveCity(unit: AbstractUnit?, at location: HexPoint) {}
    func remove(city: AbstractCity?) {}

    func show(city: AbstractCity?) {}
    func update(city: AbstractCity?) {}

    func refresh(tile: AbstractTile?) {}

    func showTooltip(at point: HexPoint, type: TooltipType, delay: Double) {}

    func focus(on location: HexPoint) {}

    func animationsAreRunning(for leader: LeaderType) -> Bool { return false }

    func finish(tutorial: TutorialType) {}
}

class UsecaseTests: XCTestCase {

    func testFirstCityBuild() {

        // GIVEN

        // players
        let playerBarbarian = Player(leader: .barbar)
        playerBarbarian.initialize()

        let playerTrajan = Player(leader: .trajan)
        playerTrajan.initialize()

        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()

        // map
        var mapModel = MapUtils.mapFilled(with: .grass, sized: .duel, seed: 42)
        mapModel.tile(at: HexPoint(x: 2, y: 1))?.set(terrain: .ocean)

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

        // game
        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [playerBarbarian, playerTrajan, playerAlexander],
            on: mapModel
        )

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // initial units
        /*let playerAlexanderSettler = Unit(at: HexPoint(x: 5, y: 5), type: .settler, owner: playerAlexander)
         gameModel.add(unit: playerAlexanderSettler)*/

        let playerAlexanderWarrior = Unit(at: HexPoint(x: 5, y: 6), type: .warrior, owner: playerAlexander)
        gameModel.add(unit: playerAlexanderWarrior)

        let playerAugustusSettler = Unit(at: HexPoint(x: 15, y: 15), type: .settler, owner: playerTrajan)
        gameModel.add(unit: playerAugustusSettler)

        let playerAugustusWarrior = Unit(at: HexPoint(x: 15, y: 16), type: .warrior, owner: playerTrajan)
        gameModel.add(unit: playerAugustusWarrior)

        let playerBarbarianWarrior = Unit(at: HexPoint(x: 10, y: 10), type: .barbarianWarrior, owner: playerBarbarian)
        gameModel.add(unit: playerBarbarianWarrior)

        // this is cheating
        MapUtils.discover(mapModel: &mapModel, by: playerAlexander, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerTrajan, in: gameModel)
        MapUtils.discover(mapModel: &mapModel, by: playerBarbarian, in: gameModel)

        let numberOfCitiesBefore = gameModel.cities(of: playerTrajan).count
        let numberOfUnitsBefore = gameModel.units(of: playerTrajan).count

        // WHEN
        repeat {
            gameModel.update()

            if playerAlexander.isTurnActive() {
                playerAlexander.finishTurn()
                playerAlexander.setAutoMoves(to: true)
            }
        } while !(playerAlexander.hasProcessedAutoMoves() && playerAlexander.turnFinished())

        // THEN
        XCTAssertEqual(numberOfCitiesBefore, 0)
        XCTAssertEqual(numberOfUnitsBefore, 2)
        let numberOfCitiesAfter = gameModel.cities(of: playerTrajan).count
        let numberOfUnitsAfter = gameModel.units(of: playerTrajan).count
        XCTAssertEqual(numberOfCitiesAfter, 1)
        XCTAssertEqual(numberOfUnitsAfter, 1)

        XCTAssertEqual(playerAugustusWarrior.activityType(), .none) // warriro has skipped
        // XCTAssertEqual(playerAugustusWarrior.peekMission()!.buildType, BuildType.repair)
    }
}

let suite = XCTestSuite.default
suite.addTest(UsecaseTests())
suite.run()
