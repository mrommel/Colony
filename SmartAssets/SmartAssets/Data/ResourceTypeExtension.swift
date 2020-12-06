//
//  ResourceTypeExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

extension ResourceType {

    /*public func name() -> String {

        switch self {

        case .none: return "---"

        case .wheat: return "Wheat"
        case .rice: return "Rice"
        case .deer: return "Deer"
        case .sheep: return "Sheep"
        case .copper: return "Copper"
        case .stone: return "Stone"
        case .bananas: return "Bananas"
        case .cattle: return "Cattle"
        case .fish: return "Fish"

            // luxury
        case .marble: return "Marble"
        case .gems: return "Gems"
        case .furs: return "Furs"
        case .citrus: return "Citrus"
        case .tea: return "Tea"
        case .sugar: return "Sugar"
        case .whales: return "Whales"
        case .pearls: return "Pearls"
        case .ivory: return "Ivory"
        case .wine: return "Wine"
        case .cotton: return "Cotton"
        case .dyes: return "Dyes"
        case .incense: return "Incense"
        case .silk: return "Silk"
        case .silver: return "Silver"
        case .gold: return "Gold"
        case .spices: return "Spices"

            // strategic
        case .horses: return "Horses"
        case .iron: return "Iron"
        case .coal: return "Coal"
        case .oil: return "Oil"
        case .aluminium: return "Aliminium"
        case .uranium: return "Uranium"
        case .niter: return "Niter"
        }
    }*/
    
    public static func from(name: String) -> ResourceType? {
        
        for resource in ResourceType.all {
            if resource.name() == name {
                return resource
            }
        }
        
        return nil
    }

    public func textureMarkerName() -> String {

        switch self {

        case .none: return "resource_marker_default"

        case .wheat: return "resource_marker_wheat"
        case .rice: return "resource_marker_rice"
        case .deer: return "resource_marker_deer"
        case .sheep: return "resource_marker_sheep"
        case .copper: return "resource_marker_copper"
        case .stone: return "resource_marker_stone"
        case .bananas: return "resource_marker_banana"
        case .cattle: return "resource_marker_cattle"
        case .fish: return "resource_marker_fish"
        case .marble: return "resource_marker_marble"
        case .gems: return "resource_marker_gems"
        case .furs: return "resource_marker_furs"
        case .citrus: return "resource_marker_citrus"
        case .tea: return "resource_marker_tea"

        case .sugar: return "resource_marker_sugar"
        case .whales: return "resource_marker_whales"
        case .pearls: return "resource_marker_pearls"
        case .ivory: return "resource_marker_ivory"
        case .wine: return "resource_marker_wine"
        case .cotton: return "resource_marker_cotton"
        case .dyes: return "resource_marker_dyes"
        case .incense: return "resource_marker_incense"
        case .silk: return "resource_marker_silk"
        case .silver: return "resource_marker_silver"
        case .gold: return "resource_marker_gold"
        case .spices: return "resource_marker_spices"

        case .horses: return "resource_marker_horse"
        case .iron: return "resource_marker_iron"
        case .coal: return "resource_marker_coal"
        case .oil: return "resource_marker_oil"
        case .aluminium: return "resource_marker_aluminium"
        case .uranium: return "resource_marker_uranium"
        case .niter: return "resource_marker_niter"
        }
    }

    public func textureName() -> String {

        switch self {

        case .none: return "resource_default"

        case .wheat: return "resource_wheat"
        case .rice: return "resource_rice"
        case .deer: return "resource_deer"
        case .sheep: return "resource_sheep"
        case .copper: return "resource_copper"
        case .stone: return "resource_stone"
        case .bananas: return "resource_banana"
        case .cattle: return "resource_cattle"
        case .fish: return "resource_fish"
        case .marble: return "resource_marble"
        case .gems: return "resource_gems"
        case .furs: return "resource_furs"
        case .citrus: return "resource_citrus"
        case .tea: return "resource_tea"

        case .sugar: return "resource_sugar"
        case .whales: return "resource_whales"
        case .pearls: return "resource_pearls"
        case .ivory: return "resource_ivory"
        case .wine: return "resource_wine"
        case .cotton: return "resource_cotton"
        case .dyes: return "resource_dyes"
        case .incense: return "resource_incense"
        case .silk: return "resource_silk"
        case .silver: return "resource_silver"
        case .gold: return "resource_gold"
        case .spices: return "resource_spices"

        case .horses: return "resource_horse"
        case .iron: return "resource_iron"
        case .coal: return "resource_coal"
        case .oil: return "resource_oil"
        case .aluminium: return "resource_aluminium"
        case .uranium: return "resource_uranium"
        case .niter: return "resource_niter"
        }
    }
}
