//
//  Civ5Resource.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension ResourceType {

    static func fromCiv5String(value: String) -> ResourceType? {

        switch value {

        case "RESOURCE_HORSE": return .horses
        case "RESOURCE_IRON": return .iron
        case "RESOURCE_GOLD": return .gold
        case "RESOURCE_WHEAT": return .wheat
        case "RESOURCE_STONE": return .stone
        case "RESOURCE_FUR": return .furs
        case "RESOURCE_WHALE": return .whales
        case "RESOURCE_FISH": return .fish
        case "RESOURCE_DEER": return .deer
        case "RESOURCE_SHEEP": return .sheep
        case "RESOURCE_COAL": return .coal
        case "RESOURCE_SUGAR": return .sugar
        case "RESOURCE_ALUMINUM": return .aluminium
        case "RESOURCE_COTTON": return .cotton
        case "RESOURCE_SILVER": return .silver
        case "RESOURCE_CRAB": return .crab
        case "RESOURCE_PEARLS": return .pearls
        case "RESOURCE_URANIUM": return .uranium
        case "RESOURCE_WINE": return .wine
        case "RESOURCE_OIL": return .oil
        case "RESOURCE_COW": return .cattle
        case "RESOURCE_SALT": return .salt
        case "RESOURCE_CITRUS": return .citrus
        case "RESOURCE_GEMS": return .gems
        case "RESOURCE_COPPER": return .copper
        case "RESOURCE_IVORY": return .ivory
        case "RESOURCE_BISON": return .cattle
        case "RESOURCE_SPICES": return .spices
        case "RESOURCE_COCOA": return .cocoa
        case "RESOURCE_BANANA": return .bananas
        case "RESOURCE_INCENSE": return .incense
        case "RESOURCE_MARBLE": return .marble
        case "RESOURCE_DYE": return .dyes
        case "RESOURCE_SILK": return .silk
        // case "RESOURCE_TRUFFLES": return .truffles

        default:
            print("case \(value) must be handled")
            return nil
            //fatalError("case \(value) must be handled")
        }
    }
}
