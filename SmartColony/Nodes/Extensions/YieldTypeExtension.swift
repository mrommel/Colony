//
//  YieldTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 15.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

extension YieldType {
    
    func backgroundTexture() -> String {
        
        switch self {
            
        case .none: return "box_blue"
            
        case .food: return "box_food"
        case .production: return "box_production"
        case .gold: return "box_gold"
        case .science: return "box_science"
        case .culture: return "box_culture"
        case .faith: return "box_faith"
        }
    }
    
    func iconTexture() -> String {
        
        switch self {
            
        case .none: return "none"
            
        case .food: return "food"
        case .production: return "production"
        case .gold: return "gold"
        case .science: return "science"
            
        case .culture: return "culture"
        case .faith: return "faith"
        }
    }
    
    func fontColor() -> SKColor {
        
        switch self {
            
        case .none: return .white
            
        case .food: return SKColor(hex: "#4f6645")
        case .production: return SKColor(hex: "#664c38")
        case .gold: return SKColor(hex: "#665839")
        case .science: return SKColor(hex: "#365066")
            
        case .culture: return SKColor(hex: "#5b4966")
        case .faith: return SKColor(hex: "#285966")
        }
    }
}
