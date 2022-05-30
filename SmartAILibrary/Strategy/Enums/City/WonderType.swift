//
//  WonderType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
public enum WonderType: Int, Codable {

    case none

    // ancient
    case greatBath
    case etemenanki
    case pyramids
    case hangingGardens
    case oracle
    case stonehenge
    case templeOfArtemis

    // classical
    case greatLighthouse
    case greatLibrary
    case apadana
    case colosseum
    case colossus
    case jebelBarkal
    case mausoleumAtHalicarnassus
    case mahabodhiTemple
    case petra
    case terracottaArmy
    case machuPicchu
    case statueOfZeus

    // medieval
    case alhambra
    case angkorWat
    case chichenItza
    case hagiaSophia
    case hueyTeocalli
    case kilwaKisiwani
    case kotokuIn
    case meenakshiTemple
    case montStMichel
    case universityOfSankore

    // renaissance
    case casaDeContratacion
    case forbiddenCity
    case greatZimbabwe
    case potalaPalace
    case stBasilsCathedral
    case tajMahal
    case torreDeBelem
    case venetianArsenal

    // industrial
    // Big Ben
    // Bolshoi Theatre
    // Hermitage
    // Országház
    // Oxford University
    // Panama Canal
    // Ruhr Valley
    // Statue of Liberty

    // modern
    // Broadway
    // Cristo Redentor
    // Eiffel Tower
    // Golden Gate Bridge

    // atomic
    // Amundsen-Scott Research Station
    // Biosphère
    // Estádio do Maracanã
    // Sydney Opera House

    public static var all: [WonderType] {

        return [
            // ancient
            .greatBath, .etemenanki, .pyramids, .hangingGardens, .oracle, .stonehenge, .templeOfArtemis,

            // classical
            .greatLighthouse, .greatLibrary, .apadana, .colosseum, .colossus, .jebelBarkal,
            .mausoleumAtHalicarnassus, .mahabodhiTemple, .petra, .terracottaArmy, .machuPicchu,
            .statueOfZeus,

            // medieval
            .alhambra, .angkorWat, .chichenItza, .hagiaSophia, .hueyTeocalli, .kilwaKisiwani,
            .kotokuIn, .meenakshiTemple, .montStMichel, .universityOfSankore,

            // renaissance
            .casaDeContratacion, .forbiddenCity, .greatZimbabwe, .potalaPalace, .stBasilsCathedral,
            .tajMahal, .torreDeBelem, .venetianArsenal
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    public func era() -> EraType {

        return self.data().era
    }

    public func productionCost() -> Int {

        return self.data().productionCost
    }

    public func requiredTech() -> TechType? {

        return self.data().requiredTech
    }

    public func requiredCivic() -> CivicType? {

        return self.data().requiredCivic
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

    public func yields() -> Yields {

        return self.data().yields
    }

    func amenities() -> Double {

        return self.data().amenities
    }

    func slotsForGreatWork() -> [GreatWorkSlotType] {

        return self.data().slots
    }

    private struct WonderTypeData {

        let name: String
        let effects: [String]
        let era: EraType
        let productionCost: Int
        let requiredTech: TechType?
        let requiredCivic: CivicType?
        let amenities: Double
        let yields: Yields
        let slots: [GreatWorkSlotType]
        let flavours: [Flavor]
    }

    // swiftlint:disable function_body_length
    private func data() -> WonderTypeData {

        switch self {

        case .none:
            return WonderTypeData(
                name: "",
                effects: [],
                era: .none,
                productionCost: -1,
                requiredTech: nil,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: []
            )

            // ancient
        case .greatBath:
            // https://civilization.fandom.com/wiki/Great_Bath_(Civ6)
            return WonderTypeData(
                name: "TXT_KEY_WONDER_GREAT_BATH_TITLE",
                effects: [
                    "TXT_KEY_WONDER_GREAT_BATH_EFFECT1",
                    "TXT_KEY_WONDER_GREAT_BATH_EFFECT2",
                    "TXT_KEY_WONDER_GREAT_BATH_EFFECT3", // #
                    "TXT_KEY_WONDER_GREAT_BATH_EFFECT4", // #
                    "TXT_KEY_WONDER_GREAT_BATH_EFFECT5" // #
                ],
                era: .ancient,
                productionCost: 180,
                requiredTech: .pottery,
                requiredCivic: nil,
                amenities: 1.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, housing: 3.0),
                slots: [],
                flavours: [Flavor(type: .wonder, value: 15), Flavor(type: .religion, value: 10)]
            )

        case .etemenanki:
            // https://civilization.fandom.com/wiki/Etemenanki_(Civ6)
            return WonderTypeData(
                name: "Etemenanki",
                effects: [
                    "+2 [Science] Science and +1 [Production] Production to all Marsh tiles in your empire.",
                    "+1 [Science] Science and +1 [Production] Production on all Floodplains tiles in this city.",
                    "+2 [Science] Science"
                ],
                era: .ancient,
                productionCost: 220,
                requiredTech: .writing,
                requiredCivic: nil,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, science: 2.0),
                slots: [],
                flavours: [Flavor(type: .science, value: 7), Flavor(type: .production, value: 3)]
            )

        case .hangingGardens:
            // https://civilization.fandom.com/wiki/Hanging_Gardens_(Civ6)
            return WonderTypeData(
                name: "Hanging Gardens",
                effects: [
                    "Increases growth by 15% in all cities.",
                    "+2 [Housing] Housing"
                ],
                era: .ancient,
                productionCost: 180,
                requiredTech: .irrigation,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, housing: 2.0),
                slots: [],
                flavours: [
                    Flavor(type: .wonder, value: 20),
                    Flavor(type: .growth, value: 20)
                ]
            )

        case .stonehenge:
            // https://civilization.fandom.com/wiki/Stonehenge_(Civ6)
            // Great Prophets may found a religion on Stonehenge instead of a Holy Site.
            return WonderTypeData(
                name: "Stonehenge",
                effects: [
                    "+2 [Faith] Faith",
                    "Grants a free [GreatProphet] Great Prophet."
                ],
                era: .ancient,
                productionCost: 180,
                requiredTech: .astrology,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 2.0),
                slots: [],
                flavours: [
                    Flavor(type: .wonder, value: 25),
                    Flavor(type: .culture, value: 20)
                ]
            )

        case .templeOfArtemis:
            // https://civilization.fandom.com/wiki/Temple_of_Artemis_(Civ6)
            return WonderTypeData(
                name: "Temple of Artemis",
                effects: [
                    "+4 [Food] Food",
                    "+3 [Housing] Housing",
                    "Each Camp, Pasture, and Plantation improvement within 4 tiles of this wonder provides +1 Amenity."
                ],
                era: .ancient,
                productionCost: 180,
                requiredTech: .archery,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 4.0, production: 0.0, gold: 0.0, housing: 3.0),
                slots: [],
                flavours: [
                    Flavor(type: .wonder, value: 20),
                    Flavor(type: .growth, value: 10)
                ]
            )

        case .pyramids:
            // https://civilization.fandom.com/wiki/Pyramids_(Civ6)
            return WonderTypeData(
                name: "Pyramids",
                effects: [
                    "+2 [Culture] Culture",
                    "Grants a free Builder.",
                    "All Builders can build 1 extra improvement."
                ],
                era: .ancient,
                productionCost: 220,
                requiredTech: .masonry,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, culture: 2.0),
                slots: [],
                flavours: [
                    Flavor(type: .wonder, value: 25),
                    Flavor(type: .culture, value: 20)
                ]
            )

        case .oracle:
            // https://civilization.fandom.com/wiki/Oracle_(Civ6)
            return WonderTypeData(
                name: "Oracle",
                effects: [
                    "+1 [Culture] Culture",
                    "+1 [Faith] Faith",
                    "Patronage of Great People costs 25% less Faith.", // #
                    "Districts in this city provide +2 Great Person points of their type."
                ],
                era: .ancient,
                productionCost: 290,
                requiredTech: nil,
                requiredCivic: .mysticism,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, culture: 1.0, faith: 1.0),
                slots: [],
                flavours: [
                    Flavor(type: .wonder, value: 20),
                    Flavor(type: .culture, value: 15)
                ]
            )

            // classical
        case .greatLighthouse:
            // https://civilization.fandom.com/wiki/Great_Lighthouse_(Civ6)
            return WonderTypeData(
                name: "Great Lighthouse",
                effects: [
                    "+1 Movement for all naval units.",
                    "+3 [Gold] Gold",
                    "+1 [GreatAdmiral] Great Admiral point per turn"
                ],
                era: .classical,
                productionCost: 290,
                requiredTech: .celestialNavigation,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                slots: [],
                flavours: [
                    Flavor(type: .greatPeople, value: 20),
                    Flavor(type: .gold, value: 15),
                    Flavor(type: .navalGrowth, value: 10),
                    Flavor(type: .navalRecon, value: 8)
                ]
            )

        case .greatLibrary:
            // https://civilization.fandom.com/wiki/Great_Library_(Civ6)
            return WonderTypeData(
                name: "Great Library",
                effects: [
                    "+2 [Science] Science",
                    "+1 [GreatScientist] Great Scientist point per turn",
                    "+2 Great Works of Writing slots",
                    "Receive boosts to all Ancient and Classical era technologies.",
                    "+1 [GreatWriter] Great Writer point per turn"
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: nil,
                requiredCivic: .recordedHistory,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, science: 2.0),
                slots: [.written, .written],
                flavours: [
                    Flavor(type: .science, value: 20),
                    Flavor(type: .greatPeople, value: 15)
                ]
            )

        case .apadana:
            // https://civilization.fandom.com/wiki/Apadana_(Civ6)
            return WonderTypeData(
                name: "Apadana",
                effects: [
                    "+2 Great Work slots",
                    "+2 [Envoy] Envoys when you build a wonder, including Apadana, in this city." // #
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: nil,
                requiredCivic: .politicalPhilosophy,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [.any, .any],
                flavours: [
                    Flavor(type: .diplomacy, value: 20),
                    Flavor(type: .culture, value: 7)
                ]
            )

        case .colosseum:
            // https://civilization.fandom.com/wiki/Colosseum_(Civ6)
            return WonderTypeData(
                name: "Colosseum",
                effects: [
                    "+2 [Culture] Culture, +2 Loyalty, +2 [Amenities] Amenities from entertainment " +
                        "to each City Center within 6 tiles."
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: nil,
                requiredCivic: .gamesAndRecreation,
                amenities: 0.0, // is handled differently !
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, culture: 2.0),
                slots: [],
                flavours: [
                    Flavor(type: .amenities, value: 20),
                    Flavor(type: .culture, value: 10)
                ]
            )

        case .colossus:
            // https://civilization.fandom.com/wiki/Colossus_(Civ6)
            return WonderTypeData(
                name: "Colossus",
                effects: [
                    "+3 [Gold] Gold",
                    "+1 [GreatAdmiral] Great Admiral point per turn",
                    "+1 [TradeRoute] Trade Route capacity",
                    "Grants a Trader unit."
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: .shipBuilding,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                slots: [],
                flavours: [
                    Flavor(type: .gold, value: 12),
                    Flavor(type: .naval, value: 14),
                    Flavor(type: .navalRecon, value: 3)
                ]
            )

        case .jebelBarkal:
            // https://civilization.fandom.com/wiki/Jebel_Barkal_(Civ6)
            return WonderTypeData(
                name: "Jebel Barkal",
                effects: [
                    "Awards 2 Iron.", // #
                    "Provides +4 [Faith] Faith to all your cities that are within 6 tiles."
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: .ironWorking,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .religion, value: 12),
                    Flavor(type: .tileImprovement, value: 7)
                ]
            )

        case .mausoleumAtHalicarnassus:
            // https://civilization.fandom.com/wiki/Mausoleum_at_Halicarnassus_(Civ6)
            return WonderTypeData(
                name: "Mausoleum at Halicarnassus",
                effects: [
                    "+1 [Science] Science, +1 [Faith] Faith and +1 [Culture] Culture on all Coast tiles in this city.",
                    "All [GreatEngineer] Great Engineers have an additional charge." // #
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: nil,
                requiredCivic: .defensiveTactics,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, science: 1.0, faith: 1.0),
                slots: [],
                flavours: [
                    Flavor(type: .tileImprovement, value: 7),
                    Flavor(type: .science, value: 5),
                    Flavor(type: .religion, value: 5),
                    Flavor(type: .culture, value: 7)
                ]
            )

        case .mahabodhiTemple:
            // https://civilization.fandom.com/wiki/Mahabodhi_Temple_(Civ6)
            return WonderTypeData(
                name: "Mahabodhi Temple",
                effects: [
                    "+4 [Faith] Faith",
                    "Grants 2 Apostles." // #
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: nil,
                requiredCivic: .theology,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 4.0),
                slots: [],
                flavours: [
                    Flavor(type: .religion, value: 20),
                    Flavor(type: .greatPeople, value: 7)
                ]
            )

        case .petra:
            // https://civilization.fandom.com/wiki/Petra_(Civ6)
            return WonderTypeData(
                name: "Petra",
                effects: [
                    "+2 [Food] Food, +2 [Gold] Gold and +1 [Production] Production on all Desert tiles for this city (non-Floodplains)."
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: .mathematics,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 2.0, production: 1.0, gold: 2.0),
                slots: [],
                flavours: [
                    Flavor(type: .tileImprovement, value: 10),
                    Flavor(type: .growth, value: 12),
                    Flavor(type: .gold, value: 10)
                ]
            )

        case .terracottaArmy:
            // https://civilization.fandom.com/wiki/Terracotta_Army_(Civ6)
            return WonderTypeData(
                name: "Terracotta Army",
                effects: ["+2 [GreatGeneral] Great General points per turn",
                          "All current land units gain a promotion level."], // #
                era: .classical,
                productionCost: 400,
                requiredTech: .construction,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .greatPeople, value: 10),
                    Flavor(type: .militaryTraining, value: 7)
                ]
            )

        case .machuPicchu:
            // https://civilization.fandom.com/wiki/Machu_Picchu_(Civ6)
            return WonderTypeData(
                name: "Machu Picchu",
                effects: [
                    "+4 [Gold] Gold",
                    "Mountain tiles provide a standard adjacency bonus to Commercial Hub, " +
                        "Theater Square and Industrial Zone districts in all cities." // #
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: .engineering,
                requiredCivic: nil,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 4.0),
                slots: [],
                flavours: [Flavor(type: .production, value: 7)]
            )

        case .statueOfZeus:
            // https://civilization.fandom.com/wiki/Statue_of_Zeus_(Civ6)
            return WonderTypeData(
                name: "Statue of Zeus",
                effects: [
                    "+3 [Gold] Gold",
                    "Grants 3 Spearmen, 3 Archers, and a Battering Ram.",
                    "+50% [Production] Production towards anti-cavalry units."
                ],
                era: .classical,
                productionCost: 400,
                requiredTech: nil,
                requiredCivic: .militaryTraining,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                slots: [],
                flavours: [Flavor(type: .gold, value: 7)]
            )

            // medieval
        case .alhambra:
            // https://civilization.fandom.com/wiki/Alhambra_(Civ6)
            return WonderTypeData(
                name: "Alhambra",
                effects: [
                    "+2 Amenities",
                    "+2 [GreatGeneral] Great General points per turn",
                    "+1 Military policy slot",
                    "Provides the same defensive bonuses as the Fort improvement" // #
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: .castles,
                requiredCivic: nil,
                amenities: 2,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .greatPeople, value: 8),
                    Flavor(type: .cityDefense, value: 5)
                ]
            )

        case .angkorWat:
            // https://civilization.fandom.com/wiki/Angkor_Wat_(Civ6)
            return WonderTypeData(
                name: "Angkor Wat",
                effects: [
                    "+2 [Faith] Faith",
                    "+1 [Citizen] Population in all current cities when built.",
                    "+1 [Housing] Housing in all cities."
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: nil,
                requiredCivic: .medievalFaires,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 2),
                slots: [],
                flavours: [
                    Flavor(type: .growth, value: 10),
                    Flavor(type: .religion, value: 2)
                ]
            )

        case .chichenItza:
            // https://civilization.fandom.com/wiki/Chichen_Itza_(Civ6)
            return WonderTypeData(
                name: "Chichen Itza",
                effects: [
                    "+2 [Culture] Culture and +1 [Production] Production to all Rainforest tiles for this city."
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: nil,
                requiredCivic: .guilds,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .production, value: 4)
                ]
            )

        case .hagiaSophia:
            // https://civilization.fandom.com/wiki/Hagia_Sophia_(Civ6)
            return WonderTypeData(
                name: "Hagia Sophia",
                effects: [
                    "+4 [Faith] Faith",
                    "Missionaries and Apostles can use Spread Religion 1 extra time." // #
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: .buttress,
                requiredCivic: nil,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 4),
                slots: [],
                flavours: [
                    Flavor(type: .religion, value: 10)
                ]
            )

        case .hueyTeocalli:
            // https://civilization.fandom.com/wiki/Huey_Teocalli_(Civ6)
            return WonderTypeData(
                name: "Huey Teocalli",
                effects: [
                    "+1 Amenity from entertainment for each Lake tile within one tile of Huey Teocalli. " +
                        "(This includes the Lake tile where the wonder is placed.)",
                    "+1 [Food] Food and +1 [Production] Production for each Lake tile in your empire."
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: .militaryTactics,
                requiredCivic: nil,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .growth, value: 7)
                ]
            )

        case .kilwaKisiwani:
            // https://civilization.fandom.com/wiki/Kilwa_Kisiwani_(Civ6)
            return WonderTypeData(
                name: "Kilwa Kisiwani",
                effects: [
                    "+3 [Envoy] Envoys when built.", // #
                    "When you are the Suzerain of a City-State this city receives a +15% boost to the yield " +
                    "provided by that City-State. If you are the Suzerain to 2 or more City-States of that " +
                    "type an additional +15% boost is given to all your cities." // #
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: .machinery,
                requiredCivic: nil,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .diplomacy, value: 4)
                ]
            )

        case .kotokuIn:
            // https://civilization.fandom.com/wiki/Kotoku-in_(Civ6)
            return WonderTypeData(
                name: "Kotoku-in",
                effects: [
                    "+20% [Faith] Faith in this city.",
                    "Grants 4 Warrior Monks (if player has founded a religion or if there is " +
                        "a majority religion for this player or city)." // #
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: nil,
                requiredCivic: .divineRight,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .religion, value: 10)
                ]
            )

        case .meenakshiTemple:
            // https://civilization.fandom.com/wiki/Meenakshi_Temple_(Civ6)
            return WonderTypeData(
                name: "Meenakshi Temple",
                effects: [
                    "+3 [Faith] Faith.",
                    "+2 Gurus.", // #
                    "Gurus are 30% cheaper to purchase.", // #
                    "Religious units adjacent to Gurus receive +5 Religious Strength in Theological Combat and +1 Movement." // #
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: nil,
                requiredCivic: .civilService,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 3),
                slots: [],
                flavours: [
                    Flavor(type: .religion, value: 10)
                ]
            )

        case .montStMichel:
            // https://civilization.fandom.com/wiki/Mont_St._Michel_(Civ6)
            return WonderTypeData(
                name: "Mont St. Michel",
                effects: [
                    "+2 [Faith] Faith",
                    "2 [Relic] Relic slots",
                    "All Apostles you create gain the Martyr ability in addition to a " +
                        "second ability you choose normally." // #
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: nil,
                requiredCivic: .divineRight,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 2),
                slots: [.relic, .relic],
                flavours: [
                    Flavor(type: .religion, value: 10)
                ]
            )

        case .universityOfSankore:
            // https://civilization.fandom.com/wiki/University_of_Sankore_(Civ6)
            return WonderTypeData(
                name: "University of Sankore",
                effects: [
                    "+3 [Science] Science",
                    "+1 [Faith] Faith",
                    "+2 [GreatScientist] Great Scientist points per turn", // #
                    "Other civilizations' Trade Routes to this city provide +1 Science and +1 Gold for them", // #
                    "+2 [Science] Science for every Trade Route to this city", // #
                    "Domestic [TradeRoute] Trade Routes give an additional +1 [Faith] Faith to this city" // #
                ],
                era: .medieval,
                productionCost: 710,
                requiredTech: .education,
                requiredCivic: nil,
                amenities: 0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, science: 3, faith: 1),
                slots: [],
                flavours: [
                    Flavor(type: .science, value: 8),
                    Flavor(type: .gold, value: 3)
                ]
            )

            // renaissance

        case .casaDeContratacion:
            // https://civilization.fandom.com/wiki/Casa_de_Contrataci%C3%B3n_(Civ6)
            // It must be built adjacent to a Government Plaza.
            return WonderTypeData(
                name: "TXT_KEY_WONDER_CASA_DE_CONTRATACIO_TITLE",
                effects: [
                    "TXT_KEY_WONDER_CASA_DE_CONTRATACIO_EFFECT1", // #
                    "TXT_KEY_WONDER_CASA_DE_CONTRATACIO_EFFECT2", // #
                    "TXT_KEY_WONDER_CASA_DE_CONTRATACIO_EFFECT3" // #
                ],
                era: .renaissance,
                productionCost: 920,
                requiredTech: .cartography,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .greatPeople, value: 8)
                ]
            )

        case .forbiddenCity:
            // https://civilization.fandom.com/wiki/Forbidden_City_(Civ6)
            return WonderTypeData(
                name: "Forbidden City",
                effects: [
                    "+1 Wildcard policy slot", // #
                    "+5 [Culture] Culture"
                ],
                era: .renaissance,
                productionCost: 920,
                requiredTech: .printing,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, culture: 5.0),
                slots: [],
                flavours: [
                    Flavor(type: .culture, value: 8)
                ]
            )

        case .greatZimbabwe:
            // https://civilization.fandom.com/wiki/Great_Zimbabwe_(Civ6)
            return WonderTypeData(
                name: "Great Zimbabwe",
                effects: [
                    "+1 [TradeRoute] Trade Route", // #
                    "+5 [Gold] Gold",
                    "+2 [GreatMerchant] Great Merchant points per turn", // #
                    "Trade Routes from this city get +2 Gold for every bonus resource within 3 tiles of the city and in this city's territory" // #
                ],
                era: .renaissance,
                productionCost: 920,
                requiredTech: .banking,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 5.0),
                slots: [],
                flavours: [
                    Flavor(type: .gold, value: 8)
                ]
            )

        case .potalaPalace:
            // https://civilization.fandom.com/wiki/Potala_Palace_(Civ6)
            // It must be built on Hills adjacent to Mountains.
            return WonderTypeData(
                name: "Potala Palace",
                effects: [
                    "+1 Diplomatic policy slot", // #
                    "+2 [Culture] Culture",
                    "+3 [Faith] Faith",
                    "+1 Diplomatic Victory Point when built" // #
                ],
                era: .renaissance,
                productionCost: 1060,
                requiredTech: .astronomy,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0, culture: 2.0, faith: 3.0),
                slots: [],
                flavours: [
                    Flavor(type: .diplomacy, value: 7),
                    Flavor(type: .culture, value: 3),
                    Flavor(type: .religion, value: 3)
                ]
            )

        case .stBasilsCathedral:
            // https://civilization.fandom.com/wiki/St._Basil%27s_Cathedral_(Civ6)
            return WonderTypeData(
                name: "St. Basil's Cathedral",
                effects: [
                    "+3 [Relic] Relic slots",
                    "+100% Religious Tourism from this city.", // #
                    "+1 [Food] Food, +1 [Production] Production, and +1 [Culture] Culture on all Tundra tiles for this city." // #
                ],
                era: .renaissance,
                productionCost: 920,
                requiredTech: nil,
                requiredCivic: .reformedChurch,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [.relic, .relic, .relic],
                flavours: [
                    Flavor(type: .religion, value: 10)
                ]
            )

        case .tajMahal:
            // https://civilization.fandom.com/wiki/Taj_Mahal_(Civ6)
            // It must be built along a River.
            return WonderTypeData(
                name: "Taj Mahal",
                effects: [
                    "+1 Era Score from Historic Moment earned after this wonder is complete if that Moment " +
                    "is usually worth 2 or more Era Score." // #
                ],
                era: .renaissance,
                productionCost: 920,
                requiredTech: nil,
                requiredCivic: .humanism,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .religion, value: 2)
                ]
            )

        case .torreDeBelem:
            // https://civilization.fandom.com/wiki/Torre_de_Bel%C3%A9m_(Civ6)
            //  It must be built on Coast adjacent to land and a Harbor. It cannot be built on a Lake.
            return WonderTypeData(
                name: "Torre de Belém",
                effects: [
                    "International [TradeRoute] Trade Route from this city receive +2 [Gold] Gold for every luxury resource at the destination", // #
                    "When the Torre de Belém is constructed, cities not on your home continent " +
                        "receive the lowest Production cost building they can currently construct", // #
                    "+5 [Gold] Gold",
                    "+1 [GreatAdmiral] Great Admiral point per turn" // #
                ],
                era: .renaissance,
                productionCost: 920,
                requiredTech: nil,
                requiredCivic: .mercantilism,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 5.0),
                slots: [],
                flavours: [
                    Flavor(type: .gold, value: 8)
                ]
            )

        case .venetianArsenal:
            // https://civilization.fandom.com/wiki/Venetian_Arsenal_(Civ6)
            // It must be built on Coast adjacent to an Industrial Zone. It cannot be built on a Lake.
            return WonderTypeData(
                name: "Venetian Arsenal",
                effects: [
                    "+2 [GreatEngineer] Great Engineer points per turn", // #
                    "Receive a second naval unit each time you train a naval unit." // #
                ],
                era: .renaissance,
                productionCost: 920,
                requiredTech: .massProduction,
                requiredCivic: nil,
                amenities: 0.0,
                yields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                slots: [],
                flavours: [
                    Flavor(type: .navalGrowth, value: 8),
                    Flavor(type: .naval, value: 3)
                ]
            )
        }
    }

    private func adjacentTo(district: DistrictType, on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var nextToDistrict: Bool = false

        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            if neighborTile.has(district: district) {
                nextToDistrict = true
            }
        }

        return nextToDistrict
    }

    private func adjacentTo(resource: ResourceType, on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var nextToResource: Bool = false

        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            guard let player = neighborTile.owner() else {
                continue
            }

            if neighborTile.has(resource: resource, for: player) {
                nextToResource = true
            }
        }

        return nextToResource
    }

    private func adjacentTo(feature: FeatureType, on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var nextToFeature: Bool = false

        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            if neighborTile.has(feature: feature) {
                nextToFeature = true
            }
        }

        return nextToFeature
    }

    private func adjacentTo(improvement: ImprovementType, on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var nextToImprovement: Bool = false

        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            if neighborTile.has(improvement: improvement) {
                nextToImprovement = true
            }
        }

        return nextToImprovement
    }

    private func adjacentTo(building: BuildingType, on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var nextToBuilding: Bool = false

        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            guard let city = neighborTile.workingCity() else {
                continue
            }

            if city.has(building: building) {
                nextToBuilding = true
            }
        }

        return nextToBuilding
    }

    // swiftlint:disable cyclomatic_complexity
    func canBuild(on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        let hasReligion = tile.owner()?.religion?.currentReligion() != ReligionType.none

        switch self {

        case .none:
            return false

        case .greatBath:
            // It must be built on Floodplains.
            return tile.has(feature: .floodplains)

        case .etemenanki:
            // Must be built on Floodplains or Marsh.
            return tile.has(feature: .floodplains) || tile.has(feature: .marsh)

        case .pyramids:
            // Must be built on Desert (including Floodplains) without Hills.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            return tile.terrain() == .desert || tile.has(feature: .floodplains)

        case .hangingGardens:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built next to a River.
            return gameModel.river(at: point)

        case .oracle:
            // Must be built on Hills.
            guard tile.isLand() && tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            return true

        case .stonehenge:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built on flat land adjacent to Stone.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            return self.adjacentTo(resource: .stone, on: point, in: gameModel)

        case .templeOfArtemis:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built next to a Camp.
            return self.adjacentTo(improvement: .camp, on: point, in: gameModel)

        case .greatLighthouse:
            // Must be built on the Coast and adjacent to a Harbor district with a Lighthouse.
            guard tile.terrain() == .shore else {
                return false
            }

            guard self.adjacentTo(building: .lighthouse, on: point, in: gameModel) else {
                return false
            }

            return self.adjacentTo(district: .harbor, on: point, in: gameModel)

        case .greatLibrary:
            // Must be built on flat land adjacent to a Campus with a Library.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            guard self.adjacentTo(building: .library, on: point, in: gameModel) else {
                return false
            }

            return self.adjacentTo(district: .campus, on: point, in: gameModel)

        case .apadana:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built adjacent to a Capital.
            for player in gameModel.players {
                for cityRef in gameModel.cities(of: player) {

                    guard let city = cityRef else {
                        continue
                    }

                    if city.isCapital() && point.isNeighbor(of: city.location) {
                        return true
                    }
                }
            }

            return false

        case .colosseum:
            // Must be built on flat land adjacent to an Entertainment Complex district with an Arena.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            guard self.adjacentTo(building: .arena, on: point, in: gameModel) else {
                return false
            }

            return self.adjacentTo(district: .entertainmentComplex, on: point, in: gameModel)

        case .colossus:
            // Must be built on Coast and adjacent to a Harbor district.
            guard tile.terrain() == .shore else {
                return false
            }

            return self.adjacentTo(district: .harbor, on: point, in: gameModel)

        case .jebelBarkal:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built on a Desert Hills tile.
            return tile.terrain() == .desert

        case .mausoleumAtHalicarnassus:
            // Must be built on a coastal tile adjacent to a Harbor district.
            guard gameModel.isCoastal(at: point) else {
                return false
            }

            return self.adjacentTo(district: .harbor, on: point, in: gameModel)

        case .mahabodhiTemple:
            // Must be built on Woods adjacent to a Holy Site district with a Temple,
            // and player must have founded a religion.
            guard tile.has(feature: .forest) else {
                return false
            }

            guard hasReligion else {
                return false
            }

            guard self.adjacentTo(building: .temple, on: point, in: gameModel) else {
                return false
            }

            return self.adjacentTo(district: .holySite, on: point, in: gameModel)

        case .petra:
            // Must be built on Desert or Floodplains without Hills.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            return tile.terrain() == .desert || tile.has(feature: .floodplains)

        case .terracottaArmy:
            // Must be built on flat Grassland or Plains adjacent to an Encampment district with a Barracks or Stable.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            guard tile.terrain() == .grass || tile.terrain() == .plains else {
                return false
            }

            guard self.adjacentTo(building: .barracks, on: point, in: gameModel) ||
                    self.adjacentTo(building: .stable, on: point, in: gameModel) else {
                return false
            }

            return self.adjacentTo(district: .encampment, on: point, in: gameModel)

        case .machuPicchu:
            // Must be built on a Mountain tile that does not contain a Volcano.
            return tile.has(feature: .mountains)

        case .statueOfZeus:
            // Must be built on flat land adjacent to an Encampment with a Barracks.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            guard self.adjacentTo(building: .barracks, on: point, in: gameModel) else {
                return false
            }

            return self.adjacentTo(district: .encampment, on: point, in: gameModel)

        case .alhambra:
            // Must be built on Hills adjacent to an Encampment district.
            guard tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            return self.adjacentTo(district: .encampment, on: point, in: gameModel)

        case .angkorWat:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built adjacent to an Aqueduct district.
            return self.adjacentTo(district: .aqueduct, on: point, in: gameModel)

        case .chichenItza:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built on Rainforest.
            return tile.has(feature: .rainforest)

        case .hagiaSophia:
            // Must be built on flat land adjacent to a Holy Site district, and player must have founded a religion.
            guard !tile.hasHills() && tile.isLand() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            guard hasReligion else {
                return false
            }

            return self.adjacentTo(district: .holySite, on: point, in: gameModel)

        case .hueyTeocalli:
            // Must be built on a Lake tile adjacent to land.
            guard tile.has(feature: .lake) else {
                return false
            }

            var nextToLand: Bool = false

            for neighbor in point.neighbors() {

                guard let neighborTile = gameModel.tile(at: neighbor) else {
                    continue
                }

                if neighborTile.isLand() {
                    nextToLand = true
                }
            }

            return nextToLand
        case .kilwaKisiwani:
            // Must be built on a flat tile adjacent to a Coast.
            guard !tile.hasHills() && tile.isLand() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            var nextToCoast: Bool = false

            for neighbor in point.neighbors() {

                guard let neighborTile = gameModel.tile(at: neighbor) else {
                    continue
                }

                if neighborTile.isWater() {
                    nextToCoast = true
                }
            }

            return nextToCoast
        case .kotokuIn:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built adjacent to a Holy Site with a Temple.
            guard self.adjacentTo(district: .holySite, on: point, in: gameModel) else {
                return false
            }

            guard self.adjacentTo(building: .temple, on: point, in: gameModel) else {
                return false
            }

            return true
        case .meenakshiTemple:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built adjacent to a Holy Site district, and player must have founded a religion.
            guard hasReligion else {
                return false
            }
            return self.adjacentTo(district: .holySite, on: point, in: gameModel)

        case .montStMichel:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built on Floodplains or Marsh.
            guard tile.has(feature: .floodplains) || tile.has(feature: .marsh) else {
                return false
            }

            return true

        case .universityOfSankore:
            // Must be built on a Desert or Desert Hill adjacent to a Campus with a University.
            guard tile.terrain() == .desert else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            if !self.adjacentTo(district: .campus, on: point, in: gameModel) {
                return false
            }

            /*guard self.adjacentTo(building: .university, on: point, in: gameModel) else {
                return false
            }*/

            return true

        case .casaDeContratacion:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built adjacent to a Government Plaza.
            // return self.adjacentTo(district: .governmentPlaza, on: point, in: gameModel)
            return true

        case .forbiddenCity:
            // Must be built on flat land adjacent to City Center.
            guard tile.isLand() && !tile.hasHills() else {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            return self.adjacentTo(district: .cityCenter, on: point, in: gameModel)

        case .greatZimbabwe:
            // Must be built adjacent to Cattle and a Commercial Hub district with a Market.
            if !self.adjacentTo(resource: .cattle, on: point, in: gameModel) {
                return false
            }

            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            if !self.adjacentTo(district: .commercialHub, on: point, in: gameModel) {
                return false
            }

            guard self.adjacentTo(building: .market, on: point, in: gameModel) else {
                return false
            }

            return true

        case .potalaPalace:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built on a Hill adjacent to a Mountain.
            guard tile.hasHills() else {
                return false
            }

            return self.adjacentTo(feature: .mountains, on: point, in: gameModel)

        case .stBasilsCathedral:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built adjacent to a City Center
            return self.adjacentTo(district: .cityCenter, on: point, in: gameModel)

        case .tajMahal:
            // no mountains
            guard !tile.has(feature: .mountains) else {
                return false
            }

            // Must be built next to a River.
            return gameModel.river(at: point)

        case .torreDeBelem:
            // It must be built on Coast adjacent to land and a Harbor. It cannot be built on a Lake.
            guard tile.isWater() else {
                return false
            }

            return self.adjacentTo(district: .harbor, on: point, in: gameModel)

        case .venetianArsenal:
            // It must be built on Coast adjacent to an Industrial Zone. It cannot be built on a Lake.
            guard tile.isWater() else {
                return false
            }

            return self.adjacentTo(district: .industrialZone, on: point, in: gameModel)
        }
    }
}
