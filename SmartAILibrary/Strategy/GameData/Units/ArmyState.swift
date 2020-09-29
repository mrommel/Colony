//
//  ArmyState.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum ArmyState: Int, Codable {

    case waitingForUnitsToReinforce // ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
    case waitingForUnitsToCatchUp // ARMYAISTATE_WAITING_FOR_UNITS_TO_CATCH_UP
    case movingToDestination // ARMYAISTATE_MOVING_TO_DESTINATION
    case atDestination // ARMYAISTATE_AT_DESTINATION
}
