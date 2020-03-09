//
//  UnitMissionTypes.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum UnitAutomationType {
    
    case none
    
    case build
    case explore
}

// CIV5Missions.xml
enum UnitMissionType {
   
    case found
    case moveTo
    case garrison
    case pillage
    case skip
    case rangedAttack
    
    case sleep
    case fortify
    case alert
    case airPatrol
    case heal
    
    case embark
    case disembark
    case rebase

    func name() -> String {
        
        return self.data().name
    }
    
    func needsTarget() -> Bool {
        
        return self.data().needsTarget
    }
    
    internal struct UnitMissionTypeData {
        
        let name: String
        let needsTarget: Bool
    }
    
    func data() -> UnitMissionTypeData {
        
        switch self {
        case .found: return UnitMissionTypeData(name: "Found", needsTarget: false)
        case .moveTo: return UnitMissionTypeData(name: "MoveTo", needsTarget: true)
        case .garrison: return UnitMissionTypeData(name: "Garrison", needsTarget: false)
        case .pillage: return UnitMissionTypeData(name: "Pillage", needsTarget: false)
        case .skip: return UnitMissionTypeData(name: "skip", needsTarget: false)
        case .rangedAttack: return UnitMissionTypeData(name: "rangedAttack", needsTarget: true)
        case .sleep: return UnitMissionTypeData(name: "sleep", needsTarget: false)
        case .fortify: return UnitMissionTypeData(name: "fortify", needsTarget: false)
        case .alert: return UnitMissionTypeData(name: "alert", needsTarget: false)
        case .airPatrol: return UnitMissionTypeData(name: "airpatrol", needsTarget: false)
        case .heal: return UnitMissionTypeData(name: "heal", needsTarget: false)
        case .embark: return UnitMissionTypeData(name: "embark", needsTarget: true)
        case .disembark: return UnitMissionTypeData(name: "disembark", needsTarget: true)
        case .rebase: return UnitMissionTypeData(name: "rebase", needsTarget: true)
        }
    }
}
