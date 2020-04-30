//
//  TechType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct TechAchievements {
    
    public let buildingTypes: [BuildingType]
    public let unitTypes: [UnitType]
    public let wonderTypes: [WonderType]
    public let buildTypes: [BuildType]
}

public enum TechType: String, Codable {
    
    case none
    
    // ancient
    case mining
    case pottery
    case animalHusbandry
    case sailing
    case astrology
    case irrigation
    case writing
    case masonry
    case archery
    case bronzeWorking
    case wheel

    // classical
    case celestialNavigation
    case horsebackRiding
    case currency
    case construction
    case ironWorking
    case shipBuilding
    case mathematics
    case engineering

    // medieval
    case militaryTactics
    case buttress
    case apprenticesship
    case stirrups
    case machinery
    case education
    case militaryEngineering
    case castles

    // renaissance
    case cartography
    case massProduction
    case banking
    case gunpowder
    case printing
    case squareRigging
    case astronomy
    case metalCasting
    case siegeTactics
    
    // industrial
    case industrialization
    case scientificTheory
    case ballistics
    case militaryScience
    case steamPower
    case sanitation
    case economics
    case rifling
    
    // modern
    case flight
    case replaceableParts
    case steel
    case refining
    case electricity
    case radio
    case chemistry
    case combustrion
    
    // atomic
    case advancedFlight
    case rocketry
    case advancedBallistics
    case combinedArms
    case plastics
    case computers
    case nuclearFission
    case syntheticMaterials
    
    // information
    case telecommunications
    case satellites
    case guidanceSystems
    case lasers
    case composites
    case stealthTechnology
    case robotics
    case nuclearFusion
    case nanotechnology
    
    case futureTech

    static var all: [TechType] {
        return [
            // ancient
            .mining, .pottery, .animalHusbandry, .sailing, .astrology, .irrigation, .writing, .masonry, .archery, .bronzeWorking, .wheel,
            
            // classical
            .celestialNavigation, horsebackRiding, .currency, .construction, .ironWorking, .shipBuilding, .mathematics, .engineering,
            
            // medieval
            .militaryTactics, .buttress, .apprenticesship, .stirrups, .machinery, .education, .militaryEngineering, .castles,
            
            // renaissance
            .cartography, .massProduction, .banking, .gunpowder, .printing, .squareRigging, .astronomy, .metalCasting, .siegeTactics,
            
            // industrial
            .industrialization, .scientificTheory, .ballistics, .militaryScience, .steamPower, .sanitation, .economics, .rifling,
            
            // modern
            .flight, .replaceableParts, .steel, .refining, .electricity, .radio, .chemistry, .combustrion,
            
            // atomic
            .advancedFlight, .rocketry, .advancedBallistics, .combinedArms, .plastics, .computers, .nuclearFission, .syntheticMaterials,
            
            // information
            .telecommunications, .satellites, .guidanceSystems, .lasers, .composites, .stealthTechnology, .robotics, .nuclearFusion,. nanotechnology,
            
            // future
            .futureTech
        ]
    }
    
    public func name() -> String {
        
        return self.data().name
    }
    
    public func eurekaSummary() -> String {
        
        return self.data().eurekaSummary
    }

    func era() -> EraType {

        return self.data().era
    }

    public func cost() -> Int {

        return self.data().cost
    }

    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Technologies.xml
    func required() -> [TechType] {

        return self.data().required
    }

    func leadsTo() -> [TechType] {

        var leadingTo: [TechType] = []

        for tech in TechType.all {
            if tech.required().contains(self) {
                leadingTo.append(tech)
            }
        }

        return leadingTo
    }

    func flavorValue(for flavor: FlavorType) -> Int {

        if let flavorOfTech = self.flavours().first(where: { $0.type == flavor }) {
            return flavorOfTech.value
        }

        return 0
    }

    func flavours() -> [Flavor] {

        return self.data().flavors
    }
    
    func isGoodyTech() -> Bool {
        
        return self.era() == .ancient
    }
    
    public func achievements() -> TechAchievements {
        
        let buildings = BuildingType.all.filter({
            if let tech = $0.requiredTech() {
                return tech == self
                
            } else {
                return false
            }
        })
        
        let units = UnitType.all.filter({
            if let tech = $0.required() {
                return tech == self
            } else {
                return false
            }
        })
        
        // districts
        // wonders
        let wonders = WonderType.all.filter({
            if let tech = $0.requiredTech() {
                return tech == self
            } else {
                return false
            }
        })
        
        // buildtypes
        let builds = BuildType.all.filter({
            if let tech = $0.required() {
                return tech == self
            } else {
                return false
            }
        })
            
        return TechAchievements(buildingTypes: buildings, unitTypes: units, wonderTypes: wonders, buildTypes: builds)
    }
    
    // MARK private
    
    private struct TechTypeData {
        
        let name: String
        let eurekaSummary: String
        let era: EraType
        let cost: Int
        let required: [TechType]
        let flavors: [Flavor]
    }
    
    private func data() -> TechTypeData {
        
        switch self {

        case .none:
            return TechTypeData(name: "---",
                                eurekaSummary: "",
                                era: .ancient,
                                cost: -1,
                                required: [],
                                flavors: [])
            
            // ancient
        case .mining:
            return TechTypeData(name: "Mining",
                                eurekaSummary: "",
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .production, value: 3), Flavor(type: .tileImprovement, value: 2)])
        case .pottery:
            return TechTypeData(name: "Pottery",
                                eurekaSummary: "",
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .growth, value: 5)])
        case .animalHusbandry:
            return TechTypeData(name: "Animal Husbandry",
                                eurekaSummary: "",
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .mobile, value: 4), Flavor(type: .tileImprovement, value: 1)])
        case .sailing:
            return TechTypeData(name: "Sailing",
                                eurekaSummary: "Found a city on the Coast",
                                era: .ancient,
                                cost: 50,
                                required: [],
                                flavors: [Flavor(type: .naval, value: 3), Flavor(type: .navalTileImprovement, value: 3), Flavor(type: .wonder, value: 3), Flavor(type: .navalRecon, value: 2)])
        case .astrology:
            return TechTypeData(name: "Astrology",
                                eurekaSummary: "Find a Natural Wonder",
                                era: .ancient,
                                cost: 50,
                                required: [],
                                flavors: [Flavor(type: .happiness, value: 10), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 4)])
        case .irrigation:
            return TechTypeData(name: "Irrigation",
                                eurekaSummary: "Farm a resource",
                                era: .ancient,
                                cost: 50,
                                required: [.pottery],
                                flavors: [Flavor(type: .growth, value: 5)])
        case .writing:
            return TechTypeData(name: "Writing",
                                eurekaSummary: "Meet another civilization",
                                era: .ancient,
                                cost: 50,
                                required: [.pottery],
                                flavors: [Flavor(type: .science, value: 6), Flavor(type: .wonder, value: 2), Flavor(type: .diplomacy, value: 2)])
        case .masonry:
            return TechTypeData(name: "Masonry",
                                eurekaSummary: "Build a Quarry",
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .cityDefense, value: 4), Flavor(type: .happiness, value: 2), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 2)])
        case .archery:
            return TechTypeData(name: "Archery",
                                eurekaSummary: "Kill a unit with a Slinger",
                                era: .ancient,
                                cost: 50,
                                required: [.animalHusbandry],
                                flavors: [Flavor(type: .ranged, value: 4), Flavor(type: .offense, value: 1)])
        case .bronzeWorking:
            return TechTypeData(name: "Bronze Working",
                                eurekaSummary: "Kill 3 Barbarians",
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .defense, value: 4), Flavor(type: .militaryTraining, value: 4), Flavor(type: .wonder, value: 2)])
        case .wheel:
            return TechTypeData(name: "Wheel",
                                eurekaSummary: "Mine a resource",
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .mobile, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .ranged, value: 2), Flavor(type: .infrastructure, value: 2), Flavor(type: .gold, value: 6)])
            
            // classical
        case .celestialNavigation:
            return TechTypeData(name: "Celestrial Navigation",
                                eurekaSummary: "Improve 2 Sea Resources",
                                era: .classical,
                                cost: 120,
                                required: [.sailing, .astrology],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 5)])
        case .horsebackRiding:
            return TechTypeData(name: "Horseback Riding",
                                eurekaSummary: "Build a Pasture",
                                era: .classical,
                                cost: 120,
                                required: [.animalHusbandry],
                                flavors: [Flavor(type: .mobile, value: 7), Flavor(type: .happiness, value: 3)])
        case .currency:
            return TechTypeData(name: "Currency",
                                eurekaSummary: "Make a Trade Route",
                                era: .classical,
                                cost: 120,
                                required: [.writing],
                                flavors: [Flavor(type: .gold, value: 8), Flavor(type: .wonder, value: 2)])
        case .construction:
            return TechTypeData(name: "Construction",
                                eurekaSummary: "Build a Water Mill",
                                era: .classical,
                                cost: 200,
                                required: [.masonry, .horsebackRiding],
                                flavors: [Flavor(type: .happiness, value: 17), Flavor(type: .infrastructure, value: 2), Flavor(type: .wonder, value: 2)])
        case .ironWorking:
            return TechTypeData(name: "Iron Working",
                                eurekaSummary: "Build an Iron Mine",
                                era: .classical,
                                cost: 120,
                                required: [.bronzeWorking],
                                flavors: [Flavor(type: .offense, value: 12), Flavor(type: .defense, value: 6), Flavor(type: .militaryTraining, value: 3)])
        case .shipBuilding:
            return TechTypeData(name: "Ship Building",
                                eurekaSummary: "Own 2 Galleys",
                                era: .classical,
                                cost: 200,
                                required: [.sailing],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 3), Flavor(type: .navalRecon, value: 2)])
        case .mathematics:
            return TechTypeData(name: "Mathematics",
                                eurekaSummary: "Build 3 Specialty Districts",
                                era: .classical,
                                cost: 200,
                                required: [.currency],
                                flavors: [Flavor(type: .ranged, value: 8), Flavor(type: .wonder, value: 2)])
        case .engineering:
            return TechTypeData(name: "Engeneering",
                                eurekaSummary: "Build Ancient Walls",
                                era: .classical,
                                cost: 200,
                                required: [.wheel],
                                flavors: [Flavor(type: .defense, value: 2), Flavor(type: .production, value: 5), Flavor(type: .tileImprovement, value: 5)])
            
            // medieval
        case .militaryTactics:
            return TechTypeData(name: "Military Tactics",
                                eurekaSummary: "Kill a unit with a Spearman",
                                era: .medieval,
                                cost: 275,
                                required: [.mathematics],
                                flavors: [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .cityDefense, value: 2), Flavor(type: .wonder, value: 2),])
        case .buttress:
            return TechTypeData(name: "Buttress",
                                eurekaSummary: "Build a Classical Era or later Wonder",
                                era: .medieval,
                                cost: 300,
                                required: [.shipBuilding, .mathematics],
                                flavors: [Flavor(type: .wonder, value: 2)])
        case .apprenticesship:
            return TechTypeData(name: "Apprenticesship",
                                eurekaSummary: "Build 3 Mines",
                                era: .medieval,
                                cost: 275,
                                required: [.currency, .horsebackRiding],
                                flavors: [Flavor(type: .gold, value: 5), Flavor(type: .production, value: 3)])
        case .stirrups:
            return TechTypeData(name: "Stirrups",
                                eurekaSummary: "Have the Feudalism civic",
                                era: .medieval,
                                cost: 360,
                                required: [.horsebackRiding],
                                flavors: [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .defense, value: 2), Flavor(type: .wonder, value: 2)])
        case .machinery:
            return TechTypeData(name: "Machinery",
                                eurekaSummary: "Own 3 Archers",
                                era: .medieval,
                                cost: 275,
                                required: [.ironWorking, .engineering],
                                flavors: [Flavor(type: .ranged, value: 8), Flavor(type: .infrastructure, value: 2),])
        case .education:
            return TechTypeData(name: "Education",
                                eurekaSummary: "Earn a Great Scientist",
                                era: .medieval,
                                cost: 335,
                                required: [.apprenticesship, .mathematics],
                                flavors: [Flavor(type: .science, value: 8), Flavor(type: .wonder, value: 2)])
        case .militaryEngineering:
            return TechTypeData(name: "Military Engineering",
                                eurekaSummary: "Build an Aqueduct",
                                era: .medieval,
                                cost: 335,
                                required: [.construction],
                                flavors: [Flavor(type: .defense, value: 5), Flavor(type: .production, value: 2)])
        case .castles:
            return TechTypeData(name: "Castles",
                                eurekaSummary: "Have a government with 6 policy slots",
                                era: .medieval,
                                cost: 390,
                                required: [.construction],
                                flavors: [Flavor(type: .cityDefense, value: 5)])
            
            // renaissance
        case .cartography:
            return TechTypeData(name: "Cartography",
                                eurekaSummary: "Build 2 Harbors",
                                era: .renaissance,
                                cost: 490,
                                required: [.shipBuilding],
                                flavors: [Flavor(type: .navalRecon, value: 5)])
        case .massProduction:
            return TechTypeData(name: "Mass Production",
                                eurekaSummary: "Build a Lumber Mill",
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .shipBuilding],
                                flavors: [Flavor(type: .production, value: 7)])
        case .banking:
            return TechTypeData(name: "Banking",
                                eurekaSummary: "Have the Guilds civic",
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .apprenticesship, .stirrups],
                                flavors: [Flavor(type: .gold, value: 6)])
        case .gunpowder:
            return TechTypeData(name: "Gunpowder",
                                eurekaSummary: "Build an Armory",
                                era: .renaissance,
                                cost: 490,
                                required: [.militaryEngineering, .stirrups, .apprenticesship],
                                flavors: [Flavor(type: .production, value: 2), Flavor(type: .defense, value: 3), Flavor(type: .cityDefense, value: 2)])
        case .printing:
            return TechTypeData(name: "Printing",
                                eurekaSummary: "Build 2 Universities",
                                era: .renaissance,
                                cost: 490,
                                required: [.machinery],
                                flavors: [Flavor(type: .science, value: 7)])
        case .squareRigging:
            return TechTypeData(name: "Square Rigging",
                                eurekaSummary: "Kill a unit with a Musketman",
                                era: .renaissance,
                                cost: 600,
                                required: [.cartography],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 2), Flavor(type: .navalRecon, value: 3)])
        case .astronomy:
            return TechTypeData(name: "Astronomy",
                                eurekaSummary: "Build a University next to a Mountain",
                                era: .renaissance,
                                cost: 600,
                                required: [.education],
                                flavors: [Flavor(type: .science, value: 4)])
        case .metalCasting:
            return TechTypeData(name: "Metal Casting",
                                eurekaSummary: "Own 2 Crossbowmen",
                                era: .renaissance,
                                cost: 660,
                                required: [.gunpowder],
                                flavors: [Flavor(type: .production, value: 3)])
        case .siegeTactics:
            return TechTypeData(name: "Siege Tactics",
                                eurekaSummary: "Own 2 Bombards",
                                era: .renaissance,
                                cost: 660,
                                required: [.castles],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 3)])

            // industrial
        case .industrialization:
            return TechTypeData(name: "Industrialization",
                                eurekaSummary: "Build 3 Workshops",
                                era: .industrial,
                                cost: 700,
                                required: [.massProduction, .squareRigging],
                                flavors: [Flavor(type: .production, value: 7)])
        case .scientificTheory:
            return TechTypeData(name: "Scientific Theory",
                                eurekaSummary: "Have The Enlightenment civic",
                                era: .industrial,
                                cost: 700,
                                required: [.astronomy, .banking],
                                flavors: [Flavor(type: .diplomacy, value: 5), Flavor(type: .science, value: 5)])
        case .ballistics:
            return TechTypeData(name: "Ballistics",
                                eurekaSummary: "Have 2 Forts in your territory",
                                era: .industrial,
                                cost: 840,
                                required: [.metalCasting],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 5), ])
        case .militaryScience:
            return TechTypeData(name: "Military Science",
                                eurekaSummary: "Kill a unit with a Knight",
                                era: .industrial,
                                cost: 845,
                                required: [.printing, .siegeTactics],
                                flavors: [Flavor(type: .offense, value: 7),])
        case .steamPower:
            return TechTypeData(name: "Steam Power",
                                eurekaSummary: "Build 2 Shipyards",
                                era: .industrial,
                                cost: 805,
                                required: [.industrialization, .squareRigging],
                                flavors: [Flavor(type: .mobile, value: 5), Flavor(type: .offense, value: 2), Flavor(type: .navalGrowth, value: 3)])
        case .sanitation:
            return TechTypeData(name: "Sanitation",
                                eurekaSummary: "Build 2 Neighborhoods",
                                era: .industrial,
                                cost: 805,
                                required: [.scientificTheory],
                                flavors: [Flavor(type: .growth, value: 5),])
        case .economics:
            return TechTypeData(name: "Economics",
                                eurekaSummary: "Build 2 Banks",
                                era: .industrial,
                                cost: 805,
                                required: [.metalCasting, .scientificTheory],
                                flavors: [Flavor(type: .wonder, value: 5),])
        case .rifling:
            return TechTypeData(name: "Rifling",
                                eurekaSummary: "Build a Niter Mine",
                                era: .industrial,
                                cost: 970,
                                required: [.ballistics, .militaryScience],
                                flavors: [Flavor(type: .offense, value: 5),])
            
            // modern
        case .flight:
            return TechTypeData(name: "Flight",
                                eurekaSummary: "Build an Industrial era or later wonder",
                                era: .modern,
                                cost: 900, required: [.industrialization, .scientificTheory],
                                flavors: [Flavor(type: .mobile, value: 5)])
        case .replaceableParts:
            return TechTypeData(name: "Replaceable Parts",
                                eurekaSummary: "Own 3 Musketmen",
                                era: .modern,
                                cost: 1250,
                                required: [.economics],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .gold, value: 3), Flavor(type: .production, value: 3), ])
        case .steel:
            return TechTypeData(name: "Steel",
                                eurekaSummary: "Build a Coal Mine",
                                era: .modern,
                                cost: 1140,
                                required: [.rifling],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .wonder, value: 3), ])
        case .refining:
            return TechTypeData(name: "Refining",
                                eurekaSummary: "Build 2 Coal Power Plants",
                                era: .modern,
                                cost: 1250,
                                required: [.rifling],
                                flavors: [Flavor(type: .navalGrowth, value: 5), Flavor(type: .tileImprovement, value: 3), ])
        case .electricity:
            return TechTypeData(name: "Electricity",
                                eurekaSummary: "Own 3 Privateers",
                                era: .modern,
                                cost: 985,
                                required: [.steamPower],
                                flavors: [Flavor(type: .navalGrowth, value: 5), Flavor(type: .energy, value: 3), ])
        case .radio:
            return TechTypeData(name: "Radio",
                                eurekaSummary: "Build a National Park",
                                era: .modern,
                                cost: 985,
                                required: [.flight, .steamPower],
                                flavors: [Flavor(type: .expansion, value: 3)])
        case .chemistry:
            return TechTypeData(name: "Chemistry",
                                eurekaSummary: "Complete a Research Agreement.",
                                era: .modern,
                                cost: 985,
                                required: [.sanitation],
                                flavors: [Flavor(type: .growth, value: 4), Flavor(type: .science, value: 5)])
        case .combustrion:
            return TechTypeData(name: "Combustion",
                                eurekaSummary: "Extract an Artifact.",
                                era: .modern,
                                cost: 1250,
                                required: [.steel, .rifling],
                                flavors: [Flavor(type: .offense, value: 4), Flavor(type: .wonder, value: 3), ])
            
            // atomic
        case .advancedFlight:
            return TechTypeData(name: "Advanced Flight",
                                eurekaSummary: "Build 3 Biplanes",
                                era: .atomic,
                                cost: 1065,
                                required: [.radio],
                                flavors: [Flavor(type: .offense, value: 4), ])
        case .rocketry:
            return TechTypeData(name: "Rocketry",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                era: .atomic,
                                cost: 1065,
                                required: [.radio, .chemistry],
                                flavors: [Flavor(type: .science, value: 5)])
        case .advancedBallistics:
            return TechTypeData(name: "Advanced Ballistics",
                                eurekaSummary: "Build 2 Power Plants",
                                era: .information,
                                cost: 1410,
                                required: [.replaceableParts, .steel],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 5)])
        case .combinedArms:
            return TechTypeData(name: "Combined Arms",
                                eurekaSummary: "Build an Airstrip",
                                era: .information,
                                cost: 1480,
                                required: [.steel],
                                flavors: [Flavor(type: .navalGrowth, value: 5), ])
        case .plastics:
            return TechTypeData(name: "Plastics",
                                eurekaSummary: "Build an Oil Well",
                                era: .information,
                                cost: 1065,
                                required: [.combustrion],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .navalTileImprovement, value: 4), ])
        case .computers:
            return TechTypeData(name: "Computers",
                                eurekaSummary: "Have a government with 8 policy slots",
                                era: .atomic,
                                cost: 1195,
                                required: [.electricity, .radio],
                                flavors: [Flavor(type: .growth, value: 2), Flavor(type: .science, value: 4), Flavor(type: .diplomacy, value: 5)])
        case .nuclearFission:
            return TechTypeData(name: "Nuclear Fission",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                era: .atomic,
                                cost: 1195,
                                required: [.combinedArms, .advancedBallistics],
                                flavors: [Flavor(type: .energy, value: 5), ])
        case .syntheticMaterials:
            return TechTypeData(name: "Synthetic Materials",
                                eurekaSummary: "Build 2 Aerodromes",
                                era: .atomic,
                                cost: 1195,
                                required: [.plastics],
                                flavors: [Flavor(type: .gold, value: 4), Flavor(type: .offense, value: 2)])
            
            // information
        case .telecommunications:
            return TechTypeData(name: "Telecommunications",
                                eurekaSummary: "Build 2 Broadcast Centers",
                                era: .information,
                                cost: 1340,
                                required: [.computers],
                                flavors: [Flavor(type: .offense, value: 3)])
        case .satellites:
            return TechTypeData(name: "Satellites",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                era: .information,
                                cost: 1340,
                                required: [.advancedFlight, .rocketry],
                                flavors: [Flavor(type: .science, value: 3), Flavor(type: .expansion, value: 3)])
        case .guidanceSystems:
            return TechTypeData(name: "Guidance Systems",
                                eurekaSummary: "Kill a Fighter",
                                era: .information,
                                cost: 1580,
                                required: [.rocketry, .advancedBallistics],
                                flavors: [Flavor(type: .offense, value: 5), ])
        case .lasers:
            return TechTypeData(name: "Lasers",
                                eurekaSummary: "Boost through Great Scientist or Spy.",
                                era: .information,
                                cost: 1340,
                                required: [.nuclearFission],
                                flavors: [Flavor(type: .navalGrowth, value: 5), ])
        case .composites:
            return TechTypeData(name: "Composites",
                                eurekaSummary: "Own 3 Tanks",
                                era: .information,
                                cost: 1340,
                                required: [.syntheticMaterials],
                                flavors: [Flavor(type: .offense, value: 6)])
        case .stealthTechnology:
            return TechTypeData(name: "Stealth Technology",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                era: .information,
                                cost: 1340,
                                required: [.syntheticMaterials],
                                flavors: [Flavor(type: .offense, value: 3)])
        case .robotics:
            return TechTypeData(name: "Robotics",
                                eurekaSummary: "Have the Globalization civic.",
                                era: .information,
                                cost: 1560,
                                required: [.computers],
                                flavors: [Flavor(type: .production, value: 3), Flavor(type: .offense, value: 3),])
        case .nuclearFusion:
            return TechTypeData(name: "Nuclear Fusion",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                era: .information,
                                cost: 1560,
                                required: [.lasers],
                                flavors: [Flavor(type: .energy, value: 3),])
        case .nanotechnology:
            return TechTypeData(name: "Nanotechnology",
                                eurekaSummary: "Build an Aluminum Mine",
                                era: .information,
                                cost: 1560,
                                required: [.composites],
                                flavors: [Flavor(type: .science, value: 3)])
            
            // future
        case .futureTech:
            return TechTypeData(name: "Future Tech",
                                eurekaSummary: "---",
                                era: .future,
                                cost: 1780,
                                required: [.robotics, .nuclearFusion],
                                flavors: [])
        }
    }
}
