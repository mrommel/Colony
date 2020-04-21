//
//  TechType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum TechType: String, Codable {
    
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

    static var all: [TechType] {
        return [
            // ancient
            .mining, .pottery, .animalHusbandry, .sailing, .astrology, .irrigation, .writing, .masonry, .archery, .bronzeWorking, .wheel,
            
            // classical
            .celestialNavigation, horsebackRiding, .currency, .construction, .ironWorking, .shipBuilding, .mathematics, .engineering,
            
            // medieval
            .militaryTactics, .buttress, .apprenticesship, .stirrups, .machinery, .education, .militaryEngineering, .castles,
            
            // renaissance
            .cartography, .massProduction, .banking, .gunpowder, .printing, .squareRigging, .astronomy, .metalCasting, .siegeTactics]
    }
    
    public func name() -> String {
        
        return self.data().name
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
    
    // MARK private
    
    private struct TechTypeData {
        
        let name: String
        let era: EraType
        let cost: Int
        let required: [TechType]
        let flavors: [Flavor]
    }
    
    private func data() -> TechTypeData {
        
        switch self {

            // ancient
        case .mining:
            return TechTypeData(name: "Mining",
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .production, value: 3), Flavor(type: .tileImprovement, value: 2)])
        case .pottery:
            return TechTypeData(name: "Pottery",
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .growth, value: 5)])
        case .animalHusbandry:
            return TechTypeData(name: "Animal Husbandry",
                                era: .ancient,
                                cost: 25,
                                required: [],
                                flavors: [Flavor(type: .mobile, value: 4), Flavor(type: .tileImprovement, value: 1)])
        case .sailing:
            return TechTypeData(name: "Sailing",
                                era: .ancient,
                                cost: 50,
                                required: [],
                                flavors: [Flavor(type: .naval, value: 3), Flavor(type: .navalTileImprovement, value: 3), Flavor(type: .wonder, value: 3), Flavor(type: .navalRecon, value: 2)])
        case .astrology:
            return TechTypeData(name: "Astrology",
                                era: .ancient,
                                cost: 50,
                                required: [],
                                flavors: [Flavor(type: .happiness, value: 10), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 4)])
        case .irrigation:
            return TechTypeData(name: "Irrigation",
                                era: .ancient,
                                cost: 50,
                                required: [.pottery],
                                flavors: [Flavor(type: .growth, value: 5)])
        case .writing:
            return TechTypeData(name: "Writing",
                                era: .ancient,
                                cost: 50,
                                required: [.pottery],
                                flavors: [Flavor(type: .science, value: 6), Flavor(type: .wonder, value: 2), Flavor(type: .diplomacy, value: 2)])
        case .masonry:
            return TechTypeData(name: "Masonry",
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .cityDefense, value: 4), Flavor(type: .happiness, value: 2), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 2)])
        case .archery:
            return TechTypeData(name: "Archery",
                                era: .ancient,
                                cost: 50,
                                required: [.animalHusbandry],
                                flavors: [Flavor(type: .ranged, value: 4), Flavor(type: .offense, value: 1)])
        case .bronzeWorking:
            return TechTypeData(name: "Bronze Working",
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .defense, value: 4), Flavor(type: .militaryTraining, value: 4), Flavor(type: .wonder, value: 2)])
        case .wheel:
            return TechTypeData(name: "Wheel",
                                era: .ancient,
                                cost: 80,
                                required: [.mining],
                                flavors: [Flavor(type: .mobile, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .ranged, value: 2), Flavor(type: .infrastructure, value: 2), Flavor(type: .gold, value: 6)])
            
            // classical
        case .celestialNavigation:
            return TechTypeData(name: "Celestrial Navigation",
                                era: .classical,
                                cost: 120,
                                required: [.sailing, .astrology],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 5)])
        case .horsebackRiding:
            return TechTypeData(name: "Horseback Riding",
                                era: .classical,
                                cost: 120,
                                required: [.animalHusbandry],
                                flavors: [Flavor(type: .mobile, value: 7), Flavor(type: .happiness, value: 3)])
        case .currency:
            return TechTypeData(name: "Currency",
                                era: .classical,
                                cost: 120,
                                required: [.writing],
                                flavors: [Flavor(type: .gold, value: 8), Flavor(type: .wonder, value: 2)])
        case .construction:
            return TechTypeData(name: "Construction",
                                era: .classical,
                                cost: 200,
                                required: [.masonry, .horsebackRiding],
                                flavors: [Flavor(type: .happiness, value: 17), Flavor(type: .infrastructure, value: 2), Flavor(type: .wonder, value: 2)])
        case .ironWorking:
            return TechTypeData(name: "Iron Working",
                                era: .classical,
                                cost: 120,
                                required: [.bronzeWorking],
                                flavors: [Flavor(type: .offense, value: 12), Flavor(type: .defense, value: 6), Flavor(type: .militaryTraining, value: 3)])
        case .shipBuilding:
            return TechTypeData(name: "Ship Building",
                                era: .classical,
                                cost: 200,
                                required: [.sailing],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 3), Flavor(type: .navalRecon, value: 2)])
        case .mathematics:
            return TechTypeData(name: "Mathematics",
                                era: .classical,
                                cost: 200,
                                required: [.currency],
                                flavors: [Flavor(type: .ranged, value: 8), Flavor(type: .wonder, value: 2)])
        case .engineering:
            return TechTypeData(name: "Engeneering",
                                era: .classical,
                                cost: 200,
                                required: [.wheel],
                                flavors: [Flavor(type: .defense, value: 2), Flavor(type: .production, value: 5), Flavor(type: .tileImprovement, value: 5)])
            
            // medieval
        case .militaryTactics:
            return TechTypeData(name: "Military Tactics",
                                era: .medieval,
                                cost: 275,
                                required: [.mathematics],
                                flavors: [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .cityDefense, value: 2), Flavor(type: .wonder, value: 2),])
        case .buttress:
            return TechTypeData(name: "Buttress",
                                era: .medieval,
                                cost: 300,
                                required: [.shipBuilding, .mathematics],
                                flavors: [Flavor(type: .wonder, value: 2)])
        case .apprenticesship:
            return TechTypeData(name: "Apprenticesship",
                                era: .medieval,
                                cost: 275,
                                required: [.currency, .horsebackRiding],
                                flavors: [Flavor(type: .gold, value: 5), Flavor(type: .production, value: 3)])
        case .stirrups:
            return TechTypeData(name: "Stirrups",
                                era: .medieval,
                                cost: 360,
                                required: [.horsebackRiding],
                                flavors: [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .defense, value: 2), Flavor(type: .wonder, value: 2)])
        case .machinery:
            return TechTypeData(name: "Machinery",
                                era: .medieval,
                                cost: 275,
                                required: [.ironWorking, .engineering],
                                flavors: [Flavor(type: .ranged, value: 8), Flavor(type: .infrastructure, value: 2),])
        case .education:
            return TechTypeData(name: "Education",
                                era: .medieval,
                                cost: 335,
                                required: [.apprenticesship, .mathematics],
                                flavors: [Flavor(type: .science, value: 8), Flavor(type: .wonder, value: 2)])
        case .militaryEngineering:
            return TechTypeData(name: "Military Engineering",
                                era: .medieval,
                                cost: 335,
                                required: [.construction],
                                flavors: [Flavor(type: .defense, value: 5), Flavor(type: .production, value: 2)])
        case .castles:
            return TechTypeData(name: "Castles",
                                era: .medieval,
                                cost: 390,
                                required: [.construction],
                                flavors: [Flavor(type: .cityDefense, value: 5)])
            
            // renaissance
        case .cartography:
            return TechTypeData(name: "Cartography",
                                era: .renaissance,
                                cost: 490,
                                required: [.shipBuilding],
                                flavors: [Flavor(type: .navalRecon, value: 5)])
        case .massProduction:
            return TechTypeData(name: "Mass Production",
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .shipBuilding],
                                flavors: [Flavor(type: .production, value: 7)])
        case .banking:
            return TechTypeData(name: "Banking",
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .apprenticesship, .stirrups],
                                flavors: [Flavor(type: .gold, value: 6)])
        case .gunpowder:
            return TechTypeData(name: "Gunpowder",
                                era: .renaissance,
                                cost: 490,
                                required: [.militaryEngineering, .stirrups, .apprenticesship],
                                flavors: [Flavor(type: .production, value: 2), Flavor(type: .defense, value: 3), Flavor(type: .cityDefense, value: 2)])
        case .printing:
            return TechTypeData(name: "Printing",
                                era: .renaissance,
                                cost: 490,
                                required: [.machinery],
                                flavors: [Flavor(type: .science, value: 7)])
        case .squareRigging:
            return TechTypeData(name: "Square Rigging",
                                era: .renaissance,
                                cost: 600,
                                required: [.cartography],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 2), Flavor(type: .navalRecon, value: 3)])
        case .astronomy:
            return TechTypeData(name: "Astronomy",
                                era: .renaissance,
                                cost: 600,
                                required: [.education],
                                flavors: [Flavor(type: .science, value: 4)])
        case .metalCasting:
            return TechTypeData(name: "Metal Casting",
                                era: .renaissance,
                                cost: 660,
                                required: [.gunpowder],
                                flavors: [Flavor(type: .production, value: 3)])
        case .siegeTactics:
            return TechTypeData(name: "Siege Tactics",
                                era: .renaissance,
                                cost: 660,
                                required: [.castles],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 3)])

            // industrial
        }
    }
}
