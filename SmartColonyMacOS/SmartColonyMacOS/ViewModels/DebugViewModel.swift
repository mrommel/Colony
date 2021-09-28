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
