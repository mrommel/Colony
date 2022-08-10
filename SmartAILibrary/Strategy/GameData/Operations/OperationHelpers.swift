//
//  OperationHelpers.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class OperationHelpers {

    static func gatherRangeFor(numberOfUnits: Int) -> Int {

        if numberOfUnits <= 2 {
            return 1
        } else if numberOfUnits <= 6 {
            return 2
        } else if numberOfUnits <= 10 {
            return 3
        } else {
            return 4
        }
    }
}
