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
    case canBuildRoads
    case canImproveSea
    case canEstablishTradeRoute
    
    case canEmbark
    case experienceFromTribal // Gains XP when activating Tribal Villages (+5 XP) and discovering Natural Wonders (+10 XP
    case oceanImpassable // Can only operate on coastal waters, until the research of Cartography.
    case canCapture
    
    case canHeal // Increases the healing of stationary adjacent units by +20 HP/turn.
    case canMoveInRivalTerritory

    static var all: [UnitAbilityType] {
        
        return [
            .canFound, .canImprove, .canBuildRoads, .canImproveSea, .canEstablishTradeRoute,
            
            .canEmbark, .experienceFromTribal, .oceanImpassable, .canCapture,
            
            .canHeal, .canMoveInRivalTerritory
        ]
    }

    // MARK: internal classes

    private struct AbilityData {

        let name: String
    }

    // MARK: methods

    func name() -> String {

        return self.data().name
    }

    // MARK: private methods

    private func data() -> AbilityData {

        switch self {
            
        case .canFound: return AbilityData(name: "Can Found")
        case .canImprove: return AbilityData(name: "Can Improve")
        case .canBuildRoads: return AbilityData(name: "Can Build Roads")
        case .canImproveSea: return AbilityData(name: "Can Improve at sea")
        case .canEstablishTradeRoute: return AbilityData(name: "Can establish TradeRoute") // FIXME foreign trade
            
        case .canEmbark: return AbilityData(name: "Can Embark")
        case .experienceFromTribal: return AbilityData(name: "Experience from tribal")
        case .oceanImpassable: return AbilityData(name: "Ocean impassable")
        case .canCapture: return AbilityData(name: "Can capture")
            
        case .canHeal: return AbilityData(name: "Can Heal adjacent units")
        case .canMoveInRivalTerritory: return AbilityData(name: "Can move in rival territorys")
        }
    }
}
