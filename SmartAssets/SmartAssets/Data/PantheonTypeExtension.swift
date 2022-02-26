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

        case .cityPatronGoddess: return "pantheon-cityPatronGoddess"
        case .danceOfTheAurora: return "pantheon-danceOfTheAurora"
        case .desertFolklore: return "pantheon-desertFolklore"
        case .divineSpark: return "pantheon-divineSpark"
        case .earthGoddess: return "pantheon-earthGoddess"
        case .fertilityRites: return "pantheon-fertilityRites"
        case .fireGoddess: return "pantheon-fireGoddess"
        case .godOfCraftsmen: return "pantheon-godOfCraftsmen"
        case .godOfHealing: return "pantheon-godOfHealing"
        case .godOfTheForge: return "pantheon-godOfTheForge"
        case .godOfTheOpenSky: return "pantheon-godOfTheOpenSky"
        case .godOfTheSea: return "pantheon-godOfTheSea"
        case .godOfWar: return "pantheon-godOfWar"
        case .goddessOfFestivals: return "pantheon-goddessOfFestivals"
        case .goddessOfTheHarvest: return "pantheon-goddessOfTheHarvest"
        case .goddessOfTheHunt: return "pantheon-goddessOfTheHunt"
        case .initiationRites: return "pantheon-initiationRites"
        case .ladyOfTheReedsAndMarshes: return "pantheon-ladyOfTheReedsAndMarshes"
        case .monumentToTheGods: return "pantheon-monumentToTheGods"
        case .oralTradition: return "pantheon-oralTradition"
        case .religiousIdols: return "pantheon-religiousIdols"
        case .riverGoddess: return "pantheon-riverGoddess"
        case .religiousSettlements: return "pantheon-religiousSettlements"
        case .sacredPath: return "pantheon-sacredPath"
        case .stoneCircles: return "pantheon-stoneCircles"
        }
    }
}
