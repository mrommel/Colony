//
//  Game.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol GameUpdateDelegate {
    func update(time: TimeInterval)
    func update(coins: Int)
}

class Game {

    private let level: Level?

    var startTime: TimeInterval = 0.0
    var timer: Timer? = nil
    
    var coins: Int = 0
    
    let gameUsecase: GameUsecase?

    // game condition
    private var conditionChecks: [GameConditionCheck] = []
    var conditionCheckIdentifiers: [String] {
        return self.conditionChecks.map { $0.identifier }
    }

    var conditionDelegate: GameConditionDelegate?
    var gameUpdateDelegate: GameUpdateDelegate?

    init(with level: Level?) {

        self.level = level
        self.gameUsecase = GameUsecase()

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

    deinit {
        self.cancelTimer()
    }

    func start() {
        print("start timer")

        // save start time
        self.startTime = Date().timeIntervalSince1970

        // start timer to check for conditions ever 1 seconds
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            self.gameUpdateDelegate?.update(time: self.timeElapsedInSeconds())
            self.checkCondition()
            
            //
            self.level?.gameObjectManager.update(in: self)
        }
        
        self.level?.gameObjectManager.setup()
    }
    
    func cancelTimer() {
        if let timer = self.timer {
            timer.invalidate()
        }
    }

    func timeElapsedInSeconds() -> TimeInterval {
        let current = Date().timeIntervalSince1970
        return current - self.startTime
    }

    func add(conditionCheck: GameConditionCheck) {

        conditionCheck.game = self
        conditionChecks.append(conditionCheck)
    }

    func checkCondition() {

        for conditionCheck in self.conditionChecks {
            if let type = conditionCheck.isWon() {
                self.conditionDelegate?.won(with: type)
                self.cancelTimer()
            }

            if let type = conditionCheck.isLost() {
                self.conditionDelegate?.lost(with: type)
                self.cancelTimer()
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
    
    func neighborsInWater(of point: HexPoint) -> [HexPoint] {
        
        guard let map = self.level?.map else {
            fatalError("Can't get map")
        }
        
        return point.neighbors().filter({ map.tile(at: $0)?.isWater ?? false })
    }
    
    func getSelectedUnitOfUser() -> GameObject? {
        
        return self.level?.gameObjectManager.selected
    }
    
    func getAllUnitsOfUser() -> [GameObject?]? {
        
        return self.level?.gameObjectManager.unitsOf(civilization: .english) // FIXME
    }
    
    func getUnitsBy(type: GameObjectType) -> [GameObject?]? {
        
        return self.level?.gameObjectManager.unitsOf(type: type)
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
}

extension Game: GameObservationDelegate {
    
    func updated() {
        self.checkCondition()
    }
    
    func coinConsumed() {
        self.coins += 1
        
        self.gameUpdateDelegate?.update(coins: self.coins)
    }
}
