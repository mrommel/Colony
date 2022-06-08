//
//  DistrictType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
public enum DistrictType: Int, Codable {

    case none

    case cityCenter
    case campus
    case theatherSquare
    case holySite
    case encampment
    case harbor
    case commercialHub
    case industrialZone
    case preserve
    case entertainmentComplex
    case waterPark
    case aqueduct
    case neighborhood
    // canal
    // dam
    // areodrome
    case spaceport
    case governmentPlaza
    // case diplomaticQuarter

    public static let defaultFlavorValue = 5

    public static var all: [DistrictType] {
        return [
            .cityCenter,
            .campus,
            .theatherSquare,
            .holySite,
            .encampment,
            .harbor,
            .commercialHub,
            .industrialZone,
            .preserve,
            .entertainmentComplex,
            .waterPark,
            .aqueduct,
            .neighborhood,
            // canal
            // dam
            // areodrome
            .spaceport,
            .governmentPlaza
            // .diplomaticQuarter,
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func isSpecialty() -> Bool {

        return self.data().specialty
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    // in production units
    public func productionCost() -> Int {

        return self.data().productionCost
    }

    // in gold
    public func maintenanceCost() -> Int {

        return self.data().maintenanceCost
    }

    public func requiredTech() -> TechType? {

        return self.data().requiredTech
    }

    public func requiredCivic() -> CivicType? {

        return self.data().requiredCivic
    }

    public func domesticTradeYields() -> Yields {

        return self.data().domesticTradeYields
    }

    public func foreignTradeYields() -> Yields {

        return self.data().foreignTradeYields
    }

    public func oncePerCivilization() -> Bool {

        return self.data().oncePerCivilization
    }

    // MARK: private methods / classes

    private class DistrictTypeData {

        let name: String
        let specialty: Bool
        let effects: [String]
        let productionCost: Int
        let maintenanceCost: Int // in gold
        let requiredTech: TechType?
        let requiredCivic: CivicType?

        let domesticTradeYields: Yields
        let foreignTradeYields: Yields

        let flavours: [Flavor]
        let oncePerCivilization: Bool

        init(
            name: String,
            specialty: Bool,
            effects: [String],
            productionCost: Int,
            maintenanceCost: Int,
            requiredTech: TechType?,
            requiredCivic: CivicType?,
            domesticTradeYields: Yields,
            foreignTradeYields: Yields,
            flavours: [Flavor],
            oncePerCivilization: Bool = false) {

                self.name = name
                self.specialty = specialty
                self.effects = effects
                self.productionCost = productionCost
                self.maintenanceCost = maintenanceCost
                self.requiredTech = requiredTech
                self.requiredCivic = requiredCivic

                self.domesticTradeYields = domesticTradeYields
                self.foreignTradeYields = foreignTradeYields

                self.flavours = flavours
                self.oncePerCivilization = oncePerCivilization
        }
    }

    // swiftlint:disable line_length
    private func data() -> DistrictTypeData {

        switch self {

        case .none:
            return DistrictTypeData(
                name: "",
                specialty: false,
                effects: [],
                productionCost: -1,
                maintenanceCost: -1,
                requiredTech: nil,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: []
            )

        case .cityCenter:
            // https://civilization.fandom.com/wiki/City_Center_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_CITY_CENTER_TITLE",
                specialty: false,
                effects: [
                    "TXT_KEY_DISTRICT_CITY_CENTER_EFFECT1"
                ],
                productionCost: 0,
                maintenanceCost: 0,
                requiredTech: nil,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                flavours: [
                    Flavor(type: .cityDefense, value: 7)
                ]
            )

        case .campus:
            // https://civilization.fandom.com/wiki/Campus_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_CAMPUS_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_CAMPUS_EFFECT1",
                    "TXT_KEY_DISTRICT_CAMPUS_EFFECT2",
                    "TXT_KEY_DISTRICT_CAMPUS_EFFECT3",
                    "TXT_KEY_DISTRICT_CAMPUS_EFFECT4",
                    "TXT_KEY_DISTRICT_CAMPUS_EFFECT5",
                    "TXT_KEY_DISTRICT_CAMPUS_EFFECT6"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: .writing,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0, science: 1.0),
                flavours: [
                    Flavor(type: .science, value: 8)
                ]
            )

        case .theatherSquare:
            // https://civilization.fandom.com/wiki/Theater_Square_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_THEATER_SQUARE_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT1",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT2",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT3",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT4",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT5",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT6",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT7",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT8",
                    "TXT_KEY_DISTRICT_THEATER_SQUARE_EFFECT9"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .dramaAndPoetry,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .culture, value: 6),
                    Flavor(type: .greatPeople, value: 4)
                ]
            )

        case .holySite:
            // https://civilization.fandom.com/wiki/Holy_Site_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_HOLY_SITE_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT1",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT2",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT3",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT4",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT5",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT6",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT7",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT8",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT9",
                    "TXT_KEY_DISTRICT_HOLY_SITE_EFFECT10"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: .astrology,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 1.0),
                flavours: [
                    Flavor(type: .religion, value: 7)
                ]
            )

        case .encampment:
            // https://civilization.fandom.com/wiki/Encampment_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_ENCAMPMENT_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT1",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT2",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT3",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT4",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT5",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT6",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT7",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT8",
                    "TXT_KEY_DISTRICT_ENCAMPMENT_EFFECT9"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .bronzeWorking,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                flavours: [
                    Flavor(type: .militaryTraining, value: 7),
                    Flavor(type: .cityDefense, value: 3)
                ]
            )

        case .harbor:
            // https://civilization.fandom.com/wiki/Harbor_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_HARBOR_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT1",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT2",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT3",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT4",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT5",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT6",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT7",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT8",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT9",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT10",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT11",
                    "TXT_KEY_DISTRICT_HARBOR_EFFECT12"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .celestialNavigation,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                flavours: [
                    Flavor(type: .naval, value: 3),
                    Flavor(type: .navalGrowth, value: 7)
                ]
            )

        case .entertainmentComplex:
            // https://civilization.fandom.com/wiki/Entertainment_Complex_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_ENTERTAINMENT_COMPLEX_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_ENTERTAINMENT_COMPLEX_EFFECT1",
                    "TXT_KEY_DISTRICT_ENTERTAINMENT_COMPLEX_EFFECT2",
                    "TXT_KEY_DISTRICT_ENTERTAINMENT_COMPLEX_EFFECT3",
                    "TXT_KEY_DISTRICT_ENTERTAINMENT_COMPLEX_EFFECT4",
                    "TXT_KEY_DISTRICT_ENTERTAINMENT_COMPLEX_EFFECT5"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .gamesAndRecreation,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .amenities, value: 7)
                ]
            )

        case .waterPark:
            // https://civilization.fandom.com/wiki/Water_Park_(Civ6)?so=search
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_WATER_PARK_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_WATER_PARK_EFFECT1",
                    "TXT_KEY_DISTRICT_WATER_PARK_EFFECT2",
                    "TXT_KEY_DISTRICT_WATER_PARK_EFFECT3"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .naturalHistory,
                domesticTradeYields: Yields(food: 1, production: 0, gold: 0),
                foreignTradeYields: Yields(food: 1, production: 0, gold: 0),
                flavours: [
                    Flavor(type: .amenities, value: 7)
                ]
            )

        case .commercialHub:
            // https://civilization.fandom.com/wiki/Commercial_Hub_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_COMMERCIAL_HUB_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_COMMERCIAL_HUB_EFFECT1",
                    "TXT_KEY_DISTRICT_COMMERCIAL_HUB_EFFECT2",
                    "TXT_KEY_DISTRICT_COMMERCIAL_HUB_EFFECT3",
                    "TXT_KEY_DISTRICT_COMMERCIAL_HUB_EFFECT4",
                    "TXT_KEY_DISTRICT_COMMERCIAL_HUB_EFFECT5"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .currency,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                flavours: [
                    Flavor(type: .gold, value: 7)
                ]
            )

        case .industrialZone:
            // https://civilization.fandom.com/wiki/Industrial_Zone_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_INDUSTRIAL_ZONE_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_INDUSTRIAL_ZONE_EFFECT1",
                    "TXT_KEY_DISTRICT_INDUSTRIAL_ZONE_EFFECT2",
                    "TXT_KEY_DISTRICT_INDUSTRIAL_ZONE_EFFECT3",
                    "TXT_KEY_DISTRICT_INDUSTRIAL_ZONE_EFFECT4",
                    "TXT_KEY_DISTRICT_INDUSTRIAL_ZONE_EFFECT5",
                    "TXT_KEY_DISTRICT_INDUSTRIAL_ZONE_EFFECT6"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .apprenticeship,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                flavours: [
                    Flavor(type: .production, value: 9)
                ]
            )

        case .preserve:
            // https://civilization.fandom.com/wiki/Preserve_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_PRESERVE_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_PRESERVE_EFFECT1",
                    "TXT_KEY_DISTRICT_PRESERVE_EFFECT2",
                    "TXT_KEY_DISTRICT_PRESERVE_EFFECT3"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: nil,
                requiredCivic: .mysticism,
                domesticTradeYields: Yields(food: 0, production: 0, gold: 0),
                foreignTradeYields: Yields(food: 0, production: 0, gold: 0),
                flavours: [
                    Flavor(type: .culture, value: 6)
                ]
            )

            // waterPark

        case .aqueduct:
            // https://civilization.fandom.com/wiki/Aqueduct_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_AQUEDUCT_TITLE",
                specialty: false,
                effects: [
                    "TXT_KEY_DISTRICT_AQUEDUCT_EFFECT1",
                    "TXT_KEY_DISTRICT_AQUEDUCT_EFFECT2",
                    "TXT_KEY_DISTRICT_AQUEDUCT_EFFECT3",
                    "TXT_KEY_DISTRICT_AQUEDUCT_EFFECT4",
                    "TXT_KEY_DISTRICT_AQUEDUCT_EFFECT5",
                    "TXT_KEY_DISTRICT_AQUEDUCT_EFFECT6"
                ],
                productionCost: 36,
                maintenanceCost: 0,
                requiredTech: .engineering,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .tileImprovement, value: 7),
                    Flavor(type: .growth, value: 2)
                ]
            )

        case .neighborhood:
            // https://civilization.fandom.com/wiki/Neighborhood_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_NEIGHBORHOOD_TITLE",
                specialty: false,
                effects: [
                    "TXT_KEY_DISTRICT_NEIGHBORHOOD_EFFECT1"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: nil,
                requiredCivic: .urbanization,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .expansion, value: 3)
                ]
            )

            // canal
            // dam
            // areodrome

        case .spaceport:
            // https://civilization.fandom.com/wiki/Spaceport_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_SPACEPORT_TITLE",
                specialty: false,
                effects: [
                    "TXT_KEY_DISTRICT_SPACEPORT_EFFECT1"
                ],
                productionCost: 1800,
                maintenanceCost: 0,
                requiredTech: .rocketry,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .science, value: 7)
                ]
            )

        case .governmentPlaza:
            // https://civilization.fandom.com/wiki/Government_Plaza_(Civ6)
            return DistrictTypeData(
                name: "TXT_KEY_DISTRICT_GOVERNMENT_PLAZA_TITLE",
                specialty: true,
                effects: [
                    "TXT_KEY_DISTRICT_GOVERNMENT_PLAZA_EFFECT1",
                    "TXT_KEY_DISTRICT_GOVERNMENT_PLAZA_EFFECT2",
                    "TXT_KEY_DISTRICT_GOVERNMENT_PLAZA_EFFECT3"
                ],
                productionCost: 30,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .stateWorkforce,
                domesticTradeYields: Yields(food: 1, production: 1, gold: 0),
                foreignTradeYields: Yields(food: 0, production: 0, gold: 2),
                flavours: [
                    Flavor(type: .diplomacy, value: 8)
                ],
                oncePerCivilization: true
            )
        }
    }

    func canBuild(on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        // Districts and wonders (except for Machu Picchu) cannot be placed on Mountains tiles.
        if tile.has(feature: .mountains) {
            return false
        }

        // natural wonders cant be used for districts
        if tile.feature().isNaturalWonder() {
            return false
        }

        switch self {

        case .none: return false

        case .cityCenter: return true

        case .campus: return tile.isLand()
        case .theatherSquare: return tile.isLand()
        case .holySite: return tile.isLand()
        case .encampment: return tile.isLand()
        case .commercialHub: return tile.isLand()
        case .harbor: return tile.terrain() == .shore // must be built on water adjacent to land
        case .entertainmentComplex: return tile.isLand()
        case .industrialZone: return tile.isLand()
        case .waterPark: return tile.terrain() == .shore || tile.has(feature: .lake) // # must be built on a Coast or Lake tile adjacent to land.
        case .aqueduct: return self.canBuildAqueduct(on: tile.point, in: gameModel)
        case .neighborhood: return tile.isLand()
            // canal
            // dam
            // areodrome
        case .preserve: return self.canBuildPreserve(on: tile.point, in: gameModel) // Cannot be adjacent to the City Center
        case .spaceport: return tile.isLand() && !tile.hasHills()
        case .governmentPlaza: return tile.isLand()
        }
    }

    private func canBuildAqueduct(on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        // Must be built adjacent to both the City Center and one of the following: River, Lake, Oasis, or Mountain.
        var nextToCityCenter: Bool = false
        var nextToWaterSource: Bool = false

        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            if neighborTile.isRiver() || neighborTile.has(feature: .lake) ||
                neighborTile.has(feature: .oasis) || neighborTile.has(feature: .mountains) {

                nextToWaterSource = true
            }

            if tile.workingCity()?.location == neighbor {
                nextToCityCenter = true
            }
        }

        return nextToCityCenter && nextToWaterSource
    }

    // Cannot be adjacent to the City Center
    func canBuildPreserve(on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        for neighbor in point.neighbors() {

            guard gameModel.city(at: neighbor) == nil else {
                return false
            }
        }

        return tile.isLand()
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let flavor = self.flavours().first(where: { $0.type == flavorType }) {
            return flavor.value
        }

        return DistrictType.defaultFlavorValue
    }

    private func flavours() -> [Flavor] {

        return self.data().flavours
    }
}
