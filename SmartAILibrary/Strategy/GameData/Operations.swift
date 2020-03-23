//
//  Operations.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class Operations {
    
    private var operations: [Operation]
    
    init() {
        
        self.operations = []
    }
    
    func turn(in gameMode: GameModel?) {
                
        //fatalError("not implemented yet")
        for operation in self.operations {
            
            //if operation.state ==
            
            print("--- operation: \(operation.type) - \(operation.state)")
        }
    }
    
    func add(operation: Operation) {
        
        self.operations.append(operation)
    }
    
    func operationsOf(type: UnitOperationType) -> [Operation] {
        
        return self.operations.filter({ $0.type == type })
    }
    
    func numUnitsNeededToBeBuilt() -> Int {
        
        var rtnValue = 0

        for operation in self.operations {

            rtnValue += operation.numUnitsNeededToBeBuilt()
        }

        return rtnValue
    }
    
    func doDelayedDeath() {
        
        var operationsToDelete: [Operation?] = []
        
        for operation in self.operations {
            
            if operation.doDelayedDeath() {
                operationsToDelete.append(operation)
            }
        }
        
        for operationToDelete in operationsToDelete {
            self.operations.removeAll(where: { $0 == operationToDelete })
        }
    }
}
