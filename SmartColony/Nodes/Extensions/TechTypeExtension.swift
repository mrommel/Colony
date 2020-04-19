//
//  TechTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension TechType {
    
    func iconTexture() -> String {
        
        switch self {
            
            // ancient
        case .mining: return "tech_mining"
        case .pottery: return "tech_pottery"
        case .animalHusbandry: return "tech_animalHusbandry"
        case .sailing: return "tech_sailing"
        case .astrology: return "tech_astrology"
        case .irrigation: return "tech_irrigation"
        case .writing: return "tech_writing"
        case .masonry: return "tech_masonry"
        case .archery: return "tech_archery"
        case .bronzeWorking: return "tech_bronzeWorking"
        case .wheel: return "tech_wheel"
            
            // classical
        case .celestialNavigation: return "tech_none"
        case .horsebackRiding: return "tech_none"
        case .currency: return "tech_none"
        case .construction: return "tech_none"
        case .ironWorking: return "tech_none"
        case .shipBuilding: return "tech_none"
        case .mathematics: return "tech_none"
        case .engineering: return "tech_none"
            
            // medieval
        case .militaryTactics: return "tech_none"
        case .buttress: return "tech_none"
        case .apprenticesship: return "tech_none"
        case .stirrups: return "tech_none"
        case .machinery: return "tech_none"
        case .education: return "tech_none"
        case .militaryEngineering: return "tech_none"
        case .castles: return "tech_none"
            
            // renaissance
        case .cartography: return "tech_none"
        case .massProduction: return "tech_none"
        case .banking: return "tech_none"
        case .gunpowder: return "tech_none"
        case .printing: return "tech_none"
        case .squareRigging: return "tech_none"
        case .astronomy: return "tech_none"
        case .metalCasting: return "tech_none"
        case .siegeTactics: return "tech_none"
        }
    }
}
