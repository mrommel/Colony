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
        
        case .barbarianWarrior: return "--"
            
        case .settler: return "settler-idle-0"
        case .builder: return "builder-idle-0"
        case .scout: return "archer-idle-0"
        case .warrior: return "warrior-idle-0"
        case .slinger: return "archer-idle-0"
        case .archer: return "archer-idle-0"
        case .spearman: return "archer-idle-0"
        case .heavyChariot: return "archer-idle-0"
        case .galley: return "archer-idle-0"
            
        case .artist: return "archer-idle-0"
        case .admiral: return "archer-idle-0"
        case .engineer: return "archer-idle-0"
        case .general: return "archer-idle-0"
        case .merchant: return "archer-idle-0"
        case .prophet: return "archer-idle-0"
        case .scientist: return "archer-idle-0"
        }
    }
    
    var idleAtlas: GameObjectAtlas? {
        
        switch self {
        case .barbarianWarrior: return GameObjectAtlas(atlasName: "Warrior", textures: ["axemann-idle-0", "axemann-idle-1", "axemann-idle-2", "axemann-idle-3"])
            
        case .settler: return GameObjectAtlas(atlasName: "Settler", template: "settler-idle-", range: 0..<15)
        case .builder: return GameObjectAtlas(atlasName: "Builder", template: "builder-idle-", range: 0..<15)
        case .scout: return nil
        case .warrior: return GameObjectAtlas(atlasName: "Warrior", template: "warrior-idle-", range: 0..<10)
        case .slinger: return nil
        case .archer: return GameObjectAtlas(atlasName: "Archer", textures: ["archer-idle-0", "archer-idle-1", "archer-idle-2", "archer-idle-3", "archer-idle-4", "archer-idle-5", "archer-idle-6", "archer-idle-7", "archer-idle-8", "archer-idle-9"])
        case .spearman: return nil
        case .heavyChariot: return nil
        case .galley: return nil
            
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .prophet: return nil
        case .scientist: return nil
        }
    }
    
    var anchorPoint: CGPoint {
        
        switch self {
        
        case .barbarianWarrior: return CGPoint(x: 0.0, y: 0.0)
            
        case .settler: return CGPoint(x: 0.0, y: 0.0)
        case .builder: return CGPoint(x: 0.0, y: 0.0)
        case .scout: return CGPoint(x: 0.0, y: 0.0)
        case .warrior: return CGPoint(x: 0.0, y: 0.0)
        case .slinger:return CGPoint(x: 0.0, y: 0.0)
        case .archer: return CGPoint(x: 0.0, y: 0.0)
        case .spearman: return CGPoint(x: 0.0, y: 0.0)
        case .heavyChariot: return CGPoint(x: 0.0, y: 0.0)
        case .galley: return CGPoint(x: 0.0, y: 0.0)
            
        case .artist: return CGPoint(x: 0.0, y: 0.0)
        case .admiral: return CGPoint(x: 0.0, y: 0.0)
        case .engineer: return CGPoint(x: 0.0, y: 0.0)
        case .general: return CGPoint(x: 0.0, y: 0.0)
        case .merchant: return CGPoint(x: 0.0, y: 0.0)
        case .prophet: return CGPoint(x: 0.0, y: 0.0)
        case .scientist:return CGPoint(x: 0.0, y: 0.0)
        }
    }
}
