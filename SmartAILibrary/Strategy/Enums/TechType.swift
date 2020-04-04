//
//  TechType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum TechType: Int, Codable {
    
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
        return [.mining, .pottery, .animalHusbandry, .sailing, .astrology, .irrigation, .writing, .masonry, .archery, .bronzeWorking, .wheel,
                    .celestialNavigation, horsebackRiding, .currency, .construction, .ironWorking, .shipBuilding, .mathematics, .engineering,
                    .militaryTactics, .buttress, .apprenticesship, .stirrups, .machinery, .education, .militaryEngineering, .castles,
                    .cartography, .massProduction, .banking, .gunpowder, .printing, .squareRigging, .astronomy, .metalCasting, .siegeTactics]
    }

    func era() -> EraType {

        switch self {

            // ancient
        case .pottery: return .ancient
        case .animalHusbandry: return .ancient
        case .mining: return .ancient
        case .sailing: return .ancient
        case .astrology: return .ancient
        case .irrigation: return .ancient
        case .writing: return .ancient
        case .archery: return .ancient
        case .masonry: return .ancient
        case .bronzeWorking: return .ancient
        case .wheel: return .ancient

            // classical
        case .celestialNavigation: return .classical
        case .currency: return .classical
        case .horsebackRiding: return .classical
        case .ironWorking: return .classical
        case .shipBuilding: return .classical
        case .mathematics: return .classical
        case .construction: return .classical
        case .engineering: return .classical

            // medieval
        case .militaryTactics: return .medieval
        case .buttress: return .medieval
        case .apprenticesship: return .medieval
        case .stirrups: return .medieval
        case .machinery: return .medieval
        case .education: return .medieval
        case .militaryEngineering: return .medieval
        case .castles: return .medieval

            // renaissance
        case .cartography: return .renaissance
        case .massProduction: return .renaissance
        case .banking: return .renaissance
        case .gunpowder: return .renaissance
        case .printing: return .renaissance
        case .squareRigging: return .renaissance
        case .astronomy: return .renaissance
        case .metalCasting: return .renaissance
        case .siegeTactics: return .renaissance

            // industrial
        }
    }

    func cost() -> Int {

        switch self {

            // ancient
        case .pottery: return 25
        case .mining: return 25
        case .animalHusbandry: return 25
        case .sailing: return 50
        case .astrology: return 50
        case .irrigation: return 50
        case .writing: return 50
        case .archery: return 50
        case .masonry: return 80
        case .bronzeWorking: return 80
        case .wheel: return 80

            // classical
        case .celestialNavigation: return 120
        case .currency: return 120
        case .horsebackRiding: return 120
        case .ironWorking: return 120
        case .shipBuilding: return 200
        case .mathematics: return 200
        case .construction: return 200
        case .engineering: return 200

            // medieval
        case .militaryTactics: return 275
        case .buttress: return 300
        case .apprenticesship: return 275
        case .stirrups: return 360
        case .machinery: return 275
        case .education: return 335
        case .militaryEngineering: return 335
        case .castles: return 390

            // renaissance
        case .cartography: return 490
        case .massProduction: return 490
        case .banking: return 490
        case .gunpowder: return 490
        case .printing: return 490
        case .squareRigging: return 600
        case .astronomy: return 600
        case .metalCasting: return 660
        case .siegeTactics: return 660

            // industrial
        }
    }

    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Technologies.xml
    func required() -> [TechType] {

        switch self {

            // ancient
        case .pottery: return []
        case .mining: return []
        case .animalHusbandry: return []
        case .sailing: return []
        case .astrology: return []
        case .irrigation: return [.pottery]
        case .writing: return [.pottery]
        case .archery: return [.animalHusbandry]
        case .masonry: return [.mining]
        case .bronzeWorking: return [.mining]
        case .wheel: return [.mining]

            // classical
        case .celestialNavigation: return [.sailing, .astrology]
        case .currency: return [.writing]
        case .horsebackRiding: return [.animalHusbandry]
        case .ironWorking: return [.bronzeWorking]
        case .shipBuilding: return [.sailing]
        case .mathematics: return [.currency]
        case .construction: return [.masonry, .horsebackRiding]
        case .engineering: return [.wheel]

            // medieval
        case .militaryTactics: return [.mathematics]
        case .buttress: return [.shipBuilding, .mathematics]
        case .apprenticesship: return [.currency, .horsebackRiding]
        case .stirrups: return [.horsebackRiding]
        case .machinery: return [.ironWorking, .engineering]
        case .education: return [.apprenticesship, .mathematics]
        case .militaryEngineering: return [.construction]
        case .castles: return [.construction]

            // renaissance
        case .cartography: return [.shipBuilding]
        case .massProduction: return [.education, .shipBuilding]
        case .banking: return [.education, .apprenticesship, .stirrups]
        case .gunpowder: return [.militaryEngineering, .stirrups, .apprenticesship]
        case .printing: return [.machinery]
        case .squareRigging: return [.cartography]
        case .astronomy: return [.education]
        case .metalCasting: return [.gunpowder]
        case .siegeTactics: return [.castles]

            // industrial

        }
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

        switch self {

            // ancient
        case .pottery: return [Flavor(type: .growth, value: 5)]
        case .mining: return [Flavor(type: .production, value: 3), Flavor(type: .tileImprovement, value: 2)]
        case .animalHusbandry: return [Flavor(type: .mobile, value: 4), Flavor(type: .tileImprovement, value: 1)]
        case .sailing: return [Flavor(type: .naval, value: 3), Flavor(type: .navalTileImprovement, value: 3), Flavor(type: .wonder, value: 3), Flavor(type: .navalRecon, value: 2)]
        case .astrology: return [Flavor(type: .happiness, value: 10), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 4)]
        case .irrigation: return [Flavor(type: .growth, value: 5)]
        case .writing: return [Flavor(type: .science, value: 6), Flavor(type: .wonder, value: 2), Flavor(type: .diplomacy, value: 2)]
        case .archery: return [Flavor(type: .ranged, value: 4), Flavor(type: .offense, value: 1)]
        case .masonry: return [Flavor(type: .cityDefense, value: 4), Flavor(type: .happiness, value: 2), Flavor(type: .tileImprovement, value: 2), Flavor(type: .wonder, value: 2)]
        case .bronzeWorking: return [Flavor(type: .defense, value: 4), Flavor(type: .militaryTraining, value: 4), Flavor(type: .wonder, value: 2)]
        case .wheel: return [Flavor(type: .mobile, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .ranged, value: 2), Flavor(type: .infrastructure, value: 2), Flavor(type: .gold, value: 6)]

            // classical
        case .celestialNavigation: return [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 5)]
        case .currency: return [Flavor(type: .gold, value: 8), Flavor(type: .wonder, value: 2)]
        case .horsebackRiding: return [Flavor(type: .mobile, value: 7), Flavor(type: .happiness, value: 3)]
        case .ironWorking: return [Flavor(type: .offense, value: 12), Flavor(type: .defense, value: 6), Flavor(type: .militaryTraining, value: 3)]
        case .shipBuilding: return [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 3), Flavor(type: .navalRecon, value: 2)]
        case .mathematics: return [Flavor(type: .ranged, value: 8), Flavor(type: .wonder, value: 2)]
        case .construction: return [Flavor(type: .happiness, value: 17), Flavor(type: .infrastructure, value: 2), Flavor(type: .wonder, value: 2)]
        case .engineering: return [Flavor(type: .defense, value: 2), Flavor(type: .production, value: 5), Flavor(type: .tileImprovement, value: 5)]

            // medieval
        case .militaryTactics: return [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .cityDefense, value: 2), Flavor(type: .wonder, value: 2),]
        case .buttress: return [Flavor(type: .wonder, value: 2)]
        case .apprenticesship: return [Flavor(type: .gold, value: 5), Flavor(type: .production, value: 3)]
        case .stirrups: return [Flavor(type: .offense, value: 3), Flavor(type: .mobile, value: 3), Flavor(type: .defense, value: 2), Flavor(type: .wonder, value: 2)]
        case .machinery: return [Flavor(type: .ranged, value: 8), Flavor(type: .infrastructure, value: 2),]
        case .education: return [Flavor(type: .science, value: 8), Flavor(type: .wonder, value: 2)]
        case .militaryEngineering: return [Flavor(type: .defense, value: 5), Flavor(type: .production, value: 2)]
        case .castles: return [Flavor(type: .cityDefense, value: 5)]

            // renaissance
        case .cartography: return [Flavor(type: .navalRecon, value: 5)]
        case .massProduction: return [Flavor(type: .production, value: 7)]
        case .banking: return [Flavor(type: .gold, value: 6)]
        case .gunpowder: return [Flavor(type: .production, value: 2), Flavor(type: .defense, value: 3), Flavor(type: .cityDefense, value: 2)]
        case .printing: return [Flavor(type: .science, value: 7)]
        case .squareRigging: return [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 2), Flavor(type: .navalRecon, value: 3)]
        case .astronomy: return [Flavor(type: .science, value: 4)]
        case .metalCasting: return [Flavor(type: .production, value: 3)]
        case .siegeTactics: return [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 3)]

            // industrial

        }
    }
}
