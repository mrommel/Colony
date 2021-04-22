//
//  ResourceTypeExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

extension ResourceType {
    
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

        case .none: return "resource-marker-default"

        case .wheat: return "resource-marker-wheat"
        case .rice: return "resource-marker-rice"
        case .deer: return "resource-marker-deer"
        case .sheep: return "resource-marker-sheep"
        case .copper: return "resource-marker-copper"
        case .stone: return "resource-marker-stone"
        case .bananas: return "resource-marker-banana"
        case .cattle: return "resource-marker-cattle"
        case .fish: return "resource-marker-fish"
        case .crab: return "resource-marker-crab"
            
        case .marble: return "resource-marker-marble"
        case .gems: return "resource-marker-gems"
        case .furs: return "resource-marker-furs"
        case .citrus: return "resource-marker-citrus"
        case .tea: return "resource-marker-tea"
        case .sugar: return "resource-marker-sugar"
        case .whales: return "resource-marker-whales"
        case .pearls: return "resource-marker-pearls"
        case .ivory: return "resource-marker-ivory"
        case .wine: return "resource-marker-wine"
        case .cotton: return "resource-marker-cotton"
        case .dyes: return "resource-marker-dyes"
        case .incense: return "resource-marker-incense"
        case .silk: return "resource-marker-silk"
        case .silver: return "resource-marker-silver"
        case .gold: return "resource-marker-gold"
        case .spices: return "resource-marker-spices"
        case .salt: return "resource-marker-salt"
        case .cocoa: return "resource-marker-cocoa"

        case .horses: return "resource-marker-horses"
        case .iron: return "resource-marker-iron"
        case .coal: return "resource-marker-coal"
        case .oil: return "resource-marker-oil"
        case .aluminium: return "resource-marker-aluminium"
        case .uranium: return "resource-marker-uranium"
        case .niter: return "resource-marker-niter"
        }
    }

    public func textureName() -> String {

        switch self {

        case .none: return "resource_default"

            // bonus
        case .wheat: return "resource_wheat"
        case .rice: return "resource_rice"
        case .deer: return "resource_deer"
        case .sheep: return "resource_sheep"
        case .copper: return "resource_copper"
        case .stone: return "resource_stone"
        case .bananas: return "resource_banana"
        case .cattle: return "resource_cattle"
        case .fish: return "resource_fish"
        case .crab: return "resource_crab"
            
            // luxus
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
        case .salt: return "resource_salt"
        case .cocoa: return "resource_cocoa"

            // strategic
        case .horses: return "resource_horses"
        case .iron: return "resource_iron"
        case .coal: return "resource_coal"
        case .oil: return "resource_oil"
        case .aluminium: return "resource_aluminium"
        case .uranium: return "resource_uranium"
        case .niter: return "resource_niter"
        }
    }
}
