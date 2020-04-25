//
//  UnitTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 24.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

extension UnitType {

    func iconTexture() -> String {
        
        switch self {
            
            case .barbarianWarrior: return "unit_warrior"

                // ancient
            case .settler: return "unit_settler"
            case .builder: return "unit_builder"

            case .scout: return "unit_scout"
            case .warrior: return "unit_warrior"
            case .slinger: return "unit_slinger"
            case .archer: return "unit_archer"
            case .spearman: return "unit_spearman"
            case .heavyChariot: return "unit_heavyChariot"
            case .galley: return "unit_galley"

                // great people
            case .admiral: return "unit_default"
            case .artist: return "unit_default"
            case .engineer: return "unit_default"
            case .general: return "unit_default"
            case .merchant: return "unit_default"
            case .musician: return "unit_default"
            case .prophet: return "unit_default"
            case .scientist: return "unit_default"
            case .writer: return "unit_default"
        }
    }
}
