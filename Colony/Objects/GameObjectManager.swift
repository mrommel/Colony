//
//  GameObjectManager.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol GameObjectDelegate {

    func moved(object: GameObject?)
}

public protocol GameConditionType {
    
    var summary: String { get }
}

extension GameConditionType {
}

extension GameConditionType where Self: RawRepresentable, Self.RawValue: FixedWidthInteger {
}

protocol GameConditionDelegate {

    func won(with type: GameConditionType)
    func lost(with type: GameConditionType)
}

class GameObjectManager: Codable {

    weak var map: HexagonTileMap?
    var objects: [GameObject?]
    
    var startTime: TimeInterval = 0.0
    var timer: Timer? = nil

    // game condition
    private var conditionChecks: [GameConditionCheck] = []
    var conditionCheckIdentifiers: [String] {
        return self.conditionChecks.map { $0.identifier }
    }
    
    var conditionDelegate: GameConditionDelegate?

    enum CodingKeys: String, CodingKey {
        case objects
    }

    // MARK: constrcutor

    init(on map: HexagonTileMap?) {
        self.objects = []
        self.map = map
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    func start() {
        print("start timer")
        
        // save start time
        self.startTime = Date().timeIntervalSince1970
        
        // start timer to check for conditions ever 1 seconds
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            
            self.checkCondition()
        }
    }
    
    func timeInSecondsElapsed() -> TimeInterval {
        let current = Date().timeIntervalSince1970
        return current - self.startTime
    }

    func add(conditionCheck: GameConditionCheck) {

        conditionCheck.gameObjectManager = self
        conditionChecks.append(conditionCheck)
    }

    func add(object: GameObject?) {

        guard let object = object else {
            fatalError("Can't add nil object")
        }

        // only player unit update the fog
        if object.tribe == .player {
            self.map?.fogManager?.add(unit: object)
        }

        object.delegate = self
        self.objects.append(object)

        // check if already won / lost the game
        self.checkCondition()
    }
    
    func unitBy(identifier: String) -> GameObject? {
        
        if let object = self.objects.first(where: { $0?.identifier == identifier }) {
            return object
        }
        
        return nil
    }

    func unitsOf(tribe: GameObjectTribe) -> [GameObject?] {

        return self.objects.filter { $0?.tribe == tribe }
    }

    func checkCondition() {

        for conditionCheck in self.conditionChecks {
            if let type = conditionCheck.isWon() {
                self.conditionDelegate?.won(with: type)
                
                if let timer = self.timer {
                    timer.invalidate()
                }
            }

            if let type = conditionCheck.isLost() {
                self.conditionDelegate?.lost(with: type)
                
                if let timer = self.timer {
                    timer.invalidate()
                }
            }
        }
    }
}

extension GameObjectManager: GameObjectDelegate {

    func moved(object: GameObject?) {

        guard let object = object else {
            fatalError("Can't add nil object")
        }

        guard let fogManager = self.map?.fogManager else {
            fatalError("no fogManager set")
        }

        if object.tribe == .player {
            // update fog for own units
            fogManager.update()

            for enemyUnit in self.unitsOf(tribe: .enemy) {

                if let position = enemyUnit?.position {

                    // show/hide enemies based on fog
                    let fogAtEnemy = fogManager.fog(at: position)
                    if fogAtEnemy == .sighted {
                        enemyUnit?.sprite.alpha = 1.0
                    } else {
                        enemyUnit?.sprite.alpha = 0.1
                    }
                }
            }
        } else if object.tribe == .enemy {

            let fogAtEnemy = fogManager.fog(at: object.position)
            if fogAtEnemy == .sighted {
                object.sprite.alpha = 1.0
            } else {
                object.sprite.alpha = 0.1 // TODO: make completely invisible
            }
        }

        // check if won / lost the game
        self.checkCondition()
    }
}
