//
//  TacticalPostureType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvTacticalPosture
//!  \brief        The posture an AI has adopted for fighting in a specific dominance zone
//
//!  Key Attributes:
//!  - Used to keep consistency in approach from turn-to-turn
//!  - Reevaluated by tactical AI each turn before units are moved for this zone
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
enum TacticalPostureType {
    
    case none
    case withdraw
    case sitAndBombard
    case attritFromRange
    case exploitFlanks
    case steamRoll
    case surgicalCityStrike
    case hedgehog
    case counterAttack
    case shoreBombardment
    case emergencyPurchases
}
