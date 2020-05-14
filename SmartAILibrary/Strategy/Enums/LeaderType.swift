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

    case convertLandBarbarians
    case cityStateFriendship
    case capitalBuildsCheaper
    case oceanMovement
    case enhancedGoldenAges
    case giftsForTheTlatoani

    func extraEmbarkMoves() -> Int {

        if self == .oceanMovement {
            return 2
        }

        return 0
    }

    func goldenAgeMovesChange() -> Int {

        if self == .oceanMovement {
            return 1
        }

        return 0
    }
}

// https://civdata.com/
public enum LeaderType: Int, Codable {

    case none
    case barbar

    case alexander
    case augustus
    case elizabeth
    case darius
    case montezuma
    case napoleon
    case cleopatra
    case barbarossa
    case peterTheGreat

    static var all: [LeaderType] {
        return [.alexander, .augustus, .elizabeth, .darius, .montezuma, .napoleon, .cleopatra, .barbarossa, .peterTheGreat]
    }

    public func name() -> String {

        switch self {

        case .none: return "None"
        case .barbar: return "Barbar"

        case .alexander: return "Alexander"
        case .augustus: return "Augustus"
        case .elizabeth: return "Elizabeth"
        case .darius: return "Darius"
        case .montezuma: return "Montezuma"
        case .napoleon: return "Napoleon"
        case .cleopatra: return "Cleopatra"
        case .barbarossa: return "Barbarossa"
        case .peterTheGreat: return "Peter the Great"
        }
    }

    public func firstGreeting(of leader: LeaderType) -> String {

        if self == .augustus {
            return "Hail, stranger. I am the Imperator Caesar Augustus of far-reaching Rome. Who are you and what lands can you claim as your own?"
        }
        
        if self == .elizabeth {
            return "Greetings. We are by the Grace of God, Elizabeth, Queen of the United Kingdom of Great Britain and Ireland. And soon, dare I say, the empire."
        }
        
        return "Greetings traveler. You should know that you stand in the presence of greatness!"
    }

    public func civilization() -> CivilizationType {

        switch self {

        case .none: return .barbarian
        case .barbar: return .barbarian

        case .alexander: return .greek
        case .augustus: return .roman
        case .elizabeth: return .english
        case .darius: return .persian
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
        case .augustus:
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
        case .elizabeth:
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

        case .darius: return []
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
        case .augustus:
            return [Trait(type: .boldness, value: 6)]
        case .elizabeth:
            return [Trait(type: .boldness, value: 4)]
        case .darius:
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
        case .augustus: return [
                ApproachBias(approach: .afraid, bias: 5),
                ApproachBias(approach: .deceptive, bias: 6),
                ApproachBias(approach: .friendly, bias: 4),
                ApproachBias(approach: .guarded, bias: 6),
                ApproachBias(approach: .hostile, bias: 5),
                ApproachBias(approach: .neutrally, bias: 5),
                ApproachBias(approach: .war, bias: 5)
            ]
        case .elizabeth: return [
                ApproachBias(approach: .afraid, bias: 5),
                ApproachBias(approach: .deceptive, bias: 6),
                ApproachBias(approach: .friendly, bias: 4),
                ApproachBias(approach: .guarded, bias: 7),
                ApproachBias(approach: .hostile, bias: 7),
                ApproachBias(approach: .neutrally, bias: 5),
                ApproachBias(approach: .war, bias: 4)
            ]
        case .darius:
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

        case .alexander: return .cityStateFriendship
        case .augustus: return .capitalBuildsCheaper
        case .elizabeth: return .oceanMovement
        case .darius: return .enhancedGoldenAges
        case .montezuma: return .giftsForTheTlatoani
        case .napoleon: return .enhancedGoldenAges
        case .cleopatra: return .enhancedGoldenAges
        case .barbarossa: return .enhancedGoldenAges
        case .peterTheGreat: return .enhancedGoldenAges
        }
    }
}
