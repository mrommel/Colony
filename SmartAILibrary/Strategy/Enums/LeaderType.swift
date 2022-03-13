//
//  Leader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civdata.com/
// swiftlint:disable type_body_length
public enum LeaderType: Codable, Equatable, Hashable {

    enum CodingKeys: String, CodingKey {

        case value
    }

    case none
    case unmet

    case barbar
    case freeCities
    case cityState(type: CityStateType)

    case alexander
    case trajan
    case victoria
    case cyrus
    case montezuma
    case napoleon
    case cleopatra
    case barbarossa
    case peterTheGreat

    public static var all: [LeaderType] {
        return [
            .alexander,
            .trajan,
            .victoria,
            .cyrus,
            .montezuma,
            .napoleon,
            .cleopatra,
            .barbarossa,
            .peterTheGreat
        ]
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let value = try container.decode(String.self, forKey: .value)
        self = LeaderType.from(key: value) ?? .none
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.toKey(), forKey: .value)
    }

    public func name() -> String {

        return self.data().name
    }

    public func intro() -> String {

        return self.data().intro
    }

    public func civilization() -> CivilizationType {

        return self.data().civilization
    }

    public func agenda() -> LeaderAgendaType {

        return self.data().agenda
    }

    public func rejectedAgendas() -> [LeaderAgendaType] {

        return self.data().rejectedAgendas
    }

    func flavors() -> [Flavor] {

        switch self {

        case .none: return []
        case .unmet: return []
        case .barbar: return []
        case .freeCities: return []
        case .cityState: return []

        case .alexander:
            return [
                Flavor(type: .cityDefense, value: 5),
                Flavor(type: .culture, value: 7),
                Flavor(type: .defense, value: 5),
                Flavor(type: .diplomacy, value: 9),
                Flavor(type: .expansion, value: 8),
                Flavor(type: .gold, value: 3),
                Flavor(type: .growth, value: 4),
                Flavor(type: .amenities, value: 5),
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
                Flavor(type: .wonder, value: 6)
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
                Flavor(type: .amenities, value: 8),
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
                Flavor(type: .wonder, value: 6)
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
                Flavor(type: .amenities, value: 5),
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
                Flavor(type: .wonder, value: 5)
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

        return -1
    }

    func traits() -> [Trait] {

        switch self {

        case .none: return []
        case .unmet: return []
        case .barbar: return []
        case .freeCities: return []
        case .cityState: return []

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
        case .unmet: return []
        case .barbar: return []
        case .freeCities: return []
        case .cityState: return []

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

    public func ability() -> LeaderAbilityType {

        return self.data().ability
    }

    // MARK: private functions

    private struct LeaderTypeData {

        let name: String
        let intro: String
        let civilization: CivilizationType
        let ability: LeaderAbilityType
        let agenda: LeaderAgendaType
        let rejectedAgendas: [LeaderAgendaType]
        let religion: ReligionType?
    }

    // intro: https://github.com/ernsnl/Civilization6Mods/blob/b59a424f952224327cae2406bc5f05f78f6f4fb4/Lightning%20Snail%20Fast%20Mod/Mod/Base/Assets/Text/en_US/FrontEndText.xml
    // swiftlint:disable line_length
    private func data() -> LeaderTypeData {

        switch self {

        case .none:
            return LeaderTypeData(
                name: "None",
                intro: "--",
                civilization: .barbarian,
                ability: .none,
                agenda: .none,
                rejectedAgendas: [],
                religion: nil
            )

        case .unmet:
            return LeaderTypeData(
                name: "Unmet",
                intro: "--",
                civilization: .unmet,
                ability: .none,
                agenda: .none,
                rejectedAgendas: [],
                religion: nil
            )

        case .barbar:
            return LeaderTypeData(
                name: "Barbar",
                intro: "--",
                civilization: .barbarian,
                ability: .none,
                agenda: .none,
                rejectedAgendas: [],
                religion: nil
            )

        case .freeCities:
            return LeaderTypeData(
                name: "Free",
                intro: "--",
                civilization: .free,
                ability: .none,
                agenda: .none,
                rejectedAgendas: [],
                religion: nil
            )

        case .cityState(type: let cityState):
            return LeaderTypeData(
                name: "City state",
                intro: "--",
                civilization: .cityState(type: cityState),
                ability: .none,
                agenda: .none,
                rejectedAgendas: [],
                religion: nil
            )

            // -----------------------------------------------------------

        case .alexander:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_ALEXANDER_NAME",
                intro: "TXT_KEY_LEADER_ALEXANDER_INTRO",
                civilization: .greek,
                ability: .toTheWorldsEnd,
                agenda: .shortLifeOfGlory,
                rejectedAgendas: [.cityStateProtector],
                religion: nil
            )

        case .trajan:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_TRAJAN_NAME",
                intro: "TXT_KEY_LEADER_TRAJAN_INTRO",
                civilization: .roman,
                ability: .trajansColumn,
                agenda: .optimusPrinceps,
                rejectedAgendas: [],
                religion: nil
            )

        case .victoria:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_VICTORIA_NAME",
                intro: "TXT_KEY_LEADER_VICTORIA_INTRO",
                civilization: .english,
                ability: .paxBritannica,
                agenda: .sunNeverSets,
                rejectedAgendas: [],
                religion: .protestantism
            )

        case .cyrus:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_CYRUS_NAME",
                intro: "TXT_KEY_LEADER_CYRUS_INTRO",
                civilization: .persian,
                ability: .fallOfBabylon,
                agenda: .opportunist,
                rejectedAgendas: [.cityStateProtector],
                religion: .zoroastrianism
            )

        case .montezuma:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_MONTEZUMA_NAME",
                intro: "TXT_KEY_LEADER_MONTEZUMA_INTRO",
                civilization: .aztecs,
                ability: .giftsForTheTlatoani,
                agenda: .tlatoani,
                rejectedAgendas: [],
                religion: nil
            )

        case .napoleon:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_NAPOLEON_NAME",
                intro: "TXT_KEY_LEADER_NAPOLEON_INTRO",
                civilization: .french,
                ability: .flyingSquadron,
                agenda: .none, // #
                rejectedAgendas: [],
                religion: .catholicism
            )

        case .cleopatra:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_CLEOPATRA_NAME",
                intro: "TXT_KEY_LEADER_CLEOPATRA_INTRO",
                civilization: .egyptian,
                ability: .mediterraneansBride,
                agenda: .queenOfTheNile,
                rejectedAgendas: [],
                religion: nil
            )

        case .barbarossa:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_BARBAROSSA_NAME",
                intro: "TXT_KEY_LEADER_BARBAROSSA_INTRO",
                civilization: .german,
                ability: .holyRomanEmperor,
                agenda: .ironCrown,
                rejectedAgendas: [.cityStateProtector],
                religion: .catholicism
            )

        case .peterTheGreat:
            return LeaderTypeData(
                name: "TXT_KEY_LEADER_PETER_THE_GREAT_NAME",
                intro: "TXT_KEY_LEADER_PETER_THE_GREAT_INTRO",
                civilization: .russian,
                ability: .theGrandEmbassy,
                agenda: .westernizer,
                rejectedAgendas: [],
                religion: .easternOrthodoxy
            )
        }
    }

    // MARK: private methods

    private func toKey() -> String {

        switch self {

        case .none:
            return "none"
        case .unmet:
            return "unmet"
        case .barbar:
            return "barbar"
        case .freeCities:
            return "freeCities"
        case .cityState(type: let type):
            return "cityState-\(type.rawValue)"
        case .alexander:
            return "alexander"
        case .trajan:
            return "trajan"
        case .victoria:
            return "victoria"
        case .cyrus:
            return "cyrus"
        case .montezuma:
            return "montezuma"
        case .napoleon:
            return "napoleon"
        case .cleopatra:
            return "cleopatra"
        case .barbarossa:
            return "barbarossa"
        case .peterTheGreat:
            return "peterTheGreat"
        }
    }

    private static func from(key: String) -> LeaderType? {

        if key.starts(with: "cityState-") {
            let cityStateName = key.replacingOccurrences(of: "cityState-", with: "")

            guard let cityState: CityStateType = CityStateType(rawValue: cityStateName) else {
                fatalError("cannot get city state type from '\(cityStateName)'")
            }

            return LeaderType.cityState(type: cityState)
        }

        switch key {

        case "none":
            return LeaderType.none
        case "barbar":
            return LeaderType.barbar
        case "freeCities":
            return .freeCities

        case "alexander":
            return .alexander
        case "trajan":
            return .trajan
        case "victoria":
            return .victoria
        case "cyrus":
            return .cyrus
        case "montezuma":
            return .montezuma
        case "napoleon":
            return .napoleon
        case "cleopatra":
            return .cleopatra
        case "barbarossa":
            return .barbarossa
        case "peterTheGreat":
            return .peterTheGreat

        default:
            fatalError("LeaderType \(key) not handled")
        }
    }
}

extension LeaderType {

    func isSmaller() -> Bool {

        if self == .montezuma || self == .cyrus {
            return true
        }

        return false
    }

    func isExpansionist() -> Bool {

        if self == .alexander || self == .napoleon {
            return true
        }

        return false
    }

    func isWarmonger() -> Bool {

        if self == .napoleon {
            return true
        }

        return false
    }

    func isPopulationBoostReligion() -> Bool {

        if self == .cyrus {
            return true
        }

        return false
    }
}
