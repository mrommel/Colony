//
//  SpecialistType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Specialists_(Civ6)
enum SpecialistType: Int, Codable {
    
    case none
    
    case citizen
    
    case artist
    case captain
    case engineer
    case commander
    case merchant
    case priest
    case scientist
    
    static var all: [SpecialistType] {
        return [.citizen, .artist, .captain, .commander, .scientist, .merchant, .engineer, .priest]
    }
    
    func cutlurePerTurn() -> Int {
        
        if self == .artist {
            return 2
        }
        
        return 0
    }
    
    func yields() -> Yields {
        
        switch self {
            
        case .none: return Yields(food: 0.0, production: 0.0, gold: 0.0)
        
        case .citizen: return Yields(food: 0.0, production: 0.0, gold: 0.0)
            
        case .artist: return Yields(food: 0.0, production: 0.0, gold: 0.0) // culture cant
        case .scientist: return Yields(food: 0.0, production: 0.0, gold: 0.0, science: 2.0)
        case .merchant: return Yields(food: 0.0, production: 0.0, gold: 2.0)
        case .engineer: return Yields(food: 0.0, production: 2.0, gold: 0.0)
        case .captain: return Yields(food: 1.0, production: 0.0, gold: 2.0)
        case .commander: return Yields(food: 0.0, production: 1.0, gold: 2.0)
        case .priest: return Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 2.0)
        }
    }
    
    func greatPeopleRateChange() -> Int {
        
        switch self {
            
        case .none: return 0
        
        case .citizen: return 0
        case .artist: return 3
        case .scientist: return 3
        case .merchant: return 3
        case .engineer: return 3
        case .captain: return 3
        case .commander: return 3
        case .priest: return 3
        }
    }
    
    /*func greatPeopleUnitClass() -> UnitType? {
        
        switch self {
            
        case .none: return nil
        
        case .citizen: return nil
            
        case .artist: return .artist
        case .scientist: return .scientist
        case .merchant: return .merchant
        case .engineer: return .engineer
        case .captain: return .admiral
        case .commander: return .general
        case .priest: return .prophet
        }
    }*/
}
