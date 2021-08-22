//
//  LeaderAbilityType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum LeaderAbilityType {

    case none

    case toTheWorldsEnd
    case trajansColumn
    case paxBritannica
    case fallOfBabylon
    case giftsForTheTlatoani
    case holyRomanEmperor // barbarossa
    case flyingSquadron // napoleon
    case mediterraneansBride // cleopatra
    case theGrandEmbassy // peter the great

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    // private methods

    private struct LeaderAbilityTypeData {

        let name: String
        let effects: [String]
    }

    // swiftlint:disable line_length
    private func data() -> LeaderAbilityTypeData {

        switch self {

        case .none:
            return LeaderAbilityTypeData(name: "",
                                         effects: [])

        case .toTheWorldsEnd:
            // https://civilization.fandom.com/wiki/Alexander_(Civ6)
            return LeaderAbilityTypeData(name: "To the World's End",
                                         effects: ["Macedonian cities never incur war weariness.", // FIXME
                                                   "All military units heal completely when a city with a Wonder is captured.",
                                                   "Gain the Hetairoi unique unit with Horseback Riding."]) // FIXME
        case .trajansColumn:
            // https://civilization.fandom.com/wiki/Trajan_(Civ6)
            return LeaderAbilityTypeData(name: "Trajan's Column",
                                         effects: ["All founded cities start with a free monument in the City Center."])
        case .paxBritannica:
            // https://civilization.fandom.com/wiki/Victoria_(Civ6)
            return LeaderAbilityTypeData(name: "Pax Britannica",
                                         effects: ["The first city founded on each continent other than England's home continent grants a free melee unit in that city and +1 TradeRoute6 Trade Route capacity.", // FIXME
                                                   "Building a Royal Navy Dockyard grants a free naval unit in that city.", // FIXME
                                                   "Gain the Redcoat unique unit with Military Science."]) // FIXME
        case .fallOfBabylon:
            // https://civilization.fandom.com/wiki/Cyrus_(Civ6)
            return LeaderAbilityTypeData(name: "Fall of Babylon",
                                         effects: ["+2 Civ6Movement Movement for all units for the next 10 turns after declaring a Surprise War.", // FIXME
                                                   "Declaring a Surprise War only counts as a Formal War for the purpose of Grievances (Civ6) Grievances and war weariness.", // FIXME
                                                   "Occupied cities have no penalties to their yields.", // FIXME
                                                   "+5 Loyalty per turn in occupied cities with a garrisoned unit."]) // FIXME
        case .giftsForTheTlatoani:
            // https://civilization.fandom.com/wiki/Montezuma_(Civ6)
            return LeaderAbilityTypeData(name: "Gifts for the Tlatoani",
                                         effects: ["Improved Luxury resources provide an Amenities6 Amenity to 2 extra cities.", // FIXME
                                                   "+1 Civ6StrengthIcon Combat Strength for all units for each different improved Luxury resource in Aztec territory."]) // FIXME
        case .holyRomanEmperor:
            // https://civilization.fandom.com/wiki/Frederick_Barbarossa_(Civ6)
            return LeaderAbilityTypeData(name: "Holy Roman Emperor",
                                         effects: ["Gain an additional Military policy slot in all Governments.", // FIXME
                                                   "+7 Civ6StrengthIcon Combat Strength for all units when fighting city-states and their units."]) // FIXME
        case .flyingSquadron:
            // https://civilization.fandom.com/wiki/Catherine_de_Medici_(Civ6)
            return LeaderAbilityTypeData(name: "Flying Squadron",
                                         effects: ["+1 level of DiplomaticVisibility6 Diplomatic Visibility with every encountered civilization.", // FIXME
                                                   "Receives a free Spy (and extra Spy capacity) with Castles.", // FIXME
                                                   "All Spies start as Agents with a free promotion."]) // FIXME
        case .mediterraneansBride:
            // https://civilization.fandom.com/wiki/Cleopatra_(Civ6)
            return LeaderAbilityTypeData(name: "Mediterranean's Bride",
                                         effects: ["International TradeRoute6 Trade Routes grant +4 Civ6Gold Gold.", // FIXME
                                                   "TradeRoute6 Trade Routes sent to Egypt from other civilizations provide +2 Civ6Food Food for them and +2 Civ6Gold Gold for Egypt."]) // FIXME
        case .theGrandEmbassy:
            // https://civilization.fandom.com/wiki/Peter_(Civ6)
            return LeaderAbilityTypeData(name: "The Grand Embassy",
                                         effects: ["TradeRoute6 Trade Routes to more advanced civilizations grant Russia +1 Civ6Science Science for every three technologies that civilization is ahead of them, and +1 Civ6Culture Culture for every three civics."]) // FIXME
        }
    }
}
