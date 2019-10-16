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
    func showBattleResult(between source: Unit?, and target: Unit?, result: BattleResult)
}

class Game: Decodable {

    fileprivate let level: Level?

    var timer: PausableTimer? = nil

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

    var conditionDelegate: GameConditionDelegate?
    var gameUpdateDelegate: GameUpdateDelegate?

    var gameRating: GameRating?
    var aiscript: AIScript?

    private var updateTimer: Timer? = nil

    enum CodingKeys: String, CodingKey {
        case level
        case coins
        case boosterStock
        case remainingDuration
    }

    // new game
    init(with level: Level?, meta: LevelMeta?, coins: Int, boosterStock: BoosterStock) {

        self.level = level
        self.level?.meta = meta
        self.coins = coins
        self.boosterStock = boosterStock

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

        self.level?.gameObjectManager.gameObservationDelegate = self
    }

    // restarted
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.level = try values.decode(Level.self, forKey: .level)
        self.coins = try values.decode(Int.self, forKey: .coins)
        self.boosterStock = try values.decode(BoosterStock.self, forKey: .boosterStock)

        let remainingDuration = try values.decode(Int.self, forKey: .remainingDuration)

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

        self.start(with: remainingDuration)
    }

    deinit {
        self.cancel()
    }

    func add(conditionCheck: GameConditionCheck) {

        conditionCheck.game = self
        conditionChecks.append(conditionCheck)
    }

    func checkCondition() {

        for conditionCheck in self.conditionChecks {
            if let type = conditionCheck.isWon() {
                self.conditionDelegate?.won(with: type)
                self.cancel()
            }

            if let type = conditionCheck.isLost() {
                self.conditionDelegate?.lost(with: type)
                self.cancel()
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

    func start(with duration: Int) {
        print("start game timer")

        // game timer
        self.timer = PausableTimer(with: TimeInterval(duration))

        // start/stop update timer to check for conditions ever 1 seconds
        self.timer?.didStart = {
            self.startUpdateTimer()
        }
        self.timer?.didPause = {
            self.stopUpdateTimer()
        }
        self.timer?.didResume = {
            self.startUpdateTimer()
        }
        self.timer?.didStop = { isFinished in
            self.stopUpdateTimer()

            if isFinished {
                self.fireUpdateTimer()
            }
        }

        self.timer?.start()

        if let selectedUnit = self.level?.gameObjectManager.selected {
            self.level?.gameObjectManager.updatePlayer(unit: selectedUnit)
        }
    }

    func pause() {

        print("pause game timer")
        if let timer = self.timer {
            timer.pause()
        }
    }

    func resume() {

        print("resume game timer")
        if let timer = self.timer {
            timer.resume()
        }
    }

    func cancel() {

        print("cancel game timer")
        if let timer = self.timer {
            timer.stop()
        }
    }

    func timeRemainingInSeconds() -> TimeInterval {

        if let timer = self.timer {
            return timer.remainingDuration()
        }

        return 0
    }

    private func startUpdateTimer() {

        print("start update timer")
        self.updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireUpdateTimer), userInfo: nil, repeats: true)
    }

    @objc private func fireUpdateTimer() {

        self.update()
        self.gameUpdateDelegate?.updateUI()
        self.checkCondition()

        // FIXME
        // self.level?.gameObjectManager.update(in: self)
    }

    private func stopUpdateTimer() {

        print("stop update timer")
        self.updateTimer?.invalidate()
    }

    private func update() {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        for player in level.players {
            player.update(in: self)
        }

        guard let userCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("can't get user civilization")
        }

        self.aiscript?.update(for: self)

        for unit in level.map.units {

            if unit.isDestroyed() {
                continue
            }

            if unit.civilization != userCivilization {
                unit.update(in: self)
            }
        }
        level.map.units = level.map.units.filter { !$0.isDestroyed() }

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

extension Game {

    var duration: Int {

        if let durationValue = self.level?.duration {
            return durationValue
        }

        return 0
    }

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
            self.pause()
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
            self.resume()
        }
    }
}

extension Game: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.level, forKey: .level)
        try container.encode(self.coins, forKey: .coins)
        try container.encode(self.boosterStock, forKey: .boosterStock)
        try container.encode(self.timer?.remainingDuration(), forKey: .remainingDuration)
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
            if map.fogManager?.fog(at: landTile) == .discovered {
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
        return level.map.fogManager?.currentlyVisible(at: position) ?? false
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

    func pathfinderDataSource(for movementType: MovementType, ignoreSight: Bool) -> PathfinderDataSource {

        guard let level = self.level else {
            fatalError("can't find level")
        }

        return level.map.pathfinderDataSource(with: self.level?.gameObjectManager, movementType: movementType, ignoreSight: ignoreSight)
    }

    func pathfinderDataSource(for unit: Unit?, ignoreSight: Bool) -> PathfinderDataSource {

        guard let movementType = unit?.unitType.movementType else {
            fatalError("can't find movementType")
        }

        return self.pathfinderDataSource(for: movementType, ignoreSight: ignoreSight)
    }

    func pathfinderDataSource(for animal: Animal?, ignoreSight: Bool) -> PathfinderDataSource {

        guard let movementType = animal?.animalType.movementType else {
            fatalError("can't find movementType")
        }

        return self.pathfinderDataSource(for: movementType, ignoreSight: ignoreSight)
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

        guard let units = self.level?.map.units else {
            return []
        }

        var navalUnits: [Unit] = []
        for unit in units {

            if unit.unitType.isNaval {
                if area.contains(unit.position) {
                    navalUnits.append(unit)
                }
            }
        }

        return navalUnits
    }

    func numberOfDiscoveredTiles(for civilization: Civilization) -> Int? {

        return self.level?.map.fogManager?.numberOfDiscoveredTiles()
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
            self.pause()
            self.gameUpdateDelegate?.showBattleDialog(between: source, and: target)
        } else if currentUser.civilization == target?.civilization {
            // user is target
            self.pause()
            self.gameUpdateDelegate?.showBattleDialog(between: source, and: target)
        } else {

            // run battle automatically (and just display the result)
            let battle = Battle(between: source, and: target, attackType: .active, in: self)
            let battleResult = battle.fight()

            self.gameUpdateDelegate?.showBattleResult(between: source, and: target, result: battleResult)
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

