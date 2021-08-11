//
//  PantheonTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.07.21.
//

import SmartAILibrary

extension PantheonType {
    
    public func iconTexture() -> String {
        
        switch self {
            
        case .none: return "pantheon-default"
            
        case .cityPatronGoddess: return "pantheon-default"
        case .danceOfTheAurora: return "pantheon-default"
        case .desertFolklore: return "pantheon-default"
        case .divineSpark: return "pantheon-default"
        case .earthGoddess: return "pantheon-default"
        case .fertilityRites: return "pantheon-default"
        case .fireGoddess: return "pantheon-default"
        case .godOfCraftsmen: return "pantheon-default"
        case .godOfHealing: return "pantheon-default"
        case .godOfTheForge: return "pantheon-default"
        case .godOfTheOpenSky: return "pantheon-default"
        case .godOfTheSea: return "pantheon-default"
        case .godOfWar: return "pantheon-default"
        case .goddessOfFestivals: return "pantheon-default"
        case .goddessOfTheHarvest: return "pantheon-default"
        case .goddessOfTheHunt: return "pantheon-default"
        case .initiationRites: return "pantheon-default"
        case .ladyOfTheReedsAndMarshes: return "pantheon-default"
        case .monumentToTheGods: return "pantheon-default"
        case .oralTradition: return "pantheon-default"
        case .religiousIdols: return "pantheon-default"
        case .riverGoddess: return "pantheon-default"
        case .religiousSettlements: return "pantheon-default"
        case .sacredPath: return "pantheon-default"
        case .stoneCircles: return "pantheon-default"
        }
    }
}
