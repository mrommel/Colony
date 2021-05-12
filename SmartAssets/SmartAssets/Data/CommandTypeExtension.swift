//
//  CommandTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.05.21.
//

import SmartAILibrary

extension CommandType {

    public func iconTexture() -> String {

        switch self {

        case .found: return "command-found"
        case .buildFarm: return "command-farm"
        case .buildMine: return "command-mine"
        case .buildCamp: return "command-camp"
        case .buildPasture: return "command-pasture"
        case .buildQuarry: return "command-quarry"

        case .hold: return "command-hold"

        case .fortify: return "command-fortify"
        case .garrison: return "command-garrison"
        case .pillage: return "command-pillage"
        case .disband: return "command-disband"
        case .establishTradeRoute: return "command-establishTradeRoute"

        case .attack: return "command-attack"
        case .rangedAttack: return "command-ranged"
        case .cancelAttack: return "command-cancel"
        }
    }

    public func buttonTexture() -> String {

        switch self {

        case .found: return "command-button-found"
        case .buildFarm: return "command-button-farm"
        case .buildMine: return "command-button-mine"
        case .buildCamp: return "command-button-camp"
        case .buildPasture: return "command-button-pasture"
        case .buildQuarry: return "command-button-quarry"

        case .hold: return "command-button-hold"

        case .fortify: return "command-button-fortify"
        case .garrison: return "command-button-garrison"
        case .pillage: return "command-button-pillage"
        case .disband: return "command-button-disband"
        case .establishTradeRoute: return "command-button-establishTradeRoute"

        case .attack: return "command-button-attack"
        case .rangedAttack: return "command-button-default"
        case .cancelAttack: return "command-button-default"
        }
    }
}