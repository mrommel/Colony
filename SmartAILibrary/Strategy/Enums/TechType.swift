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
    public let districtTypes: [DistrictType]
}

// https://github.com/fredzgreen/Civilization6_SwedishTranslation/blob/2591dc66a1674477a1857763d0b46e88d00a265b/XMLFiles/Technologies_Text.xml
// swiftlint:disable type_body_length
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
    case apprenticeship
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

    public static var all: [TechType] {
        return [
            // ancient
            .mining, .pottery, .animalHusbandry, .sailing, .astrology, .irrigation, .writing, .masonry, .archery, .bronzeWorking, .wheel,

            // classical
            .celestialNavigation, horsebackRiding, .currency, .construction, .ironWorking, .shipBuilding, .mathematics, .engineering,

            // medieval
            .militaryTactics, .buttress, .apprenticeship, .stirrups, .machinery, .education, .militaryEngineering, .castles,

            // renaissance
            .cartography, .massProduction, .banking, .gunpowder, .printing, .squareRigging, .astronomy, .metalCasting, .siegeTactics,

            // industrial
            .industrialization, .scientificTheory, .ballistics, .militaryScience, .steamPower, .sanitation, .economics, .rifling,

            // modern
            .flight, .replaceableParts, .steel, .refining, .electricity, .radio, .chemistry, .combustrion,

            // atomic
            .advancedFlight, .rocketry, .advancedBallistics, .combinedArms, .plastics, .computers, .nuclearFission, .syntheticMaterials,

            // information
            .telecommunications, .satellites, .guidanceSystems, .lasers, .composites, .stealthTechnology, .robotics, .nuclearFusion, . nanotechnology,

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

    public func eurekaDescription() -> String {

        return self.data().eurekaDescription
    }

    public func quoteTexts() -> [String] {

        return self.data().quoteTexts
    }

    public func era() -> EraType {

        return self.data().era
    }

    public func cost() -> Int {

        return self.data().cost
    }

    public func required() -> [TechType] {

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
            if let tech = $0.requiredTech() {
                return tech == self
            } else {
                return false
            }
        })

        // districts
        let districts = DistrictType.all.filter({
            if let district = $0.requiredTech() {
                return district == self
            } else {
                return false
            }
        })

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

        return TechAchievements(buildingTypes: buildings, unitTypes: units, wonderTypes: wonders, buildTypes: builds, districtTypes: districts)
    }

    // MARK: private

    private struct TechTypeData {

        let name: String
        let eurekaSummary: String
        let eurekaDescription: String
        let quoteTexts: [String]
        let era: EraType
        let cost: Int
        let required: [TechType]
        let flavors: [Flavor]
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable line_length
    // swiftlint:disable cyclomatic_complexity
    // https://github.com/caiobelfort/civ6_personal_mod/blob/9fdf8736016d855990556c71cc76a62f124f5822/Gameplay/Data/Technologies.xml
    private func data() -> TechTypeData {

        switch self {

        case .none:
            return TechTypeData(
                name: "---",
                eurekaSummary: "",
                eurekaDescription: "",
                quoteTexts: [],
                era: .ancient,
                cost: -1,
                required: [],
                flavors: []
            )

            // ancient
        case .mining:
            // https://civilization.fandom.com/wiki/Mining_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MINING_NAME",
                eurekaSummary: "TXT_KEY_TECH_MINING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MINING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MINING_QUOTE1",
                    "TXT_KEY_TECH_MINING_QUOTE2"
                ],
                era: .ancient,
                cost: 25,
                required: [],
                flavors: [
                    Flavor(type: .production, value: 3),
                    Flavor(type: .tileImprovement, value: 2)
                ]
            )

        case .pottery:
            // https://civilization.fandom.com/wiki/Pottery_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_POTTERY_NAME",
                eurekaSummary: "TXT_KEY_TECH_POTTERY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_POTTERY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_POTTERY_QUOTE1",
                    "TXT_KEY_TECH_POTTERY_QUOTE2"
                ],
                era: .ancient,
                cost: 25,
                required: [],
                flavors: [
                    Flavor(type: .growth, value: 5)
                ]
            )

        case .animalHusbandry:
            // https://civilization.fandom.com/wiki/Animal_Husbandry_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ANIMAL_HUSBANDRY_NAME",
                eurekaSummary: "TXT_KEY_TECH_ANIMAL_HUSBANDRY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ANIMAL_HUSBANDRY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ANIMAL_HUSBANDRY_QUOTE1",
                    "TXT_KEY_TECH_ANIMAL_HUSBANDRY_QUOTE2"
                ],
                era: .ancient,
                cost: 25,
                required: [],
                flavors: [
                    Flavor(type: .mobile, value: 4),
                    Flavor(type: .tileImprovement, value: 1)
                ]
            )

        case .sailing:
            // https://civilization.fandom.com/wiki/Sailing_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SAILING_NAME",
                eurekaSummary: "TXT_KEY_TECH_SAILING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SAILING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SAILING_QUOTE1",
                    "TXT_KEY_TECH_SAILING_QUOTE2"
                ],
                era: .ancient,
                cost: 50,
                required: [],
                flavors: [
                    Flavor(type: .naval, value: 3),
                    Flavor(type: .navalTileImprovement, value: 3),
                    Flavor(type: .wonder, value: 3),
                    Flavor(type: .navalRecon, value: 2)
                ]
            )

        case .astrology:
            // https://civilization.fandom.com/wiki/Astrology_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ASTROLOGY_NAME",
                eurekaSummary: "TXT_KEY_TECH_ASTROLOGY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ASTROLOGY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ASTROLOGY_QUOTE1",
                    "TXT_KEY_TECH_ASTROLOGY_QUOTE2"
                ],
                era: .ancient,
                cost: 50,
                required: [],
                flavors: [
                    Flavor(type: .happiness, value: 10),
                    Flavor(type: .tileImprovement, value: 2),
                    Flavor(type: .wonder, value: 4)
                ]
            )

        case .irrigation:
            // https://civilization.fandom.com/wiki/Irrigation_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_IRRIGATION_NAME",
                eurekaSummary: "TXT_KEY_TECH_IRRIGATION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_IRRIGATION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_IRRIGATION_QUOTE1",
                    "TXT_KEY_TECH_IRRIGATION_QUOTE2"
                ],
                era: .ancient,
                cost: 50,
                required: [.pottery],
                flavors: [
                    Flavor(type: .growth, value: 5)
                ]
            )

        case .writing:
            // https://civilization.fandom.com/wiki/Writing_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_WRITING_NAME",
                eurekaSummary: "TXT_KEY_TECH_WRITING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_WRITING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_WRITING_QUOTE1",
                    "TXT_KEY_TECH_WRITING_QUOTE2"
                ],
                era: .ancient,
                cost: 50,
                required: [.pottery],
                flavors: [
                    Flavor(type: .science, value: 6),
                    Flavor(type: .wonder, value: 2),
                    Flavor(type: .diplomacy, value: 2)
                ]
            )

        case .masonry:
            // https://civilization.fandom.com/wiki/Masonry_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MASONRY_NAME",
                eurekaSummary: "TXT_KEY_TECH_MASONRY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MASONRY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MASONRY_QUOTE1",
                    "TXT_KEY_TECH_MASONRY_QUOTE2"
                ],
                era: .ancient,
                cost: 80,
                required: [.mining],
                flavors: [
                    Flavor(type: .cityDefense, value: 4),
                    Flavor(type: .happiness, value: 2),
                    Flavor(type: .tileImprovement, value: 2),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .archery:
            // https://civilization.fandom.com/wiki/Archery_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ARCHERY_NAME",
                eurekaSummary: "TXT_KEY_TECH_ARCHERY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ARCHERY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ARCHERY_QUOTE1",
                    "TXT_KEY_TECH_ARCHERY_QUOTE2"
                ],
                era: .ancient,
                cost: 50,
                required: [.animalHusbandry],
                flavors: [
                    Flavor(type: .ranged, value: 4),
                    Flavor(type: .offense, value: 1)
                ]
            )

        case .bronzeWorking:
            // https://civilization.fandom.com/wiki/Bronze_Working_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_BRONZE_WORKING_NAME",
                eurekaSummary: "TXT_KEY_TECH_BRONZE_WORKING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_BRONZE_WORKING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_BRONZE_WORKING_QUOTE1",
                    "TXT_KEY_TECH_BRONZE_WORKING_QUOTE2"
                ],
                era: .ancient,
                cost: 80,
                required: [.mining],
                flavors: [
                    Flavor(type: .defense, value: 4),
                    Flavor(type: .militaryTraining, value: 4),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .wheel:
            // https://civilization.fandom.com/wiki/Wheel_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_WHEEL_NAME",
                eurekaSummary: "TXT_KEY_TECH_WHEEL_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_WHEEL_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_WHEEL_QUOTE1",
                    "TXT_KEY_TECH_WHEEL_QUOTE2"
                ],
                era: .ancient,
                cost: 80,
                required: [.mining],
                flavors: [
                    Flavor(type: .mobile, value: 2),
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .ranged, value: 2),
                    Flavor(type: .infrastructure, value: 2),
                    Flavor(type: .gold, value: 6)
                ]
            )

            // /////////////////////////////////
            // classical

        case .celestialNavigation:
            // https://civilization.fandom.com/wiki/Celestial_Navigation_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_CELECSTIAL_NAVIGATION_NAME",
                eurekaSummary: "TXT_KEY_TECH_CELECSTIAL_NAVIGATION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_CELECSTIAL_NAVIGATION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_CELECSTIAL_NAVIGATION_QUOTE1",
                    "TXT_KEY_TECH_CELECSTIAL_NAVIGATION_QUOTE2"
                ],
                era: .classical,
                cost: 120,
                required: [.sailing, .astrology],
                flavors: [
                    Flavor(type: .naval, value: 5),
                    Flavor(type: .navalGrowth, value: 5)
                ]
            )

        case .horsebackRiding:
            // https://civilization.fandom.com/wiki/Horseback_Riding_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_HORSEBACK_RIDING_NAME",
                eurekaSummary: "TXT_KEY_TECH_HORSEBACK_RIDING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_HORSEBACK_RIDING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_HORSEBACK_RIDING_QUOTE1",
                    "TXT_KEY_TECH_HORSEBACK_RIDING_QUOTE2"
                ],
                era: .classical,
                cost: 120,
                required: [.animalHusbandry],
                flavors: [
                    Flavor(type: .mobile, value: 7),
                    Flavor(type: .happiness, value: 3)
                ]
            )

        case .currency:
            // https://civilization.fandom.com/wiki/Currency_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_CURRENCY_NAME",
                eurekaSummary: "TXT_KEY_TECH_CURRENCY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_CURRENCY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_CURRENCY_QUOTE1",
                    "TXT_KEY_TECH_CURRENCY_QUOTE2"
                ],
                era: .classical,
                cost: 120,
                required: [.writing],
                flavors: [
                    Flavor(type: .gold, value: 8),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .construction:
            // https://civilization.fandom.com/wiki/Construction_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_CONSTRUCTION_NAME",
                eurekaSummary: "TXT_KEY_TECH_CONSTRUCTION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_CONSTRUCTION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_CONSTRUCTION_QUOTE1",
                    "TXT_KEY_TECH_CONSTRUCTION_QUOTE2"
                ],
                era: .classical,
                cost: 200,
                required: [.masonry, .horsebackRiding],
                flavors: [
                    Flavor(type: .happiness, value: 17),
                    Flavor(type: .infrastructure, value: 2),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .ironWorking:
            // https://civilization.fandom.com/wiki/Iron_Working_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_IRON_WORKING_NAME",
                eurekaSummary: "TXT_KEY_TECH_IRON_WORKING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_IRON_WORKING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_IRON_WORKING_QUOTE1",
                    "TXT_KEY_TECH_IRON_WORKING_QUOTE2"
                ],
                era: .classical,
                cost: 120,
                required: [.bronzeWorking],
                flavors: [
                    Flavor(type: .offense, value: 12),
                    Flavor(type: .defense, value: 6),
                    Flavor(type: .militaryTraining, value: 3)
                ]
            )

        case .shipBuilding:
            // https://civilization.fandom.com/wiki/Shipbuilding_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SHIP_BUILDING_NAME",
                eurekaSummary: "TXT_KEY_TECH_SHIP_BUILDING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SHIP_BUILDING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SHIP_BUILDING_QUOTE1",
                    "TXT_KEY_TECH_SHIP_BUILDING_QUOTE2"
                ],
                era: .classical,
                cost: 200,
                required: [.sailing],
                flavors: [
                    Flavor(type: .naval, value: 5),
                    Flavor(type: .navalGrowth, value: 3),
                    Flavor(type: .navalRecon, value: 2)
                ]
            )

        case .mathematics:
            // https://civilization.fandom.com/wiki/Mathematics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MATHEMATICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_MATHEMATICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MATHEMATICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MATHEMATICS_QUOTE1",
                    "TXT_KEY_TECH_MATHEMATICS_QUOTE2"
                ],
                era: .classical,
                cost: 200,
                required: [.currency],
                flavors: [
                    Flavor(type: .ranged, value: 8),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .engineering:
            // https://civilization.fandom.com/wiki/Engineering_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ENGINEERING_NAME",
                eurekaSummary: "TXT_KEY_TECH_ENGINEERING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ENGINEERING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ENGINEERING_QUOTE1",
                    "TXT_KEY_TECH_ENGINEERING_QUOTE2"
                ],
                era: .classical,
                cost: 200,
                required: [.wheel],
                flavors: [
                    Flavor(type: .defense, value: 2),
                    Flavor(type: .production, value: 5),
                    Flavor(type: .tileImprovement, value: 5)
                ]
            )

            // /////////////////////////////////
            // medieval

        case .militaryTactics:
            // https://civilization.fandom.com/wiki/Military_Tactics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MILITARY_TACTICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_MILITARY_TACTICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MILITARY_TACTICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MILITARY_TACTICS_QUOTE1",
                    "TXT_KEY_TECH_MILITARY_TACTICS_QUOTE2"
                ],
                era: .medieval,
                cost: 275,
                required: [.mathematics],
                flavors: [
                    Flavor(type: .offense, value: 3),
                    Flavor(type: .mobile, value: 3),
                    Flavor(type: .cityDefense, value: 2),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .buttress:
            // https://civilization.fandom.com/wiki/Buttress_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_BUTTRESS_NAME",
                eurekaSummary: "TXT_KEY_TECH_BUTTRESS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_BUTTRESS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_BUTTRESS_QUOTE1",
                    "TXT_KEY_TECH_BUTTRESS_QUOTE2"
                ],
                era: .medieval,
                cost: 300,
                required: [.shipBuilding, .mathematics],
                flavors: [
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .apprenticeship:
            // https://civilization.fandom.com/wiki/Apprenticeship_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_APPRENTICESHIP_NAME",
                eurekaSummary: "TXT_KEY_TECH_APPRENTICESHIP_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_APPRENTICESHIP_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_APPRENTICESHIP_QUOTE1",
                    "TXT_KEY_TECH_APPRENTICESHIP_QUOTE2"
                ],
                era: .medieval,
                cost: 275,
                required: [.currency, .horsebackRiding],
                flavors: [
                    Flavor(type: .gold, value: 5),
                    Flavor(type: .production, value: 3)
                ]
            )

        case .stirrups:
            // https://civilization.fandom.com/wiki/Stirrups_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_STIRRUPS_NAME",
                eurekaSummary: "TXT_KEY_TECH_STIRRUPS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_STIRRUPS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_STIRRUPS_QUOTE1",
                    "TXT_KEY_TECH_STIRRUPS_QUOTE2"
                ],
                era: .medieval,
                cost: 360,
                required: [.horsebackRiding],
                flavors: [
                    Flavor(type: .offense, value: 3),
                    Flavor(type: .mobile, value: 3),
                    Flavor(type: .defense, value: 2),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .machinery:
            // https://civilization.fandom.com/wiki/Machinery_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MACHINERY_NAME",
                eurekaSummary: "TXT_KEY_TECH_MACHINERY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MACHINERY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MACHINERY_QUOTE1",
                    "TXT_KEY_TECH_MACHINERY_QUOTE2"
                ],
                era: .medieval,
                cost: 275,
                required: [.ironWorking, .engineering],
                flavors: [
                    Flavor(type: .ranged, value: 8),
                    Flavor(type: .infrastructure, value: 2)
                ]
            )

        case .education:
            // https://civilization.fandom.com/wiki/Education_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_EDUCATION_NAME",
                eurekaSummary: "TXT_KEY_TECH_EDUCATION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_EDUCATION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_EDUCATION_QUOTE1",
                    "TXT_KEY_TECH_EDUCATION_QUOTE2"
                ],
                era: .medieval,
                cost: 335,
                required: [.apprenticeship, .mathematics],
                flavors: [
                    Flavor(type: .science, value: 8),
                    Flavor(type: .wonder, value: 2)
                ]
            )

        case .militaryEngineering:
            // https://civilization.fandom.com/wiki/Military_Engineering_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MILITARY_ENGINEERING_NAME",
                eurekaSummary: "TXT_KEY_TECH_MILITARY_ENGINEERING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MILITARY_ENGINEERING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MILITARY_ENGINEERING_QUOTE1",
                    "TXT_KEY_TECH_MILITARY_ENGINEERING_QUOTE2"
                ],
                era: .medieval,
                cost: 335,
                required: [.construction],
                flavors: [
                    Flavor(type: .defense, value: 5),
                    Flavor(type: .production, value: 2)
                ]
            )

        case .castles:
            // https://civilization.fandom.com/wiki/Castles_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_CASTLES_NAME",
                eurekaSummary: "TXT_KEY_TECH_CASTLES_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_CASTLES_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_CASTLES_QUOTE1",
                    "TXT_KEY_TECH_CASTLES_QUOTE2"
                ],
                era: .medieval,
                cost: 390,
                required: [.construction],
                flavors: [
                    Flavor(type: .cityDefense, value: 5)
                ]
            )

            // renaissance
        case .cartography:
            return TechTypeData(name: "Cartography",
                                eurekaSummary: "Build 2 Harbors",
                                eurekaDescription: "With so many ships leaving the harbors of your empire you long to document your explorations.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.shipBuilding],
                                flavors: [Flavor(type: .navalRecon, value: 5)])
        case .massProduction:
            return TechTypeData(name: "Mass Production",
                                eurekaSummary: "Build a Lumber Mill",
                                eurekaDescription: "Now that you have a ready supply of standardized boards, your shipping industry will soon take off.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .shipBuilding],
                                flavors: [Flavor(type: .production, value: 7)])
        case .banking:
            return TechTypeData(name: "Banking",
                                eurekaSummary: "Have the Guilds civic",
                                eurekaDescription: "Your emerging guilds have plans that require a large influx of gold. Perhaps we can find a way to let them take out a loan?",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.education, .apprenticeship, .stirrups],
                                flavors: [Flavor(type: .gold, value: 6)])
        case .gunpowder:
            return TechTypeData(name: "Gunpowder",
                                eurekaSummary: "Build an Armory",
                                eurekaDescription: "Your men at the armory are fashioning a new weapon that will devastate opponents.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.militaryEngineering, .stirrups, .apprenticeship],
                                flavors: [Flavor(type: .production, value: 2), Flavor(type: .defense, value: 3), Flavor(type: .cityDefense, value: 2)])
        case .printing:
            return TechTypeData(name: "Printing",
                                eurekaSummary: "Build 2 Universities",
                                eurekaDescription: "Out of necessity your scholars are devising methods for quickly copying books.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 490,
                                required: [.machinery],
                                flavors: [Flavor(type: .science, value: 7)])
        case .squareRigging:
            return TechTypeData(name: "Square Rigging",
                                eurekaSummary: "Kill a unit with a Musketman",
                                eurekaDescription: "The success of your Musketmen on land has spurred a new idea: what if we upgrade to gunpowder weaponry at sea?",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 600,
                                required: [.cartography],
                                flavors: [Flavor(type: .naval, value: 5), Flavor(type: .navalGrowth, value: 2), Flavor(type: .navalRecon, value: 3)])
        case .astronomy:
            return TechTypeData(name: "Astronomy",
                                eurekaSummary: "Build a University next to a Mountain",
                                eurekaDescription: "Your scientists are hiking into the mountains for a sharper view of the heavens. Maybe a permanent facility would help?",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 600,
                                required: [.education],
                                flavors: [Flavor(type: .science, value: 4)])
        case .metalCasting:
            return TechTypeData(name: "Metal Casting",
                                eurekaSummary: "Own 2 Crossbowmen",
                                eurekaDescription: "With so many Crossbowmen in the field, we’ve had a lot of practice studying ranged weapons.",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 660,
                                required: [.gunpowder],
                                flavors: [Flavor(type: .production, value: 3)])
        case .siegeTactics:
            return TechTypeData(name: "Siege Tactics",
                                eurekaSummary: "Own 2 Bombards",
                                eurekaDescription: "After creating bombards you realize that castles are not impregnable – you need a stauncher defense!",
                                quoteTexts: [],
                                era: .renaissance,
                                cost: 660,
                                required: [.castles],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 3)])

            // industrial
        case .industrialization:
            return TechTypeData(name: "Industrialization",
                                eurekaSummary: "Build 3 Workshops",
                                eurekaDescription: "The busy workshops of your empire hint at greatness to come. Is an Industrial Revolution about to commence?",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 700,
                                required: [.massProduction, .squareRigging],
                                flavors: [Flavor(type: .production, value: 7)])
        case .scientificTheory:
            return TechTypeData(name: "Scientific Theory",
                                eurekaSummary: "Have The Enlightenment civic",
                                eurekaDescription: "The dawning of an age of enlightenment in our realm has sparked a serious discourse on our scientific methods.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 700,
                                required: [.astronomy, .banking],
                                flavors: [Flavor(type: .diplomacy, value: 5), Flavor(type: .science, value: 5)])
        case .ballistics:
            return TechTypeData(name: "Ballistics",
                                eurekaSummary: "Have 2 Forts in your territory",
                                eurekaDescription: "Your cities have been protected by multiple fortifications, what if they could be defended by cannons?",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 840,
                                required: [.metalCasting],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .offense, value: 5) ])
        case .militaryScience:
            return TechTypeData(name: "Military Science",
                                eurekaSummary: "Kill a unit with a Knight",
                                eurekaDescription: "Your valiant Knight has vanquished his foe. Let us learn from this victory and become students of military affairs.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 845,
                                required: [.printing, .siegeTactics],
                                flavors: [Flavor(type: .offense, value: 7) ])
        case .steamPower:
            return TechTypeData(name: "Steam Power",
                                eurekaSummary: "Build 2 Shipyards",
                                eurekaDescription: "Let us apply our industrial acumen to your newly-constructed shipyards. Steam-powered naval vessels could rule the seas.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 805,
                                required: [.industrialization, .squareRigging],
                                flavors: [Flavor(type: .mobile, value: 5), Flavor(type: .offense, value: 2), Flavor(type: .navalGrowth, value: 3)])
        case .sanitation:
            return TechTypeData(name: "Sanitation",
                                eurekaSummary: "Build 2 Neighborhoods",
                                eurekaDescription: "With the introduction of neighborhoods, our cities are growing larger than ever before. Developing a sanitation plan is crucial.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 805,
                                required: [.scientificTheory],
                                flavors: [Flavor(type: .growth, value: 5) ])
        case .economics:
            return TechTypeData(name: "Economics",
                                eurekaSummary: "Build 2 Banks",
                                eurekaDescription: "The power of your banks in on the rise. It is time to formally study the forces that are shaping your national economy.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 805,
                                required: [.metalCasting, .scientificTheory],
                                flavors: [Flavor(type: .wonder, value: 5) ])
        case .rifling:
            return TechTypeData(name: "Rifling",
                                eurekaSummary: "Build a Niter Mine",
                                eurekaDescription: "With a source of niter, your firearms industry is switching into top gear. The next step will be to improve our accuracy.",
                                quoteTexts: [],
                                era: .industrial,
                                cost: 970,
                                required: [.ballistics, .militaryScience],
                                flavors: [Flavor(type: .offense, value: 5) ])

            // modern
        case .flight:
            return TechTypeData(name: "Flight",
                                eurekaSummary: "Build an Industrial era or later wonder",
                                eurekaDescription: "Having completed a modern wonder, our engineers are sure they can tackle anything. What, are they thinking of flying next?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 900, required: [.industrialization, .scientificTheory],
                                flavors: [Flavor(type: .mobile, value: 5)])
        case .replaceableParts:
            return TechTypeData(name: "Replaceable Parts",
                                eurekaSummary: "Own 3 Musketmen",
                                eurekaDescription: "Your armament makers are tired of having to hand craft so many muskets.  Perhaps some standardization would help?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1250,
                                required: [.economics],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .gold, value: 3), Flavor(type: .production, value: 3) ])
        case .steel:
            return TechTypeData(name: "Steel",
                                eurekaSummary: "Build a Coal Mine",
                                eurekaDescription: "Your coal-powered blast furnaces should soon allow us to produce the finest-grade steel.",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1140,
                                required: [.rifling],
                                flavors: [Flavor(type: .ranged, value: 5), Flavor(type: .wonder, value: 3) ])
        case .refining:
            return TechTypeData(name: "Refining",
                                eurekaSummary: "Build 2 Coal Power Plants",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1250,
                                required: [.rifling],
                                flavors: [Flavor(type: .navalGrowth, value: 5), Flavor(type: .tileImprovement, value: 3) ])
        case .electricity:
            return TechTypeData(name: "Electricity",
                                eurekaSummary: "Own 3 Privateers",
                                eurekaDescription: "Your crafty privateers are intrigued by the discovery of electric current. Could they use this to create stealthy propulsion?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 985,
                                required: [.steamPower],
                                flavors: [Flavor(type: .navalGrowth, value: 5), Flavor(type: .energy, value: 3) ])
        case .radio:
            return TechTypeData(name: "Radio",
                                eurekaSummary: "Build a National Park",
                                eurekaDescription: "Your new national park needs visitors. Perhaps a new form of communications will help advertise it?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 985,
                                required: [.flight, .steamPower],
                                flavors: [Flavor(type: .expansion, value: 3)])
        case .chemistry:
            return TechTypeData(name: "Chemistry",
                                eurekaSummary: "Complete a Research Agreement.",
                                eurekaDescription: "Joining forces with other nations has started a chain reaction of scientific advances.  Will the next push be in chemistry?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 985,
                                required: [.sanitation],
                                flavors: [Flavor(type: .growth, value: 4), Flavor(type: .science, value: 5)])
        case .combustrion:
            return TechTypeData(name: "Combustion",
                                eurekaSummary: "Extract an Artifact.",
                                eurekaDescription: "Your archaeologist has noticed petroleum seeping out of the rocks. Perhaps your geologists would like to take a look?",
                                quoteTexts: [],
                                era: .modern,
                                cost: 1250,
                                required: [.steel, .rifling],
                                flavors: [Flavor(type: .offense, value: 4), Flavor(type: .wonder, value: 3) ])

            // atomic
        case .advancedFlight:
            return TechTypeData(name: "Advanced Flight",
                                eurekaSummary: "Build 3 Biplanes",
                                eurekaDescription: "Your extensive experience with biplanes has led to several aeronautic breakthroughs.",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1065,
                                required: [.radio],
                                flavors: [Flavor(type: .offense, value: 4) ])
        case .rocketry:
            return TechTypeData(name: "Rocketry",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1065,
                                required: [.radio, .chemistry],
                                flavors: [Flavor(type: .science, value: 5)])
        case .advancedBallistics:
            return TechTypeData(name: "Advanced Ballistics",
                                eurekaSummary: "Build 2 Power Plants",
                                eurekaDescription: "Development of new power plants has spurred on industrial advances that could help your armament production.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1410,
                                required: [.replaceableParts, .steel],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 5)])
        case .combinedArms:
            return TechTypeData(name: "Combined Arms",
                                eurekaSummary: "Build an Airstrip",
                                eurekaDescription: "Now that you know how to build portable airstrips on land, why not try one at sea?",
                                quoteTexts: [],
                                era: .information,
                                cost: 1480,
                                required: [.steel],
                                flavors: [Flavor(type: .navalGrowth, value: 5) ])
        case .plastics:
            return TechTypeData(name: "Plastics",
                                eurekaSummary: "Build an Oil Well",
                                eurekaDescription: "Having a source of petrochemicals should lead to many advances. Its plasticity is of particular interest.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1065,
                                required: [.combustrion],
                                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .navalTileImprovement, value: 4) ])
        case .computers:
            return TechTypeData(name: "Computers",
                                eurekaSummary: "Have a government with 8 policy slots",
                                eurekaDescription: "A modern government comes with a lot of bureaucracy. Developing ways to efficiently track data will be a huge help.",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1195,
                                required: [.electricity, .radio],
                                flavors: [Flavor(type: .growth, value: 2), Flavor(type: .science, value: 4), Flavor(type: .diplomacy, value: 5)])
        case .nuclearFission:
            return TechTypeData(name: "Nuclear Fission",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1195,
                                required: [.combinedArms, .advancedBallistics],
                                flavors: [Flavor(type: .energy, value: 5) ])
        case .syntheticMaterials:
            return TechTypeData(name: "Synthetic Materials",
                                eurekaSummary: "Build 2 Aerodromes",
                                eurekaDescription: "With facilities for aircrafts in multiple cities, your aeronautic industry is taking off.",
                                quoteTexts: [],
                                era: .atomic,
                                cost: 1195,
                                required: [.plastics],
                                flavors: [Flavor(type: .gold, value: 4), Flavor(type: .offense, value: 2)])

            // information
        case .telecommunications:
            return TechTypeData(name: "Telecommunications",
                                eurekaSummary: "Build 2 Broadcast Centers",
                                eurekaDescription: "With your pioneers in radio and television leading the way, you’ve grown adept at transmitting data quickly.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.computers],
                                flavors: [Flavor(type: .offense, value: 3)])
        case .satellites:
            return TechTypeData(name: "Satellites",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.advancedFlight, .rocketry],
                                flavors: [Flavor(type: .science, value: 3), Flavor(type: .expansion, value: 3)])
        case .guidanceSystems:
            return TechTypeData(name: "Guidance Systems",
                                eurekaSummary: "Kill a Fighter",
                                eurekaDescription: "Your military has defeated an enemy plane. Now it is time to have the best defense against enemy aircraft.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1580,
                                required: [.rocketry, .advancedBallistics],
                                flavors: [Flavor(type: .offense, value: 5) ])
        case .lasers:
            return TechTypeData(name: "Lasers",
                                eurekaSummary: "Boost through Great Scientist or Spy.",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.nuclearFission],
                                flavors: [Flavor(type: .navalGrowth, value: 5) ])
        case .composites:
            return TechTypeData(name: "Composites",
                                eurekaSummary: "Own 3 Tanks",
                                eurekaDescription: "Tanks have been the backbone of your army so your scientists are striving for a more advanced model.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.syntheticMaterials],
                                flavors: [Flavor(type: .offense, value: 6)])
        case .stealthTechnology:
            return TechTypeData(name: "Stealth Technology",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1340,
                                required: [.syntheticMaterials],
                                flavors: [Flavor(type: .offense, value: 3)])
        case .robotics:
            return TechTypeData(name: "Robotics",
                                eurekaSummary: "Have the Globalization civic.",
                                eurekaDescription: "Having a diverse set of metals to experiment on will help your scientists push into new fields.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1560,
                                required: [.computers],
                                flavors: [Flavor(type: .production, value: 3), Flavor(type: .offense, value: 3) ])
        case .nuclearFusion:
            return TechTypeData(name: "Nuclear Fusion",
                                eurekaSummary: "Boost through Great Scientist or Spy",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .information,
                                cost: 1560,
                                required: [.lasers],
                                flavors: [Flavor(type: .energy, value: 3) ])
        case .nanotechnology:
            return TechTypeData(name: "Nanotechnology",
                                eurekaSummary: "Build an Aluminum Mine",
                                eurekaDescription: "Having a diverse set of metals to experiment on will help your scientists push into new fields.",
                                quoteTexts: [],
                                era: .information,
                                cost: 1560,
                                required: [.composites],
                                flavors: [Flavor(type: .science, value: 3)])

            // future
        case .futureTech:
            return TechTypeData(name: "Future Tech",
                                eurekaSummary: "---",
                                eurekaDescription: "",
                                quoteTexts: [],
                                era: .future,
                                cost: 1780,
                                required: [.robotics, .nuclearFusion],
                                flavors: [])
        }
    }
}
