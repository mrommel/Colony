//
//  GovernmentTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension GovernmentType {
    
    func iconTexture() -> String {
        
        switch self {
            
            // ancient
        case .chiefdom: return "government_chiefdom"
            
            // classical
        case .autocracy: return "government_autocracy"
        case .classicalRepublic: return "government_classicalRepublic"
        case .oligarchy: return "government_oligarchy"
            
            //
        case .merchantRepublic: return "government_merchantRepublic"
        case .monarchy: return "government_monarchy"
        case .theocracy: return "government_theocracy"
            
            // modern
        case .fascism: return "government_fascism"
        case .communism: return "government_communism"
        case .democracy: return "government_democracy"
        }
    }
    
    func bannerTexture() -> String {
        
        switch self {
            
            // ancient
        case .chiefdom: return "government_ambient_chiefdom"
            
            // classical
        case .autocracy: return "government_ambient_autocracy"
        case .classicalRepublic: return "government_ambient_classicalRepublic"
        case .oligarchy: return "government_ambient_oligarchy"
            
            //
        case .merchantRepublic: return "government_ambient_merchantRepublic"
        case .monarchy: return "government_ambient_monarchy"
        case .theocracy: return "government_ambient_theocracy"
            
            // modern
        case .fascism: return "government_ambient_fascism"
        case .communism: return "government_ambient_communism"
        case .democracy: return "government_ambient_democracy"
        }
    }
}
