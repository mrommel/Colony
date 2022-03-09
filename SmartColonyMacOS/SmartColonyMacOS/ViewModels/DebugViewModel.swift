//
//  DebugViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 28.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol DebugViewModelDelegate: AnyObject {

    func preparing()
    func prepared(game: GameModel?)
    func preparedSkriteKit()
    func closed()
}

class TestUI: UserInterfaceDelegate {

    func update(gameState: GameStateType) {}

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

    func show(unit: AbstractUnit?, at location: HexPoint) {}
    func hide(unit: AbstractUnit?, at location: HexPoint) {}
    func enterCity(unit: AbstractUnit?, at location: HexPoint) {}
    func leaveCity(unit: AbstractUnit?, at location: HexPoint) {}
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

    func showTooltip(at point: HexPoint, type: TooltipType, delay: Double) {}

    func focus(on location: HexPoint) {}
}

// swiftlint:disable force_try
class DebugViewModel: ObservableObject {

    private var downloadsFolder: URL = {
        return FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    }()

    weak var delegate: DebugViewModelDelegate?

    init() {

    }

    func prepare() {

    }

    func createAttackBarbariansWorld() {

        print("Attack Barbarians")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!
            let barbarianPlayer = gameModel.barbarianPlayer()!

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
            gameModel.userInterface?.show(unit: humanWarriorUnit, at: HexPoint(x: 2, y: 6))

            let barbarianWarriorUnit = Unit(at: HexPoint(x: 3, y: 6), type: .barbarianWarrior, owner: barbarianPlayer)
            gameModel.add(unit: barbarianWarriorUnit)
            gameModel.userInterface?.show(unit: barbarianWarriorUnit, at: HexPoint(x: 3, y: 6))

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createFastTradeRouteWorld() {

        print("Fast Trade Route")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!

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
            gameModel.userInterface?.show(unit: humanTraderUnit, at: HexPoint(x: 2, y: 6))

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

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!

            gameModel.tile(at: HexPoint(x: 1, y: 2))?.set(terrain: .plains)
            gameModel.tile(at: HexPoint(x: 1, y: 2))?.set(hills: true)
            gameModel.tile(at: HexPoint(x: 1, y: 2))?.set(resource: .wheat)
            gameModel.tile(at: HexPoint(x: 3, y: 2))?.set(terrain: .plains)
            gameModel.tile(at: HexPoint(x: 3, y: 2))?.set(resource: .iron)

            for index in 0..<40 {
                gameModel.tile(at: HexPoint(x: index, y: 3))?.set(terrain: .shore)
            }

            // AI
            aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)
            aiPlayer.found(at: HexPoint(x: 12, y: 10), named: "AI City", in: gameModel)

            // Human
            humanPlayer.found(at: HexPoint(x: 3, y: 7), named: "Human Capital", in: gameModel)
            try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
            try! humanPlayer.techs?.discover(tech: .sailing, in: gameModel)
            try! humanPlayer.techs?.setCurrent(tech: .irrigation, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
            try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
            try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

            if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 7)) {
                humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
            }

            var x = 0
            for unitType in UnitType.all {

                if unitType.domain() == .sea {
                    gameModel.tile(at: HexPoint(x: x, y: 4))?.set(terrain: .shore)
                }

                let unit = Unit(at: HexPoint(x: x, y: 4), type: unitType, owner: humanPlayer)
                unit.origin = HexPoint(x: 3, y: 5)
                gameModel.add(unit: unit)
                gameModel.userInterface?.show(unit: unit, at: HexPoint(x: x, y: 4))

                x += 1
            }

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createFastReligionFoundingWorld() {

        print("fast religion founding")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!

            gameModel.tile(at: HexPoint(x: 1, y: 2))?.set(terrain: .plains)
            gameModel.tile(at: HexPoint(x: 1, y: 2))?.set(hills: true)
            gameModel.tile(at: HexPoint(x: 1, y: 2))?.set(resource: .wheat)
            gameModel.tile(at: HexPoint(x: 3, y: 2))?.set(terrain: .plains)
            gameModel.tile(at: HexPoint(x: 3, y: 2))?.set(resource: .iron)

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
            gameModel.userInterface?.show(unit: prophetUnit, at: HexPoint(x: 3, y: 4))

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createTileImprovementsWorld() {

        print("Tile Improvements")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!

            gameModel.tile(at: HexPoint(x: 2, y: 4))?.set(terrain: .plains)
            gameModel.tile(at: HexPoint(x: 2, y: 4))?.set(hills: true)

            gameModel.tile(at: HexPoint(x: 3, y: 4))?.set(resource: .wheat)
            gameModel.tile(at: HexPoint(x: 3, y: 4))?.set(terrain: .plains)

            gameModel.tile(at: HexPoint(x: 3, y: 3))?.set(resource: .iron)
            gameModel.tile(at: HexPoint(x: 3, y: 3))?.set(hills: true)

            gameModel.tile(at: HexPoint(x: 4, y: 4))?.set(feature: .forest)
            gameModel.tile(at: HexPoint(x: 4, y: 4))?.set(resource: .furs)

            gameModel.tile(at: HexPoint(x: 4, y: 5))?.set(hills: true)
            gameModel.tile(at: HexPoint(x: 4, y: 5))?.set(resource: .wine)

            gameModel.tile(at: HexPoint(x: 4, y: 3))?.set(terrain: .shore)
            gameModel.tile(at: HexPoint(x: 4, y: 3))?.set(resource: .fish)

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
            gameModel.userInterface?.show(unit: builderUnit, at: HexPoint(x: 3, y: 4))

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createCityCombatWorld() {

        print("city combat")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!

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

            if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
                humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))
            }

            humanPlayer.doFirstContact(with: aiPlayer, in: gameModel)
            aiPlayer.doDeclareWar(to: humanPlayer, in: gameModel)

            // add combat units
            let warriorUnit = Unit(at: HexPoint(x: 20, y: 7), type: .warrior, owner: humanPlayer)
            gameModel.add(unit: warriorUnit)
            gameModel.userInterface?.show(unit: warriorUnit, at: HexPoint(x: 20, y: 7))

            let warriorUnit2 = Unit(at: HexPoint(x: 21, y: 7), type: .warrior, owner: humanPlayer)
            gameModel.add(unit: warriorUnit2)
            gameModel.userInterface?.show(unit: warriorUnit2, at: HexPoint(x: 21, y: 7))

            let archerUnit = Unit(at: HexPoint(x: 20, y: 6), type: .archer, owner: humanPlayer)
            gameModel.add(unit: archerUnit)
            gameModel.userInterface?.show(unit: archerUnit, at: HexPoint(x: 20, y: 6))

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func createCityRevoltWorld() {

        print("city revolt")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!

            let ownCity = City(name: "Potsdam", at: HexPoint(x: 5, y: 5), capital: true, owner: humanPlayer)
            ownCity.initialize(in: gameModel)
            gameModel.add(city: ownCity)

            let enemyCity1 = City(name: "Enemy1", at: HexPoint(x: 8, y: 5), capital: true, owner: aiPlayer)
            enemyCity1.initialize(in: gameModel)
            enemyCity1.set(population: 10, in: gameModel)
            gameModel.add(city: enemyCity1)

            let enemyCity2 = City(name: "Enemy2", at: HexPoint(x: 2, y: 5), owner: aiPlayer)
            enemyCity2.initialize(in: gameModel)
            enemyCity2.set(population: 10, in: gameModel)
            gameModel.add(city: enemyCity2)

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func generateUnitAssets() {

        print("generate unit assets")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            for unitType in UnitType.all {
                if let firstTexture = unitType.idleAtlas?.textures.first {

                    let fileURL = self.downloadsFolder.appendingPathComponent("\(unitType.spriteName)@3x.png")
                    do {
                        try firstTexture.savePngTo(url: fileURL)
                        print("saved idle image for \(unitType) - \(unitType.spriteName)")
                    } catch {
                        print("failed to save idle image for \(unitType) - \(unitType.spriteName) => \(error)")
                    }
                } else {
                    print("no idle image for \(unitType)")
                }
            }

            DispatchQueue.main.async {
                // self.delegate?.prepared(game: gameModel)
                self.delegate?.closed()
            }
        }
    }

    func createSpriteKitView() {

        self.delegate?.preparedSkriteKit()
    }

    func loadSlp() {

        print("load slp")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)
            // let humanPlayer = gameModel.humanPlayer()!
            // let aiPlayer = gameModel.player(for: .victoria)!

            let texturesBundle = Bundle(for: Textures.self)
            let path = texturesBundle.path(forResource: "merchant-idle", ofType: "slp")
            let url = URL(fileURLWithPath: path!)

            let slpLoader = SlpFileReader()
            let slpFile = slpLoader.load(from: url)

            let filename = self.downloadsFolder.appendingPathComponent("merchant-idle.png")

            if let frame = slpFile?.frames.first {
                if let image = frame.image() {
                    do {
                        try image.savePngTo(url: filename)
                    } catch {
                        print("cant save image: \(error)")
                    }
                }
            }

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func mapTextures() {

        print("map textures")

        self.delegate?.preparing()

        DispatchQueue.global(qos: .background).async {

            let gameModel = GameUtils.setupDuelGrass(human: .alexander, ai: .victoria, discover: true)

            gameModel.tile(at: HexPoint(x: 4, y: 3))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 3, y: 4))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 3, y: 5))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 4, y: 5))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 5, y: 5))?.set(feature: .mountains)

            gameModel.tile(at: HexPoint(x: 4, y: 7))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 5, y: 7))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 6, y: 7))?.set(feature: .mountains)

            gameModel.tile(at: HexPoint(x: 6, y: 1))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 5, y: 2))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 5, y: 3))?.set(feature: .mountains)

            gameModel.tile(at: HexPoint(x: 2, y: 10))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 2, y: 11))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 3, y: 10))?.set(feature: .mountains)
            gameModel.tile(at: HexPoint(x: 3, y: 11))?.set(feature: .mountains)

            gameModel.tile(at: HexPoint(x: 9, y: 1))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 8, y: 2))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 8, y: 3))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 10, y: 1))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 9, y: 2))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 9, y: 3))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 11, y: 1))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 10, y: 2))?.set(feature: .rainforest)
            gameModel.tile(at: HexPoint(x: 10, y: 3))?.set(feature: .rainforest)

            let humanPlayer = gameModel.humanPlayer()!
            let aiPlayer = gameModel.player(for: .victoria)!

            // AI
            aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)

            // Human
            humanPlayer.found(at: HexPoint(x: 10, y: 8), named: "Human Capital", in: gameModel)

            humanPlayer.doFirstContact(with: aiPlayer, in: gameModel)
            aiPlayer.doDeclareWar(to: humanPlayer, in: gameModel)

            // add combat units
            let warriorUnit = Unit(at: HexPoint(x: 20, y: 7), type: .warrior, owner: humanPlayer)
            gameModel.add(unit: warriorUnit)
            gameModel.userInterface?.show(unit: warriorUnit, at: HexPoint(x: 20, y: 7))

            DispatchQueue.main.async {
                self.delegate?.prepared(game: gameModel)
            }
        }
    }

    func close() {

        self.delegate?.closed()
    }
}
