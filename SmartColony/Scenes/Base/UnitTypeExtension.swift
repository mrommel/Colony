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
            
        case .settler: return "archer-idle-0"
        case .builder: return "archer-idle-0"
        case .scout: return "archer-idle-0"
        case .warrior: return "archer-idle-0"
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
