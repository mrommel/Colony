//
//  ApproachBias.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class ApproachBias {

    let approach: PlayerApproachType
    let bias: Int

    init(approach: PlayerApproachType, bias: Int) {

        self.approach = approach
        self.bias = bias
    }
}
