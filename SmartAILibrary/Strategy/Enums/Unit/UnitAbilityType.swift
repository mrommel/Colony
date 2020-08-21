//
//  UnitAbilityType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 19.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum UnitAbilityType {

    // civil
    case canFound
    case canImprove
    case canImproveSea
    case canEstablishTradeRoute
    
    case canEmbark
    case experienceFromTribal // Gains XP when activating Tribal Villages (+5 XP) and discovering Natural Wonders (+10 XP
    case oceanImpassable // Can only operate on coastal waters, until the research of Cartography.
    case canCapture
    
    case canHeal // Increases the healing of stationary adjacent units by +20 HP/turn.

    static var all: [UnitAbilityType] {
        
        return [
            .canFound, .canImprove, .canImproveSea, .canEstablishTradeRoute,
            
            .canEmbark, .experienceFromTribal, .oceanImpassable, .canCapture,
            
            .canHeal
        ]
    }

    // MARK: internal classes

    private struct AbilityData {

        let name: String
        let required: [TechType]
    }

    // MARK: methods

    func name() -> String {

        return self.data().name
    }
    
    func required() -> [TechType] {

        return self.data().required
    }

    // MARK: private methods

    private func data() -> AbilityData {

        switch self {
            
        case .canFound: return AbilityData(name: "Can Found", required: [])
        case .canImprove: return AbilityData(name: "Can Improve", required: [])
        case .canImproveSea: return AbilityData(name: "Can Improve at sea", required: [])
        case .canEstablishTradeRoute: return AbilityData(name: "Can establish TradeRoute", required: []) // FIXME foreign trade
            
        case .canEmbark: return AbilityData(name: "Can Embark", required: [])
        case .experienceFromTribal: return AbilityData(name: "Experience from tribal", required: [])
        case .oceanImpassable: return AbilityData(name: "Ocean impassable", required: [])
        case .canCapture: return AbilityData(name: "Can capture", required: [])
            
        case .canHeal: return AbilityData(name: "Can Heal adjacent units", required: [])
        }
    }
}
