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

        case .antiquitySite: return "resource-marker-antiquitySite"
        case .shipwreck: return "resource-marker-shipwreck"
        }
    }

    public func textureName() -> String {

        switch self {

        case .none: return "resource-default"

            // bonus
        case .wheat: return "resource-wheat"
        case .rice: return "resource-rice"
        case .deer: return "resource-deer"
        case .sheep: return "resource-sheep"
        case .copper: return "resource-copper"
        case .stone: return "resource-stone"
        case .bananas: return "resource-banana"
        case .cattle: return "resource-cattle"
        case .fish: return "resource-fish"
        case .crab: return "resource-crab"

            // luxus
        case .marble: return "resource-marble"
        case .gems: return "resource-gems"
        case .furs: return "resource-furs"
        case .citrus: return "resource-citrus"
        case .tea: return "resource-tea"
        case .sugar: return "resource-sugar"
        case .whales: return "resource-whales"
        case .pearls: return "resource-pearls"
        case .ivory: return "resource-ivory"
        case .wine: return "resource-wine"
        case .cotton: return "resource-cotton"
        case .dyes: return "resource-dyes"
        case .incense: return "resource-incense"
        case .silk: return "resource-silk"
        case .silver: return "resource-silver"
        case .gold: return "resource-gold"
        case .spices: return "resource-spices"
        case .salt: return "resource-salt"
        case .cocoa: return "resource-cocoa"

            // strategic
        case .horses: return "resource-horses"
        case .iron: return "resource-iron"
        case .coal: return "resource-coal"
        case .oil: return "resource-oil"
        case .aluminium: return "resource-aluminium"
        case .uranium: return "resource-uranium"
        case .niter: return "resource-niter"

            // artifacts
        case .antiquitySite: return "resource-antiquitySite"
        case .shipwreck: return "resource-shipwreck"
        }
    }
}
