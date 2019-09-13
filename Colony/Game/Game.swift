//
//  Game.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol GameUpdateDelegate {
    
    func updateUI()
    
    func showBattleDialog(between source: GameObject?, and target: GameObject?)
    func showBattleResult(between source: GameObject?, and target: GameObject?, result: BattleResult)
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
    
    private var updateTimer: Timer? = nil
    
    enum CodingKeys: String, CodingKey {
        case level
        case coins
        case boosterStock
        case remainingDuration
    }

    // new game
    init(with level: Level?, coins: Int, boosterStock: BoosterStock) {

        self.level = level
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
        
        let score = self.coins
        let levelScore = level.score(for: score)
        
        self.gameUsecase?.set(score: Int32(score), levelScore: levelScore, for: Int32(level.number))
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
            self.level?.gameObjectManager.updatePlayer(object: selectedUnit)
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
        
        self.gameUpdateDelegate?.updateUI()
        self.checkCondition()
        
        //
        self.level?.gameObjectManager.update(in: self)
    }
    
    private func stopUpdateTimer() {

        print("stop update timer")
        self.updateTimer?.invalidate()
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
    
    func neighborsInWater(of point: HexPoint) -> [HexPoint] {
        
        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }
        
        guard let level = self.level else {
            fatalError("can't find level")
        }
        
        let waterTiles = point.neighbors().filter({ map.tile(at: $0)?.isWater ?? false })
        let waterTilesWithoutObstacles = waterTiles.filter({ !level.gameObjectManager.obstacle(at: $0) })
        
        return waterTilesWithoutObstacles
    }
    
    func neighborsOnLand(of point: HexPoint) -> [HexPoint] {
        
        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }
        
        guard let level = self.level else {
            fatalError("can't find level")
        }
        
        let landTiles = point.neighbors().filter({ map.tile(at: $0)?.isGround ?? false })
        let landTilesWithoutObstacles = landTiles.filter({ !level.gameObjectManager.obstacle(at: $0) })
        
        return landTilesWithoutObstacles
    }
    
    func getUnits(at point: HexPoint) -> [GameObject?] {
        
        guard let level = self.level else {
            fatalError("can't find level")
        }
        
        return level.gameObjectManager.units(at: point)
    }
    
    func getSelectedUnitOfUser() -> GameObject? {
        
        return self.level?.gameObjectManager.selected
    }
    
    func getAllUnitsOfUser() -> [GameObject?]? {
        
        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }
        
        return self.level?.gameObjectManager.unitsOf(civilization: currentUserCivilization)
    }
    
    func getUnitsBy(type: UnitType) -> [GameObject?]? {
        
        return self.level?.gameObjectManager.unitsOf(type: type)
    }
    
    func getUnitBy(identifier: String) -> GameObject? {
        
        return self.level?.gameObjectManager.unitBy(identifier: identifier)
    }
    
    func getCityObject(at point: HexPoint) -> CityObject? {
        
        guard let level = self.level else {
            fatalError("can't find level")
        }
        
        let units = level.gameObjectManager.units(at: point)
        let cities = units.filter({ $0?.type == .city })
        
        if cities.count == 1 {
            let city = cities.first as? CityObject
            return city
        }
        
        return nil
    }
    
    func getCityObject(identifier: String) -> CityObject? {
        
        return self.level?.gameObjectManager.unitBy(identifier: identifier) as? CityObject
    }
    
    func pathfinderDataSource(for movementType: GameObjectMoveType, ignoreSight: Bool) -> PathfinderDataSource {
        
        guard let level = self.level else {
            fatalError("can't find level")
        }
        
        return level.map.pathfinderDataSource(with: self.level?.gameObjectManager, movementType: movementType, ignoreSight: ignoreSight)
    }
    
    func getCoastalCities(at ocean: Ocean) -> [City] {
        
        guard let level = self.level else {
            fatalError("can't find level")
        }
        
        return level.map.getCoastalCities(at: ocean)
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
    
    func numberOfDiscoveredTiles() -> Int? {
        
        return self.level?.map.fogManager?.numberOfDiscoveredTiles()
    }
    
    func add(gameObjectUnitDelegate: GameObjectUnitDelegate) {
        
        self.level?.gameObjectManager.gameObjectUnitDelegates.addDelegate(gameObjectUnitDelegate)
    }
    
    func navalUnits(in area: HexArea) -> [GameObject] {
        
        guard let objects = self.level?.gameObjectManager.objects else {
            return []
        }
        
        var navalUnits: [GameObject] = []
        for object in objects {
            
            if let object = object {
                if object.type.isNaval {
                    if area.contains(object.position) {
                        navalUnits.append(object)
                    }
                }
            }
        }
        
        return navalUnits
    }
    
    func city(at point: HexPoint) -> City? {
        
        return self.level?.map.city(at: point)
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
    
    func battle(between source: GameObject?, and target: GameObject?) {
        
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
