//
//  UnitTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 24.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

extension UnitType {

    func iconTexture() -> SKTexture {

        if let texture = self.idleAtlas?.textures.first {
            return texture
        }
        
        return SKTexture(imageNamed: "unit_type_default")
    }

    func typeTexture() -> String {

        switch self {

            // barbarian
        case .barbarianWarrior: return "unit_type_warrior"
        case .barbarianArcher: return "unit_type_archer"

            // ancient
        case .settler: return "unit_type_settler"
        case .builder: return "unit_type_builder"
        case .trader: return "unit_type_trader"

        case .scout: return "unit_type_scout"
        case .warrior: return "unit_type_warrior"
        case .slinger: return "unit_type_slinger"
        case .archer: return "unit_type_archer"
        case .spearman: return "unit_type_spearman"
        case .heavyChariot: return "unit_type_heavyChariot"
        case .galley: return "unit_type_galley"

            // industrial
        case .medic: return "unit_type_medic"
            
            // great people
        case .admiral: return "unit_type_default"
        case .artist: return "unit_type_default"
        case .engineer: return "unit_type_default"
        case .general: return "unit_type_default"
        case .merchant: return "unit_type_default"
        case .musician: return "unit_type_default"
        case .prophet: return "unit_type_default"
        case .scientist: return "unit_type_default"
        case .writer: return "unit_type_default"
        }
    }
}
