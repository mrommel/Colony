//
//  WonderType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum WonderType {
    
    case none
    
    // ancient
    case greatBath
    case pyramids
    case hangingGardens
    case oracle
    case stonehenge
    case templeOfArtemis
    
    static var all: [WonderType] {
        
        return [
            // ancient
            .greatBath, .pyramids, .hangingGardens, .oracle, .stonehenge, .templeOfArtemis
        ]
    }
    
    func productionCost() -> Int {
        
        switch self {
            
        case .none: return -1
            
            // ancient
        case .greatBath: return 180
        case .hangingGardens: return 180
        case .stonehenge: return 180
        case .templeOfArtemis: return 180
        case .pyramids: return 220
        case .oracle: return 290
            
        }
    }
    
    func requiredTech() -> TechType? {
        
        switch self {
    
        case .none: return nil
            
            // ancient
        case .greatBath: return .pottery
        case .hangingGardens: return .irrigation
        case .stonehenge: return .astrology
        case .templeOfArtemis: return .archery
        case .pyramids: return .masonry
        case .oracle: return nil
            
        }
    }
    
    func requiredCivic() -> CivicType? {
        
        switch self {
            
        case .none: return nil
            
            // ancient
        case .greatBath: return nil
        case .hangingGardens: return nil
        case .stonehenge: return nil
        case .templeOfArtemis: return nil
        case .pyramids: return nil
        case .oracle: return .mysticism
            
        }
    }
    
    func flavor(for flavorType: FlavorType) -> Int {
        
        if let flavor = self.flavours().first(where: { $0.type == flavorType }) {
            return flavor.value
        }
        
        return 0
    }

    private func flavours() -> [Flavor] {
        
        switch self {
            
        case .none: return []
            
            // ancient
        case .greatBath: return [ Flavor(type: .wonder, value: 15), Flavor(type: .religion, value: 10) ]
        case .pyramids: return [ Flavor(type: .wonder, value: 25), Flavor(type: .culture, value: 20) ]
        case .hangingGardens: return [ Flavor(type: .wonder, value: 20), Flavor(type: .growth, value: 20) ]
        case .oracle: return [ Flavor(type: .wonder, value: 20), Flavor(type: .culture, value: 15) ]
        case .stonehenge: return [ Flavor(type: .wonder, value: 25), Flavor(type: .culture, value: 20) ]
        case .templeOfArtemis: return [ Flavor(type: .wonder, value: 20), Flavor(type: .growth, value: 10) ]
        }
    }
}
