//
//  PantheonType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/List_of_pantheons_in_Civ6
public enum PantheonType: Int, Codable {
    
    case none
    
    case cityPatronGoddess
    case danceOfTheAurora
    case desertFolklore
    case divineSpark
    case earthGoddess
    case fertilityRites
    case fireGoddess
    case godOfCraftsmen
    case godOfHealing
    case godOfTheForge
    case godOfTheOpenSky
    case godOfTheSea
    case godOfWar
    case goddessOfFestivals
    case goddessOfTheHarvest
    case goddessOfTheHunt
    case initiationRites
    case ladyOfTheReedsAndMarshes
    case monumentToTheGods
    case oralTradition
    case religiousIdols
    case riverGoddess
    case religiousSettlements
    case sacredPath
    case stoneCircles
    
    public static var all: [PantheonType] = [.cityPatronGoddess, danceOfTheAurora, desertFolklore, divineSpark, earthGoddess, fertilityRites, fireGoddess, godOfCraftsmen, godOfHealing, godOfTheForge, godOfTheOpenSky, godOfTheSea, godOfWar, goddessOfFestivals, goddessOfTheHarvest, goddessOfTheHunt, initiationRites, ladyOfTheReedsAndMarshes, monumentToTheGods, oralTradition, religiousIdols, riverGoddess, religiousSettlements, sacredPath, stoneCircles]
    
    public func name() -> String {
        
        return self.data().name
    }
    
    // MARK: internal classes
    
    private struct PantheonData {
        
        let name: String
        let bonus: String
    }
    
    // MARK: private methods
    
    private func data() -> PantheonData {
        
        switch self {
        
        case .none:
            return PantheonData(name: "None", bonus: "")
        
        case .cityPatronGoddess:
            return PantheonData(name: "City Patron Goddess",
                                bonus: "+25% Production Production toward districts in cities without a specialty district.")
        case .danceOfTheAurora:
            return PantheonData(name: "Dance of the Aurora",
                                bonus: "Holy Site districts get +1 Faith Faith from adjacent Tundra tiles.")
        case .desertFolklore:
            return PantheonData(name: "Desert Folklore",
                                bonus: "Holy Site districts get +1 Faith Faith from adjacent Desert tiles.")
        case .divineSpark:
            return PantheonData(name: "Divine Spark",
                                bonus: "+1 Great Person Great Person Points from Holy Sites (Prophet), Campuses with a Library (Scientist), and Theater Squares with an Amphitheater (Writer).")
        case .earthGoddess:
            return PantheonData(name: "Earth Goddess",
                                bonus: "+1 Faith Faith from tiles with Breathtaking Appeal.")
        case .fertilityRites:
            return PantheonData(name: "Fertility Rites",
                                bonus: "When chosen receive a Builder in your capital. City growth rate is 10% higher.")
        case .fireGoddess:
            return PantheonData(name: "Fire Goddess",
                                bonus: "+2 Faith Faith from Geothermal Fissures and Volcanic Soil.")
        case .godOfCraftsmen:
            return PantheonData(name: "God of Craftsmen",
                                bonus: "+1 Production Production and +1 Faith Faith from improved Strategic resources.")
        case .godOfHealing:
            return PantheonData(name: "God of Healing",
                                bonus: "Increases units' healing by 30 in Holy Site districts, or any adjacent tiles.")
        case .godOfTheForge:
            return PantheonData(name: "God of the Forge",
                                bonus: "+25% Production Production toward Ancient and Classical military units.")
        case .godOfTheOpenSky:
            return PantheonData(name: "God of the Open Sky",
                                bonus: "+1 Culture Culture from Pastures.")
        case .godOfTheSea:
            return PantheonData(name: "God of the Sea",
                                bonus: "+1 Production Production from Fishing Boats.")
        case .godOfWar:
            return PantheonData(name: "God of War",
                                bonus: "Bonus Faith Faith equal to 50% of the strength of each combat unit killed within 8 tiles of a Holy Site district.")
        case .goddessOfFestivals:
            return PantheonData(name: "Goddess of Festivals",
                                bonus: "+1 Culture Culture from Plantations.")
        case .goddessOfTheHarvest:
            return PantheonData(name: "Goddess of the Harvest",
                                bonus: "Harvesting a resource or removing a feature receives Faith Faith equal to the other yield's quantity.")
        case .goddessOfTheHunt:
            return PantheonData(name: "Goddess of the Hunt",
                                bonus: "+1 Food Food and +1 Production Production from Camps.")
        case .initiationRites:
            return PantheonData(name: "Initiation Rites",
                                bonus: "+50 Faith Faith for each Barbarian Outpost cleared. The unit that cleared the Barbarian Outpost heals +100 HP.")
        case .ladyOfTheReedsAndMarshes:
            return PantheonData(name: "Lady of the Reeds and Marshes",
                                bonus: "+2 Production Production from Marsh, Oasis, and Desert Floodplains.")
        case .monumentToTheGods:
            return PantheonData(name: "Monument to the Gods",
                                bonus: "+15% Production Production to Ancient and Classical era Wonders.")
        case .oralTradition:
            return PantheonData(name: "Oral Tradition",
                                bonus: "+1 Culture Culture from Bananas Bananas, Citrus Citrus, Cotton Cotton, Dyes Dyes, Silk Silk, Spices Spices, and Sugar Sugar Plantations.")
        case .religiousIdols:
            return PantheonData(name: "Religious Idols",
                                bonus: "+2 Faith Faith from Mines over Luxury and Bonus resources.")
        case .riverGoddess:
            return PantheonData(name: "River Goddess",
                                bonus: "+2 Amenities Amenities and +2 Housing Housing to cities if they have a Holy Site district adjacent to a River.")
        case .religiousSettlements:
            return PantheonData(name: "Religious Settlements",
                                bonus: "When chosen receive a Settler in your capital. Border expansion rate is 15% faster.")
        case .sacredPath:
            return PantheonData(name: "Sacred Path",
                                bonus: "Holy Site districts get +1 Faith Faith from adjacent Rainforest tiles.")
        case .stoneCircles:
            return PantheonData(name: "Stone Circles",
                                bonus: "+2 Faith Faith from Quarries.")
        }
    }
}

extension PantheonType {
    
    func requiresResource() -> Bool {
        
        return false
    }
    
    func requiresNoImprovement() -> Bool {
        
        return false
    }
    
    func requiresImprovement() -> Bool {
        
        return false
    }
    
    func requiresNoFeature() -> Bool {
        
        return false
    }
}
