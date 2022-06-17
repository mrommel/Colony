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
    case artifact

    func aminities() -> Int {

        switch self {

        case .bonus: return 0
        case .strategic: return 0
        case .luxury: return 4
        case .artifact: return 0
        }
    }
}

// swiftlint:disable type_body_length
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

    /* .coffee, .tobacco, .olives */

    // strategic
    case horses
    case iron // https://civilization.fandom.com/wiki/Iron_(Civ6)
    case coal // https://civilization.fandom.com/wiki/Coal_(Civ6)
    case oil // https://civilization.fandom.com/wiki/Oil_(Civ6)
    case aluminum // https://civilization.fandom.com/wiki/Aluminum_(Civ6)
    case uranium // https://civilization.fandom.com/wiki/Uranium_(Civ6)
    case niter

    // artifacts
    case antiquitySite // https://civilization.fandom.com/wiki/Antiquity_Site_(Civ6)
    case shipwreck // https://civilization.fandom.com/wiki/Shipwreck_(Civ6)

    public static var all: [ResourceType] {
        return [
            // bonus
            .wheat, .rice, .deer, .sheep, .copper, .stone, .bananas, .cattle, .fish, .crab,

            // luxury
            .marble, .gems, .furs, .citrus, tea, .whales, .pearls, .ivory, .wine, .cotton, .dyes, .incense, .silk, .silver,
                .gold, .spices, .salt, .cocoa, .sugar,

            // strategic
            .horses, .iron, .coal, .oil, .aluminum, .uranium, .niter,

            // artifacts
            .antiquitySite, .shipwreck
        ]
    }

    public static var strategic: [ResourceType] {
        return [
            // strategic
            .horses, .iron, .coal, .oil, .aluminum, .uranium, .niter
        ]
    }

    // MARK: methods

    public func name() -> String {

        return self.data().name
    }

    func usage() -> ResourceUsageType {

        return self.data().usage
    }

    public func yields() -> Yields {

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
        case .aluminum: return Yields(food: 0, production: 0, gold: 0, science: 1)
        case .uranium: return Yields(food: 0, production: 2, gold: 0, science: 0)
        case .niter: return Yields(food: 1, production: 1, gold: 0, science: 0)

            // artifacts
        case .antiquitySite: return Yields(food: 0, production: 0, gold: 0)
        case .shipwreck: return Yields(food: 0, production: 0, gold: 0)
        }
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavors().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return DistrictType.defaultFlavorValue
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
                Flavor(type: .amenities, value: 10)
            ]
        case .marble:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .furs:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .citrus:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .tea:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .sugar:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .whales:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .pearls:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .ivory:
            return [
                Flavor(type: .amenities, value: 10)
            ]
        case .wine: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .cotton: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .dyes: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .incense: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .silk: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .silver: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .gold: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .spices: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .salt: return [
                Flavor(type: .amenities, value: 10)
            ]
        case .cocoa: return [
                Flavor(type: .amenities, value: 10)
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
        case .aluminum:
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

            // artifacts
        case .antiquitySite: return []
        case .shipwreck: return []
        }
    }

    func amenities() -> Int {

        return self.data().usage.aminities()
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
        case .aluminum: return [2, 6]
        case .uranium: return [2, 6]
        case .niter: return [2, 6]

            // artifacts
        case .antiquitySite: return []
        case .shipwreck: return []
        }
    }

    func revealTech() -> TechType? {

        return self.data().revealTech
    }

    func revealCivic() -> CivicType? {

        return self.data().revealCivic
    }

    // MARK: private methids / types

    private struct FeatureData {

        let name: String
        let usage: ResourceUsageType
        let revealTech: TechType?
        let revealCivic: CivicType?

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

    // swiftlint:disable function_body_length
    private func data() -> FeatureData {

        switch self {

        case .none:
            return FeatureData(
                name: "None",
                usage: .bonus,
                revealTech: nil,
                revealCivic: nil,
                placementOrder: -1,
                placementBaseAmount: 0,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: []
            )

            // bonus
        case .wheat:
            // https://civilization.fandom.com/wiki/Wheat_(Civ6)
            return FeatureData(
                name: "Wheat",
                usage: .bonus,
                revealTech: .pottery,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 18,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.floodplains],
                placedOnFeatureTerrains: [.desert],
                placedOnTerrains: [.plains]
            )

        case .rice:
            // https://civilization.fandom.com/wiki/Rice_(Civ6)
            return FeatureData(
                name: "Rice",
                usage: .bonus,
                revealTech: .pottery,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 14,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.marsh],
                placedOnFeatureTerrains: [.grass],
                placedOnTerrains: [.grass]
            )

        case .deer:
            // https://civilization.fandom.com/wiki/Deer_(Civ6)
            return FeatureData(
                name: "Deer",
                usage: .bonus,
                revealTech: .animalHusbandry,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 16,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.forest],
                placedOnFeatureTerrains: [.grass, .plains, .tundra, .snow],
                placedOnTerrains: [.tundra]
            )

        case .sheep:
            // https://civilization.fandom.com/wiki/Sheep_(Civ6)
            return FeatureData(
                name: "Sheep",
                usage: .bonus,
                revealTech: .animalHusbandry,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 20,
                placedOnHills: true,
                placedOnRiverSide: true,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains, .desert]
            )

        case .copper:
            // https://civilization.fandom.com/wiki/Copper_(Civ6)
            return FeatureData(
                name: "Copper",
                usage: .bonus,
                revealTech: .mining,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 6,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains, .desert, .tundra]
            )

        case .stone:
            // https://civilization.fandom.com/wiki/Stone_(Civ6)
            return FeatureData(
                name: "Stone",
                usage: .bonus,
                revealTech: .mining,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 12,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass]
            )

        case .bananas:
            // https://civilization.fandom.com/wiki/Bananas_(Civ6)
            return FeatureData(
                name: "Bananas",
                usage: .bonus,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 2,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.rainforest],
                placedOnFeatureTerrains: [.grass, .plains],
                placedOnTerrains: []
            )

        case .cattle:
            // https://civilization.fandom.com/wiki/Cattle_(Civ6)
            return FeatureData(
                name: "Cattle",
                usage: .bonus,
                revealTech: .animalHusbandry,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 22,
                placedOnHills: false,
                placedOnRiverSide: true,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass]
            )

        case .fish:
            // https://civilization.fandom.com/wiki/Fish_(Civ6)
            return FeatureData(
                name: "Fish",
                usage: .bonus,
                revealTech: .sailing,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 36,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [/*.reef,*/ .lake],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.shore]
            )

        case .crab:
            // https://civilization.fandom.com/wiki/Crabs_(Civ6)
            return FeatureData(
                name: "Crab",
                usage: .bonus,
                revealTech: .sailing,
                revealCivic: nil,
                placementOrder: 4,
                placementBaseAmount: 8,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.shore]
            )

            // luxury
        case .gems:
            // https://civilization.fandom.com/wiki/Diamonds_(Civ6)
            return FeatureData(
                name: "Gems",
                usage: .luxury,
                revealTech: .mining,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 6,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [.rainforest],
                placedOnFeatureTerrains: [.grass, .plains],
                placedOnTerrains: [.grass, .plains, .desert, .tundra]
            )

        case .marble:
            // https://civilization.fandom.com/wiki/Marble_(Civ6)
            return FeatureData(
                name: "Marble",
                usage: .luxury,
                revealTech: .mining,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 6,
                placedOnHills: true,
                placedOnRiverSide: true,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains]
            )

        case .furs:
            // https://civilization.fandom.com/wiki/Furs_(Civ6)
            return FeatureData(
                name: "Furs",
                usage: .luxury,
                revealTech: .animalHusbandry,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 12,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.forest],
                placedOnFeatureTerrains: [.grass, .plains, .tundra, .snow],
                placedOnTerrains: [.tundra]
            )

        case .citrus:
            // https://civilization.fandom.com/wiki/Citrus_(Civ6)
            return FeatureData(
                name: "Citrus",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 2,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains]
            )

        case .tea:
            // https://civilization.fandom.com/wiki/Tea_(Civ6)
            return FeatureData(
                name: "Tea",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 2,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass]
            )

        case .sugar:
            // https://civilization.fandom.com/wiki/Sugar_(Civ6)
            return FeatureData(
                name: "Sugar",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 1,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.floodplains, .marsh],  // only on rainforest feature
                placedOnFeatureTerrains: [.grass, .plains, .desert],
                placedOnTerrains: []
            )

        case .whales:
            // https://civilization.fandom.com/wiki/Whales_(Civ6)
            return FeatureData(
                name: "Whales",
                usage: .luxury,
                revealTech: .sailing,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 6,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.shore]
            )

        case .pearls:
            // https://civilization.fandom.com/wiki/Pearls_(Civ6)
            return FeatureData(
                name: "Pearls",
                usage: .luxury,
                revealTech: .sailing,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 6,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.shore]
            )

        case .wine:
            // https://civilization.fandom.com/wiki/Wine_(Civ6)
            return FeatureData(
                name: "Wine",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 12,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains]
            )

        case .cotton:
            // https://civilization.fandom.com/wiki/Cotton_(Civ6)
            return FeatureData(
                name: "Cotton",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 1,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains]
            )

        case .dyes:
            // https://civilization.fandom.com/wiki/Dyes_(Civ6)
            return FeatureData(
                name: "Dyes",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 2,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.rainforest, .forest], // only on rainforest
                placedOnFeatureTerrains: [.grass, .plains],
                placedOnTerrains: [.grass, .plains]
            )

        case .incense:
            // https://civilization.fandom.com/wiki/Incense_(Civ6)
            return FeatureData(
                name: "Incense",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 4,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.plains, .desert]
            )

        case .silk:
            // https://civilization.fandom.com/wiki/Silk_(Civ6)
            return FeatureData(
                name: "Silk",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 1,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.forest], // only on forest
                placedOnFeatureTerrains: [.grass, .plains],
                placedOnTerrains: [.grass, .plains]
            )

        case .silver:
            // https://civilization.fandom.com/wiki/Silver_(Civ6)
            return FeatureData(
                name: "Silver",
                usage: .luxury,
                revealTech: .mining,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 10,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.desert, .tundra]
            )

        case .gold:
            // https://civilization.fandom.com/wiki/Gold_Ore_(Civ6)
            return FeatureData(
                name: "Gold",
                usage: .luxury,
                revealTech: .mining,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 6,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains, .desert]
            )

        case .spices:
            // https://civilization.fandom.com/wiki/Spices_(Civ6)
            return FeatureData(
                name: "Spices",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 4,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.rainforest], // only on rainforest
                placedOnFeatureTerrains: [.grass, .plains],
                placedOnTerrains: [.grass, .plains]
            )

        case .ivory:
            // https://civilization.fandom.com/wiki/Ivory_(Civ6)
            return FeatureData(
                name: "Ivory",
                usage: .luxury,
                revealTech: .animalHusbandry,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 4,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.plains, .desert]
            )

        case .salt:
            // https://civilization.fandom.com/wiki/Salt_(Civ6)
            return FeatureData(
                name: "Salt",
                usage: .luxury,
                revealTech: .mining,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 2,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.plains, .desert, .tundra]
            )

        case .cocoa:
            // https://civilization.fandom.com/wiki/Cocoa_(Civ6)
            return FeatureData(
                name: "Cocoa",
                usage: .luxury,
                revealTech: .irrigation,
                revealCivic: nil,
                placementOrder: 3,
                placementBaseAmount: 2,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [.rainforest], // only on rainforest
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains]
            )

            // strategic
        case .iron:
            // https://civilization.fandom.com/wiki/Iron_(Civ6)
            return FeatureData(
                name: "Iron",
                usage: .strategic,
                revealTech: .bronzeWorking,
                revealCivic: nil,
                placementOrder: 0,
                placementBaseAmount: 12,
                placedOnHills: false,
                placedOnRiverSide: true,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains, .desert, .tundra, .snow]
            )

        case .horses:
            // https://civilization.fandom.com/wiki/Horses_(Civ6)
            return FeatureData(
                name: "Horses",
                usage: .strategic,
                revealTech: .animalHusbandry,
                revealCivic: nil,
                placementOrder: 1,
                placementBaseAmount: 14,
                placedOnHills: false,
                placedOnRiverSide: true,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains, .tundra]
            )

        case .coal:
            // https://civilization.fandom.com/wiki/Coal_(Civ6)
            return FeatureData(
                name: "Coal",
                usage: .strategic,
                revealTech: .industrialization,
                revealCivic: nil,
                placementOrder: 2,
                placementBaseAmount: 10,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains]
            )

        case .aluminum:
            // https://civilization.fandom.com/wiki/Aluminum_(Civ6)
            return FeatureData(
                name: "Aluminum",
                usage: .strategic,
                revealTech: .radio,
                revealCivic: nil,
                placementOrder: 2,
                placementBaseAmount: 8,
                placedOnHills: true,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [.plains],
                placedOnTerrains: [.plains, .desert]
            )

        case .uranium:
            // https://civilization.fandom.com/wiki/Uranium_(Civ6)
            return FeatureData(
                name: "Uranium",
                usage: .strategic,
                revealTech: .combinedArms,
                revealCivic: nil,
                placementOrder: 2,
                placementBaseAmount: 4,
                placedOnHills: false,
                placedOnRiverSide: true,
                placedOnFlatlands: true,
                placedOnFeatures: [.rainforest, .marsh, .forest],
                placedOnFeatureTerrains: [.grass, .plains, .desert, .tundra, .snow],
                placedOnTerrains: [.grass, .plains, .desert, .tundra, .snow]
            )

        case .niter:
            // https://civilization.fandom.com/wiki/Niter_(Civ6)
            return FeatureData(
                name: "Niter",
                usage: .strategic,
                revealTech: .militaryEngineering,
                revealCivic: nil,
                placementOrder: 2,
                placementBaseAmount: 8,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains, .desert, .tundra]
            )

        case .oil:
            // https://civilization.fandom.com/wiki/Oil_(Civ6)
            return FeatureData(
                name: "Oil",
                usage: .strategic,
                revealTech: .refining,
                revealCivic: nil,
                placementOrder: 2,
                placementBaseAmount: 8,
                placedOnHills: false,
                placedOnRiverSide: true,
                placedOnFlatlands: true,
                placedOnFeatures: [.rainforest, .marsh],
                placedOnFeatureTerrains: [.grass, .plains],
                placedOnTerrains: [.desert, .tundra, .snow, .shore]
            )

            // artifacts
        case .antiquitySite:
            // https://civilization.fandom.com/wiki/Antiquity_Site_(Civ6)
            return FeatureData(
                name: "Antiquity Site",
                usage: .artifact,
                revealTech: nil,
                revealCivic: .naturalHistory,
                placementOrder: 2,
                placementBaseAmount: 8,
                placedOnHills: true,
                placedOnRiverSide: true,
                placedOnFlatlands: true,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.grass, .plains, .desert, .tundra, .snow]
            )

        case .shipwreck:
            return FeatureData(
                name: "Shipwreck",
                usage: .artifact,
                revealTech: nil,
                revealCivic: .culturalHeritage,
                placementOrder: 2,
                placementBaseAmount: 8,
                placedOnHills: false,
                placedOnRiverSide: false,
                placedOnFlatlands: false,
                placedOnFeatures: [],
                placedOnFeatureTerrains: [],
                placedOnTerrains: [.shore, .ocean]
            )
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

    func happiness() -> Int {

        return self.usage() == .luxury ? 4 : 0
    }
}
