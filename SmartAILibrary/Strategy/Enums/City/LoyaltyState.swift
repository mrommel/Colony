//
//  LoyaltyState.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum LoyaltyState {

    case loyal
    case wavering
    case disloyal
    case unrest

    public func yieldFactor() -> Double {

        switch self {

        case .loyal:
            return 1.0
        case .wavering:
            return 0.75
        case .disloyal:
            return 0.5
        case .unrest:
            return 0.0
        }
    }
}
