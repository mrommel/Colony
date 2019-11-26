//
//  Mission.swift
//  Colony
//
//  Created by Michael Rommel on 14.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum MissionResult {
    
    case failed
    case success
    case abort
}

// abstract
class Mission {
    
    weak var unit: Unit? = nil
    
    init(unit: Unit?) {
        
        self.unit = unit
    }
    
    func follow(in game: Game?) {
        fatalError("sub class must implement this method")
    }
}

class FollowAndAttackUnitMission: Mission {
    
    let target: Unit?
    
    init(unit: Unit?, target: Unit?) {
        
        self.target = target
        super.init(unit: unit)
    }
    
    func isTargetDead(in game: Game?) -> Bool {
        
        /*guard let game = game else {
            fatalError("can't get game")
        }*/
        
        guard let targetStrength = self.target?.strength else {
            fatalError("can't get target strength")
        }
        
        return targetStrength <= 0
    }
    
    func isTargetVisible(in game: Game?) -> Bool {
        
        guard let game = game else {
            fatalError("can't get game")
        }
        
        guard let targetPosition = self.target?.position else {
            fatalError("can't get target position")
        }
        
        guard let civilization = self.unit?.civilization else {
            fatalError("can't get source civilization")
        }
        
        return game.isVisible(at: targetPosition, for: civilization)
    }
    
    func targetIsInCombatRange() -> Bool {
        
        guard let sourcePosition = self.unit?.position else {
            fatalError("can't get source position")
        }
        
        guard let targetPosition = self.target?.position else {
            fatalError("can't get target position")
        }
        
        guard let range = self.unit?.properties?.range else {
            fatalError("can't get unit range")
        }
        
        return sourcePosition.distance(to: targetPosition) <= range
    }
    
    override func follow(in game: Game?) {
        
        guard let unit = self.unit else {
            fatalError("no unit set")
        }
        
        if self.isTargetDead(in: game) {
            
            // we have lost the unit and the mission
            self.unit?.missionFinished(with: .abort)
            return
        }
        
        if !self.isTargetVisible(in: game) {
            
            // we have lost the unit and the mission
            self.unit?.missionFinished(with: .failed)
            return
        }
        
        if !self.targetIsInCombatRange() {
            
            // we need to move towards the target
            guard let targetPosition = self.target?.position else {
                fatalError("can't get target position")
            }
            
            let unitPosition = unit.position
            
            let pathfinderDataSource = game?.pathfinderDataSource(for: self.unit, ignoreSight: true)
            guard let neighbors = pathfinderDataSource?.walkableAdjacentTilesCoords(forTileCoord: targetPosition) else {
                fatalError("some sort of weirdness")
            }
            
            if neighbors.isEmpty {
                self.unit?.missionFinished(with: .failed)
                return
            }
            
            var bestNeighbor = neighbors.first!
            var bestDistance = Int.max
            
            for neighbor in neighbors {
                let dist = unitPosition.distance(to: neighbor)
                
                if dist < bestDistance {
                    bestNeighbor = neighbor
                    bestDistance = dist
                }
            }
            
            let neighborMission = ScoutingMission(unit: self.unit, target: bestNeighbor)
            self.unit?.order(mission: neighborMission)
            neighborMission.follow(in: game)
            return
        }
        
        
        
        let battle = Battle(between: self.unit, and: self.target, attackType: .active, in: game)
        let prediction = battle.predict()
        
        if prediction.attackerDamage + 2 < unit.strength {
            
            // we need at least one movement point to attack
            if unit.movementInCurrentTurn >= 1 {
                game?.battle(between: self.unit, and: self.target)
                unit.movementInCurrentTurn = unit.movementInCurrentTurn - 1
            }
        } else {
            self.unit?.missionFinished(with: .abort)
            return
        }
    }
}

/// mission for going to target or following a path
class ScoutingMission: Mission {
    
    let target: HexPoint?
    var path: HexPath?
    var onWalk: Bool = false
    
    init(unit: Unit?, target: HexPoint) {
        
        self.target = target
        self.path = nil
        super.init(unit: unit)
    }
    
    init(unit: Unit?, path: HexPath) {
        
        self.target = nil
        self.path = path
        super.init(unit: unit)
    }
    
    override func follow(in game: Game?) {

        // mutex to prevent showing walk multiple times
        if self.onWalk {
            return
        }
        
        if let path = self.path {
            self.onWalk = true
            self.unit?.gameObject?.showWalk(on: path, completion: {
                self.unit?.gameObject?.showIdle()
                self.onWalk = false
                self.unit?.missionFinished(with: .success)
            })
            return
        }
        
        if let target = self.target {
            
            guard let unitPosition = self.unit?.position else {
                fatalError("can't find position of unit")
            }
            
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource = game?.pathfinderDataSource(for: self.unit, ignoreSight: true)

            if let path = pathFinder.shortestPath(fromTileCoord: unitPosition, toTileCoord: target) {
                self.path = path
            } else {
                // no path towards target can be found - nevertheless we can go in the general direction
                let neighbors = pathFinder.dataSource.walkableAdjacentTilesCoords(forTileCoord: unitPosition)
                
                if neighbors.isEmpty {
                    self.unit?.missionFinished(with: .failed)
                    return
                }
                
                var bestNeighbor = neighbors.first!
                var bestDistance = Int.max
                
                for neighbor in neighbors {
                    let dist = unitPosition.distance(to: neighbor)
                    
                    if dist < bestDistance {
                        bestNeighbor = neighbor
                        bestDistance = dist
                    }
                }
                
                let neighborMission = ScoutingMission(unit: self.unit, target: bestNeighbor)
                self.unit?.order(mission: neighborMission)
            }

            return
        }
        
        fatalError("neighter target nor path set")
    }
}
