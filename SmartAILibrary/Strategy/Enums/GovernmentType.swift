//
//  GovernmentType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

struct PolicyCardSlots {
    
    let military: Int // red
    let economic: Int // yellow
    let diplomatic: Int  // green
    let wildcard: Int // lila
}

enum GovernmentType {
    
    // ancient
    case chiefdom
    
    // classical
    case autocracy
    case classicalRepublic
    case oligarchy
    
    // medieval
    case merchantRepublic
    case monarchy
    
    // renaissance
    case theacracy
    
    // MARK: methods
    
    func era() -> EraType {
        
        switch self {
            
            // ancient
        case .chiefdom: return .ancient
            
            // classical
        case .autocracy: return .classical
        case .classicalRepublic: return .classical
        case .oligarchy: return .classical
            
            // medieval
        case .merchantRepublic: return .medieval
        case .monarchy: return .medieval

            // renaissance
        case .theacracy: return .renaissance
        }
    }
    
    func required() -> CivicType {
        
        switch self {
            
            // ancient
        case .chiefdom: return .codeOfLaws
            
            // classical
        case .autocracy: return .politicalPhilosophy
        case .classicalRepublic: return .politicalPhilosophy
        case .oligarchy: return .politicalPhilosophy
            
            // medieval
        case .merchantRepublic: return .exploration
        case .monarchy: return .divineRight

            // renaissance
        case .theacracy: return .reformedChurch
        }
    }
    
    func policyCardSlots() -> PolicyCardSlots {
        
        switch self {
            
            // ancient
        case .chiefdom: return PolicyCardSlots(military: 1, economic: 1, diplomatic: 0, wildcard: 0)
            
            // classical
        case .autocracy: return PolicyCardSlots(military: 2, economic: 1, diplomatic: 0, wildcard: 0)
        case .classicalRepublic: return PolicyCardSlots(military: 0, economic: 2, diplomatic: 1, wildcard: 1)
        case .oligarchy: return PolicyCardSlots(military: 1, economic: 1, diplomatic: 1, wildcard: 1)
            
            // medieval
        case .merchantRepublic: return PolicyCardSlots(military: 1, economic: 2, diplomatic: 1, wildcard: 2)
        case .monarchy: return PolicyCardSlots(military: 3, economic: 1, diplomatic: 1, wildcard: 1)

            // renaissance
        case .theacracy: return PolicyCardSlots(military: 2, economic: 2, diplomatic: 1, wildcard: 1)
        }
    }
}
