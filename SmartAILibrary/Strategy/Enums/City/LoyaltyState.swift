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

    public func name() -> String {

        switch self {

        case .loyal:
            return "Loyal"
        case .wavering:
            return "Wavering"
        case .disloyal:
            return "Disloyal"
        case .unrest:
            return "Unrest"
        }
    }

    public func yieldPercentage() -> Double {

        switch self {

        case .loyal:
            return 0.0
        case .wavering:
            return -0.25
        case .disloyal:
            return -0.5
        case .unrest:
            return -1.0
        }
    }
}
