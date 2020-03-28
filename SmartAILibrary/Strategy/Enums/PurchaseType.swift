//
//  PurchaseType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PurchaseType {
    
    case none // NO_PURCHASE_TYPE = -1,
    case tile // PURCHASE_TYPE_TILE,
    case unitUpgrade // PURCHASE_TYPE_UNIT_UPGRADE,
    case civTrade // PURCHASE_TYPE_MAJOR_CIV_TRADE,
    case unit // PURCHASE_TYPE_UNIT,
    case building // PURCHASE_TYPE_BUILDING,
}
