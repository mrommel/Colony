//
//  OperationHelpers.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class OperationHelpers {
    
    static func gatherRangeFor(numOfUnits: Int) -> Int {
        
        if numOfUnits <= 2 {
            return 1
        } else if numOfUnits <= 6 {
            return 2
        } else if numOfUnits <= 10 {
            return 3
        } else {
            return 4
        }
    }
}
