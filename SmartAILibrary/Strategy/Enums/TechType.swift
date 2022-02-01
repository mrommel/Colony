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
    case combustion

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
            .flight, .replaceableParts, .steel, .refining, .electricity, .radio, .chemistry, .combustion,

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

            if $0.civilization() != nil {
                return false
            }

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

            // /////////////////////////////////
            // renaissance

        case .cartography:
            // https://civilization.fandom.com/wiki/Cartography_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_CARTOGRAPHY_NAME",
                eurekaSummary: "TXT_KEY_TECH_CARTOGRAPHY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_CARTOGRAPHY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_CARTOGRAPHY_QUOTE1",
                    "TXT_KEY_TECH_CARTOGRAPHY_QUOTE2"
                ],
                era: .renaissance,
                cost: 490,
                required: [.shipBuilding],
                flavors: [
                    Flavor(type: .navalRecon, value: 5)
                ]
            )

        case .massProduction:
            // https://civilization.fandom.com/wiki/Mass_Production_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MASS_PRODUCTION_NAME",
                eurekaSummary: "TXT_KEY_TECH_MASS_PRODUCTION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MASS_PRODUCTION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MASS_PRODUCTION_QUOTE1",
                    "TXT_KEY_TECH_MASS_PRODUCTION_QUOTE2"
                ],
                era: .renaissance,
                cost: 490,
                required: [.education, .shipBuilding],
                flavors: [
                    Flavor(type: .production, value: 7)
                ]
            )

        case .banking:
            // https://civilization.fandom.com/wiki/Banking_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_BANKING_NAME",
                eurekaSummary: "TXT_KEY_TECH_BANKING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_BANKING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_BANKING_QUOTE1",
                    "TXT_KEY_TECH_BANKING_QUOTE2"
                ],
                era: .renaissance,
                cost: 490,
                required: [.education, .apprenticeship, .stirrups],
                flavors: [
                    Flavor(type: .gold, value: 6)
                ]
            )

        case .gunpowder:
            // https://civilization.fandom.com/wiki/Gunpowder_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_GUNPOWDER_NAME",
                eurekaSummary: "TXT_KEY_TECH_GUNPOWDER_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_GUNPOWDER_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_GUNPOWDER_QUOTE1",
                    "TXT_KEY_TECH_GUNPOWDER_QUOTE2"
                ],
                era: .renaissance,
                cost: 490,
                required: [.militaryEngineering, .stirrups, .apprenticeship],
                flavors: [
                    Flavor(type: .production, value: 2),
                    Flavor(type: .defense, value: 3),
                    Flavor(type: .cityDefense, value: 2)
                ]
            )

        case .printing:
            // https://civilization.fandom.com/wiki/Printing_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_PRINTING_NAME",
                eurekaSummary: "TXT_KEY_TECH_PRINTING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_PRINTING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_PRINTING_QUOTE1",
                    "TXT_KEY_TECH_PRINTING_QUOTE2"
                ],
                era: .renaissance,
                cost: 490,
                required: [.machinery],
                flavors: [
                    Flavor(type: .science, value: 7)
                ]
            )

        case .squareRigging:
            // https://civilization.fandom.com/wiki/Square_Rigging_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SQUARE_RIGGING_NAME",
                eurekaSummary: "TXT_KEY_TECH_SQUARE_RIGGING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SQUARE_RIGGING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SQUARE_RIGGING_QUOTE1",
                    "TXT_KEY_TECH_SQUARE_RIGGING_QUOTE2"
                ],
                era: .renaissance,
                cost: 600,
                required: [.cartography],
                flavors: [
                    Flavor(type: .naval, value: 5),
                    Flavor(type: .navalGrowth, value: 2),
                    Flavor(type: .navalRecon, value: 3)
                ]
            )

        case .astronomy:
            // https://civilization.fandom.com/wiki/Astronomy_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ASTRONOMY_NAME",
                eurekaSummary: "TXT_KEY_TECH_ASTRONOMY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ASTRONOMY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ASTRONOMY_QUOTE1",
                    "TXT_KEY_TECH_ASTRONOMY_QUOTE2"
                ],
                era: .renaissance,
                cost: 600,
                required: [.education],
                flavors: [
                    Flavor(type: .science, value: 4)
                ]
            )

        case .metalCasting:
            // https://civilization.fandom.com/wiki/Metal_Casting_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_METAL_CASTING_NAME",
                eurekaSummary: "TXT_KEY_TECH_METAL_CASTING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_METAL_CASTING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_METAL_CASTING_QUOTE1",
                    "TXT_KEY_TECH_METAL_CASTING_QUOTE2"
                ],
                era: .renaissance,
                cost: 660,
                required: [.gunpowder],
                flavors: [
                    Flavor(type: .production, value: 3)
                ]
            )

        case .siegeTactics:
            // https://civilization.fandom.com/wiki/Siege_Tactics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SIEGE_TACTICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_SIEGE_TACTICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SIEGE_TACTICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SIEGE_TACTICS_QUOTE1",
                    "TXT_KEY_TECH_SIEGE_TACTICS_QUOTE2"
                ],
                era: .renaissance,
                cost: 660,
                required: [.castles],
                flavors: [
                    Flavor(type: .ranged, value: 5),
                    Flavor(type: .offense, value: 3)
                ]
            )

            // /////////////////////////////////
            // industrial

        case .industrialization:
            // https://civilization.fandom.com/wiki/Industrialization_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_INDUSTRIALIZATION_NAME",
                eurekaSummary: "TXT_KEY_TECH_INDUSTRIALIZATION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_INDUSTRIALIZATION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_INDUSTRIALIZATION_QUOTE1",
                    "TXT_KEY_TECH_INDUSTRIALIZATION_QUOTE2"
                ],
                era: .industrial,
                cost: 700,
                required: [.massProduction, .squareRigging],
                flavors: [
                    Flavor(type: .production, value: 7)
                ]
            )

        case .scientificTheory:
            // https://civilization.fandom.com/wiki/Scientific_Theory_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SCIENTIFIC_THEORY_NAME",
                eurekaSummary: "TXT_KEY_TECH_SCIENTIFIC_THEORY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SCIENTIFIC_THEORY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SCIENTIFIC_THEORY_QUOTE1",
                    "TXT_KEY_TECH_SCIENTIFIC_THEORY_QUOTE2"
                ],
                era: .industrial,
                cost: 700,
                required: [.astronomy, .banking],
                flavors: [
                    Flavor(type: .diplomacy, value: 5),
                    Flavor(type: .science, value: 5)
                ]
            )

        case .ballistics:
            // https://civilization.fandom.com/wiki/Ballistics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_BALLISTICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_BALLISTICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_BALLISTICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_BALLISTICS_QUOTE1",
                    "TXT_KEY_TECH_BALLISTICS_QUOTE2"
                ],
                era: .industrial,
                cost: 840,
                required: [.metalCasting],
                flavors: [
                    Flavor(type: .ranged, value: 5),
                    Flavor(type: .offense, value: 5)
                ]
            )

        case .militaryScience:
            // https://civilization.fandom.com/wiki/Military_Science_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_MILITARY_SCIENCE_NAME",
                eurekaSummary: "TXT_KEY_TECH_MILITARY_SCIENCE_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_MILITARY_SCIENCE_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_MILITARY_SCIENCE_QUOTE1",
                    "TXT_KEY_TECH_MILITARY_SCIENCE_QUOTE2"
                ],
                era: .industrial,
                cost: 845,
                required: [.printing, .siegeTactics],
                flavors: [
                    Flavor(type: .offense, value: 7)
                ]
            )

        case .steamPower:
            // https://civilization.fandom.com/wiki/Steam_Power_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_STEAM_POWER_NAME",
                eurekaSummary: "TXT_KEY_TECH_STEAM_POWER_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_STEAM_POWER_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_STEAM_POWER_QUOTE1",
                    "TXT_KEY_TECH_STEAM_POWER_QUOTE2"
                ],
                era: .industrial,
                cost: 805,
                required: [.industrialization, .squareRigging],
                flavors: [
                    Flavor(type: .mobile, value: 5),
                    Flavor(type: .offense, value: 2),
                    Flavor(type: .navalGrowth, value: 3)
                ]
            )

        case .sanitation:
            // https://civilization.fandom.com/wiki/Sanitation_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SANITATION_NAME",
                eurekaSummary: "TXT_KEY_TECH_SANITATION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SANITATION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SANITATION_QUOTE1",
                    "TXT_KEY_TECH_SANITATION_QUOTE2"
                ],
                era: .industrial,
                cost: 805,
                required: [.scientificTheory],
                flavors: [
                    Flavor(type: .growth, value: 5)
                ]
            )

        case .economics:
            // https://civilization.fandom.com/wiki/Economics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ECONOMICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_ECONOMICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ECONOMICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ECONOMICS_QUOTE1",
                    "TXT_KEY_TECH_ECONOMICS_QUOTE2"
                ],
                era: .industrial,
                cost: 805,
                required: [.metalCasting, .scientificTheory],
                flavors: [
                    Flavor(type: .wonder, value: 5)
                ]
            )

        case .rifling:
            // https://civilization.fandom.com/wiki/Rifling_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_RIFLING_NAME",
                eurekaSummary: "TXT_KEY_TECH_RIFLING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_RIFLING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_RIFLING_QUOTE1",
                    "TXT_KEY_TECH_RIFLING_QUOTE2"
                ],
                era: .industrial,
                cost: 970,
                required: [.ballistics, .militaryScience],
                flavors: [
                    Flavor(type: .offense, value: 5)
                ]
            )

            // /////////////////////////////////
            // modern

        case .flight:
            // https://civilization.fandom.com/wiki/Flight_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_FLIGHT_NAME",
                eurekaSummary: "TXT_KEY_TECH_FLIGHT_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_FLIGHT_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_FLIGHT_QUOTE1",
                    "TXT_KEY_TECH_FLIGHT_QUOTE2"
                ],
                era: .modern,
                cost: 900, required: [.industrialization, .scientificTheory],
                flavors: [
                    Flavor(type: .mobile, value: 5)
                ]
            )

        case .replaceableParts:
            // https://civilization.fandom.com/wiki/Replaceable_Parts_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_REPLACEABLE_PARTS_NAME",
                eurekaSummary: "TXT_KEY_TECH_REPLACEABLE_PARTS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_REPLACEABLE_PARTS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_REPLACEABLE_PARTS_QUOTE1",
                    "TXT_KEY_TECH_REPLACEABLE_PARTS_QUOTE2"
                ],
                era: .modern,
                cost: 1250,
                required: [.economics],
                flavors: [
                    Flavor(type: .offense, value: 5),
                    Flavor(type: .gold, value: 3),
                    Flavor(type: .production, value: 3)
                ]
            )

        case .steel:
            // https://civilization.fandom.com/wiki/Steel_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_STEEL_NAME",
                eurekaSummary: "TXT_KEY_TECH_STEEL_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_STEEL_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_STEEL_QUOTE1",
                    "TXT_KEY_TECH_STEEL_QUOTE2"
                ],
                era: .modern,
                cost: 1140,
                required: [.rifling],
                flavors: [
                    Flavor(type: .ranged, value: 5),
                    Flavor(type: .wonder, value: 3)
                ]
            )

        case .refining:
            // https://civilization.fandom.com/wiki/Refining_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_REFINING_NAME",
                eurekaSummary: "TXT_KEY_TECH_REFINING_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_REFINING_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_REFINING_QUOTE1"
                ],
                era: .modern,
                cost: 1250,
                required: [.rifling],
                flavors: [
                    Flavor(type: .navalGrowth, value: 5),
                    Flavor(type: .tileImprovement, value: 3)
                ]
            )

        case .electricity:
            // https://civilization.fandom.com/wiki/Electricity_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ELECTRICITY_NAME",
                eurekaSummary: "TXT_KEY_TECH_ELECTRICITY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ELECTRICITY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ELECTRICITY_QUOTE1",
                    "TXT_KEY_TECH_ELECTRICITY_QUOTE2"
                ],
                era: .modern,
                cost: 985,
                required: [.steamPower],
                flavors: [
                    Flavor(type: .navalGrowth, value: 5),
                    Flavor(type: .energy, value: 3)
                ]
            )

        case .radio:
            // https://civilization.fandom.com/wiki/Radio_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_RADIO_NAME",
                eurekaSummary: "TXT_KEY_TECH_RADIO_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_RADIO_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_RADIO_QUOTE1",
                    "TXT_KEY_TECH_RADIO_QUOTE2"
                ],
                era: .modern,
                cost: 985,
                required: [.flight, .steamPower],
                flavors: [
                    Flavor(type: .expansion, value: 3)
                ]
            )

        case .chemistry:
            // https://civilization.fandom.com/wiki/Chemistry_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_CHEMISTRY_NAME",
                eurekaSummary: "TXT_KEY_TECH_CHEMISTRY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_CHEMISTRY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_CHEMISTRY_QUOTE1",
                    "TXT_KEY_TECH_CHEMISTRY_QUOTE2"
                ],
                era: .modern,
                cost: 985,
                required: [.sanitation],
                flavors: [
                    Flavor(type: .growth, value: 4),
                    Flavor(type: .science, value: 5)
                ]
            )

        case .combustion:
            // https://civilization.fandom.com/wiki/Combustion_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_COMBUSTION_NAME",
                eurekaSummary: "TXT_KEY_TECH_COMBUSTION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_COMBUSTION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_COMBUSTION_QUOTE1",
                    "TXT_KEY_TECH_COMBUSTION_QUOTE2"
                ],
                era: .modern,
                cost: 1250,
                required: [.steel, .rifling],
                flavors: [
                    Flavor(type: .offense, value: 4),
                    Flavor(type: .wonder, value: 3)
                ]
            )

            // /////////////////////////////////
            // atomic

        case .advancedFlight:
            // https://civilization.fandom.com/wiki/Advanced_Flight_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ADVANCED_FLIGHT_NAME",
                eurekaSummary: "TXT_KEY_TECH_ADVANCED_FLIGHT_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ADVANCED_FLIGHT_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ADVANCED_FLIGHT_QUOTE1",
                    "TXT_KEY_TECH_ADVANCED_FLIGHT_QUOTE2"
                ],
                era: .atomic,
                cost: 1065,
                required: [.radio],
                flavors: [
                    Flavor(type: .offense, value: 4)
                ]
            )

        case .rocketry:
            // https://civilization.fandom.com/wiki/Rocketry_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ROCKETRY_NAME",
                eurekaSummary: "TXT_KEY_TECH_ROCKETRY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ROCKETRY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ROCKETRY_QUOTE1",
                    "TXT_KEY_TECH_ROCKETRY_QUOTE2"
                ],
                era: .atomic,
                cost: 1065,
                required: [.radio, .chemistry],
                flavors: [
                    Flavor(type: .science, value: 5)
                ]
            )

        case .advancedBallistics:
            // https://civilization.fandom.com/wiki/Advanced_Ballistics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ADVANCED_BALLISTICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_ADVANCED_BALLISTICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ADVANCED_BALLISTICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ADVANCED_BALLISTICS_QUOTE1",
                    "TXT_KEY_TECH_ADVANCED_BALLISTICS_QUOTE2"
                ],
                era: .information,
                cost: 1410,
                required: [.replaceableParts, .steel],
                flavors: [
                    Flavor(type: .offense, value: 5),
                    Flavor(type: .defense, value: 5)
                ]
            )

        case .combinedArms:
            // https://civilization.fandom.com/wiki/Combined_Arms_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_COMBINED_ARMS_NAME",
                eurekaSummary: "TXT_KEY_TECH_COMBINED_ARMS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_COMBINED_ARMS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_COMBINED_ARMS_QUOTE1",
                    "TXT_KEY_TECH_COMBINED_ARMS_QUOTE2"
                ],
                era: .information,
                cost: 1480,
                required: [.steel],
                flavors: [
                    Flavor(type: .navalGrowth, value: 5)
                ]
            )

        case .plastics:
            // https://civilization.fandom.com/wiki/Plastics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_PLASTICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_PLASTICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_PLASTICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_PLASTICS_QUOTE1",
                    "TXT_KEY_TECH_PLASTICS_QUOTE2"
                ],
                era: .information,
                cost: 1065,
                required: [.combustion],
                flavors: [
                    Flavor(type: .offense, value: 5),
                    Flavor(type: .navalTileImprovement, value: 4)
                ]
            )

        case .computers:
            // https://civilization.fandom.com/wiki/Computers_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_COMPUTERS_NAME",
                eurekaSummary: "TXT_KEY_TECH_COMPUTERS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_COMPUTERS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_COMPUTERS_QUOTE1",
                    "TXT_KEY_TECH_COMPUTERS_QUOTE2"
                ],
                era: .atomic,
                cost: 1195,
                required: [.electricity, .radio],
                flavors: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .science, value: 4),
                    Flavor(type: .diplomacy, value: 5)
                ]
            )

        case .nuclearFission:
            // https://civilization.fandom.com/wiki/Nuclear_Fission_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_NUCLEAR_FISSION_NAME",
                eurekaSummary: "TXT_KEY_TECH_NUCLEAR_FISSION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_NUCLEAR_FISSION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_NUCLEAR_FISSION_QUOTE1",
                    "TXT_KEY_TECH_NUCLEAR_FISSION_QUOTE2"
                ],
                era: .atomic,
                cost: 1195,
                required: [.combinedArms, .advancedBallistics],
                flavors: [
                    Flavor(type: .energy, value: 5)
                ]
            )

        case .syntheticMaterials:
            // https://civilization.fandom.com/wiki/Synthetic_Materials_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SYNTHETIC_MATERIALS_NAME",
                eurekaSummary: "TXT_KEY_TECH_SYNTHETIC_MATERIALS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SYNTHETIC_MATERIALS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SYNTHETIC_MATERIALS_QUOTE1",
                    "TXT_KEY_TECH_SYNTHETIC_MATERIALS_QUOTE2"
                ],
                era: .atomic,
                cost: 1195,
                required: [.plastics],
                flavors: [
                    Flavor(type: .gold, value: 4),
                    Flavor(type: .offense, value: 2)
                ]
            )

            // /////////////////////////////////
            // information

        case .telecommunications:
            // https://civilization.fandom.com/wiki/Telecommunications_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_TELECOMMUNICATIONS_NAME",
                eurekaSummary: "TXT_KEY_TECH_TELECOMMUNICATIONS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_TELECOMMUNICATIONS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_TELECOMMUNICATIONS_QUOTE1",
                    "TXT_KEY_TECH_TELECOMMUNICATIONS_QUOTE2"
                ],
                era: .information,
                cost: 1340,
                required: [.computers],
                flavors: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .satellites:
            // https://civilization.fandom.com/wiki/Satellites_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_SATELLITES_NAME",
                eurekaSummary: "TXT_KEY_TECH_SATELLITES_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_SATELLITES_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_SATELLITES_QUOTE1",
                    "TXT_KEY_TECH_SATELLITES_QUOTE2"
                ],
                era: .information,
                cost: 1340,
                required: [.advancedFlight, .rocketry],
                flavors: [
                    Flavor(type: .science, value: 3),
                    Flavor(type: .expansion, value: 3)
                ]
            )

        case .guidanceSystems:
            // https://civilization.fandom.com/wiki/Guidance_Systems_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_GUIDANCE_SYSTEMS_NAME",
                eurekaSummary: "TXT_KEY_TECH_GUIDANCE_SYSTEMS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_GUIDANCE_SYSTEMS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_GUIDANCE_SYSTEMS_QUOTE1",
                    "TXT_KEY_TECH_GUIDANCE_SYSTEMS_QUOTE2"
                ],
                era: .information,
                cost: 1580,
                required: [.rocketry, .advancedBallistics],
                flavors: [
                    Flavor(type: .offense, value: 5)
                ]
            )

        case .lasers:
            // https://civilization.fandom.com/wiki/Lasers_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_LASERS_NAME",
                eurekaSummary: "TXT_KEY_TECH_LASERS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_LASERS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_LASERS_QUOTE1",
                    "TXT_KEY_TECH_LASERS_QUOTE2"
                ],
                era: .information,
                cost: 1340,
                required: [.nuclearFission],
                flavors: [
                    Flavor(type: .navalGrowth, value: 5)
                ]
            )

        case .composites:
            // https://civilization.fandom.com/wiki/Composites_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_COMPOSITES_NAME",
                eurekaSummary: "TXT_KEY_TECH_COMPOSITES_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_COMPOSITES_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_COMPOSITES_QUOTE1",
                    "TXT_KEY_TECH_COMPOSITES_QUOTE2"
                ],
                era: .information,
                cost: 1340,
                required: [.syntheticMaterials],
                flavors: [
                    Flavor(type: .offense, value: 6)
                ]
            )

        case .stealthTechnology:
            // https://civilization.fandom.com/wiki/Stealth_Technology_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_STEALTH_TECHNOLOGY_NAME",
                eurekaSummary: "TXT_KEY_TECH_STEALTH_TECHNOLOGY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_STEALTH_TECHNOLOGY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_STEALTH_TECHNOLOGY_QUOTE1",
                    "TXT_KEY_TECH_STEALTH_TECHNOLOGY_QUOTE2"
                ],
                era: .information,
                cost: 1340,
                required: [.syntheticMaterials],
                flavors: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .robotics:
            // https://civilization.fandom.com/wiki/Robotics_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_ROBOTICS_NAME",
                eurekaSummary: "TXT_KEY_TECH_ROBOTICS_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_ROBOTICS_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_ROBOTICS_QUOTE1",
                    "TXT_KEY_TECH_ROBOTICS_QUOTE2"
                ],
                era: .information,
                cost: 1560,
                required: [.computers],
                flavors: [
                    Flavor(type: .production, value: 3),
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .nuclearFusion:
            // https://civilization.fandom.com/wiki/Nuclear_Fusion_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_NUCLEAR_FUSION_NAME",
                eurekaSummary: "TXT_KEY_TECH_NUCLEAR_FUSION_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_NUCLEAR_FUSION_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_NUCLEAR_FUSION_QUOTE1",
                    "TXT_KEY_TECH_NUCLEAR_FUSION_QUOTE2"
                ],
                era: .information,
                cost: 1560,
                required: [.lasers],
                flavors: [
                    Flavor(type: .energy, value: 3)
                ]
            )

        case .nanotechnology:
            // https://civilization.fandom.com/wiki/Nanotechnology_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_NANOTECHNOLOGY_NAME",
                eurekaSummary: "TXT_KEY_TECH_NANOTECHNOLOGY_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_NANOTECHNOLOGY_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_NANOTECHNOLOGY_QUOTE1",
                    "TXT_KEY_TECH_NANOTECHNOLOGY_QUOTE2"
                ],
                era: .information,
                cost: 1560,
                required: [.composites],
                flavors: [
                    Flavor(type: .science, value: 3)
                ]
            )

            // /////////////////////////////////
            // future

        case .futureTech:
            // https://civilization.fandom.com/wiki/Future_Tech_(Civ6)
            return TechTypeData(
                name: "TXT_KEY_TECH_FUTURE_TECH_NAME",
                eurekaSummary: "TXT_KEY_TECH_FUTURE_TECH_EUREKA",
                eurekaDescription: "TXT_KEY_TECH_FUTURE_TECH_EUREKA_TEXT",
                quoteTexts: [
                    "TXT_KEY_TECH_FUTURE_TECH_QUOTE1",
                    "TXT_KEY_TECH_FUTURE_TECH_QUOTE2"
                ],
                era: .future,
                cost: 1780,
                required: [.robotics, .nuclearFusion],
                flavors: [
                ]
            )
        }
    }
}
