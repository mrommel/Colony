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

        case .rename: return "command-default"
        case .found: return "command-found"
        case .buildFarm: return "command-farm"
        case .buildMine: return "command-mine"
        case .buildCamp: return "command-camp"
        case .buildPasture: return "command-pasture"
        case .buildQuarry: return "command-quarry"
        case .buildPlantation: return "command-plantation"
        case .buildFishingBoats: return "command-fishingBoats"

        case .hold: return "command-hold"
        case .fortify: return "command-fortify"
        case .garrison: return "command-garrison"
        case .pillage: return "command-pillage"

        case .disband: return "command-disband"
        case .cancelOrder: return "command-cancelOrder"
        case .upgrade: return "command-default"

        case .automateExploration: return "command-automateExploration"
        case .automateBuild: return "command-automateBuild"
        case .establishTradeRoute: return "command-establishTradeRoute"
        case .foundReligion: return "command-default"
        case .activateGreatPerson: return "command-default"
        case .transferToAnotherCity: return "command-default"

        case .attack: return "command-attack"
        case .rangedAttack: return "command-ranged"
        case .cancelAttack: return "command-cancel"
        }
    }

    public func buttonTexture() -> String {

        switch self {

        case .rename: return "command-button-rename"
        case .found: return "command-button-found"
        case .buildFarm: return "command-button-farm"
        case .buildMine: return "command-button-mine"
        case .buildCamp: return "command-button-camp"
        case .buildPasture: return "command-button-pasture"
        case .buildQuarry: return "command-button-quarry"
        case .buildPlantation: return "command-button-plantation"
        case .buildFishingBoats: return "command-button-fishingBoats"

        case .hold: return "command-button-hold"
        case .fortify: return "command-button-fortify"
        case .garrison: return "command-button-garrison"
        case .pillage: return "command-button-pillage"

        case .disband: return "command-button-disband"
        case .cancelOrder: return "command-button-cancelOrder"
        case .upgrade: return "command-button-upgrade"

        case .automateExploration: return "command-button-automateExploration"
        case .automateBuild: return "command-button-automateBuild"
        case .establishTradeRoute: return "command-button-establishTradeRoute"
        case .foundReligion: return "command-button-foundReligion"
        case .activateGreatPerson: return "command-button-activateGreatPerson"
        case .transferToAnotherCity: return "command-button-transferToAnotherCity"

        case .attack: return "command-button-attack"
        case .rangedAttack: return "command-button-ranged"
        case .cancelAttack: return "command-button-default" // generic
        }
    }
}
