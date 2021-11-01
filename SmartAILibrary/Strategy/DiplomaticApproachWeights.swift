//
//  DiplomaticApproachWeights.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 13.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class DiplomaticApproachWeights: WeightedList<PlayerApproachType> {

    override func fill() {
        for approach in PlayerApproachType.all {
            self.items[approach] = 0.0
        }
    }
}
