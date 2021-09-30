//
//  DebugViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 28.09.21.
//

import SwiftUI
import SmartAILibrary

protocol DebugViewModelDelegate: AnyObject {

    func start(game: GameModel?)
    func closed()
}

class TestUI: UserInterfaceDelegate {

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData? = nil) { }

    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) { }

    func update(city: AbstractCity?) { }

    func showPopup(popupType: PopupType) { }

    func showScreen(screenType: ScreenType, city: AbstractCity?) { }

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

    func clearAttackFocus() { }

    func showAttackFocus(at point: HexPoint) { }

    func askToDisband(unit: AbstractUnit?, completion: @escaping (Bool) -> Void) {}
    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> Void) {}
    func askForSelection(title: String, items: [SelectableItem], completion: @escaping (Int) -> Void) {}

    func select(tech: TechType) {}
    func select(civic: CivicType) {}

    func show(city: AbstractCity?) { }

    func refresh(tile: AbstractTile?) { }

    func showTooltip(at point: HexPoint, text: String, delay: Double) { }

    func focus(on location: HexPoint) { }
}

// swiftlint:disable force_try
class DebugViewModel: ObservableObject {

    weak var delegate: DebugViewModelDelegate?

    init() {

    }

    func createAttackBarbariansWorld() {

        print("Attack Barbarians")

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // AI
        aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)

        // Human
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! humanPlayer.techs?.discover(tech: .pottery)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws)
        try! humanPlayer.civics?.discover(civic: .foreignTrade)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
        }

        let humanWarriorUnit = Unit(at: HexPoint(x: 2, y: 6), type: .warrior, owner: humanPlayer)
        humanWarriorUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: humanWarriorUnit)
        gameModel.userInterface?.show(unit: humanWarriorUnit)

        let barbarianWarriorUnit = Unit(at: HexPoint(x: 3, y: 6), type: .barbarianWarrior, owner: barbarianPlayer)
        gameModel.add(unit: barbarianWarriorUnit)
        gameModel.userInterface?.show(unit: barbarianWarriorUnit)

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        self.delegate?.start(game: gameModel)
    }

    func createFastTradeRouteWorld() {

        print("Fast Trade Route")

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // AI
        aiPlayer.found(at: HexPoint(x: 10, y: 5), named: "AI Capital", in: gameModel)
        let aiCity = gameModel.city(at: HexPoint(x: 10, y: 5))

        // Human
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! humanPlayer.techs?.discover(tech: .pottery)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws)
        try! humanPlayer.civics?.discover(civic: .foreignTrade)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
        }

        let humanTraderUnit = Unit(at: HexPoint(x: 2, y: 6), type: .trader, owner: humanPlayer)
        humanTraderUnit.origin = HexPoint(x: 3, y: 5)
        gameModel.add(unit: humanTraderUnit)
        gameModel.userInterface?.show(unit: humanTraderUnit)

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        guard humanTraderUnit.doEstablishTradeRoute(to: aiCity, in: gameModel) else {
            fatalError("cant create trade route")
        }

        // add UI
        let userInterface = TestUI()
        gameModel.userInterface = userInterface

        // hack
        var turnCounter = 0

        repeat {

            repeat {
                gameModel.update()

                if humanPlayer.isTurnActive() {
                    humanPlayer.finishTurn()
                    humanPlayer.setAutoMoves(to: true)
                }
            } while !(humanPlayer.hasProcessedAutoMoves() && humanPlayer.finishTurnButtonPressed())

            turnCounter += 1
        } while turnCounter < 20

        self.delegate?.start(game: gameModel)
    }

    func createAllUnitsWorld() {

        print("All Units")

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // AI
        aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)
        aiPlayer.found(at: HexPoint(x: 12, y: 10), named: "AI City", in: gameModel)

        // Human
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! humanPlayer.techs?.discover(tech: .pottery)
        try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws)
        try! humanPlayer.civics?.discover(civic: .foreignTrade)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
        }

        var x = 0
        for unitType in UnitType.all {
            let unit = Unit(at: HexPoint(x: x, y: 4), type: unitType, owner: humanPlayer)
            unit.origin = HexPoint(x: 3, y: 5)
            gameModel.add(unit: unit)
            gameModel.userInterface?.show(unit: unit)

            x += 1
        }

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        self.delegate?.start(game: gameModel)
    }

    func close() {

        self.delegate?.closed()
    }
}
