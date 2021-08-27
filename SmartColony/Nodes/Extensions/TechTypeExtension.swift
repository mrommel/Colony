//
//  TechTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension TechType {

    func iconTexture() -> String {

        switch self {

        case .none: return "tech_default"

            // ancient
        case .mining: return "tech_mining"
        case .pottery: return "tech_pottery"
        case .animalHusbandry: return "tech_animalHusbandry"
        case .sailing: return "tech_sailing"
        case .astrology: return "tech_astrology"
        case .irrigation: return "tech_irrigation"
        case .writing: return "tech_writing"
        case .masonry: return "tech_masonry"
        case .archery: return "tech_archery"
        case .bronzeWorking: return "tech_bronzeWorking"
        case .wheel: return "tech_wheel"

            // classical
        case .celestialNavigation: return "tech_celestialNavigation"
        case .horsebackRiding: return "tech_horsebackRiding"
        case .currency: return "tech_currency"
        case .construction: return "tech_construction"
        case .ironWorking: return "tech_ironWorking"
        case .shipBuilding: return "tech_shipBuilding"
        case .mathematics: return "tech_mathematics"
        case .engineering: return "tech_engineering"

            // medieval
        case .militaryTactics: return "tech_default"
        case .buttress: return "tech_default"
        case .apprenticeship: return "tech_default"
        case .stirrups: return "tech_default"
        case .machinery: return "tech_default"
        case .education: return "tech_default"
        case .militaryEngineering: return "tech_default"
        case .castles: return "tech_default"

            // renaissance
        case .cartography: return "tech_default"
        case .massProduction: return "tech_default"
        case .banking: return "tech_default"
        case .gunpowder: return "tech_default"
        case .printing: return "tech_default"
        case .squareRigging: return "tech_default"
        case .astronomy: return "tech_default"
        case .metalCasting: return "tech_default"
        case .siegeTactics: return "tech_default"

            // industrial
        case .industrialization: return "tech_default"
        case .scientificTheory: return "tech_default"
        case .ballistics: return "tech_default"
        case .militaryScience: return "tech_default"
        case .steamPower: return "tech_default"
        case .sanitation: return "tech_default"
        case .economics: return "tech_default"
        case .rifling: return "tech_default"

            // modern
        case .flight: return "tech_default"
        case .replaceableParts: return "tech_default"
        case .steel: return "tech_default"
        case .refining: return "tech_default"
        case .electricity: return "tech_default"
        case .radio: return "tech_default"
        case .chemistry: return "tech_default"
        case .combustrion: return "tech_default"

            // atomic
        case .advancedFlight: return "tech_default"
        case .rocketry: return "tech_default"
        case .advancedBallistics: return "tech_default"
        case .combinedArms: return "tech_default"
        case .plastics: return "tech_default"
        case .computers: return "tech_default"
        case .nuclearFission: return "tech_default"
        case .syntheticMaterials: return "tech_default"

            // information
        case .telecommunications: return "tech_default"
        case .satellites: return "tech_default"
        case .guidanceSystems: return "tech_default"
        case .lasers: return "tech_default"
        case .composites: return "tech_default"
        case .stealthTechnology: return "tech_default"
        case .robotics: return "tech_default"
        case .nuclearFusion: return "tech_default"
        case .nanotechnology: return "tech_default"

        case .futureTech: return "tech_default"
        }
    }
}
