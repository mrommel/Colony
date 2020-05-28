//
//  Operations.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class Operations: Codable {
    
    enum CodingKeys: CodingKey {

        case operations
    }
    
    private var operations: [Operation]
    
    init() {
        
        self.operations = []
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.operations = try container.decode([Operation].self, forKey: .operations)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.operations, forKey: .operations)
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
