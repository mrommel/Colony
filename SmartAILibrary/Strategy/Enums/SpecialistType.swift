//
//  SpecialistType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum SpecialistType {
    
    case none
    
    case citizen
    
    // https://civilization.fandom.com/wiki/Great_People_(Civ6)
    case artist
    // case admiral
    case engineer
    // case general
    case merchant
    // case musician
    // case prophet
    case scientist
    // case writer
    
    static var all: [SpecialistType] {
        return [.citizen, .artist, .scientist, .merchant, .engineer]
    }
    
    func cutlurePerTurn() -> Int {
        
        if self == .artist {
            return 1
        }
        
        return 0
    }
    
    func yields() -> Yields {
        
        switch self {
            
        case .none: return Yields(food: 0.0, production: 0.0, gold: 0.0)
        
        case .citizen: return Yields(food: 0.0, production: 1.0, gold: 0.0)
        case .artist: return Yields(food: 0.0, production: 0.0, gold: 0.0) // culture cant
        case .scientist: return Yields(food: 0.0, production: 0.0, gold: 0.0, science: 3.0)
        case .merchant: return Yields(food: 0.0, production: 0.0, gold: 2.0)
        case .engineer: return Yields(food: 0.0, production: 1.0, gold: 0.0)
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
        }
    }
    
    func unitType() -> UnitType? {
        
        switch self {
            
        case .none: return nil
        
        case .citizen: return nil
            
        case .artist: return .artist
        case .scientist: return .scientist
        case .merchant: return .merchant
        case .engineer: return .engineer
        }
    }
}
