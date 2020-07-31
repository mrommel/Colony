//
//  GreatWork.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum GreatWork {
    
    // writings
    case odyssey
    case iliad
    
    // artworks (paitings)
    case annunciation
    case saviourInGlory
    case ascension
    
    private struct GreatWorkData {
        
        let name: String
        let type: GreatWorkType
    }
    
    private func data() -> GreatWorkData {
        
        switch self {
            
            // writings
        case .odyssey:
            return GreatWorkData(name: "Odyssey", type: .writing)
        case .iliad:
            return GreatWorkData(name: "Iliad", type: .writing)
            
            // artworks / paintings
        case .annunciation:
            return GreatWorkData(name: "Annunciation", type: .art)
        case .saviourInGlory:
            return GreatWorkData(name: "Saviour in Glory", type: .art)
        case .ascension:
            return GreatWorkData(name: "Ascension", type: .art)
        }
    }
}
