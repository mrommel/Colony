//
//  ResourceType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum ResourceUsageType {

    case bonus
    case strategic
    case luxury
}

public enum ResourceType: Int, Codable {

    case none

    // bonus
    case wheat
    case rice
    case deer
    case sheep
    case copper
    case stone // https://civilization.fandom.com/wiki/Stone_(Civ6)
    case bananas
    case cattle
    case fish

    // luxury
    case marble // https://civilization.fandom.com/wiki/Marble_(Civ6)
    case gems // https://civilization.fandom.com/wiki/Diamonds_(Civ6)
    case furs // https://civilization.fandom.com/wiki/Furs_(Civ6)
    case citrus
    case tea // https://civilization.fandom.com/wiki/Tea_(Civ6)
    case sugar
    case whales // https://civilization.fandom.com/wiki/Whales_(Civ6)
    case pearls // https://civilization.fandom.com/wiki/Pearls_(Civ6)
    case ivory // https://civilization.fandom.com/wiki/Ivory_(Civ6)
    case wine // https://civilization.fandom.com/wiki/Wine_(Civ6)
    case cotton // https://civilization.fandom.com/wiki/Cotton_(Civ6)
    case dyes // https://civilization.fandom.com/wiki/Dyes_(Civ6)
    case incense // https://civilization.fandom.com/wiki/Incense_(Civ6)
    case silk // https://civilization.fandom.com/wiki/Silk_(Civ6)
    case silver // https://civilization.fandom.com/wiki/Silver_(Civ6)
    case gold // https://civilization.fandom.com/wiki/Gold_Ore_(Civ6)/Gifts_of_the_Nile
    case spices // https://civilization.fandom.com/wiki/Spices_(Civ6)

    // strategic
    //case coal
    case horses
    case iron // https://civilization.fandom.com/wiki/Iron_(Civ6)
    case coal // https://civilization.fandom.com/wiki/Coal_(Civ6)
    case oil // https://civilization.fandom.com/wiki/Oil_(Civ6)
    case aluminium // https://civilization.fandom.com/wiki/Aluminum_(Civ6)
    case uranium // https://civilization.fandom.com/wiki/Uranium_(Civ6)
    case niter

    // Special
    // Antiquity Site
    // Shipwreck

    public static var all: [ResourceType] {
        return [
            // bonus
            .wheat, .rice, .deer, .sheep, .copper, .stone, .bananas, .cattle, .fish,

            // luxury
            .marble, .gems, .furs, .citrus, tea, .whales, .pearls, .ivory, .wine, .cotton, .dyes, .incense, .silk, .silver, .gold, .spices,

            // strategic
            .horses, .iron, .coal, .oil, .aluminium, .uranium, .niter
        ]
    }

    // MARK: methods
    
    public func name() -> String {
        
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
    }

    func usage() -> ResourceUsageType {

        switch self {

        case .none:
            return .bonus

        case .wheat, .rice, .sheep, .deer, .copper, .stone, .bananas, .cattle, .fish:
            return .bonus

        case .gems, .marble, .furs, .citrus, .tea, .sugar, .whales, .pearls, .ivory, .wine, .cotton, .dyes, .incense, .silk, .silver, .gold, .spices:
            return .luxury

        case .iron, .horses, .coal, .oil, .aluminium, .uranium, .niter:
            return .strategic
        }
    }

    func yields() -> Yields {

        switch self {

        case .none: return Yields(food: 0, production: 0, gold: 0, science: 0)

            // bonus
        case .wheat: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .rice: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .deer: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .sheep: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .copper: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .stone: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .bananas: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .cattle: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .fish: return Yields(food: 1, production: 0, gold: 0, science: 0)

            // luxury
        case .gems: return Yields(food: 0, production: 0, gold: 3, science: 0)
        case .citrus: return Yields(food: 2, production: 0, gold: 0, science: 0)
        case .furs: return Yields(food: 1, production: 0, gold: 1, science: 0)
        case .marble: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 1)
        case .tea: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 1)
        case .sugar: return Yields(food: 2, production: 0, gold: 0, science: 0, culture: 0)
        case .whales: return Yields(food: 0, production: 1, gold: 1, science: 0, culture: 0)
        case .pearls: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 1)
        case .ivory: return Yields(food: 0, production: 1, gold: 1, science: 0)
        case .wine: return Yields(food: 1, production: 0, gold: 1, science: 0)
        case .cotton: return Yields(food: 0, production: 0, gold: 3, science: 0)
        case .dyes: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 1)
        case .incense: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 1)
        case .silk: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 1)
        case .silver: return Yields(food: 0, production: 0, gold: 3, science: 0)
        case .gold: return Yields(food: 0, production: 0, gold: 3, science: 0)
        case .spices: return Yields(food: 2, production: 0, gold: 0, science: 0)

            // strategic
        case .iron: return Yields(food: 0, production: 0, gold: 0, science: 1)
        case .horses: return Yields(food: 1, production: 1, gold: 0, science: 0)
        case .coal: return Yields(food: 0, production: 2, gold: 0, science: 0)
        case .oil: return Yields(food: 0, production: 3, gold: 0, science: 0)
        case .aluminium: return Yields(food: 0, production: 0, gold: 0, science: 1)
        case .uranium: return Yields(food: 0, production: 2, gold: 0, science: 0)
        case .niter: return Yields(food: 1, production: 1, gold: 0, science: 0)
        }
    }

    func accessImprovement() -> ImprovementType {

        switch self {

        case .none:
            return .none

        case .wheat, .rice:
            return .farm

        case .cattle, .sheep, .horses:
            return .pasture

        case .stone, .marble:
            return .quarry

        case .bananas, .citrus, .tea, .sugar, .spices, .wine, .cotton, .dyes, .incense, .silk:
            return .plantation

        case .deer, .furs, .ivory:
            return .camp

        case .fish, .whales, .pearls:
            return .fishingBoats

        case .gems, .iron, .copper, .coal, .aluminium, .uranium, .niter, .gold, .silver:
            return .mine
            
        case .oil:
            return .oilWell // offshoreOilRig !!!
        }
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavors().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }

    func flavors() -> [Flavor] {

        switch self {

        case .none: return []

            // bonus
        case .wheat:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .rice:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .deer:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .sheep:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .copper:
            return [
                Flavor(type: .gold, value: 10)
            ]
        case .stone:
            return [
                Flavor(type: .production, value: 10)
            ]
        case .bananas:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .cattle:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .fish:
            return [
                Flavor(type: .navalTileImprovement, value: 10)
            ]

            // luxury
        case .gems:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .marble:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .furs:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .citrus:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .tea:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .sugar:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .whales:
        return [
            Flavor(type: .happiness, value: 10)
        ]
            case .pearls:
            return [
                Flavor(type: .happiness, value: 10)
            ]
            case .ivory:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .wine: return [
            Flavor(type: .happiness, value: 10)
        ]
        case .cotton:return [
            Flavor(type: .happiness, value: 10)
        ]
        case .dyes: return [
            Flavor(type: .happiness, value: 10)
        ]
        case .incense: return [
            Flavor(type: .happiness, value: 10)
        ]
        case .silk: return [
            Flavor(type: .happiness, value: 10)
        ]
        case .silver: return [
            Flavor(type: .happiness, value: 10)
        ]
        case .gold: return [
            Flavor(type: .happiness, value: 10)
        ]
        case .spices: return [
            Flavor(type: .happiness, value: 10)
        ]

            // strategic
        case .iron:
            return [
                Flavor(type: .offense, value: 10)
            ]
        case .horses:
            return [
                Flavor(type: .mobile, value: 10)
            ]
        case .coal:
            return [
                Flavor(type: .production, value: 10)
            ]
        case .oil:
            return [
                Flavor(type: .production, value: 10)
            ]
        case .aluminium:
        return [
            Flavor(type: .science, value: 5), Flavor(type: .production, value: 7)
        ]
        case .uranium:
            return [
                Flavor(type: .production, value: 10)
            ]
        case .niter:
        return [
            Flavor(type: .production, value: 7), Flavor(type: .growth, value: 5)
        ]
        }
    }

    func amenities() -> Int {

        switch self {

        case .none: return 0
        case .wheat: return 0
        case .rice: return 0
        case .deer: return 0
        case .sheep: return 0
        case .copper: return 0
        case .stone: return 0
        case .bananas: return 0
        case .cattle: return 0
        case .fish: return 0

            // luxury
        case .gems: return 4
        case .marble: return 4
        case .furs: return 4
        case .citrus: return 4
        case .tea: return 4
        case .sugar: return 4
        case .whales: return 4
        case .pearls: return 4
        case .ivory: return 4
        case .wine: return 4
        case .cotton: return 4
        case .dyes: return 4
        case .incense: return 4
        case .silk: return 4
        case .silver: return 4
        case .gold: return 4
        case .spices: return 4

            // strategic
        case .iron: return 0
        case .horses: return 0
        case .coal: return 0
        case .oil: return 0
        case .aluminium: return 0
        case .uranium: return 0
        case .niter: return 0
        }
    }

    func techCityTrade() -> TechType? {

        return self.revealTech()
    }

    func quantity() -> [Int] {

        switch self {

        case .none: return []

            // bonus
        case .wheat: return []
        case .rice: return []
        case .deer: return []
        case .sheep: return []
        case .copper: return []
        case .stone: return []
        case .bananas: return []
        case .cattle: return []
        case .fish: return []

            // luxury
        case .gems: return []
        case .marble: return []
        case .furs: return []
        case .citrus: return []
        case .tea: return []
        case .sugar: return []
        case .whales: return []
        case .pearls: return []
        case .ivory: return []
        case .wine: return []
        case .cotton: return []
        case .dyes: return []
        case .incense: return []
        case .silk: return []
        case .silver: return []
        case .gold: return []
        case .spices: return []

            // strategic
        case .horses: return [2, 4]
        case .iron: return [2, 6]
        case .coal: return [2, 6]
        case .oil: return [2, 6]
        case .aluminium: return [2, 6]
        case .uranium: return [2, 6]
        case .niter: return [2, 6]
        }
    }

    func revealTech() -> TechType? {

        switch self {
        case .none: return nil

            // bonus
        case .wheat: return .pottery
        case .rice: return .pottery
        case .deer: return .animalHusbandry
        case .sheep: return .animalHusbandry
        case .copper: return .mining
        case .stone: return .mining
        case .bananas: return .irrigation
        case .cattle: return .animalHusbandry
        case .fish: return .celestialNavigation

            // luxury
        case .gems: return .mining
        case .marble: return .mining
        case .furs: return .animalHusbandry
        case .citrus: return .irrigation
        case .tea: return .irrigation
        case .sugar: return .irrigation
        case .whales: return .sailing
        case .pearls: return .sailing
        case .wine: return .irrigation
        case .cotton: return .irrigation
        case .dyes: return .irrigation
        case .incense: return .irrigation
        case .silk: return .irrigation
        case .silver: return .mining
        case .gold: return .mining
        case .spices: return .irrigation
        case .ivory: return .animalHusbandry

            // strategic
        case .iron: return .bronzeWorking
        case .horses: return .animalHusbandry
        case .coal: return .industrialization
        case .aluminium: return .radio
        case .uranium: return .combinedArms
        case .niter: return .militaryEngineering
        case .oil: return .refining
        }
    }

    func placedOnHills() -> Bool {

        if self == .coal || self == .gold || self == .copper || self == .marble {
            return true
        }
        
        if self == .sheep {
            return true
        }

        return false
    }
    
    func placedOnRiverSide() -> Bool {
        
        if self == .cattle || self == .iron || self == .horses || self == .oil || self == .uranium || self == .sheep || self == .marble {
            return false
        }
        
        return true
    }
    
    func isFlatlands() -> Bool {
        
        if self == .iron || self == .horses || self == .oil || self == .uranium || self == .niter || self == .wheat  || self == .cattle || self == .deer  || self == .bananas || self == .ivory || self == .furs  || self == .dyes  || self == .spices || self == .silk  || self == .sugar || self == .cotton || self == .wine  || self == .incense {
            return true
        }
        
        return false
    }
    
    func placedOn(feature: FeatureType) -> Bool {
        
        if self == .oil {
            return feature == .rainforest || feature == .marsh
        }
        
        if self == .uranium {
            return feature == .rainforest || feature == .forest || feature == .marsh
        }
        
        if self == .wheat {
            return feature == .floodplains
        }
        
        if self == .rice {
            return feature == .marsh
        }
        
        if self == .deer {
            return feature == .forest
        }
        
        if self == .bananas {
            return feature == .rainforest
        }
        
        if self == .gems {
            return feature == .rainforest
        }
        
        if self == .furs {
            return feature == .forest
        }
        
        if self == .dyes {
            return feature == .rainforest || feature == .forest
        }
        
        if self == .spices {
            return feature == .rainforest
        }
        
        if self == .silk {
            return feature == .forest
        }
        
        if self == .sugar {
            return feature == .floodplains || feature == .marsh
        }
        
        return false
    }
    
    func placedOn(featureTerrain: TerrainType) -> Bool {
        
        if self == .oil {
            return featureTerrain == .grass || featureTerrain == .plains
        }
        
        if self == .uranium {
            return featureTerrain == .grass || featureTerrain == .plains || featureTerrain == .desert || featureTerrain == .tundra || featureTerrain == .snow
        }
        
        if self == .wheat {
            return featureTerrain == .desert
        }
        
        if self == .deer {
            return featureTerrain == .grass || featureTerrain == .plains || featureTerrain == .tundra || featureTerrain == .snow
        }
        
        if self == .bananas {
            return featureTerrain == .grass || featureTerrain == .plains
        }
        
        if self == .gems {
            return featureTerrain == .grass || featureTerrain == .plains
        }
        
        if self == .furs {
            return featureTerrain == .grass || featureTerrain == .plains || featureTerrain == .tundra || featureTerrain == .snow
        }
        
        if self == .dyes {
            return featureTerrain == .grass || featureTerrain == .plains
        }
        
        if self == .spices {
            return featureTerrain == .grass || featureTerrain == .plains
        }
        
        if self == .silk {
            return featureTerrain == .grass || featureTerrain == .plains
        }
        
        if self == .sugar {
            return featureTerrain == .grass || featureTerrain == .plains || featureTerrain == .desert
        }
        
        return true
    }
    
    // only checked if no feature
    func placedOn(terrain: TerrainType) -> Bool {
        
        switch self {
            
        case .none: return false
            
            // bonus
        case .wheat:
            return terrain == .plains
        case .rice:
            return terrain == .grass
        case .deer:
            return terrain == .tundra
        case .sheep:
            return terrain == .grass || terrain == .plains || terrain == .desert
        case .copper:
            // they all can have hills
            return terrain == .grass || terrain == .plains || terrain == .desert || terrain == .tundra
        case .stone:
            return terrain == .grass
        case .bananas:
            return false // only on rainforest feature
        case .cattle:
            return terrain == .grass
        case .fish:
            return terrain == .shore
            
            // luxury
        case .marble:
            return terrain == .grass || terrain == .plains
        case .gems:
            return terrain == .grass || terrain == .plains || terrain == .desert || terrain == .tundra
        case .furs:
            return terrain == .tundra
        case .citrus:
            return terrain == .grass || terrain == .plains
        case .tea:
            return terrain == .grass
        case .sugar:
            return false // only on floodplains, marshes feature
        case .whales:
            return terrain == .shore
        case .pearls:
            return terrain == .shore
        case .ivory:
            return terrain == .plains || terrain == .desert
        case .wine:
            return terrain == .grass || terrain == .plains
        case .cotton:
            return terrain == .grass || terrain == .plains
        case .dyes:
            return false // only on forest and rainforest feature
        case .incense:
            return terrain == .plains || terrain == .desert
        case .silk:
            return false // only on forest feature
        case .silver:
            return terrain == .desert || terrain == .tundra
        case .gold:
            return terrain == .grass || terrain == .plains || terrain == .desert
        case .spices:
            return false // only on forest and rainforest feature
            
            // strategic
        case .horses:
            return terrain == .grass || terrain == .plains || terrain == .tundra
        case .iron:
            return terrain == .grass || terrain == .plains || terrain == .desert || terrain == .tundra || terrain == .snow
        case .coal:
            return terrain == .grass || terrain == .plains
        case .oil:
            return terrain == .desert || terrain == .tundra || terrain == .snow || terrain == .shore
        case .aluminium:
            return terrain == .plains || terrain == .desert || terrain == .tundra
        case .uranium:
            return terrain == .grass || terrain == .plains || terrain == .desert || terrain == .tundra || terrain == .snow
        case .niter:
            return terrain == .grass || terrain == .plains || terrain == .desert || terrain == .tundra
        }
    }
    
    func placementOrder() -> Int {
        
        switch self {
            
        case .none: return -1
            
        case .iron: return 0
            
        case .horses: return 1
            
        case .coal: return 2
        case .oil: return 2
        case .aluminium: return 2
        case .uranium: return 2
        case .niter: return 2
            
        case .marble: return 3
        case .furs: return 3
        case .citrus: return 3
        case .tea: return 3
        case .sugar: return 3
        case .wine: return 3
        case .incense: return 3
        case .cotton: return 3
        case .silk: return 3
        case .spices: return 3
        case .dyes: return 3
        case .ivory: return 3
        case .fish: return 3
        
        case .wheat: return 4
        case .rice: return 4
        case .deer: return 4
        case .sheep: return 4
        case .copper: return 4
        case .stone: return 4
        case .bananas: return 4
        case .cattle: return 4
        case .gems: return 4
        case .silver: return 4
        case .gold: return 4
        case .pearls: return 4
        case .whales: return 4
        }
    }
    
    func basePropability() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .iron, .horses, .coal, .oil, .aluminium, .uranium, .niter: return 100
            
        case .marble, .furs, .citrus, .tea, .sugar, .wine, .incense, .cotton, .silk, .spices, .dyes, .ivory, .fish, .wheat, .rice, .deer, .sheep, .copper, .stone, .bananas, .cattle, .gems, .silver, .gold, .pearls, .whales: return 50
        }
    }
    
    func propability() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .iron, .horses, .coal, .oil, .aluminium, .uranium, .niter: return 10
            
        case .marble, .furs, .citrus, .tea, .sugar, .wine, .incense, .cotton, .silk, .spices, .dyes, .ivory, .fish, .wheat, .rice, .deer, .sheep, .copper, .stone, .bananas, .cattle, .gems, .silver, .gold, .pearls, .whales: return 25
        }
    }
    
    func tilesPerPossible() -> Int {
        
        if self == .wheat || self == .cattle {
            return 5
        }
        
        if self == .bananas  {
            return 6
        }
        
        if self == .sheep  {
            return 8
        }
        
        if self == .deer  {
            return 9
        }
        
        if self == .fish  {
            return 12
        }
        
        return 0
    }
    
    // used for upscaling
    func playerScale()  -> Int {
        
        switch self {
            
            // stractegic
        case .horses: return 75
        case .iron: return 100
        case .coal: return 75
        case .oil: return 100
        case .aluminium: return 75
        case .uranium: return 75
        case .niter: return 75
            
        default:
            return 0
        }
    }
}
