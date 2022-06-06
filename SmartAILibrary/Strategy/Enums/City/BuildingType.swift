//
//  BuildingType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
public enum BuildingType: Int, Codable {

    case none

    // ancient
    case ancientWalls
    case barracks
    case granary
    case grove // https://civilization.fandom.com/wiki/Grove_(Civ6)
    case library // https://civilization.fandom.com/wiki/Library_(Civ6)
    case monument // https://civilization.fandom.com/wiki/Monument_(Civ6)
    case palace
    case shrine
    case waterMill // https://civilization.fandom.com/wiki/Water_Mill_(Civ6)

    // classical
    case amphitheater // https://civilization.fandom.com/wiki/Amphitheater_(Civ6)
    case lighthouse // https://civilization.fandom.com/wiki/Lighthouse_(Civ6)
    case stable // https://civilization.fandom.com/wiki/Stable_(Civ6)
    case arena // https://civilization.fandom.com/wiki/Arena_(Civ6)
    case market // https://civilization.fandom.com/wiki/Market_(Civ6)
    case temple // https://civilization.fandom.com/wiki/Temple_(Civ6)
    case ancestralHall
    case audienceChamber
    case warlordsThrone

    // medieval
    case medievalWalls // https://civilization.fandom.com/wiki/Medieval_Walls_(Civ6)
    case workshop // https://civilization.fandom.com/wiki/Workshop_(Civ6)
    case armory // https://civilization.fandom.com/wiki/Armory_(Civ6)
    case foreignMinistry
    case grandMastersChapel
    case intelligenceAgency
    case university // https://civilization.fandom.com/wiki/University_(Civ6)

    // renaissance
    case renaissanceWalls // https://civilization.fandom.com/wiki/Renaissance_Walls_(Civ6)
    case shipyard // https://civilization.fandom.com/wiki/Shipyard_(Civ6)
    case bank // https://civilization.fandom.com/wiki/Bank_(Civ6)
    case artMuseum // https://civilization.fandom.com/wiki/Art_Museum_(Civ6)
    case archaeologicalMuseum // https://civilization.fandom.com/wiki/Archaeological_Museum_(Civ6)

    // industrial
    case aquarium // https://civilization.fandom.com/wiki/Aquarium_(Civ6)
    case coalPowerPlant // https://civilization.fandom.com/wiki/Coal_Power_Plant_(Civ6)
    case factory // https://civilization.fandom.com/wiki/Factory_(Civ6)
    case ferrisWheel // https://civilization.fandom.com/wiki/Ferris_Wheel_(Civ6)
    case militaryAcademy // https://civilization.fandom.com/wiki/Military_Academy_(Civ6)
    case sewer // https://civilization.fandom.com/wiki/Sewer_(Civ6)
    case stockExchange // https://civilization.fandom.com/wiki/Stock_Exchange_(Civ6)
    case zoo // https://civilization.fandom.com/wiki/Zoo_(Civ6)

    // modern
    // case broadcastCenter // https://civilization.fandom.com/wiki/Broadcast_Center_(Civ6)
    // case foodMarket // https://civilization.fandom.com/wiki/Food_Market_(Civ6)
    // case hangar // https://civilization.fandom.com/wiki/Hangar_(Civ6)
    // case hydroelectricDam // https://civilization.fandom.com/wiki/Hydroelectric_Dam_(Civ6)
    // case nationalHistoryMuseum // https://civilization.fandom.com/wiki/National_History_Museum_(Civ6)
    // case researchLab // https://civilization.fandom.com/wiki/Research_Lab_(Civ6)
    // case royalSociety https://civilization.fandom.com/wiki/Royal_Society_(Civ6)
    // case sanctuary // https://civilization.fandom.com/wiki/Sanctuary_(Civ6)
    // case seaport // https://civilization.fandom.com/wiki/Seaport_(Civ6)
    // case shoppingMall // https://civilization.fandom.com/wiki/Shopping_Mall_(Civ6)
    // case warDepartment // https://civilization.fandom.com/wiki/War_Department_(Civ6)

    // atomic
    // case airport // https://civilization.fandom.com/wiki/Airport_(Civ6)
    // case aquaticsCenter // https://civilization.fandom.com/wiki/Aquatics_Center_(Civ6)
    // case floodBarrier // https://civilization.fandom.com/wiki/Flood_Barrier_(Civ6)
    // case nuclearPowerPlant // https://civilization.fandom.com/wiki/Nuclear_Power_Plant_(Civ6)
    // case stadium // https://civilization.fandom.com/wiki/Stadium_(Civ6)

    // information
    // --

    public static var all: [BuildingType] {
        return [
            // ancient
            .ancientWalls, .barracks, .granary, .grove, .library, .monument,
                .palace, .shrine, .waterMill,

            // classical
            .amphitheater, .lighthouse, .stable, .arena, .market, .temple, .ancestralHall,
            .audienceChamber, .warlordsThrone,

            // medieval
            .medievalWalls, .workshop, .armory, .foreignMinistry, .grandMastersChapel,
                .intelligenceAgency, .university,

            // renaissance
            .renaissanceWalls, .shipyard, .bank, .artMuseum, .archaeologicalMuseum,

            // industrial
            .aquarium, .coalPowerPlant, .factory, .ferrisWheel, .militaryAcademy,
            .sewer, .stockExchange, .zoo

            // modern

            // atomic
        ]
    }

    // MARK: methods

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    public func era() -> EraType {

        return self.data().era
    }

    func defense() -> Int {

        return self.data().defense
    }

    /// cost in gold
    func purchaseCost() -> Int {

        return self.data().goldCost
    }

    /// cost in faith
    func faithCost() -> Int {

        return self.data().faithCost
    }

    // in production units
    public func productionCost() -> Int {

        return self.data().productionCost
    }

    // in gold
    func maintenanceCost() -> Int {

        return self.data().maintenanceCost
    }

    public func yields() -> Yields {

        return self.data().yields
    }

    public func amenities() -> Int {

        if self == .arena {
            return 1
        }

        return 0
    }

    public func requiredTech() -> TechType? {

        return self.data().requiredTech
    }

    public func requiredCivic() -> CivicType? {

        return self.data().requiredCivic
    }

    public func requiredBuildings() -> [BuildingType] {

        return self.data().requiredBuildingsOr
    }

    public func obsoleteBuildings() -> [BuildingType] {

        return self.data().obsoleteBuildingsOr
    }

    public func district() -> DistrictType {

        return self.data().district
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let flavor = self.flavours().first(where: { $0.type == flavorType }) {
            return flavor.value
        }

        return DistrictType.defaultFlavorValue
    }

    func flavours() -> [Flavor] {

        return self.data().flavours
    }

    func specialistCount() -> Int {

        if let specialSlots = self.data().specialSlots {
            return specialSlots.amount
        }

        return 0
    }

    func canAddSpecialist() -> Bool {

        return self.specialistCount() > 0
    }

    // check CIV5Buildings.xml
    func specialistType() -> SpecialistType {

        if let specialSlots = self.data().specialSlots {
            return specialSlots.type
        }

        return .none
    }

    func categoryType() -> BuildingCategoryType {

        return self.data().category
    }

    func slotsForGreatWork() -> [GreatWorkSlotType] {

        return self.data().slots
    }

    private struct SpecialistSlots {

        let type: SpecialistType
        let amount: Int
    }

    private struct BuildingTypeData {

        let name: String
        let effects: [String]
        let category: BuildingCategoryType
        let era: EraType
        let district: DistrictType
        let requiredTech: TechType?
        let requiredCivic: CivicType?
        let requiredBuildingsOr: [BuildingType] // means one of them is needed
        let requiredGovermentsOr: [GovernmentType] // means one of them is needed
        let obsoleteBuildingsOr: [BuildingType] // means one built will prevent this building
        let productionCost: Int
        let goldCost: Int
        let faithCost: Int
        let maintenanceCost: Int
        let yields: Yields
        let defense: Int
        let slots: [GreatWorkSlotType]
        let specialSlots: SpecialistSlots?
        let flavours: [Flavor]
    }

    // swiftlint:disable line_length
    // swiftlint:disable function_body_length
    private func data() -> BuildingTypeData {

        switch self {

        case .none:
            return BuildingTypeData(
                name: "",
                effects: [],
                category: .none,
                era: .none,
                district: .cityCenter,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 0,
                goldCost: -1,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: []
            )

            // ancient
            // ---------------------------------------------------

        case .ancientWalls:
            // https://civilization.fandom.com/wiki/Ancient_Walls_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_ANCIENT_WALL_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_ANCIENT_WALL_EFFECT0",
                    "TXT_KEY_BUILDING_ANCIENT_WALL_EFFECT1"
                ],
                category: .defensive,
                era: .ancient,
                district: .cityCenter,
                requiredTech: .masonry,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 80,
                goldCost: 80,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 50,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .militaryTraining, value: 7),
                    Flavor(type: .offense, value: 5),
                    Flavor(type: .defense, value: 5),
                    Flavor(type: .production, value: 2),
                    Flavor(type: .naval, value: 2),
                    Flavor(type: .tileImprovement, value: 2)
                ]
            )

        case .barracks:
            // https://civilization.fandom.com/wiki/Barracks_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_BARRACKS_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_BARRACKS_EFFECT0",
                    "TXT_KEY_BUILDING_BARRACKS_EFFECT1",
                    "TXT_KEY_BUILDING_BARRACKS_EFFECT2",
                    "TXT_KEY_BUILDING_BARRACKS_EFFECT3",
                    "TXT_KEY_BUILDING_BARRACKS_EFFECT4",
                    "TXT_KEY_BUILDING_BARRACKS_EFFECT5"
                ],
                category: .military,
                era: .ancient,
                district: .encampment,
                requiredTech: .bronzeWorking,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [.stable],
                productionCost: 90,
                goldCost: 90,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 1),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .commander, amount: 1),
                flavours: [
                    Flavor(type: .cityDefense, value: 8),
                    Flavor(type: .greatPeople, value: 5),
                    Flavor(type: .defense, value: 4),
                    Flavor(type: .wonder, value: 1),
                    Flavor(type: .production, value: 1)
                ]
            )

        case .granary:
            // https://civilization.fandom.com/wiki/Granary_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_GRANARY_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_GRANARY_EFFECT0",
                    "TXT_KEY_BUILDING_GRANARY_EFFECT1"
                ],
                category: .population,
                era: .ancient,
                district: .cityCenter,
                requiredTech: .pottery,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 65,
                goldCost: 65,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 1, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 2),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .growth, value: 10),
                    Flavor(type: .greatPeople, value: 3),
                    Flavor(type: .science, value: 4),
                    Flavor(type: .tileImprovement, value: 3),
                    Flavor(type: .gold, value: 2),
                    Flavor(type: .production, value: 3),
                    Flavor(type: .offense, value: 1),
                    Flavor(type: .defense, value: 1)
                ]
            )

        case .grove:
            // https://civilization.fandom.com/wiki/Grove_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_GROVE_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_GROVE_EFFECT0",
                    "TXT_KEY_BUILDING_GROVE_EFFECT1"
                ],
                category: .conservation,
                era: .ancient,
                district: .preserve,
                requiredTech: nil,
                requiredCivic: .mysticism,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 150,
                goldCost: 150,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .growth, value: 3),
                    Flavor(type: .religion, value: 5)
                ]
            )

        case .library:
            // https://civilization.fandom.com/wiki/Library_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_LIBRARY_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_LIBRARY_EFFECT0",
                    "TXT_KEY_BUILDING_LIBRARY_EFFECT1",
                    "TXT_KEY_BUILDING_LIBRARY_EFFECT2"
                ],
                category: .scientific,
                era: .ancient,
                district: .campus,
                requiredTech: .writing,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 90,
                goldCost: 90,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0, science: 2, culture: 0, faith: 0, housing: 0),
                defense: 0,
                slots: [.written, .written],
                specialSlots: SpecialistSlots(type: .scientist, amount: 1),
                flavours: [
                    Flavor(type: .science, value: 8),
                    Flavor(type: .greatPeople, value: 5),
                    Flavor(type: .offense, value: 3),
                    Flavor(type: .defense, value: 3)
                    /*, Flavor(type: .spaceShip, value: 2)*/
                ]
            )

        case .monument:
            // https://civilization.fandom.com/wiki/Monument_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_MONUMENT_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_MONUMENT_EFFECT0",
                    "TXT_KEY_BUILDING_MONUMENT_EFFECT1",
                    "TXT_KEY_BUILDING_MONUMENT_EFFECT2"
                ],
                category: .cultural,
                era: .ancient,
                district: .cityCenter,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 60,
                goldCost: 60,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    // Note: The Monument has so many flavors because culture leads to policies,
                    // which help with a number of things
                    Flavor(type: .culture, value: 7),
                    Flavor(type: .tourism, value: 3),
                    Flavor(type: .expansion, value: 2),
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .wonder, value: 1),
                    Flavor(type: .gold, value: 1),
                    Flavor(type: .greatPeople, value: 1),
                    Flavor(type: .production, value: 1),
                    Flavor(type: .amenities, value: 1),
                    Flavor(type: .science, value: 1),
                    Flavor(type: .diplomacy, value: 1),
                    Flavor(type: .offense, value: 1),
                    Flavor(type: .defense, value: 1),
                    Flavor(type: .cityDefense, value: 1),
                    Flavor(type: .naval, value: 1),
                    Flavor(type: .navalTileImprovement, value: 1),
                    Flavor(type: .religion, value: 1)
                ]
            )

        case .palace:
            // https://civilization.fandom.com/wiki/Palace_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_PALACE_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_PALACE_EFFECT0",
                    "TXT_KEY_BUILDING_PALACE_EFFECT1",
                    "TXT_KEY_BUILDING_PALACE_EFFECT2",
                    "TXT_KEY_BUILDING_PALACE_EFFECT3",
                    "TXT_KEY_BUILDING_PALACE_EFFECT4",
                    "TXT_KEY_BUILDING_PALACE_EFFECT5"
                ],
                category: .government,
                era: .ancient,
                district: .cityCenter,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 0,
                goldCost: -1,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 2, gold: 5, science: 2, culture: 1, faith: 0, housing: 1),
                defense: 25,
                slots: [.any],
                specialSlots: nil,
                flavours: []
            )

        case .shrine:
            // https://civilization.fandom.com/wiki/Shrine_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_SHRINE_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_SHRINE_EFFECT0",
                    "TXT_KEY_BUILDING_SHRINE_EFFECT1",
                    "TXT_KEY_BUILDING_SHRINE_EFFECT2",
                    "TXT_KEY_BUILDING_SHRINE_EFFECT3" // #
                ],
                category: .religious,
                era: .ancient,
                district: .holySite,
                requiredTech: .astrology,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 70,
                goldCost: 70,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 2, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .priest, amount: 1),
                flavours: [
                    Flavor(type: .religion, value: 9),
                    Flavor(type: .culture, value: 4),
                    Flavor(type: .gold, value: 3),
                    Flavor(type: .amenities, value: 3),
                    Flavor(type: .expansion, value: 2),
                    Flavor(type: .tourism, value: 2),
                    Flavor(type: .diplomacy, value: 1),
                    Flavor(type: .offense, value: 1),
                    Flavor(type: .defense, value: 1),
                    Flavor(type: .growth, value: 1)]
            ) // Note: The Shrine has a number of flavors because religion improves a variety of game aspects

        case .waterMill:
            // https://civilization.fandom.com/wiki/Water_Mill_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_WATER_MILL_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_WATER_MILL_EFFECT0",
                    "TXT_KEY_BUILDING_WATER_MILL_EFFECT1",
                    "TXT_KEY_BUILDING_WATER_MILL_EFFECT2" // #
                ],
                category: .military,
                era: .ancient,
                district: .cityCenter,
                requiredTech: .wheel,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 80,
                goldCost: 80,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 1, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .growth, value: 7),
                    Flavor(type: .science, value: 4),
                    Flavor(type: .tileImprovement, value: 3),
                    Flavor(type: .production, value: 3),
                    Flavor(type: .offense, value: 1),
                    Flavor(type: .defense, value: 1)
                ]
            )

            // --------------------------------------
            // classical

        case .amphitheater:
            // https://civilization.fandom.com/wiki/Amphitheater_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_AMPHITHEATER_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_AMPHITHEATER_EFFECT0",
                    "TXT_KEY_BUILDING_AMPHITHEATER_EFFECT1",
                    "TXT_KEY_BUILDING_AMPHITHEATER_EFFECT2",
                    "TXT_KEY_BUILDING_AMPHITHEATER_EFFECT3"
                ],
                category: .cultural,
                era: .classical,
                district: .entertainmentComplex,
                requiredTech: nil,
                requiredCivic: .dramaAndPoetry,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 150,
                goldCost: 150,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 0, housing: 0),
                defense: 0,
                slots: [.written, .written],
                specialSlots: SpecialistSlots(type: .artist, amount: 1),
                flavours: [
                    Flavor(type: .growth, value: 4),
                    Flavor(type: .culture, value: 8),
                    Flavor(type: .wonder, value: 1)
                ]
            )
        case .lighthouse:
            // https://civilization.fandom.com/wiki/Lighthouse_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_LIGHTHOUSE_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_LIGHTHOUSE_EFFECT0",
                    "TXT_KEY_BUILDING_LIGHTHOUSE_EFFECT1",
                    "TXT_KEY_BUILDING_LIGHTHOUSE_EFFECT2",
                    "TXT_KEY_BUILDING_LIGHTHOUSE_EFFECT3",
                    "TXT_KEY_BUILDING_LIGHTHOUSE_EFFECT4",
                    "TXT_KEY_BUILDING_LIGHTHOUSE_EFFECT5"
                ],
                category: .cultural,
                era: .classical,
                district: .harbor,
                requiredTech: .celestialNavigation,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 120,
                goldCost: 120,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 1, production: 0, gold: 1, science: 0, culture: 0, faith: 0, housing: 1),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .captain, amount: 1),
                flavours: [
                    Flavor(type: .growth, value: 7),
                    Flavor(type: .science, value: 4),
                    Flavor(type: .navalTileImprovement, value: 8),
                    Flavor(type: .gold, value: 3),
                    Flavor(type: .offense, value: 1),
                    Flavor(type: .defense, value: 1)
                ]
            )

        case .stable:
            // https://civilization.fandom.com/wiki/Stable_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_STABLE_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_STABLE_EFFECT0",
                    "TXT_KEY_BUILDING_STABLE_EFFECT1",
                    "TXT_KEY_BUILDING_STABLE_EFFECT2",
                    "TXT_KEY_BUILDING_STABLE_EFFECT3",
                    "TXT_KEY_BUILDING_STABLE_EFFECT4",
                    "TXT_KEY_BUILDING_STABLE_EFFECT5"
                ],
                category: .military,
                era: .classical,
                district: .encampment,
                requiredTech: .horsebackRiding,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [.barracks],
                productionCost: 120,
                goldCost: 120,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 1),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .commander, amount: 1),
                flavours: [
                    Flavor(type: .cityDefense, value: 6),
                    Flavor(type: .greatPeople, value: 5),
                    Flavor(type: .offense, value: 8),
                    Flavor(type: .defense, value: 4),
                    Flavor(type: .wonder, value: 1),
                    Flavor(type: .production, value: 1)
                ]
            )

        case .arena:
            // https://civilization.fandom.com/wiki/Arena_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_ARENA_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_ARENA_EFFECT0",
                    "TXT_KEY_BUILDING_ARENA_EFFECT1",
                    "TXT_KEY_BUILDING_ARENA_EFFECT2"
                ],
                category: .entertainment,
                era: .classical,
                district: .entertainmentComplex,
                requiredTech: nil,
                requiredCivic: .gamesAndRecreation,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 150,
                goldCost: 150,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 1, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .culture, value: 7),
                    Flavor(type: .tourism, value: 3),
                    Flavor(type: .expansion, value: 2),
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .wonder, value: 1),
                    Flavor(type: .gold, value: 1),
                    Flavor(type: .greatPeople, value: 1),
                    Flavor(type: .production, value: 1),
                    Flavor(type: .amenities, value: 1),
                    Flavor(type: .science, value: 1),
                    Flavor(type: .diplomacy, value: 1),
                    Flavor(type: .offense, value: 1),
                    Flavor(type: .defense, value: 1),
                    Flavor(type: .cityDefense, value: 1),
                    Flavor(type: .naval, value: 1),
                    Flavor(type: .navalTileImprovement, value: 1),
                    Flavor(type: .religion, value: 1)
                ]
            )

        case .market:
            // https://civilization.fandom.com/wiki/Market_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_MARKET_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_MARKET_EFFECT0",
                    "TXT_KEY_BUILDING_MARKET_EFFECT1",
                    "TXT_KEY_BUILDING_MARKET_EFFECT2"
                ],
                category: .economic,
                era: .classical,
                district: .commercialHub,
                requiredTech: .currency,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 120,
                goldCost: 120,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 3, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .merchant, amount: 1),
                flavours: [
                    Flavor(type: .cityDefense, value: 2),
                    Flavor(type: .greatPeople, value: 5),
                    Flavor(type: .gold, value: 8),
                    Flavor(type: .offense, value: 1),
                    Flavor(type: .defense, value: 1),
                    Flavor(type: .wonder, value: 1),
                    Flavor(type: .production, value: 1)
                ]
            )

        case .temple:
            // https://civilization.fandom.com/wiki/Temple_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_TEMPLE_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_TEMPLE_EFFECT0",
                    "TXT_KEY_BUILDING_TEMPLE_EFFECT1",
                    "TXT_KEY_BUILDING_TEMPLE_EFFECT2",
                    "TXT_KEY_BUILDING_TEMPLE_EFFECT3",
                    "TXT_KEY_BUILDING_TEMPLE_EFFECT4"
                ],
                category: .religious,
                era: .classical,
                district: .holySite,
                requiredTech: nil,
                requiredCivic: .theology,
                requiredBuildingsOr: [.shrine],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 120,
                goldCost: 120,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 4, housing: 0),
                defense: 0,
                slots: [.relic],
                specialSlots: SpecialistSlots(type: .priest, amount: 1),
                flavours: [
                    Flavor(type: .greatPeople, value: 5),
                    Flavor(type: .religion, value: 10)
                ]
            )

        case .ancestralHall:
            // https://civilization.fandom.com/wiki/Ancestral_Hall_(Civ6)
            return BuildingTypeData(
                name: "Ancestral Hall",
                effects: [
                    "50% increased [Production] Production toward Settlers in this city", // #
                    "New cities receive a free Builder", // #
                    "Awards +1 [Governor] Governor Title" // #
                ],
                category: .government,
                era: .classical,
                district: .governmentPlaza,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [.autocracy, .classicalRepublic, .oligarchy],
                obsoleteBuildingsOr: [.audienceChamber, .warlordsThrone],
                productionCost: 150,
                goldCost: 150,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .tileImprovement, value: 4)
                ]
            )

        case .audienceChamber:
            // https://civilization.fandom.com/wiki/Audience_Chamber_(Civ6)
            return BuildingTypeData(
                name: "Audience Chamber",
                effects: [
                    "+2 [Amenities] Amenities and +4 [Housing] Housing in Cities with Governors.", // #
                    "-2 Loyalty in Cities without Governors.", // #
                    "Awards +1 [Governor] Governor Title." // #
                ],
                category: .government,
                era: .classical,
                district: .governmentPlaza,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [.autocracy, .classicalRepublic, .oligarchy],
                obsoleteBuildingsOr: [.ancestralHall, .warlordsThrone],
                productionCost: 150,
                goldCost: 150,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .growth, value: 4),
                    Flavor(type: .amenities, value: 2)
                ]
            )

        case .warlordsThrone:
            // https://civilization.fandom.com/wiki/Warlord%27s_Throne_(Civ6)
            return BuildingTypeData(
                name: "Warlord's Throne",
                effects: [
                    "Capturing an enemy City grants 20% bonus [Production] Production in all Cities for 5 turns.", // #
                    "Awards +1 [Governor] Governor Title." // #
                ],
                category: .government,
                era: .classical,
                district: .governmentPlaza,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [.autocracy, .classicalRepublic, .oligarchy],
                obsoleteBuildingsOr: [.ancestralHall, .audienceChamber],
                productionCost: 150,
                goldCost: 150,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .production, value: 3),
                    Flavor(type: .offense, value: 2)
                ]
            )

            // --------------------------------------
            // medieval

        case .medievalWalls:
            // https://civilization.fandom.com/wiki/Medieval_Walls_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_MEDIEVAL_WALLS_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_MEDIEVAL_WALLS_EFFECT0",
                    "TXT_KEY_BUILDING_MEDIEVAL_WALLS_EFFECT1" // #
                ],
                category: .defensive,
                era: .medieval,
                district: .cityCenter,
                requiredTech: .castles,
                requiredCivic: nil,
                requiredBuildingsOr: [.ancientWalls],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 225,
                goldCost: -1,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 100,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .militaryTraining, value: 7),
                    Flavor(type: .offense, value: 5),
                    Flavor(type: .defense, value: 6),
                    Flavor(type: .production, value: 2),
                    Flavor(type: .naval, value: 2),
                    Flavor(type: .tileImprovement, value: 2)
                ]
            )

        case .workshop:
            // https://civilization.fandom.com/wiki/Workshop_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_WORKSHOP_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_WORKSHOP_EFFECT0",
                    "TXT_KEY_BUILDING_WORKSHOP_EFFECT1",
                    "TXT_KEY_BUILDING_WORKSHOP_EFFECT2"
                ],
                category: .production,
                era: .medieval,
                district: .industrialZone,
                requiredTech: .apprenticeship,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 195,
                goldCost: 195,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 2, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .engineer, amount: 1),
                flavours: [
                    Flavor(type: .production, value: 7)
                ]
            )

        case .armory:
            // https://civilization.fandom.com/wiki/Armory_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_ARMORY_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_ARMORY_EFFECT0",
                    "TXT_KEY_BUILDING_ARMORY_EFFECT1",
                    "TXT_KEY_BUILDING_ARMORY_EFFECT2",
                    "TXT_KEY_BUILDING_ARMORY_EFFECT3",
                    "TXT_KEY_BUILDING_ARMORY_EFFECT4", // #
                    "TXT_KEY_BUILDING_ARMORY_EFFECT5" // #
                ],
                category: .military,
                era: .medieval,
                district: .encampment,
                requiredTech: .militaryEngineering,
                requiredCivic: nil,
                requiredBuildingsOr: [.barracks, .stable],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 195,
                goldCost: 195,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 2, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .commander, amount: 1),
                flavours: [
                    Flavor(type: .cityDefense, value: 6),
                    Flavor(type: .greatPeople, value: 3),
                    Flavor(type: .offense, value: 8),
                    Flavor(type: .defense, value: 4),
                    Flavor(type: .wonder, value: 1),
                    Flavor(type: .production, value: 1)
                ]
            )

        case .foreignMinistry:
            //
            return BuildingTypeData(
                name: "Foreign Ministry",
                effects: [
                    "Levying City-States costs half [Gold] Gold.", // #
                    "City-State units gain +4 [Strength] Combat Strength if you are the City-State's Suzerain (including levied units).", // #
                    "Awards +1 [Governor] Governor Title.", // #
                    "+3 [DiplomaticFavor] Diplomatic Favor." // #
                ],
                category: .government,
                era: .medieval,
                district: .governmentPlaza,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [.grandMastersChapel, .intelligenceAgency],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    // Flavor(type: .cityState, value: 6),
                    Flavor(type: .diplomacy, value: 6),
                ]
            )

        case .grandMastersChapel:
            // https://civilization.fandom.com/wiki/Grand_Master%27s_Chapel_(Civ6)
            return BuildingTypeData(
                name: "Grand Master's Chapel",
                effects: [
                    "Grants the ability to buy land military units with [Faith] Faith.",
                    "Pillaging improvements and [District] Districts provides bonus [Faith] Faith.",
                    "Awards +1 [Governor] Governor Title.",
                    "+5 [Faith] Faith."
                ],
                category: .government,
                era: .medieval,
                district: .governmentPlaza,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [.foreignMinistry, .intelligenceAgency],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .religion, value: 6),
                ]
            )

        case .intelligenceAgency:
            // https://civilization.fandom.com/wiki/Intelligence_Agency_(Civ6)
            return BuildingTypeData(
                name: "Intelligence Agency",
                effects: [
                    "+1 Spy and Spy capacity.",
                    "All Spy Operations have a higher chance of success.",
                    "Awards +1 [Governor] Governor Title."
                ],
                category: .government,
                era: .medieval,
                district: .governmentPlaza,
                requiredTech: nil,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [.foreignMinistry, .grandMastersChapel],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .diplomacy, value: 4),
                ]
            )

        case .university:
            // https://civilization.fandom.com/wiki/University_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_UNIVERSITY_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_UNIVERSITY_EFFECT0",
                    "TXT_KEY_BUILDING_UNIVERSITY_EFFECT1",
                    "TXT_KEY_BUILDING_UNIVERSITY_EFFECT2",
                    "TXT_KEY_BUILDING_UNIVERSITY_EFFECT3"
                ],
                category: .scientific,
                era: .medieval,
                district: .campus,
                requiredTech: .education,
                requiredCivic: nil,
                requiredBuildingsOr: [.library],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 250,
                goldCost: 250,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0, science: 4, housing: 1),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .science, value: 8)
                ]
            )

            // --------------------------------------
            // renaissance

        case .renaissanceWalls:
            // https://civilization.fandom.com/wiki/Renaissance_Walls_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_RENAISSANCE_WALLS_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_RENAISSANCE_WALLS_EFFECT0"
                ],
                category: .defensive,
                era: .renaissance,
                district: .cityCenter,
                requiredTech: .siegeTactics,
                requiredCivic: nil,
                requiredBuildingsOr: [.medievalWalls],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 305,
                goldCost: -1,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 100,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .militaryTraining, value: 7),
                    Flavor(type: .offense, value: 5),
                    Flavor(type: .defense, value: 7),
                    Flavor(type: .production, value: 2),
                    Flavor(type: .naval, value: 2),
                    Flavor(type: .tileImprovement, value: 2)
                ]
            )

        case .shipyard:
            // https://civilization.fandom.com/wiki/Shipyard_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_SHIPYARD_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_SHIPYARD_EFFECT0",
                    "TXT_KEY_BUILDING_SHIPYARD_EFFECT1",
                    "TXT_KEY_BUILDING_SHIPYARD_EFFECT2",
                    "TXT_KEY_BUILDING_SHIPYARD_EFFECT3",
                    "TXT_KEY_BUILDING_SHIPYARD_EFFECT4"
                ],
                category: .maritime,
                era: .renaissance,
                district: .harbor,
                requiredTech: .massProduction,
                requiredCivic: nil,
                requiredBuildingsOr: [.lighthouse],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .naval, value: 7),
                    Flavor(type: .militaryTraining, value: 7)
                ]
            )

        case .bank:
            // https://civilization.fandom.com/wiki/Bank_(Civ6)
            return BuildingTypeData(
                name: "TXT_KEY_BUILDING_BANK_TITLE",
                effects: [
                    "TXT_KEY_BUILDING_BANK_EFFECT0",
                    "TXT_KEY_BUILDING_BANK_EFFECT1",
                    "TXT_KEY_BUILDING_BANK_EFFECT2",
                    "TXT_KEY_BUILDING_BANK_EFFECT3"
                    // "+2 Great Works Slots for any type with Great Merchant Giovanni de' Medici activated." // #
                ],
                category: .economic,
                era: .renaissance,
                district: .commercialHub,
                requiredTech: .banking,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 5),
                defense: 0,
                slots: [],
                specialSlots: SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .gold, value: 8)
                ]
            )

        case .artMuseum:
            // https://civilization.fandom.com/wiki/Art_Museum_(Civ6)
            return BuildingTypeData(
                name: "Art Museum",
                effects: [
                    "+2 [Culture] Culture",
                    "+1 [Citizen] Citizen slot",
                    "+1 [GreatWriter] Great Writer point per turn", // #
                    "+2 [GreatArtist] Great Artist points per turn", // #
                    "+3 [Sculpture] [Portrait] [Landscape] [ReligiousArt] Great Work of Art slots"
                ],
                category: .cultural,
                era: .renaissance,
                district: .theatherSquare,
                requiredTech: nil,
                requiredCivic: .humanism,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [.archaeologicalMuseum],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0, culture: 2),
                defense: 0,
                slots: [.artwork, .artwork, .artwork],
                specialSlots: BuildingType.SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .culture, value: 7)
                ]
            )

        case .archaeologicalMuseum:
            // https://civilization.fandom.com/wiki/Archaeological_Museum_(Civ6)
            return BuildingTypeData(
                name: "Archaeological Museum",
                effects: [
                    "+2 [Culture] Culture",
                    "+1 [Citizen] Citizen slot",
                    "+1 [GreatWriter] Great Writer point per turn", // #
                    "+2 [GreatArtist] Great Artist points per turn", // #
                    "+3 [Artifact] Artifact slots",
                    "Allows training and maintaining 1 Archaeologist, while there are free [Artifact] Artifact slots in the Museum"
                ],
                category: .cultural,
                era: .renaissance,
                district: .theatherSquare,
                requiredTech: nil,
                requiredCivic: .humanism,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [.artMuseum],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0, culture: 2),
                defense: 0,
                slots: [.artifact, .artifact, .artifact],
                specialSlots: BuildingType.SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .culture, value: 7)
                ]
            )

            // ////////////////////////////////
            // industrial
        case .aquarium:
            // https://civilization.fandom.com/wiki/Aquarium_(Civ6)
            return BuildingTypeData(
                name: "Aquarium",
                effects: [
                    "+1 [Amenity] Amenity from entertainment. This bonus extends to each City Center within 9 tiles. This bonus applies once to a city, and multiple copies of this building within 9 tiles of a City Center do not provide additional bonuses.", // #
                    "+1 [Science] Science to each coastal resource, [Shipwreck] Shipwreck, and Reef tile in this city." // #
                ],
                category: .entertainment,
                era: .industrial,
                district: .waterPark,
                requiredTech: nil,
                requiredCivic: .naturalHistory,
                requiredBuildingsOr: [.ferrisWheel],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 360,
                goldCost: 360,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .amenities, value: 5)
                ]
            )

        case .coalPowerPlant:
            // https://civilization.fandom.com/wiki/Coal_Power_Plant_(Civ6)
            return BuildingTypeData(
                name: "Coal Power Plant",
                effects: [
                    "Grants bonus [Production] Production equal to the district's current adjacency bonus.", // #
                    "Converts [Coal] Coal into [Power] Power for this city and other cities whose City Centers are within 6 tiles. (Conversion rate: 1 [Coal] Coal → 4 [Power] Power)", // #
                    "+1 [Citizen] Citizen slot.",
                    "+1 [Production] Production additionally per Specialist in this district", // #
                    "+1 [GreatEngineer] Great Engineer point per turn.", // #
                    "Heavy CO2 emissions into the atmosphere." // #
                ],
                category: .production,
                era: .industrial,
                district: .industrialZone,
                requiredTech: .industrialization,
                requiredCivic: nil,
                requiredBuildingsOr: [.factory /*, .electronicsFactory*/], // #
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 300,
                goldCost: 300,
                faithCost: -1,
                maintenanceCost: 3,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: BuildingType.SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .production, value: 7)
                ]
            )

        case .factory:
            // https://civilization.fandom.com/wiki/Factory_(Civ6)
            return BuildingTypeData(
                name: "Factory",
                effects: [
                    "+3 [Production] Production to all city centers within 6 tiles", // #
                    "+1 [Citizen] Citizen slot", // #
                    "+1 [GreatEngineer] Great Engineer point per turn" // #
                ],
                category: .production,
                era: .industrial,
                district: .industrialZone,
                requiredTech: .industrialization,
                requiredCivic: nil,
                requiredBuildingsOr: [.workshop],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 330,
                goldCost: 330,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: BuildingType.SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .production, value: 8)
                ]
            )

        case .ferrisWheel:
            // https://civilization.fandom.com/wiki/Ferris_Wheel_(Civ6)
            return BuildingTypeData(
                name: "Ferris Wheel",
                effects: [
                    "+2 [Amenities] Amenities from entertainment", // #
                    "+2 [Tourism] Tourism", // #
                    "+3 [Culture] Culture"
                ],
                category: .entertainment,
                era: .industrial,
                district: .waterPark,
                requiredTech: nil,
                requiredCivic: .naturalHistory,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 290,
                goldCost: 290,
                faithCost: -1,
                maintenanceCost: 1,
                yields: Yields(food: 0, production: 0, gold: 0, culture: 3),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .amenities, value: 7),
                    Flavor(type: .culture, value: 4)
                ]
            )

        case .militaryAcademy:
            // https://civilization.fandom.com/wiki/Military_Academy_(Civ6)
            return BuildingTypeData(
                name: "Military Academy",
                effects: [
                    "+25% combat experience for all land units trained in this city", // #
                    "Allows faster Corps and Army training", // #
                    "+4 [Production] Production",
                    "+1 [Housing] Housing",
                    "+1 [Citizen] Citizen slot",
                    "+1 [Production] Production additionally per Specialist in this district", // #
                    "+1 [GreatGeneral] Great General point per turn", // #
                    "Strategic Resource stockpiles increased by 10" // #
                ],
                category: .military,
                era: .industrial,
                district: .encampment,
                requiredTech: .militaryScience,
                requiredCivic: nil,
                requiredBuildingsOr: [.armory],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 330,
                goldCost: 330,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 4, gold: 0, housing: 1),
                defense: 0,
                slots: [],
                specialSlots: BuildingType.SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .offense, value: 4),
                    Flavor(type: .production, value: 4)
                ]
            )

        case .sewer:
            // https://civilization.fandom.com/wiki/Sewer_(Civ6)
            return BuildingTypeData(
                name: "Sewer",
                effects: [
                    "+2 [Housing] Housing" // #
                ],
                category: .infrastructure,
                era: .industrial,
                district: .cityCenter,
                requiredTech: .sanitation,
                requiredCivic: nil,
                requiredBuildingsOr: [],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 200,
                goldCost: 200,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0, housing: 2),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .growth, value: 7)
                ]
            )

        case .stockExchange:
            // https://civilization.fandom.com/wiki/Stock_Exchange_(Civ6)
            return BuildingTypeData(
                name: "Stock Exchange",
                effects: [
                    "+7 [Gold] Gold additionally when [Power] Powered. Base Load: 3 [Power] Power", // #
                    "+1 [Citizen] Citizen slot",
                    "+2 [Gold] Gold additionally per Specialist in this district", // #
                    "+1 [GreatMerchant] Great Merchant point per turn." // #
                ],
                category: .economic,
                era: .industrial,
                district: .commercialHub,
                requiredTech: .economics,
                requiredCivic: nil,
                requiredBuildingsOr: [.bank],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 330,
                goldCost: 330,
                faithCost: -1,
                maintenanceCost: 0,
                yields: Yields(food: 0, production: 0, gold: 7),
                defense: 0,
                slots: [],
                specialSlots: BuildingType.SpecialistSlots(type: .citizen, amount: 1),
                flavours: [
                    Flavor(type: .gold, value: 10)
                ]
            )

        case .zoo:
            // https://civilization.fandom.com/wiki/Zoo_(Civ6)
            return BuildingTypeData(
                name: "Zoo",
                effects: [
                    "+1 [Amenity] Amenity from Entertainment to all City Centers within 6 tiles of this Zoo's Entertainment Complex", // #
                    "+1 [Science] Science to each Rainforest and Marsh tile in this city" // #
                ],
                category: .entertainment,
                era: .industrial,
                district: .entertainmentComplex,
                requiredTech: nil,
                requiredCivic: .naturalHistory,
                requiredBuildingsOr: [.arena],
                requiredGovermentsOr: [],
                obsoleteBuildingsOr: [],
                productionCost: 360,
                goldCost: 360,
                faithCost: -1,
                maintenanceCost: 2,
                yields: Yields(food: 0, production: 0, gold: 0),
                defense: 0,
                slots: [],
                specialSlots: nil,
                flavours: [
                    Flavor(type: .amenities, value: 6)
                ]
            )
        }
    }

    func canBuild(in city: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        switch self {

        case .none: return false

            // ancient
        case .ancientWalls: return true
        case .barracks: return true
        case .granary: return true
        case .grove: return true
        case .library: return true
        case .monument: return true
        case .palace: return false
        case .shrine: return true

            // classic
        case .waterMill:
            // It can be built in the City Center, if the city is next to a River.
            return gameModel.river(at: city.location)

        case .amphitheater: return true
        case .lighthouse: return true
        case .stable: return true
        case .arena: return true
        case .market: return true
        case .temple: return true
        case .ancestralHall: return true
        case .audienceChamber: return true
        case .warlordsThrone: return true

            // medieval
        case .medievalWalls: return true //
        case .workshop: return true
        case .armory: return true
        case .foreignMinistry: return true
        case .grandMastersChapel: return true
        case .intelligenceAgency: return true
        case .university: return true

            // renaissance
        case .renaissanceWalls: return true
        case .shipyard: return true
        case .bank: return true
        case .artMuseum: return true
        case .archaeologicalMuseum: return true

            // industrial
        case .aquarium: return true
        case .coalPowerPlant: return true
        case .factory: return true
        case .ferrisWheel: return true
        case .militaryAcademy: return true
        case .sewer: return true
        case .stockExchange: return true
        case .zoo: return true
        }
    }
}
