//
//  BuildingType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum BuildingType: Int, Codable {

    case none

    // ancient
    case palace
    case granary
    case monument
    case library // https://civilization.fandom.com/wiki/Library_(Civ6)
    case shrine
    case ancientWalls
    case barracks
    case waterMill // https://civilization.fandom.com/wiki/Water_Mill_(Civ6)

    // classical
    case amphitheater // https://civilization.fandom.com/wiki/Amphitheater_(Civ6)
    case lighthouse // https://civilization.fandom.com/wiki/Lighthouse_(Civ6)
    case stable // https://civilization.fandom.com/wiki/Stable_(Civ6)
    case arena // https://civilization.fandom.com/wiki/Arena_(Civ6)
    case market // https://civilization.fandom.com/wiki/Market_(Civ6)
    case temple // https://civilization.fandom.com/wiki/Temple_(Civ6)
    
    // medieval
    case medievalWalls // https://civilization.fandom.com/wiki/Medieval_Walls_(Civ6)
    case workshop // https://civilization.fandom.com/wiki/Workshop_(Civ6)
    
    // renaissance
    case renaissanceWalls // https://civilization.fandom.com/wiki/Renaissance_Walls_(Civ6)
    case shipyard // https://civilization.fandom.com/wiki/Shipyard_(Civ6)

    public static var all: [BuildingType] {
        return [
            // ancient
            .palace, // ???
            .granary, .monument, .library, .shrine, .ancientWalls, .barracks, .waterMill,

            // classical
            .amphitheater, .lighthouse, .stable, .arena, .market, .temple,
            
            // medieval
            .medievalWalls,
            
            // renaissance
            .renaissanceWalls,  .shipyard
        ]
    }

    // MARK: methods

    public func name() -> String {

        return self.data().name
    }
    
    public func era() -> EraType {
        
        return self.data().era
    }

    func defense() -> Int {

        return self.data().defense
    }

    // in production units
    public func productionCost() -> Int {

        return self.data().productionCost
    }

    // in gold
    func maintenanceCost() -> Int {

        return self.data().maintenanceCost
    }

    func yields() -> Yields {
        
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
    
    public func requiredBuilding() -> BuildingType? {

        return self.data().requiredBuilding
    }

    public func district() -> DistrictType {

        return self.data().district
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let flavor = self.flavours().first(where: { $0.type == flavorType }) {
            return flavor.value
        }

        return 0
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
        let category: BuildingCategoryType
        let era: EraType
        let district: DistrictType
        let requiredTech: TechType?
        let requiredCivic: CivicType?
        let requiredBuilding: BuildingType?
        let productionCost: Int
        let goldCost: Int
        let maintenanceCost: Int
        let yields: Yields
        let defense: Int
        let slots: [GreatWorkSlotType]
        let specialSlots: SpecialistSlots?
        let flavours: [Flavor]
    }

    private func data() -> BuildingTypeData {
        
        switch self {
            
        case .none:
            return BuildingTypeData(name: "",
                                    category: .none,
                                    era: .none,
                                    district: .cityCenter,
                                    requiredTech: nil,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 0,
                                    goldCost: -1,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [])

        case .palace:
            // https://civilization.fandom.com/wiki/Palace_(Civ6)
            return BuildingTypeData(name: "Palace",
                                    category: .government,
                                    era: .ancient,
                                    district: .cityCenter,
                                    requiredTech: nil,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 0,
                                    goldCost: -1,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 0, production: 2, gold: 5, science: 2, culture: 1, faith: 0, housing: 1),
                                    defense: 25,
                                    slots: [.any],
                                    specialSlots: nil,
                                    flavours: [])

            // ancient
        case .granary:
            // https://civilization.fandom.com/wiki/Granary_(Civ6)
            return BuildingTypeData(name: "Granary",
                                    category: .population,
                                    era: .ancient,
                                    district: .cityCenter,
                                    requiredTech: .pottery,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 65,
                                    goldCost: 65,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 1, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 2),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [Flavor(type: .growth, value: 10), Flavor(type: .greatPeople, value: 3), Flavor(type: .science, value: 4), Flavor(type: .tileImprovement, value: 3), Flavor(type: .gold, value: 2), Flavor(type: .production, value: 3), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1)])
        case .monument:
            // https://civilization.fandom.com/wiki/Monument_(Civ6)
            // FIXME +1 Loyalty
            // FIXME +1 additional Civ6Culture Culture if city is at maximum Loyalty.
            return BuildingTypeData(name: "Monument",
                                    category: .cultural,
                                    era: .ancient,
                                    district: .cityCenter,
                                    requiredTech: nil,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 60,
                                    goldCost: 60,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [Flavor(type: .culture, value: 7), Flavor(type: .tourism, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .wonder, value: 1), Flavor(type: .gold, value: 1), Flavor(type: .greatPeople, value: 1), Flavor(type: .production, value: 1), Flavor(type: .happiness, value: 1), Flavor(type: .science, value: 1), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .cityDefense, value: 1), Flavor(type: .naval, value: 1), Flavor(type: .navalTileImprovement, value: 1), Flavor(type: .religion, value: 1)]) // Note: The Monument has so many flavors because culture leads to policies, which help with a number of things
        case .library:
            // https://civilization.fandom.com/wiki/Library_(Civ6)
            return BuildingTypeData(name: "Library",
                                    category: .scientific,
                                    era: .ancient,
                                    district: .campus,
                                    requiredTech: .writing,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 90,
                                    goldCost: 90,
                                    maintenanceCost: 1,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 2, culture: 0, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [.written, .written],
                                    specialSlots: SpecialistSlots(type: .scientist, amount: 1),
                                    flavours: [Flavor(type: .science, value: 8), Flavor(type: .greatPeople, value: 5), Flavor(type: .offense, value: 3), Flavor(type: .defense, value: 3)/*, Flavor(type: .spaceShip, value: 2)*/])
        case .shrine:
            // https://civilization.fandom.com/wiki/Shrine_(Civ6)
            // FIXME Allows purchasing of Missionaries in this city.
            return BuildingTypeData(name: "Shrine",
                                    category: .religious,
                                    era: .ancient,
                                    district: .holySite,
                                    requiredTech: .astrology,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 70,
                                    goldCost: 70,
                                    maintenanceCost: 1,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 2, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: SpecialistSlots(type: .priest, amount: 1),
                                    flavours: [Flavor(type: .religion, value: 9), Flavor(type: .culture, value: 4), Flavor(type: .gold, value: 3), Flavor(type: .happiness, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .tourism, value: 2), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .growth, value: 1)]) // Note: The Shrine has a number of flavors because religion improves a variety of game aspects
        case .ancientWalls:
            // https://civilization.fandom.com/wiki/Ancient_Walls_(Civ6)
            return BuildingTypeData(name: "Ancient Walls",
                                    category: .defensive,
                                    era: .ancient,
                                    district: .cityCenter,
                                    requiredTech: .masonry,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 80,
                                    goldCost: 80,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 50,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [Flavor(type: .militaryTraining, value: 7), Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 5), Flavor(type: .production, value: 2), Flavor(type: .naval, value: 2), Flavor(type: .tileImprovement, value: 2)])
        case .barracks:
            // https://civilization.fandom.com/wiki/Barracks_(Civ6)
            // FIXME +25% combat experience for all melee, ranged and anti-cavalry land units trained in this city
            return BuildingTypeData(name: "Barracks",
                                    category: .military,
                                    era: .ancient,
                                    district: .encampment,
                                    requiredTech: .bronzeWorking,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 90,
                                    goldCost: 90,
                                    maintenanceCost: 1,
                                    yields: Yields(food: 0, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 1),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: SpecialistSlots(type: .commander, amount: 1),
                                    flavours: [Flavor(type: .cityDefense, value: 8), Flavor(type: .greatPeople, value: 5), Flavor(type: .defense, value: 4), Flavor(type: .wonder, value: 1), Flavor(type: .production, value: 1)])
        case .waterMill:
            // https://civilization.fandom.com/wiki/Water_Mill_(Civ6)
            // FIXME Bonus resources improved by Farms gain +1 Civ6Food Food each.
            // FIXME It can be built in the City Center if the city is next to a River.
            return BuildingTypeData(name: "Water Mill",
                                    category: .military,
                                    era: .ancient,
                                    district: .cityCenter,
                                    requiredTech: .wheel,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 80,
                                    goldCost: 80,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 1, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [Flavor(type: .growth, value: 7), Flavor(type: .science, value: 4), Flavor(type: .tileImprovement, value: 3), Flavor(type: .production, value: 3), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1)])

            // classical
        case .amphitheater:
            // https://civilization.fandom.com/wiki/Amphitheater_(Civ6)
            return BuildingTypeData(name: "Amphitheater",
                                    category: .cultural,
                                    era: .classical,
                                    district: .entertainment,
                                    requiredTech: nil,
                                    requiredCivic: .dramaAndPoetry,
                                    requiredBuilding: nil,
                                    productionCost: 150,
                                    goldCost: 150,
                                    maintenanceCost: 1,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [.written, .written],
                                    specialSlots: SpecialistSlots(type: .artist, amount: 1),
                                    flavours: [Flavor(type: .growth, value: 4), Flavor(type: .culture, value: 8), Flavor(type: .wonder, value: 1)])
        case .lighthouse:
            // https://civilization.fandom.com/wiki/Lighthouse_(Civ6)
            // FIXME +25% combat XP for all naval units trained in this city
            // FIXME +1 TradeRoute6 Trade Route capacity if this city doesn't have a Market.
            return BuildingTypeData(name: "Lighthouse",
                                    category: .cultural,
                                    era: .classical,
                                    district: .harbor,
                                    requiredTech: .celestialNavigation,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 120,
                                    goldCost: 120,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 1, production: 0, gold: 1, science: 0, culture: 0, faith: 0, housing: 1),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: SpecialistSlots(type: .captain, amount: 1),
                                    flavours: [Flavor(type: .growth, value: 7), Flavor(type: .science, value: 4), Flavor(type: .navalTileImprovement, value: 8), Flavor(type: .gold, value: 3), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1)])
        case .stable:
            // https://civilization.fandom.com/wiki/Stable_(Civ6)
            // FIXME +25% combat experience for all light and heavy cavalry units trained in this city
            // FIXME +25% combat experience for all siege units trained in this city
            // FIXME Cannot be built if Barracks has already been built in this district.
            return BuildingTypeData(name: "Stable",
                                    category: .military,
                                    era: .classical,
                                    district: .encampment,
                                    requiredTech: .horsebackRiding,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 120,
                                    goldCost: 120,
                                    maintenanceCost: 1,
                                    yields: Yields(food: 0, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 1),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: SpecialistSlots(type: .commander, amount: 1),
                                    flavours: [Flavor(type: .cityDefense, value: 6), Flavor(type: .greatPeople, value: 5), Flavor(type: .offense, value: 8), Flavor(type: .defense, value: 4), Flavor(type: .wonder, value: 1), Flavor(type: .production, value: 1)])
        case .arena:
            // https://civilization.fandom.com/wiki/Arena_(Civ6)
            // FIXME +1 Tourism6 Tourism after developing the Conservation civic
            return BuildingTypeData(name: "Arena",
                                    category: .entertainment,
                                    era: .classical,
                                    district: .entertainment,
                                    requiredTech: nil,
                                    requiredCivic: .gamesAndRecreation,
                                    requiredBuilding: nil,
                                    productionCost: 150,
                                    goldCost: 150,
                                    maintenanceCost: 1,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 1, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [Flavor(type: .culture, value: 7), Flavor(type: .tourism, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .wonder, value: 1), Flavor(type: .gold, value: 1), Flavor(type: .greatPeople, value: 1), Flavor(type: .production, value: 1), Flavor(type: .happiness, value: 1), Flavor(type: .science, value: 1), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .cityDefense, value: 1), Flavor(type: .naval, value: 1), Flavor(type: .navalTileImprovement, value: 1), Flavor(type: .religion, value: 1)])
        case .market:
            // https://civilization.fandom.com/wiki/Market_(Civ6)
            // FIXME +1 TradeRoute6 Trade Route capacity if this city doesn't have a Lighthouse.
            return BuildingTypeData(name: "Market",
                                    category: .economic,
                                    era: .classical,
                                    district: .commercialHub,
                                    requiredTech: .currency,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 120,
                                    goldCost: 120,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 0, production: 0, gold: 3, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: SpecialistSlots(type: .merchant, amount: 1),
                                    flavours: [Flavor(type: .cityDefense, value: 2), Flavor(type: .greatPeople, value: 5), Flavor(type: .gold, value: 8), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .wonder, value: 1), Flavor(type: .production, value: 1)])
        case .temple:
            // https://civilization.fandom.com/wiki/Temple_(Civ6)
            return BuildingTypeData(name: "Temple",
                                    category: .religious,
                                    era: .classical,
                                    district: .holySite,
                                    requiredTech: nil,
                                    requiredCivic: .theology,
                                    requiredBuilding: .shrine,
                                    productionCost: 120,
                                    goldCost: 120,
                                    maintenanceCost: 2,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 4, housing: 0),
                                    defense: 0,
                                    slots: [.relic],
                                    specialSlots: SpecialistSlots(type: .priest, amount: 1),
                                    flavours: [Flavor(type: .greatPeople, value: 5), Flavor(type: .religion, value: 10)])
            
            // --------------------------------------
            // medieval
        case .medievalWalls:
            // https://civilization.fandom.com/wiki/Medieval_Walls_(Civ6)
            // FIXME +2 Housing6 Housing under the Monarchy Government
            // FIXME +2 Tourism6 Tourism (with Conservation)
            return BuildingTypeData(name: "Medieval Walls",
                                    category: .defensive,
                                    era: .medieval,
                                    district: .cityCenter,
                                    requiredTech: .castles,
                                    requiredCivic: nil,
                                    requiredBuilding: .ancientWalls,
                                    productionCost: 225,
                                    goldCost: -1,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 100,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [Flavor(type: .militaryTraining, value: 7), Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 6), Flavor(type: .production, value: 2), Flavor(type: .naval, value: 2), Flavor(type: .tileImprovement, value: 2)])
        case .workshop:
            // https://civilization.fandom.com/wiki/Workshop_(Civ6)
            return BuildingTypeData(name: "Workshop",
                                    category: .production,
                                    era: .medieval,
                                    district: .industrial,
                                    requiredTech: .apprenticeship,
                                    requiredCivic: nil,
                                    requiredBuilding: nil,
                                    productionCost: 195,
                                    goldCost: 195,
                                    maintenanceCost: 1,
                                    yields: Yields(food: 0, production: 2, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: SpecialistSlots(type: .engineer, amount: 1),
                                    flavours: [Flavor(type: .production, value: 7)])
            
            // --------------------------------------
            // renaissance
        case .renaissanceWalls:
            // https://civilization.fandom.com/wiki/Renaissance_Walls_(Civ6)
            // FIXME +3 Tourism6 Tourism (with Conservation)
            // FIXME +2 Civ6Science Science with the Military Research Policy
            return BuildingTypeData(name: "Renaissance Walls",
                                    category: .defensive,
                                    era: .renaissance,
                                    district: .cityCenter,
                                    requiredTech: .siegeTactics,
                                    requiredCivic: nil,
                                    requiredBuilding: .medievalWalls,
                                    productionCost: 305,
                                    goldCost: -1,
                                    maintenanceCost: 0,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 100,
                                    slots: [],
                                    specialSlots: nil,
                                    flavours: [Flavor(type: .militaryTraining, value: 7), Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 7), Flavor(type: .production, value: 2), Flavor(type: .naval, value: 2), Flavor(type: .tileImprovement, value: 2)])
        case .shipyard:
            // https://civilization.fandom.com/wiki/Shipyard_(Civ6)
            return BuildingTypeData(name: "Shipyard",
                                    category: .maritime,
                                    era: .renaissance,
                                    district: .harbor,
                                    requiredTech: .massProduction,
                                    requiredCivic: nil,
                                    requiredBuilding: .lighthouse,
                                    productionCost: 290,
                                    goldCost: 290,
                                    maintenanceCost: 2,
                                    yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0),
                                    defense: 0,
                                    slots: [],
                                    specialSlots: SpecialistSlots(type: .captain, amount: 1),
                                    flavours: [Flavor(type: .naval, value: 7), Flavor(type: .militaryTraining, value: 7),])
        }
    }
}
