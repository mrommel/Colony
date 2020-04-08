//
//  GoodyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 08.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum GoodyType {
    
    case warrior
    case population
    case culture
    case revealNearbyBarbarians
    case gold
    case map
    case tech
    case upgradeUnit
    case settler
    case worker
    case experience
    
    static var all: [GoodyType] {
        return [.warrior, .population, .culture, .revealNearbyBarbarians, .gold, .map, .tech, .upgradeUnit, .settler, .worker, .experience]
    }
    
    func unitType() -> UnitType? {
        
        if self == .warrior {
            return .warrior
        }
        
        if self == .settler {
            return .settler
        }
        
        if self == .worker {
            return .builder
        }
        
        return nil
    }
    
    func gold() -> Int {
        
        if self == .gold {
            return 50
        }
        
        return 0
    }
    
    func numGoldRandRolls() -> Int {
        
        if self == .gold {
            return 5
        }
        
        return 0
    }
    
    func goldRandAmount() -> Int {
        
        if self == .gold {
            return 11
        }
        
        return 0
    }
    
    func population() -> Int {
        return 1
    }
}
