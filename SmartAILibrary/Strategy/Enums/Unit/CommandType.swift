//
//  CommandType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/List_of_unit_actions_in_Civ6
public enum CommandType {

    case none

    case rename
    case found
    case buildFarm
    case buildMine
    case buildCamp
    case buildPasture
    case buildQuarry
    case buildPlantation
    case buildFishingBoats
    case removeFeature
    case plantForest

    case pillage
    case fortify
    case hold
    case garrison

    case disband
    case cancelOrder
    // case wakeUp
    case upgrade

    // special
    case automateExploration
    case automateBuild
    case establishTradeRoute
    case foundReligion
    case activateGreatPerson
    case transferToAnotherCity

    // combat
    case attack
    case rangedAttack
    case cancelAttack

    public static var all: [CommandType] {

        return [
            .rename,
            .found,
            .buildFarm,
            .buildMine,
            .buildCamp,
            .buildPasture,
            .buildQuarry,
            .buildPlantation,
            .buildFishingBoats,
            .removeFeature,
            .plantForest,

            .pillage,
            .fortify,
            .hold,
            .garrison,
            .disband,
            .cancelOrder,
            .upgrade,
            .automateExploration,
            .automateBuild,
            .establishTradeRoute,
            .foundReligion,
            .activateGreatPerson,
            .transferToAnotherCity,
            .attack,
            .rangedAttack,
            .cancelAttack
        ]
    }

    public func title() -> String {

        switch self {

        case .none: return ""

        case .rename: return "Rename"
        case .found: return "Found City"
        case .buildFarm: return "Build Farm"
        case .buildMine: return "Build Mine"
        case .buildCamp: return "Camp"
        case .buildPasture: return "Pasture"
        case .buildQuarry: return "Quarry"
        case .buildPlantation: return "Plantation"
        case .buildFishingBoats: return "Fishing Boats"
        // case .buildRoute: return "Build Route"
        case .removeFeature: return "Remove Feature"
        case .plantForest: return "Plant Forest"

        case .pillage: return "Pillage Improvement"
        case .fortify: return "Fortify"
        case .hold: return "Hold"
        case .garrison: return "Garrison"

        case .disband: return "Disband"
        case .cancelOrder: return "Cancel order"
        case .upgrade: return "Upgrade"

        case .automateExploration: return "Automate Exploration"
        case .automateBuild: return "Automate Build"
        case .establishTradeRoute: return "Establish TradeRoute"
        case .foundReligion: return "Found Religion"
        case .activateGreatPerson: return "Activate Great Person"
        case .transferToAnotherCity: return "Transfer to another City"

        case .attack: return "Attack"
        case .rangedAttack: return "Ranged"
        case .cancelAttack: return "Cancel"

        }
    }
}
