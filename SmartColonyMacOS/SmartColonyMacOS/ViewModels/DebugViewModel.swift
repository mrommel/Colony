//
//  DebugViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 28.09.21.
//

import SwiftUI
import SmartAILibrary

protocol DebugViewModelDelegate: AnyObject {

    func preparing()
    func prepared(game: GameModel?)
    func closed()
}

class TestUI: UserInterfaceDelegate {

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData? = nil) {}

    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {}

    func update(city: AbstractCity?) {}

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

    func clearAttackFocus() {}

    func showAttackFocus(at point: HexPoint) {}

    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> Void) {}

    func askForConfirmation(title: String, question: String, confirm: String, cancel: String, completion: @escaping (Bool) -> Void) {}
    func askForSelection(title: String, items: [SelectableItem], completion: @escaping (Int) -> Void) {}
    func askForInput(title: String, summary: String, value: String, confirm: String, cancel: String, completion: @escaping (String) -> Void) {}

    func select(tech: TechType) {}
    func select(civic: CivicType) {}

    func show(city: AbstractCity?) {}
    func remove(city: AbstractCity?) {}

    func refresh(tile: AbstractTile?) {}

    func showTooltip(at point: HexPoint, text: String, delay: Double) {}

    func focus(on location: HexPoint) {}
}

// swiftlint:disable force_try
class DebugViewModel: ObservableObject {

    weak var delegate: DebugViewModelDelegate?

    init() {

    }

    func prepare() {

    }

    func createAttackBarbariansWorld() {

        print("Attack Barbarians")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

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
            try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
            try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
            try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

            if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
                humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
                humanCity.assign(governor: .reyna)
            }

            let humanWarriorUnit = Unit(at: HexPoint(x: 2, y: 6), type: .warrior, owner: humanPlayer)
            humanWarriorUnit.origin = HexPoint(x: 3, y: 5)
            gameModel.add(unit: humanWarriorUnit)
            gameModel.userInterface?.show(unit: humanWarriorUnit)

            let barbarianWarriorUnit = Unit(at: HexPoint(x: 3, y: 6), type: .barbarianWarrior, owner: barbarianPlayer)
            gameModel.add(unit: barbarianWarriorUnit)
            gameModel.userInterface?.show(unit: barbarianWarriorUnit)

            MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createFastTradeRouteWorld() {

        print("Fast Trade Route")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

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
            try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
            try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
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
                } while !(humanPlayer.hasProcessedAutoMoves() && humanPlayer.turnFinished())

                turnCounter += 1
            } while turnCounter < 20

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createAllUnitsWorld() {

        print("All Units")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

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

            for index in 0..<40 {
                mapModel.set(terrain: .shore, at: HexPoint(x: index, y: 3))
            }

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
            try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
            try! humanPlayer.techs?.discover(tech: .sailing, in: gameModel)
            try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
            try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

            if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
                humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
            }

            var x = 0
            for unitType in UnitType.all {

                if unitType.domain() == .sea {
                    mapModel.set(terrain: .shore, at: HexPoint(x: x, y: 4))
                }

                let unit = Unit(at: HexPoint(x: x, y: 4), type: unitType, owner: humanPlayer)
                unit.origin = HexPoint(x: 3, y: 5)
                gameModel.add(unit: unit)
                gameModel.userInterface?.show(unit: unit)

                x += 1
            }

            MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createFastReligionFoundingWorld() {

        print("fast religion founding")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

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
            try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
            try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
            try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

            if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
                humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
                try! humanCity.districts?.build(district: .holySite, at: HexPoint(x: 3, y: 4))
            }

            humanPlayer.religion?.foundPantheon(with: .danceOfTheAurora, in: gameModel)

            let prophetUnit = Unit(at: HexPoint(x: 3, y: 4), type: .prophet, owner: humanPlayer)
            gameModel.add(unit: prophetUnit)
            gameModel.userInterface?.show(unit: prophetUnit)

            MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createTileImprovementsWorld() {

        print("Tile Improvements")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let barbarianPlayer = Player(leader: .barbar, isHuman: false)
            barbarianPlayer.initialize()

            let aiPlayer = Player(leader: .victoria, isHuman: false)
            aiPlayer.initialize()

            let humanPlayer = Player(leader: .alexander, isHuman: true)
            humanPlayer.initialize()

            var mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

            mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 4))
            mapModel.set(hills: true, at: HexPoint(x: 2, y: 4))

            mapModel.set(resource: .wheat, at: HexPoint(x: 3, y: 4))
            mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 4))

            mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 3))
            mapModel.set(hills: true, at: HexPoint(x: 3, y: 3))

            mapModel.set(feature: .forest, at: HexPoint(x: 4, y: 4))
            mapModel.set(resource: .furs, at: HexPoint(x: 4, y: 4))

            mapModel.set(hills: true, at: HexPoint(x: 4, y: 5))
            mapModel.set(resource: .wine, at: HexPoint(x: 4, y: 5))

            mapModel.set(terrain: .shore, at: HexPoint(x: 4, y: 3))
            mapModel.set(resource: .fish, at: HexPoint(x: 4, y: 3))

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
            try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
            try! humanPlayer.techs?.discover(tech: .bronzeWorking, in: gameModel)
            try! humanPlayer.techs?.discover(tech: .irrigation, in: gameModel)
            try! humanPlayer.techs?.discover(tech: .animalHusbandry, in: gameModel)
            try! humanPlayer.techs?.discover(tech: .sailing, in: gameModel)
            try! humanPlayer.techs?.setCurrent(tech: .archery, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
            try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

            if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
                humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))

                humanCity.assign(governor: .amani)

                for pointToClaim in HexPoint(x: 3, y: 5).areaWith(radius: 2) {
                    if let tileToClaim = gameModel.tile(at: pointToClaim) {
                        if !tileToClaim.hasOwner() {
                            do {
                                try tileToClaim.set(owner: humanPlayer)
                                try tileToClaim.setWorkingCity(to: humanCity)

                                humanPlayer.addPlot(at: pointToClaim)

                                gameModel.userInterface?.refresh(tile: tileToClaim)
                            } catch {
                                fatalError("cant set owner")
                            }
                        }
                    }
                }
            }

            let builderUnit = Unit(at: HexPoint(x: 3, y: 4), type: .builder, owner: humanPlayer)
            gameModel.add(unit: builderUnit)
            gameModel.userInterface?.show(unit: builderUnit)

            MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createCityCombatWorld() {

        print("city combat")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let barbarianPlayer = Player(leader: .barbar, isHuman: false)
            barbarianPlayer.initialize()

            let aiPlayer = Player(leader: .victoria, isHuman: false)
            aiPlayer.initialize()

            let humanPlayer = Player(leader: .alexander, isHuman: true)
            humanPlayer.initialize()

            var mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

            let gameModel = GameModel(
                victoryTypes: [.domination],
                handicap: .settler,
                turnsElapsed: 0,
                players: [barbarianPlayer, aiPlayer, humanPlayer],
                on: mapModel
            )

            // AI
            aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)

            // Human
            humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
            try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
            try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)

            try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .craftsmanship, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .militaryTradition, in: gameModel)
            //try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

            if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
                humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
            }

            humanPlayer.doFirstContact(with: aiPlayer, in: gameModel)
            aiPlayer.diplomacyAI?.doDeclareWar(to: humanPlayer, in: gameModel)

            // add combat units
            let warriorUnit = Unit(at: HexPoint(x: 20, y: 7), type: .warrior, owner: humanPlayer)
            gameModel.add(unit: warriorUnit)
            gameModel.userInterface?.show(unit: warriorUnit)

            let warriorUnit2 = Unit(at: HexPoint(x: 21, y: 7), type: .warrior, owner: humanPlayer)
            gameModel.add(unit: warriorUnit2)
            gameModel.userInterface?.show(unit: warriorUnit2)

            let archerUnit = Unit(at: HexPoint(x: 20, y: 6), type: .archer, owner: humanPlayer)
            gameModel.add(unit: archerUnit)
            gameModel.userInterface?.show(unit: archerUnit)

            MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func close() {

        self.delegate?.closed()
    }
}
