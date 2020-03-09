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
            print("--- operation: \(operation.type)")
        }
    }
    
    func add(operation: Operation) {
        
        self.operations.append(operation)
    }
    
    func operationsOf(type: UnitOperationType) -> [Operation] {
        
        return self.operations.filter({ $0.type == type })
    }
}
