//
//  UnitTradeRouteDirection.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum UnitTradeRouteDirection {

    /** this state is used for the trader to walk to his starting city */
    case start

    /** this state indicates that the trader is on the way from starting to target city*/
    case forward

    /** this state indicates that the trader comes back to the starting city*/
    case backward
}
