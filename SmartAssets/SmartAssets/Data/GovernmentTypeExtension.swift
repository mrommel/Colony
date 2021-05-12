//
//  GovernmentTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 12.05.21.
//

import SmartAILibrary

extension GovernmentType {
    
    public func iconTexture() -> String {
        
        switch self {
            
            // ancient
        case .chiefdom: return "government-chiefdom"
            
            // classical
        case .autocracy: return "government-autocracy"
        case .classicalRepublic: return "government-classicalRepublic"
        case .oligarchy: return "government-oligarchy"
            
            //
        case .merchantRepublic: return "government-merchantRepublic"
        case .monarchy: return "government-monarchy"
        case .theocracy: return "government-theocracy"
            
            // modern
        case .fascism: return "government-fascism"
        case .communism: return "government-communism"
        case .democracy: return "government-democracy"
        }
    }
    
    public func ambientTexture() -> String {
        
        switch self {
            
            // ancient
        case .chiefdom: return "government-ambient-chiefdom"
            
            // classical
        case .autocracy: return "government-ambient-autocracy"
        case .classicalRepublic: return "government-ambient-classicalRepublic"
        case .oligarchy: return "government-ambient-oligarchy"
            
            //
        case .merchantRepublic: return "government-ambient-merchantRepublic"
        case .monarchy: return "government-ambient-monarchy"
        case .theocracy: return "government-ambient-theocracy"
            
            // modern
        case .fascism: return "government-ambient-fascism"
        case .communism: return "government-ambient-communism"
        case .democracy: return "government-ambient-democracy"
        }
    }
}
