//
//  DangerPlotsAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class DangerPlotsAI {
    
    let player: AbstractPlayer
    var dangerPlots: Array2D<Double>?
    
    init(player: AbstractPlayer) {
        
        self.player = player
        self.dangerPlots = nil
    }
    
    func initialize(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let mapSize = gameModel.mapSize()
        self.dangerPlots = Array2D<Double>(columns: mapSize.width(), rows: mapSize.height())
        self.dangerPlots?.fill(with: 0)
    }
    
    func update(with gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // wipe out values
        self.dangerPlots?.fill(with: 0)
        
        // for each opposing civ
        for otherPlayer in gameModel.players {
            
            if !otherPlayer.isAlive() {
                continue
            }
            
            if otherPlayer.leader == player.leader {
                continue
            }
            
            // for each unit
            for unitRef in gameModel.units(of: otherPlayer) {
                
                if let unit = unitRef {
                    
                    var range = unit.moves()
                    if unit.isOf(unitClass: .ranged) {
                    
                        range += unit.range()
                    }
                    
                    self.assignDangerValue(for: unit, at: unit.location)
                    
                    for pt in unit.location.areaWith(radius: range) {
                        
                        if !gameModel.valid(point: pt) {
                            continue
                        }
                        
                        if pt == unit.location {
                            continue
                        }
                        
                        if !unit.canMoveOrAttack(into: pt) {
                            continue
                        }
                        
                        /*if !unit.canRangeStrike(at: pt) {
                            continue
                        }*/
                        
                        self.assignDangerValue(for: unit, at: pt)
                    }
                }
            }
            
            // for each city
        }
    }
    
    /// Contains the calculations to do the danger value for the plot according to the unit
    func assignDangerValue(for unit: AbstractUnit, at point: HexPoint) {
        
        let combatValueCalc = 100
        //let baseUnitCombatValue = unit.
        
        fatalError("not implemented yet")
    }
    
    func danger(at point: HexPoint) -> Double {
        
        if let value = self.dangerPlots?[point] {
            return value
        }
        
        return 0.0
    }
}
