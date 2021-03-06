//
//  WonderType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum WonderType: Int, Codable {

    case none

    // ancient
    //case greatBath
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

    public static var all: [WonderType] {

        return [
            // ancient
            /*.greatBath, */.pyramids, .hangingGardens, .oracle, .stonehenge, .templeOfArtemis,
            
            // classical
                .greatLighthouse, .greatLibrary, .apadana, .colosseum, .colossus, .jebelBarkal, .mausoleumAtHalicarnassus, .mahabodhiTemple, .petra, .terracottaArmy
        ]
    }

    public func name() -> String {

        return self.data().name
    }
    
    public func bonuses() -> [String] {

        return self.data().bonuses
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

        return 0
    }

    private func flavours() -> [Flavor] {

        return self.data().flavours
    }

    func amenities() -> Double {

        return self.data().amenities
    }
    
    func slotsForGreatWork() -> [GreatWorkSlotType] {

        return self.data().slots
    }

    private struct WonderTypeData {

        let name: String
        let bonuses: [String]
        let era: EraType
        let productionCost: Int
        let requiredTech: TechType?
        let requiredCivic: CivicType?
        let amenities: Double
        let slots: [GreatWorkSlotType]
        let flavours: [Flavor]
    }

    private func data() -> WonderTypeData {

        switch self {

        case .none:
            return WonderTypeData(name: "",
                                  bonuses: [],
                                  era: .none,
                                  productionCost: -1,
                                  requiredTech: nil,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [])

            // ancient
        /*case .greatBath:
            return WonderTypeData(name: "Great Bath",
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .pottery,
                                  requiredCivic: nil,
                                  amenities: 1.0,
                                  slots: [],
                                  flavours: [Flavor(type: .wonder, value: 15), Flavor(type: .religion, value: 10)])*/
        case .hangingGardens:
            // https://civilization.fandom.com/wiki/Hanging_Gardens_(Civ6)
            return WonderTypeData(name: "Hanging Gardens",
                                  bonuses: ["Increases growth by 15% in all cities.",
                                            "+2 Housing6 Housing"],
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .irrigation,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .wonder, value: 20), Flavor(type: .growth, value: 20)])
        case .stonehenge:
            // https://civilization.fandom.com/wiki/Stonehenge_(Civ6)
            // FIXME Great Prophets may found a religion on Stonehenge instead of a Holy Site.
            return WonderTypeData(name: "Stonehenge",
                                  bonuses: ["+2 Civ6Faith Faith",
                                            "Grants a free Great Prophet."],
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .astrology,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .wonder, value: 25), Flavor(type: .culture, value: 20)])
        case .templeOfArtemis:
            // https://civilization.fandom.com/wiki/Temple_of_Artemis_(Civ6)
            // FIXME Must be built next to a Camp.
            return WonderTypeData(name: "Temple of Artemis",
                                  bonuses: ["+4 Civ6Food Food",
                                            "+3 Housing6 Housing",
                                            "Each Camp, Pasture, and Plantation improvement within 4 tiles of this wonder provides +1 Amenities6 Amenity."],
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .archery,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .wonder, value: 20), Flavor(type: .growth, value: 10)])
        case .pyramids:
            // https://civilization.fandom.com/wiki/Pyramids_(Civ6)
            return WonderTypeData(name: "Pyramids",
                                  bonuses: ["+2 Civ6Culture Culture",
                                            "Grants a free Builder.",
                                            "All Builders can build 1 extra improvement."],
                                  era: .ancient,
                                  productionCost: 220,
                                  requiredTech: .masonry,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .wonder, value: 25), Flavor(type: .culture, value: 20)])
        case .oracle:
            // https://civilization.fandom.com/wiki/Oracle_(Civ6)
            // FIXME Patronage of Great People costs 25% less Civ6Faith Faith.
            // FIXME Districts in this city provide +2 Great Person points of their type.
            return WonderTypeData(name: "Oracle",
                                  bonuses: ["+1 Civ6Culture Culture",
                                            "+1 Civ6Faith Faith",
                                            "Patronage of Great People costs 25% less Civ6Faith Faith.",
                                            "Districts in this city provide +2 Great Person points of their type."],
                                  era: .ancient,
                                  productionCost: 290,
                                  requiredTech: nil,
                                  requiredCivic: .mysticism,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .wonder, value: 20), Flavor(type: .culture, value: 15)])

            // classical
        case .greatLighthouse:
            // https://civilization.fandom.com/wiki/Great_Lighthouse_(Civ6)
            // FIXME Must be built on the Coast and adjacent to a Harbor district with a Lighthouse.
            return WonderTypeData(name: "Great Lighthouse",
                                  bonuses: ["+1 Civ6Movement Movement for all naval units.",
                                            "+3 Civ6Gold Gold",
                                            "+1 Admiral6 Great Admiral point per turn"],
                                  era: .classical,
                                  productionCost: 290,
                                  requiredTech: .celestialNavigation,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .greatPeople, value: 20), Flavor(type: .gold, value: 15), Flavor(type: .navalGrowth, value: 10), Flavor(type: .navalRecon, value: 8)])
        case .greatLibrary:
            // https://civilization.fandom.com/wiki/Great_Library_(Civ6)
            return WonderTypeData(name: "Great Library",
                                  bonuses: ["+2 Civ6Science Science",
                                            "+1 Scientist6 Great Scientist point per turn",
                                            "+2 GreatWorkWriting6 Great Works of Writing slots",
                                            "Receive boosts to all Ancient and Classical era technologies.",
                                            "+1 Writer6 Great Writer point per turn"],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: nil,
                                  requiredCivic: .recordedHistory,
                                  amenities: 0.0,
                                  slots: [.written, .written],
                                  flavours: [Flavor(type: .science, value: 20), Flavor(type: .greatPeople, value: 15)])
        case .apadana:
            // https://civilization.fandom.com/wiki/Apadana_(Civ6)
            // FIXME +2 Envoy6 Envoys when you build a wonder, including Apadana, in this city.
            return WonderTypeData(name: "Apadana",
                                  bonuses: ["+2 Great Work slots",
                                            "+2 Envoy6 Envoys when you build a wonder, including Apadana, in this city."],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: nil,
                                  requiredCivic: .politicalPhilosophy,
                                  amenities: 0.0,
                                  slots: [.any, .any],
                                  flavours: [Flavor(type: .diplomacy, value: 20), Flavor(type: .culture, value: 7),])
        case .colosseum:
            // https://civilization.fandom.com/wiki/Colosseum_(Civ6)
            // FIXME +2 Loyalty
            return WonderTypeData(name: "Colosseum",
                                  bonuses: ["+2 Civ6Culture Culture",
                                            "+2 Loyalty and +2 Amenities6 Amenities from entertainment"],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: nil,
                                  requiredCivic: .gamesAndRecreation,
                                  amenities: 2.0,
                                  slots: [],
                                  flavours: [Flavor(type: .happiness, value: 20), Flavor(type: .culture, value: 10)])
        case .colossus:
            // https://civilization.fandom.com/wiki/Colossus_(Civ6)
            // FIXME +1 TradeRoute6 Trade Route capacity
            return WonderTypeData(name: "Colossus",
                                  bonuses: ["+3 Civ6Gold Gold",
                                            "+1 Admiral6 Great Admiral point per turn",
                                            "+1 TradeRoute6 Trade Route capacity",
                                            "Grants a Trader unit."],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: .shipBuilding,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .gold, value: 12), Flavor(type: .naval, value: 14), Flavor(type: .navalRecon, value: 3)])
        case .jebelBarkal:
            // https://civilization.fandom.com/wiki/Jebel_Barkal_(Civ6)
            // FIXME Awards 2 Iron (Civ6) Iron.
            // FIXME It must be built on a Desert Hills tile
            return WonderTypeData(name: "Jebel Barkal",
                                  bonuses: ["Awards 2 Iron (Civ6) Iron.",
                                        "Provides +4 Civ6Faith Faith to all your cities that are within 6 tiles."],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: .ironWorking,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .religion, value: 12), Flavor(type: .tileImprovement, value: 7),])
        case .mausoleumAtHalicarnassus:
            // https://civilization.fandom.com/wiki/Mausoleum_at_Halicarnassus_(Civ6)
            // FIXME It must be built adjacent to a Harbor.
            // FIXME All Great Engineers have an additional charge.
            return WonderTypeData(name: "Mausoleum at Halicarnassus",
                                  bonuses: ["+1 Civ6Science Science, +1 Civ6Faith Faith, and +1 Civ6Culture Culture on all Coast tiles in this city.",
                                            "All Great Engineers have an additional charge."],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: nil,
                                  requiredCivic: .defensiveTactics,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .tileImprovement, value: 7), Flavor(type: .science, value: 5), Flavor(type: .religion, value: 5), Flavor(type: .culture, value: 7),])
        case .mahabodhiTemple:
            // https://civilization.fandom.com/wiki/Mahabodhi_Temple_(Civ6)
            // FIXME Grants 2 Apostles.
            return WonderTypeData(name: "Mahabodhi Temple",
                                  bonuses: ["+4 Civ6Faith Faith",
                                            "Grants 2 Apostles."],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: nil,
                                  requiredCivic: .theology,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .religion, value: 20), Flavor(type: .greatPeople, value: 7),])
        case .petra:
            // https://civilization.fandom.com/wiki/Petra_(Civ6)
            // FIXME It must be built on Desert or Floodplains without Hills.
            return WonderTypeData(name: "Petra",
                                  bonuses: ["+2 Civ6Food Food, +2 Civ6Gold Gold, and +1 Civ6Production Production on all Desert tiles for this city (non-Floodplains)."],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: .mathematics,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .tileImprovement, value: 10), Flavor(type: .growth, value: 12), Flavor(type: .gold, value: 10),])
        case .terracottaArmy:
            // https://civilization.fandom.com/wiki/Terracotta_Army_(Civ6)
            // FIXME It must be built on flat Grassland or Plains adjacent to an Encampment with a Barracks or Stable.
            // FIXME All current land units gain a Promotion (Civ6) promotion level.
            return WonderTypeData(name: "Terracotta Army",
                                  bonuses: ["+2 General6 Great General points per turn",
                                            "All current land units gain a Promotion (Civ6) promotion level."],
                                  era: .classical,
                                  productionCost: 400,
                                  requiredTech: .construction,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  slots: [],
                                  flavours: [Flavor(type: .greatPeople, value: 10), Flavor(type: .militaryTraining, value: 7),])
            
            // medieval
        }
    }
}
