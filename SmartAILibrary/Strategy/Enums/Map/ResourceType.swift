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
    case salt // https://civilization.fandom.com/wiki/Salt_(Civ6)
    case crab // https://civilization.fandom.com/wiki/Crabs_(Civ6)
    case cocoa // https://civilization.fandom.com/wiki/Cocoa_(Civ6)

    // strategic
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
            .wheat, .rice, .deer, .sheep, .copper, .stone, .bananas, .cattle, .fish, .crab,

            // luxury
            .marble, .gems, .furs, .citrus, tea, .whales, .pearls, .ivory, .wine, .cotton, .dyes, .incense, .silk, .silver, .gold, .spices, .salt, .cocoa, .sugar,

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
        case .crab: return "Crab"
        case .salt: return "Salt"
        case .cocoa: return "Cocoa"

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

        case .wheat, .rice, .sheep, .deer, .copper, .stone, .bananas, .cattle, .fish, .crab:
            return .bonus

        case .gems, .marble, .furs, .citrus, .tea, .sugar, .whales, .pearls, .ivory, .wine, .cotton, .dyes, .incense, .silk, .silver, .gold, .spices, .salt, .cocoa:
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
        case .crab: return Yields(food: 0, production: 0, gold: 2, science: 0)

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
        case .salt: return Yields(food: 1, production: 0, gold: 1, science: 0)
        case .cocoa: return Yields(food: 1, production: 0, gold: 1, science: 0)

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

        case .bananas, .citrus, .tea, .sugar, .spices, .wine, .cotton, .dyes, .incense, .silk, .cocoa:
            return .plantation

        case .deer, .furs, .ivory:
            return .camp

        case .fish, .whales, .pearls, .crab:
            return .fishingBoats

        case .gems, .iron, .copper, .coal, .aluminium, .uranium, .niter, .gold, .silver, .salt:
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
        case .crab:
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
        case .cotton: return [
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
        case .salt: return [
                Flavor(type: .happiness, value: 10)
            ]
        case .cocoa: return [
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
        case .crab: return 4
        case .salt: return 4
        case .cocoa: return 4

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
        case .crab: return []
        case .salt: return []
        case .cocoa: return []

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

        return self.data().revealTech
    }

    private struct FeatureData {

        let name: String
        let revealTech: TechType?

        // placement
        let placementOrder: Int
        let placementBaseAmount: Int
        let placedOnHills: Bool
        let placedOnRiverSide: Bool
        let placedOnFlatlands: Bool
        let placedOnFeatures: [FeatureType]
        let placedOnFeatureTerrains: [TerrainType]
        let placedOnTerrains: [TerrainType]
    }

    private func data() -> FeatureData {

        switch self {

        case .none:
            return FeatureData(name: "None",
                               revealTech: nil,
                               placementOrder: -1,
                               placementBaseAmount: 0,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [])

            // bonus
        case .wheat:
            return FeatureData(name: "Wheat",
                               revealTech: .pottery,
                               placementOrder: 4,
                               placementBaseAmount: 18,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.floodplains],
                               placedOnFeatureTerrains: [.desert],
                               placedOnTerrains: [.plains])
        case .rice:
            return FeatureData(name: "Rice",
                               revealTech: .pottery,
                               placementOrder: 4,
                               placementBaseAmount: 14,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.marsh],
                               placedOnFeatureTerrains: [.grass],
                               placedOnTerrains: [.grass])
        case .deer:
            return FeatureData(name: "Deer",
                               revealTech: .animalHusbandry,
                               placementOrder: 4,
                               placementBaseAmount: 16,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.forest],
                               placedOnFeatureTerrains: [.grass, .plains, .tundra, .snow],
                               placedOnTerrains: [.tundra])
        case .sheep:
            return FeatureData(name: "Sheep",
                               revealTech: .animalHusbandry,
                               placementOrder: 4,
                               placementBaseAmount: 20,
                               placedOnHills: true,
                               placedOnRiverSide: true,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains, .desert])
        case .copper:
            return FeatureData(name: "Copper",
                               revealTech: .mining,
                               placementOrder: 4,
                               placementBaseAmount: 6,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains, .desert, .tundra])
        case .stone:
            return FeatureData(name: "Stone",
                               revealTech: .mining,
                               placementOrder: 4,
                               placementBaseAmount: 12,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass])
        case .bananas:
            return FeatureData(name: "Bananas",
                               revealTech: .irrigation,
                               placementOrder: 4,
                               placementBaseAmount: 2,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.rainforest],
                               placedOnFeatureTerrains: [.grass, .plains],
                               placedOnTerrains: []) // only on rainforest feature
        case .cattle:
            return FeatureData(name: "Cattle",
                               revealTech: .animalHusbandry,
                               placementOrder: 4,
                               placementBaseAmount: 22,
                               placedOnHills: false,
                               placedOnRiverSide: true,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass])
        case .fish:
            return FeatureData(name: "Fish",
                               revealTech: .celestialNavigation,
                               placementOrder: 4,
                               placementBaseAmount: 36,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [.reef, .lake],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.shore])
        case .crab:
            return FeatureData(name: "Crab",
                               revealTech: .sailing,
                               placementOrder: 4,
                               placementBaseAmount: 8,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.shore])

            // luxury
        case .gems:
            return FeatureData(name: "Gems",
                               revealTech: .mining,
                               placementOrder: 3,
                               placementBaseAmount: 6,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [.rainforest],
                               placedOnFeatureTerrains: [.grass, .plains],
                               placedOnTerrains: [.grass, .plains, .desert, .tundra])
        case .marble:
            return FeatureData(name: "Marble",
                               revealTech: .mining,
                               placementOrder: 3,
                               placementBaseAmount: 6,
                               placedOnHills: true,
                               placedOnRiverSide: true,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains])
        case .furs:
            return FeatureData(name: "Furs",
                               revealTech: .animalHusbandry,
                               placementOrder: 3,
                               placementBaseAmount: 12,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.forest],
                               placedOnFeatureTerrains: [.grass, .plains, .tundra, .snow],
                               placedOnTerrains: [.tundra])
        case .citrus:
            return FeatureData(name: "Citrus",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 2,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains])
        case .tea:
            return FeatureData(name: "Tea",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 2,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass])
        case .sugar:
            return FeatureData(name: "Sugar",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 1,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.floodplains, .marsh],
                               placedOnFeatureTerrains: [.grass, .plains, .desert],
                               placedOnTerrains: []) // only on rainforest feature
        case .whales:
            return FeatureData(name: "Whales",
                               revealTech: .sailing,
                               placementOrder: 3,
                               placementBaseAmount: 6,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.shore])
        case .pearls:
            return FeatureData(name: "Pearls",
                               revealTech: .sailing,
                               placementOrder: 3,
                               placementBaseAmount: 6,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.shore])
        case .wine:
            return FeatureData(name: "Wine",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 12,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains])
        case .cotton:
            return FeatureData(name: "Cotton",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 1,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains])
        case .dyes:
            return FeatureData(name: "Dyes",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 2,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.rainforest, .forest],
                               placedOnFeatureTerrains: [.grass, .plains],
                               placedOnTerrains: [.grass, .plains]) // only on rainforest
        case .incense:
            return FeatureData(name: "Incense",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 4,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.plains, .desert])
        case .silk:
            return FeatureData(name: "Silk",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 1,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.forest],
                               placedOnFeatureTerrains: [.grass, .plains],
                               placedOnTerrains: [.grass, .plains]) // only on forest
        case .silver:
            return FeatureData(name: "Silver",
                               revealTech: .mining,
                               placementOrder: 3,
                               placementBaseAmount: 10,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.desert, .tundra])
        case .gold:
            return FeatureData(name: "Gold",
                               revealTech: .mining,
                               placementOrder: 3,
                               placementBaseAmount: 6,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains, .desert])
        case .spices:
            return FeatureData(name: "Spices",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 4,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.rainforest],
                               placedOnFeatureTerrains: [.grass, .plains],
                               placedOnTerrains: [.grass, .plains]) // only on rainforest
        case .ivory:
            return FeatureData(name: "Ivory",
                               revealTech: .animalHusbandry,
                               placementOrder: 3,
                               placementBaseAmount: 4,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.plains, .desert])
        case .salt:
            return FeatureData(name: "Salt",
                               revealTech: .mining,
                               placementOrder: 3,
                               placementBaseAmount: 2,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.plains, .desert, .tundra])
        case .cocoa:
            return FeatureData(name: "Cocoa",
                               revealTech: .irrigation,
                               placementOrder: 3,
                               placementBaseAmount: 2,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.rainforest],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains]) // only on rainforest

            // strategic
        case .iron:
            return FeatureData(name: "Iron",
                               revealTech: .bronzeWorking,
                               placementOrder: 0,
                               placementBaseAmount: 12,
                               placedOnHills: false,
                               placedOnRiverSide: true,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains, .desert, .tundra, .snow])
        case .horses:
            return FeatureData(name: "Horses",
                               revealTech: .animalHusbandry,
                               placementOrder: 1,
                               placementBaseAmount: 14,
                               placedOnHills: false,
                               placedOnRiverSide: true,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains, .tundra])
        case .coal:
            return FeatureData(name: "Coal",
                               revealTech: .industrialization,
                               placementOrder: 2,
                               placementBaseAmount: 10,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains])
        case .aluminium:
            return FeatureData(name: "Aluminium",
                               revealTech: .radio,
                               placementOrder: 2,
                               placementBaseAmount: 8,
                               placedOnHills: true,
                               placedOnRiverSide: false,
                               placedOnFlatlands: false,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [.plains],
                               placedOnTerrains: [.plains, .desert])
        case .uranium:
            return FeatureData(name: "Uranium",
                               revealTech: .combinedArms,
                               placementOrder: 2,
                               placementBaseAmount: 4,
                               placedOnHills: false,
                               placedOnRiverSide: true,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.rainforest, .marsh, .forest],
                               placedOnFeatureTerrains: [.grass, .plains, .desert, .tundra, .snow],
                               placedOnTerrains: [.grass, .plains, .desert, .tundra, .snow])
        case .niter:
            return FeatureData(name: "Niter",
                               revealTech: .militaryEngineering,
                               placementOrder: 2,
                               placementBaseAmount: 8,
                               placedOnHills: false,
                               placedOnRiverSide: false,
                               placedOnFlatlands: true,
                               placedOnFeatures: [],
                               placedOnFeatureTerrains: [],
                               placedOnTerrains: [.grass, .plains, .desert, .tundra])
        case .oil:
            return FeatureData(name: "Oil",
                               revealTech: .refining,
                               placementOrder: 2,
                               placementBaseAmount: 8,
                               placedOnHills: false,
                               placedOnRiverSide: true,
                               placedOnFlatlands: true,
                               placedOnFeatures: [.rainforest, .marsh],
                               placedOnFeatureTerrains: [.grass, .plains],
                               placedOnTerrains: [.desert, .tundra, .snow, .shore])
        }
    }

    func placedOnHills() -> Bool {

        return self.data().placedOnHills
    }

    func placedOnRiverSide() -> Bool {

        return self.data().placedOnRiverSide
    }

    func isFlatlands() -> Bool {

        return self.data().placedOnFlatlands
    }

    func placedOn(feature: FeatureType) -> Bool {

        return self.data().placedOnFeatures.contains(feature)
    }

    func placedOn(featureTerrain: TerrainType) -> Bool {

        return self.data().placedOnFeatureTerrains.contains(featureTerrain)
    }

    // only checked if no feature
    func placedOn(terrain: TerrainType) -> Bool {

        return self.data().placedOnTerrains.contains(terrain)
    }

    func placementOrder() -> Int {

        return self.data().placementOrder
    }

    // for standard map size
    func baseAmount() -> Int {
        
        return self.data().placementBaseAmount
    }

    func absoluteVarPercent() -> Int {

        if self == .fish {
            return 10
        }
        
        return 25
    }
}
