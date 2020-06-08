//
//  PeaceTreatyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PeaceTreatyType: Int, Comparable, Codable {
    
    case none
    
    case whitePeace // PEACE_TREATY_WHITE_PEACE,
    case armistice // PEACE_TREATY_ARMISTICE,
    case settlement // PEACE_TREATY_SETTLEMENT,
    case backDown // PEACE_TREATY_BACKDOWN,
    case submission // PEACE_TREATY_SUBMISSION,
    case surrender // PEACE_TREATY_SURRENDER,
    case cession // PEACE_TREATY_CESSION,
    case capitulation // PEACE_TREATY_CAPITULATION,
    case unconditionalSurrender // PEACE_TREATY_UNCONDITIONAL_SURRENDER,
    
    static func < (lhs: PeaceTreatyType, rhs: PeaceTreatyType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    func increased(by amount: Int) -> PeaceTreatyType {
        
        var tmp = self
        
        for _ in 0..<amount {
            tmp.increase()
        }
        
        return tmp
    }
    
    mutating func increase() {
        
        switch self {

        case .none:
            self = .none
        case .whitePeace:
            self = .whitePeace
        case .armistice:
            self = .whitePeace
        case .settlement:
            self = .armistice
        case .backDown:
            self = .settlement
        case .submission:
            self = .backDown
        case .surrender:
            self = .submission
        case .cession:
            self = .surrender
        case .capitulation:
            self = .cession
        case .unconditionalSurrender:
            self = .capitulation
        }
    }
    
    func decreased(by amount: Int) -> PeaceTreatyType {
        
        var tmp = self
        
        for _ in 0..<amount {
            tmp.decrease()
        }
        
        return tmp
    }
    
    mutating func decrease() {
        
        switch self {

        case .none:
            self = .none
        case .whitePeace:
            self = .armistice
        case .armistice:
            self = .settlement
        case .settlement:
            self = .backDown
        case .backDown:
            self = .submission
        case .submission:
            self = .surrender
        case .surrender:
            self = .cession
        case .cession:
            self = .capitulation
        case .capitulation:
            self = .unconditionalSurrender
        case .unconditionalSurrender:
            self = .unconditionalSurrender
        }
    }
}
