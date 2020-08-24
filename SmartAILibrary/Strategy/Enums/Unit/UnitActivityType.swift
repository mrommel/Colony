//
//  UnitActivityType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum UnitActivityType: Int, Codable {

    case none
    case awake // ACTIVITY_AWAKE,
    case hold // ACTIVITY_HOLD,
    case sleep // ACTIVITY_SLEEP,
    case heal // ACTIVITY_HEAL,
    case sentry // ACTIVITY_SENTRY,
    case intercept // ACTIVITY_INTERCEPT,
    case mission // ACTIVITY_MISSION
}
