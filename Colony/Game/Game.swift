//
//  Game.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol GameUpdateDelegate {

    func updateUI()

    func showBattleDialog(between source: Unit?, and target: Unit?)
    //func showBattleResult(between source: Unit?, and target: Unit?, result: BattleResult)
}

class Game: Decodable {

    fileprivate let level: Level?
    var currentTurn: GameTurn?
    
    var coins: Int
    var boosterStock: BoosterStock

    // usecases
    let gameUsecase: GameUsecase?
    let userUsecase: UserUsecase?

    // game condition
    private var conditionChecks: [GameConditionCheck] = []
    var conditionCheckIdentifiers: [String] {
        return self.conditionChecks.map { $0.identifier }
    }
    
    var title: String {
        return self.level?.meta?.title ?? "title"
    }
    
    var maxTurns: Int {
        return self.level?.turns ?? -1
    }
    
    var initialTurns: Int {
        return 0
    }

    var conditionDelegate: GameConditionDelegate?
    var gameUpdateDelegate: GameUpdateDelegate?

    var gameRating: GameRating?
    var aiscript: AIScript?

    enum CodingKeys: String, CodingKey {
        case level
        case coins
        case boosterStock
        case currentTurn
    }

    // new game
    init(with level: Level?, meta: LevelMeta?, coins: Int, boosterStock: BoosterStock) {

        self.level = level
        self.level?.meta = meta
        self.coins = coins
        self.boosterStock = boosterStock
        self.currentTurn = GameTurn(currentTurn: 0)

        // usecases
        self.gameUsecase = GameUsecase()
        self.userUsecase = UserUsecase()

        if let gameConditionCheckIdentifiers = self.level?.gameConditionCheckIdentifiers {
            for identifier in gameConditionCheckIdentifiers {
                if let gameConditionCheck = GameConditionCheckManager.shared.gameConditionCheckFor(identifier: identifier) {
                    self.add(conditionCheck: gameConditionCheck)
                    print("- added \(gameConditionCheck.identifier)")
                }
            }
        }

        self.gameRating = meta?.getGameRating(for: self)
        self.aiscript = meta?.getAIScript(for: self)

        self.currentTurn?.turnMechanicsDelegate = self
        self.level?.gameObjectManager.gameObservationDelegate = self
    }

    // restarted
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.level = try values.decode(Level.self, forKey: .level)
        self.coins = try values.decode(Int.self, forKey: .coins)
        self.boosterStock = try values.decode(BoosterStock.self, forKey: .boosterStock)
        
        let currentTurnValue = try values.decode(Int.self, forKey: .currentTurn)
        self.currentTurn = GameTurn(currentTurn: currentTurnValue)
        
        // usecases
        self.gameUsecase = GameUsecase()
        self.userUsecase = UserUsecase()

        if let gameConditionCheckIdentifiers = self.level?.gameConditionCheckIdentifiers {
            for identifier in gameConditionCheckIdentifiers {
                if let gameConditionCheck = GameConditionCheckManager.shared.gameConditionCheckFor(identifier: identifier) {
                    self.add(conditionCheck: gameConditionCheck)
                    print("- added \(gameConditionCheck.identifier)")
                }
            }
        }

        self.level?.gameObjectManager.gameObservationDelegate = self
        self.currentTurn?.turnMechanicsDelegate = self
        
        self.start(with: currentTurnValue)
    }

    func add(conditionCheck: GameConditionCheck) {

        conditionCheck.game = self
        conditionChecks.append(conditionCheck)
    }

    func checkCondition() {

        for conditionCheck in self.conditionChecks {
            if let type = conditionCheck.isWon() {
                self.conditionDelegate?.won(with: type)
            }

            if let type = conditionCheck.isLost() {
                self.conditionDelegate?.lost(with: type)
            }
        }
    }

    func saveScore() {

        guard let level = self.level else {
            return
        }
        
        guard let levelMeta = self.level?.meta else {
            return
        }

        let score = self.coins
        let levelScore = level.score(for: score)

        self.gameUsecase?.set(score: Int32(score), levelScore: levelScore, for: Int32(levelMeta.number))
    }
}

extension Game {

    func start(with currentTurn: Int) {
        print("start game timer")

        // init turns
        self.currentTurn?.currentTurn = currentTurn
        
        if let selectedUnit = self.level?.gameObjectManager.selected {
            self.level?.gameObjectManager.updatePlayer(unit: selectedUnit)
        }
    }

    // end user turn
    func turn() {
        
        guard let currentTurn = self.currentTurn else {
            fatalError("Can't get current turn")
        }
        
        // do the turn
        currentTurn.doTurn()
    }

    private func update() {

        guard let currentTurn = self.currentTurn else {
            fatalError("Can't get current turn")
        }
        
        guard let level = self.level else {
            fatalError("can't find level")
        }
        
        //
        if currentTurn.isUserPlayer() {
            
            level.map.forEachUnit { unit in
                if unit.civilization == currentTurn.currentCivilization {
                    unit.resetMoves()
                    unit.update(in: self)
                }
            }
        } else {
            guard let player = level.playerFor(civilization: currentTurn.currentCivilization) else {
                fatalError("Can't get current ai player")
            }
            
            // update ai player
            player.update(in: self)
            
            level.map.forEachUnit { unit in
                if unit.civilization == currentTurn.currentCivilization {
                    unit.resetMoves()
                    unit.update(in: self)
                }
            }
            
            sleep(2)
        }

        self.aiscript?.update(for: self)
        
        var destroyedUnits: [Unit] = []
        level.map.forEachUnit { unit in
            if unit.isDestroyed() {
                destroyedUnits.append(unit)
            }
        }
        
        destroyedUnits.forEach { unit in
            level.map.remove(unit: unit)
        }
        
        // FIXME: should this be run only once?
        for city in level.map.cities {
            city.update(in: self)
        }

        for animal in level.map.animals {
            animal.update(in: self)
        }

        //let rating = self.gameRating?.value(for: .english)
        //print("-- rating: \(rating)")

        // check if game is lost or even won
        self.checkCondition()
    }
}

extension Game: GameTurnMechanicsDelegate {

    func notifyPlayer(with civilization: Civilization) {
        
        print("------- player is on duty: \(civilization) -------")
        
        guard let userCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("can't get user civilization")
        }
        
        DispatchQueue.background(delay: 1.0, background: {
            // do something in background
            self.update()
            self.checkCondition()
        }, completion: {
            // when background job finishes, wait 3 seconds and do something in main thread
            self.gameUpdateDelegate?.updateUI()
                    
            if userCivilization != civilization {
                self.turn()
            }
        })
    }
}

extension Game {

    func start(boosterType: BoosterType) {

        // check if we can use this booster
        guard self.boosterStock.isAvailable(boosterType: boosterType) else {
            fatalError("booster \(boosterType) not available !!! ")
        }

        // reduce the amount of the boosters in the stock
        self.boosterStock.decrement(boosterType: boosterType)

        // start timer
        Timer.scheduledTimer(timeInterval: boosterType.timeInterval, target: self, selector: #selector(fire(timer:)), userInfo: boosterType, repeats: false)

        // begin effect
        switch boosterType {

        case .telescope:
            print("start telescope")
            self.level?.gameObjectManager.selected?.sight += 1
        case .time:
            print("start time")
            self.currentTurn?.currentTurn = (self.currentTurn?.currentTurn ?? 0) + 5 // add 5 turns
        }
    }

    @objc func fire(timer: Timer) {

        if let boosterType = timer.userInfo as? BoosterType {
            print("boosterType \(boosterType) canceled")
            self.finish(boosterType: boosterType)
        }
    }

    func finish(boosterType: BoosterType) {

        // cancel effect
        switch boosterType {

        case .telescope:
            print("finish telescope")
            self.level?.gameObjectManager.selected?.sight -= 1
        case .time:
            print("finish time")
        }
    }
}

extension Game: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.level, forKey: .level)
        try container.encode(self.coins, forKey: .coins)
        try container.encode(self.boosterStock, forKey: .boosterStock)
        try container.encode(self.currentTurn?.currentTurn ?? 0, forKey: .currentTurn)
    }
}

extension Game {

    func mapSize() -> CGSize {

        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }

        return map.size
    }

    // MARK: animal methods

    func add(animal animalRef: Animal?) {

        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }

        if let animal = animalRef {
            map.animals.append(animal)
        }
    }

    // MARK: player methods

    func player(for civilization: Civilization) -> Player? {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        return level.playerFor(civilization: civilization)
    }

    func foodProduction(at position: HexPoint, for civilization: Civilization) -> Int {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        guard let player = self.player(for: civilization) else {
            fatalError("can't get player")
        }

        guard let tile = level.map.tile(at: position) else {
            fatalError("can't get tile")
        }

        return player.techs?.foodProduction(on: tile) ?? 0
    }

    // MARK: neighbor methods

    func neighborsInWater(of point: HexPoint) -> [HexPoint] {

        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }

        let waterTiles = point.neighbors().filter({ map.tile(at: $0)?.isWater ?? false })
        return waterTiles
        //let waterTilesWithoutObstacles = waterTiles.filter({ !level.gameObjectManager.obstacle(at: $0) })

        //return waterTilesWithoutObstacles
    }

    func neighborsOnLand(of point: HexPoint) -> [HexPoint] {

        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }

        let landTiles = point.neighbors().filter({ map.tile(at: $0)?.isGround ?? false })
        return landTiles
        //let landTilesWithoutObstacles = landTiles.filter({ !level.gameObjectManager.obstacle(at: $0) })

        //return landTilesWithoutObstacles
    }

    func getBestDisembarkTile(of point: HexPoint, for civilization: Civilization) -> Tile? {

        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }

        let landTiles = point.neighbors().filter({ map.tile(at: $0)?.isGround ?? false })

        if landTiles.isEmpty {
            return nil
        }

        // check if tile is occupied
        for landTile in landTiles {
            // FIXME: check for civilization
            if map.fogManager?.fog(at: landTile, by: civilization) == .discovered {
                // FIXME
            }
        }

        return nil
    }

    func isVisible(at position: HexPoint, for civilization: Civilization) -> Bool {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        // FIXME: civilization not handled
        return level.map.fogManager?.currentlyVisible(at: position, by: civilization) ?? false
    }

    // MARK: unit methods

    func getUnits(at point: HexPoint) -> [Unit?] {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        return level.map.units(at: point)
    }

    func getSelectedUnitOfUser() -> Unit? {

        return self.level?.gameObjectManager.selected
    }

    func getUnitsOf(civilization: Civilization) -> [Unit?]? {

        return self.level?.map.unitsOf(civilization: civilization)
    }

    func getAllUnitsOfUser() -> [Unit?]? {

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        return self.level?.map.unitsOf(civilization: currentUserCivilization)
    }

    func getAllUnitsOfAI() -> [Unit?]? {

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        return self.level?.map.unitsWithout(civilization: currentUserCivilization)
    }

    func getUnitsBy(type: UnitType) -> [Unit?]? {

        return self.level?.map.unitsOf(type: type)
    }

    func alliedUnits(for civilization: Civilization) -> [Unit?]? {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        guard let player = level.playerFor(civilization: civilization) else {
            fatalError("can't get player")
        }

        var units: [Unit?] = []

        for ally in player.getAllies() {
            if let allyUnits = self.getUnitsOf(civilization: ally.civilization) {
                units.append(contentsOf: allyUnits)
            }
        }

        return units
    }

    // MARK: city methods

    func getCitiesOf(civilization: Civilization) -> [City?]? {

        return self.level?.map.citiesOf(civilization: civilization)
    }

    func getAllCitiesOfUser() -> [City?]? {

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        return self.level?.map.citiesOf(civilization: currentUserCivilization)
    }

    func getCity(at point: HexPoint) -> City? {

        return self.level?.map.city(at: point)
    }

    func found(city: City) {

        self.level?.map.set(city: city)
        self.level?.gameObjectManager.setupCities()

        if let node = self.level?.gameObjectManager.node {
            city.gameObject?.addTo(node: node)
        }
    }

    func abandon(city: City) {

        self.level?.gameObjectManager.remove(city: city)
        self.level?.map.remove(city: city)
    }

    // MARK: path finding data sources

    func pathfinderDataSource(for movementType: MovementType, civilization: Civilization, ignoreSight: Bool) -> PathfinderDataSource {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        return level.map.pathfinderDataSource(with: self.level?.gameObjectManager, movementType: movementType, civilization: civilization, ignoreSight: ignoreSight)
    }

    func pathfinderDataSource(for unit: Unit?, ignoreSight: Bool) -> PathfinderDataSource {

        guard let movementType = unit?.unitType.movementType else {
            fatalError("can't find movementType")
        }
        
        guard let civilization = unit?.civilization else {
            fatalError("can't find civilization")
        }

        return self.pathfinderDataSource(for: movementType, civilization: civilization, ignoreSight: ignoreSight)
    }

    func pathfinderDataSource(for animal: Animal?, ignoreSight: Bool) -> PathfinderDataSource {

        guard let movementType = animal?.animalType.movementType else {
            fatalError("can't find movementType")
        }

        return self.pathfinderDataSource(for: movementType, civilization: .pirates, ignoreSight: ignoreSight)
    }

    func getCoastalCities(at ocean: Ocean) -> [City] {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        return level.map.getCoastalCities(at: ocean)
    }

    // MARK: terrain methods

    var oceanTiles: [Tile?] {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        return level.map.oceanTiles
    }

    var forestTiles: [Tile?] {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        return level.map.forestTiles
    }

    func ocean(at point: HexPoint) -> Ocean? {

        return self.level?.map.ocean(at: point)
    }

    func isShore(at point: HexPoint) -> Bool {

        return self.level?.map.terrain(at: point) == .shore
    }

    func terrain(at point: HexPoint) -> Terrain? {

        return self.level?.map.terrain(at: point)
    }

    func features(at point: HexPoint) -> [Feature]? {

        return self.level?.map.features(at: point)
    }

    func add(gameObjectUnitDelegate: GameObjectUnitDelegate) {

        self.level?.gameObjectManager.gameObjectUnitDelegates.addDelegate(gameObjectUnitDelegate)
    }

    func navalUnits(in area: HexArea) -> [Unit] {

        guard let navalUnits = self.level?.map.navalUnits(in: area) else {
            return []
        }

        return navalUnits
    }

    func numberOfDiscoveredTiles(for civilization: Civilization) -> Int? {

        return self.level?.map.fogManager?.numberOfDiscoveredTiles(by: civilization)
    }
}

extension Game: GameObservationDelegate {

    func updated() {
        self.checkCondition()
    }

    func coinConsumed() {

        self.coins += 1
        self.gameUpdateDelegate?.updateUI()
    }

    func boosterConsumed(type: BoosterType) {

        self.boosterStock.increment(boosterType: type)
        self.gameUpdateDelegate?.updateUI()
    }

    func battle(between source: Unit?, and target: Unit?) {

        // check diplomatic status ? hostile / aggressive?

        // check if one of the units is controlled by player
        guard let currentUser = self.userUsecase?.currentUser() else {
            fatalError("can't get current user")
        }

        if currentUser.civilization == source?.civilization {
            // user is attacker
            self.gameUpdateDelegate?.showBattleDialog(between: source, and: target)
        } else if currentUser.civilization == target?.civilization {
            // user is target
            self.gameUpdateDelegate?.showBattleDialog(between: source, and: target)
        } else {

            // run battle automatically (and just display the result)
            let battle = Battle(between: source, and: target, attackType: .active, in: self)
            let battleResult = battle.fight()

            source?.gameObject?.show(losses: battleResult.attackerDamage)
            target?.gameObject?.show(losses: battleResult.defenderDamage)
            
            //self.gameUpdateDelegate?.showBattleResult(between: source, and: target, result: battleResult)
        }
    }
}

// MARK: external classes that can access the level

extension LevelManager {

    static func storeLevelFrom(game: Game?, to fileName: String) {

        guard let level = game?.level else {
            fatalError("Can't store nil levels")
        }

        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let mapPayload: Data = try encoder.encode(level)
            try mapPayload.write(to: filename!)
        } catch {
            fatalError("Can't store level: \(error)")
        }
    }
}

extension GameSceneViewModel {

    func getLevel() -> Level? {

        return self.game?.level
    }
}

