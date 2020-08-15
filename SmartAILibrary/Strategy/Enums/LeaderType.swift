//
//  Leader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum LeaderAbilityType {

    case none

    //case convertLandBarbarians
    case toTheWorldsEnd
    case trajansColumn
    case paxBritannica
    case fallOfBabylon
    case giftsForTheTlatoani
    case holyRomanEmperor // barbarossa
    case flyingSquadron // napoleon
    case mediterraneansBride // cleopatra
    case theGrandEmbassy // peter the great
    
    private struct LeaderAbilityTypeData {
        
        let name: String
        let effects: [String]
    }
    
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

// https://civdata.com/
public enum LeaderType: Int, Codable {

    case none
    case barbar

    case alexander
    case trajan
    case victoria
    case cyrus
    case montezuma
    case napoleon
    case cleopatra
    case barbarossa
    case peterTheGreat

    static var all: [LeaderType] {
        return [.alexander, .trajan, .victoria, .cyrus, .montezuma, .napoleon, .cleopatra, .barbarossa, .peterTheGreat]
    }

    public func name() -> String {

        switch self {

        case .none: return "None"
        case .barbar: return "Barbar"

        case .alexander: return "Alexander"
        case .trajan: return "Trajan"
        case .victoria: return "Victoria"
        case .cyrus: return "Cyrus"
        case .montezuma: return "Montezuma"
        case .napoleon: return "Napoleon"
        case .cleopatra: return "Cleopatra"
        case .barbarossa: return "Barbarossa"
        case .peterTheGreat: return "Peter the Great"
        }
    }

    public func civilization() -> CivilizationType {

        switch self {

        case .none: return .barbarian
        case .barbar: return .barbarian

        case .alexander: return .greek
        case .trajan: return .roman
        case .victoria: return .english
        case .cyrus: return .persian
        case .montezuma: return .aztecs
        case .napoleon: return .french
        case .cleopatra: return .egyptian
        case .barbarossa: return .german
        case .peterTheGreat: return .russian
        }
    }

    func flavors() -> [Flavor] {

        switch self {

        case .none: return []
        case .barbar: return []

        case .alexander:
            return [
                Flavor(type: .cityDefense, value: 5),
                Flavor(type: .culture, value: 7),
                Flavor(type: .defense, value: 5),
                Flavor(type: .diplomacy, value: 9),
                Flavor(type: .expansion, value: 8),
                Flavor(type: .gold, value: 3),
                Flavor(type: .growth, value: 4),
                Flavor(type: .happiness, value: 5),
                Flavor(type: .infrastructure, value: 4),
                Flavor(type: .militaryTraining, value: 5),
                Flavor(type: .mobile, value: 8),
                Flavor(type: .naval, value: 5),
                Flavor(type: .navalGrowth, value: 6),
                Flavor(type: .navalRecon, value: 5),
                Flavor(type: .navalTileImprovement, value: 6),
                Flavor(type: .offense, value: 8),
                Flavor(type: .production, value: 5),
                Flavor(type: .recon, value: 5),
                Flavor(type: .science, value: 6),
                Flavor(type: .tileImprovement, value: 4),
                Flavor(type: .wonder, value: 6),
            ]
        case .trajan:
            return [
                Flavor(type: .cityDefense, value: 5),
                Flavor(type: .culture, value: 5),
                Flavor(type: .defense, value: 6),
                Flavor(type: .diplomacy, value: 5),
                Flavor(type: .expansion, value: 8),
                Flavor(type: .gold, value: 6),
                Flavor(type: .growth, value: 5),
                Flavor(type: .happiness, value: 8),
                Flavor(type: .infrastructure, value: 8),
                Flavor(type: .militaryTraining, value: 7),
                Flavor(type: .mobile, value: 4),
                Flavor(type: .naval, value: 5),
                Flavor(type: .navalGrowth, value: 4),
                Flavor(type: .navalRecon, value: 5),
                Flavor(type: .navalTileImprovement, value: 4),
                Flavor(type: .offense, value: 5),
                Flavor(type: .production, value: 6),
                Flavor(type: .recon, value: 3),
                Flavor(type: .science, value: 5),
                Flavor(type: .tileImprovement, value: 7),
                Flavor(type: .wonder, value: 6),
            ]
        case .victoria:
            return [
                Flavor(type: .cityDefense, value: 6),
                Flavor(type: .culture, value: 6),
                Flavor(type: .defense, value: 6),
                Flavor(type: .diplomacy, value: 6),
                Flavor(type: .expansion, value: 6),
                Flavor(type: .gold, value: 8),
                Flavor(type: .growth, value: 4),
                Flavor(type: .happiness, value: 5),
                Flavor(type: .infrastructure, value: 5),
                Flavor(type: .militaryTraining, value: 5),
                Flavor(type: .mobile, value: 3),
                Flavor(type: .naval, value: 8),
                Flavor(type: .navalGrowth, value: 7),
                Flavor(type: .navalRecon, value: 8),
                Flavor(type: .navalTileImprovement, value: 7),
                Flavor(type: .offense, value: 3),
                Flavor(type: .production, value: 6),
                Flavor(type: .recon, value: 6),
                Flavor(type: .science, value: 6),
                Flavor(type: .tileImprovement, value: 6),
                Flavor(type: .wonder, value: 5),
            ]

        case .cyrus: return []
        case .montezuma: return []
        case .napoleon: return []
        case .cleopatra: return []
        case .barbarossa: return []
        case .peterTheGreat: return []
        }
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let flavor = self.flavors().first(where: { $0.type == flavorType }) {
            return flavor.value
        }

        return 0
    }

    func traits() -> [Trait] {

        switch self {

        case .none: return []
        case .barbar: return []

        case .alexander:
            return [Trait(type: .boldness, value: 8)]
        case .trajan:
            return [Trait(type: .boldness, value: 6)]
        case .victoria:
            return [Trait(type: .boldness, value: 4)]
        case .cyrus:
            return []
        case .montezuma:
            return []
        case .napoleon:
            return []
        case .cleopatra:
            return []
        case .barbarossa:
            return []
        case .peterTheGreat:
            return []
        }
    }

    func trait(for traitType: TraitType) -> Int {

        if let trait = self.traits().first(where: { $0.type == traitType }) {
            return trait.value
        }

        return 0
    }

    func approachBiases() -> [ApproachBias] {

        switch self {

        case .none: return []
        case .barbar: return []

        case .alexander: return [
                ApproachBias(approach: .afraid, bias: 3),
                ApproachBias(approach: .deceptive, bias: 4),
                ApproachBias(approach: .friendly, bias: 5),
                ApproachBias(approach: .guarded, bias: 5),
                ApproachBias(approach: .hostile, bias: 7),
                ApproachBias(approach: .neutrally, bias: 4),
                ApproachBias(approach: .war, bias: 6)
            ]
        case .trajan: return [
                ApproachBias(approach: .afraid, bias: 5),
                ApproachBias(approach: .deceptive, bias: 6),
                ApproachBias(approach: .friendly, bias: 4),
                ApproachBias(approach: .guarded, bias: 6),
                ApproachBias(approach: .hostile, bias: 5),
                ApproachBias(approach: .neutrally, bias: 5),
                ApproachBias(approach: .war, bias: 5)
            ]
        case .victoria: return [
                ApproachBias(approach: .afraid, bias: 5),
                ApproachBias(approach: .deceptive, bias: 6),
                ApproachBias(approach: .friendly, bias: 4),
                ApproachBias(approach: .guarded, bias: 7),
                ApproachBias(approach: .hostile, bias: 7),
                ApproachBias(approach: .neutrally, bias: 5),
                ApproachBias(approach: .war, bias: 4)
            ]
        case .cyrus:
            return []
        case .montezuma:
            return []
        case .napoleon:
            return []
        case .cleopatra:
            return []
        case .barbarossa:
            return []
        case .peterTheGreat:
            return []
        }
    }

    func approachBias(for approachType: PlayerApproachType) -> Int {

        if let approachBias = self.approachBiases().first(where: { $0.approach == approachType }) {
            return approachBias.bias
        }

        return 0
    }

    func ability() -> LeaderAbilityType {

        switch self {

        case .none: return .none
        case .barbar: return .none

        case .alexander: return .toTheWorldsEnd
        case .trajan: return .trajansColumn
        case .victoria: return .paxBritannica
        case .cyrus: return .fallOfBabylon
        case .montezuma: return .giftsForTheTlatoani
        case .napoleon: return .flyingSquadron
        case .cleopatra: return .mediterraneansBride
        case .barbarossa: return .holyRomanEmperor
        case .peterTheGreat: return .theGrandEmbassy
        }
    }
}
