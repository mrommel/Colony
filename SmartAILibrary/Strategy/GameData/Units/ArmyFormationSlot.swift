//
//  ArmyFormationSlot.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class ArmyFormationSlot {
    
    static let unknownTurnAtCheckpoint = -1
    static let notIncludingInOperation = -2
    
    var unit: AbstractUnit?
    var estimatedTurnAtCheckpoint: Int
    var startedOnOperation: Bool
    
    init(unit: AbstractUnit? = nil, estimatedTurnAtCheckpoint: Int = ArmyFormationSlot.unknownTurnAtCheckpoint, startedOnOperation: Bool = false) {
        
        self.unit = unit
        self.estimatedTurnAtCheckpoint = estimatedTurnAtCheckpoint
        self.startedOnOperation = startedOnOperation
    }
    
    func turnAtCheckpoint() -> Int {
        
        return self.estimatedTurnAtCheckpoint
    }
    
    func set(turnAtCheckpoint value: Int) {
        
        self.estimatedTurnAtCheckpoint = value
    }
    
    func hasStartedOnOperation() -> Bool {
        
        return self.startedOnOperation
    }
    
    func set(startedOnOperation value: Bool) {

        self.startedOnOperation = value
    }
}
