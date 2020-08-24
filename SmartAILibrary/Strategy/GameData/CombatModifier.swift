//
//  CombatModifier.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class CombatModifier {
    
    public let modifierValue: Int
    public let modifierTitle: String
    
    init(modifierValue: Int, modifierTitle: String) {
        
        self.modifierValue = modifierValue
        self.modifierTitle = modifierTitle
    }
}
