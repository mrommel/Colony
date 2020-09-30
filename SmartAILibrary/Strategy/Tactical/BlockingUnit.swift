//
//  BlockingUnit.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvBlockingUnit
//!  \brief        Potential move of a unit to a hex to form a block keeping enemy away
//
//!  Key Attributes:
//!  - Used by CanCoverFromEnemy() to track moves we may want to make to block enemy
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class BlockingUnit {
    
    let unit: AbstractUnit?
    let point: HexPoint
    var numChoices: Int
    let distanceToTarget: Int
    
    init(unit: AbstractUnit? = nil, at point: HexPoint, numChoices: Int = 0, distanceToTarget: Int = 0) {
        
        self.unit = unit
        self.point = point
        self.numChoices = numChoices
        self.distanceToTarget = distanceToTarget
    }
}

extension BlockingUnit: Comparable {
    
    static func < (lhs: BlockingUnit, rhs: BlockingUnit) -> Bool {
        
        return lhs.distanceToTarget < rhs.distanceToTarget
    }
    
    static func == (lhs: BlockingUnit, rhs: BlockingUnit) -> Bool {
        
        return lhs.distanceToTarget == rhs.distanceToTarget
    }
}
