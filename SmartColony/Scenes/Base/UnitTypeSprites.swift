//
//  UnitTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 08.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import CoreGraphics
import SmartAILibrary

extension UnitType {
    
    var spriteName: String {
        
        switch self {
            
            // barbarian
        case .barbarianWarrior: return "warrior-idle-0"
        case .barbarianArcher: return "archer-idle-0"
  
            // ancient
        case .settler: return "settler-idle-0"
        case .builder: return "builder-idle-0"
            
        case .scout: return "archer-idle-0"
        case .warrior: return "warrior-idle-0"
        case .slinger: return "archer-idle-0"
        case .archer: return "archer-idle-0"
        case .spearman: return "archer-idle-0"
        case .heavyChariot: return "archer-idle-0"
        case .galley: return "archer-idle-0"
            
            // great people
        case .admiral: return "archer-idle-0"
        case .artist: return "archer-idle-0"
        case .engineer: return "archer-idle-0"
        case .general: return "archer-idle-0"
        case .merchant: return "archer-idle-0"
        case .musician: return "archer-idle-0"
        case .prophet: return "archer-idle-0"
        case .scientist: return "archer-idle-0"
        case .writer: return "archer-idle-0"
        
        }
    }
    
    var idleAtlas: GameObjectAtlas? {
        
        switch self {
            
            // barbarian
        case .barbarianWarrior: return GameObjectAtlas(atlasName: "Warrior", template: "warrior-idle-", range: 0..<10)
        case .barbarianArcher: return GameObjectAtlas(atlasName: "Archer", template: "archer-idle-", range: 0..<10)
            
            // ancient
        case .settler: return GameObjectAtlas(atlasName: "Settler", template: "settler-idle-", range: 0..<15)
        case .builder: return GameObjectAtlas(atlasName: "Builder", template: "builder-idle-", range: 0..<15)
        case .scout: return nil
        case .warrior: return GameObjectAtlas(atlasName: "Warrior", template: "warrior-idle-", range: 0..<10)
        case .slinger: return nil
        case .archer: return GameObjectAtlas(atlasName: "Archer", template: "archer-idle-", range: 0..<10)
        case .spearman: return nil
        case .heavyChariot: return nil
        case .galley: return nil
            
            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }
    
    var anchorPoint: CGPoint {
        
        return CGPoint(x: 0.0, y: 0.0)
    }
}
