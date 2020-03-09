//
//  UnitMission.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 08.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class UnitMission {
    
    weak var unit: AbstractUnit?
    let type: UnitMissionType
    var target: HexPoint? = nil
    let pushTurn: Int
    
    init(type: UnitMissionType, target: HexPoint? = nil, pushTurn: Int) {
        
        self.type = type
        self.target = target
        self.pushTurn = pushTurn
        
        if type.needsTarget() && target == nil {
            fatalError("need target")
        }
    }
    
    func turn(in gameModel: GameModel?) {
        
        fatalError("not implemented yet")
    }
    
    /// Initiate a mission
    func start(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("gameModel not set")
        }
        
        guard let unit = self.unit else {
            fatalError("unit not set")
        }
        
        guard let player = unit.player else {
            fatalError("player not set")
        }
        
        var delete = false
        var notify = false
        var action = false
        
        if unit.canMove() {
            unit.set(activityType: .mission)
        } else {
            unit.set(activityType: .hold)
        }
        
        if !unit.canStart(mission: self, in: gameModel) {
            delete = true
            
        } else {
        
            if self.type == .skip {
                unit.set(activityType: .hold)
                delete = true
            } else if self.type == .sleep {
                unit.set(activityType: .sleep)
                delete = true
                notify = true
            } else if self.type == .fortify {
                unit.set(activityType: .sleep)
                delete = true
                notify = true
            } else if self.type == .heal {
                unit.set(activityType: .heal)
                delete = true
                notify = true
            }
            
            if unit.canMove() {
                
                if self.type == .fortify {
                    unit.doEntrench()
                } else if self.type == .heal || self.type == .alert {
                    unit.doEntrench()
                } else if self.type == .embark || self.type == .disembark {
                    
                    action = true
                }
                // FIXME nuke, paradrop, airlift
                else if self.type == .rebase {
                    
                    guard let target = self.target else {
                        fatalError("type requires a target")
                    }
                    
                    if unit.doRebase(to: target) {
                        action = true
                    }
                } else if self.type == .rangedAttack {
                    
                    guard let target = self.target else {
                        fatalError("type requires a target")
                    }
                    
                    if !unit.canRangeStrike(at: target, needWar: false, noncombatAllowed: false) {
                        // Invalid, delete the mission
                        delete = true
                    }
                } else if self.type == .pillage {
                    
                    if unit.doPillage(in: gameModel) {
                        action = true
                    }
                } else if self.type == .found {
                    
                    if unit.doFound(with: nil, in: gameModel) {
                        action = true
                    }
                }
            }
        }
        
        if action && player.isHuman() {
            
            unit.updateMission()
        }
        
        if delete {
            unit.popMission()
        } else if unit.activityType() == .mission {
            self.continueMission()
        }
    }
    
    func update() {
        
    }
    
    func continueMission() {
        
    }
}
