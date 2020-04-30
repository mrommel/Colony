//
//  PolicyCardsTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 26.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension PolicyCardType {

    func iconTexture() -> String {

        switch self.slot() {
        case .military: return "policyCard_military"
        case .economic: return "policyCard_economic"
        case .diplomatic: return "policyCard_diplomatic"
        case .wildcard: return "policyCard_default"
        }
    }
}
