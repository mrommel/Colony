//
//  FaithPurchaseType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum FaithPurchaseType: Int, Codable {

    case noAutomaticFaithPurchase // NO_AUTOMATIC_FAITH_PURCHASE
    case saveForProphet // FAITH_PURCHASE_SAVE_PROPHET
    case purchaseUnit // FAITH_PURCHASE_UNIT
    case purchaseBuilding // FAITH_PURCHASE_BUILDING
}
