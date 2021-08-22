//
//  OperationUnit.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvOperationUnit
//!  \brief        One unit moving with operational army currently being processed
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class OperationUnit {

    let unit: AbstractUnit?
    var position: UnitFormationPosition

    init(unit: AbstractUnit?, at position: UnitFormationPosition = .none) {

        self.unit = unit
        self.position = position
    }
}
