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
                religion: nil
            )

        case .unmet:
            return LeaderTypeData(
                name: "Unmet",
                intro: "--",
                civilization: .unmet,
                ability: .none,
                religion: nil
            )

        case .barbar:
            return LeaderTypeData(
                name: "Barbar",
                intro: "--",
                civilization: .barbarian,
                ability: .none,
                religion: nil
            )

        case .freeCities:
            return LeaderTypeData(
                name: "Free",
                intro: "--",
                civilization: .free,
                ability: .none,
                religion: nil
            )

        case .cityState:
            return LeaderTypeData(
                name: "City state",
                intro: "--",
                civilization: .free,
                ability: .none,
                religion: nil
            )

        case .alexander:
            return LeaderTypeData(
                name: "Alexander",
                intro: "May the blessings of the gods be upon you, oh great King Alexander! You are the ruler of the mighty Greek nation. Your people lived for so many years in isolated city-states - legendary cities such as Athens, Sparta, Thebes - where they gave the world many great things, such as democracy, philosophy, tragedy, art and architecture, the very foundation of Western Civilization.",
                civilization: .greek,
                ability: .toTheWorldsEnd,
                religion: nil
            )

        case .trajan:
            return LeaderTypeData(
                name: "Trajan",
                intro: "Cast your net wide, oh Trajan, emperor of mighty Rome. Your legions stand at the ready to march out and establish the largest empire the world has ever seen. If you can truly get all roads to lead to Rome, yours will be an empire of great riches and luxuries. Surely then our citizens will proclaim you as their best ruler, the Optimus Princeps.",
                civilization: .roman,
                ability: .trajansColumn,
                religion: nil
            )

        case .victoria:
            return LeaderTypeData(
                name: "Victoria",
                intro: "Your Majesty the Queen Victoria of England, extend your reach beyond your borders and across the face of the globe. Worry not over the possibility of defeat for your loyal redcoats and overwhelming navy will surely carry the day. With your calm and steady touch you can bring all lands under England's sway, establishing a true Pax Britannica.",
                civilization: .english,
                ability: .paxBritannica,
                religion: .protestantism
            )

        case .cyrus:
            return LeaderTypeData(
                name: "Cyrus",
                intro: "Claim the crown, Cyrus, King of Persia, for you are the anointed one. With immortal soldiers, and an unwavering faith, you will conquer and rule the peoples of the world. You may see many alliances forming around you, but do not be fooled - such is an antiquated and weak way of navigating the world. Make no promise unless it aids you in achieving your goals.",
                civilization: .persian,
                ability: .fallOfBabylon,
                religion: .zoroastrianism
            )

        case .montezuma:
            return LeaderTypeData(
                name: "Montezuma",
                intro: "Tlatoani Montezuma, keep your eagle warriors happy and fed, and they will forever fight for your cause. As your Aztec empire unfurls across the land, you will never want for people to raise your walls, for you will be blessed with new, loyal workers as you conquer those around you. Go forth; Huitzilopochtli calls.",
                civilization: .aztecs,
                ability: .giftsForTheTlatoani,
                religion: nil
            )

        case .napoleon:
            return LeaderTypeData(
                name: "Napoleon",
                intro: "Long life and triumph to you, First Consul and Emperor of France, Napoleon I, ruler of the French people. France lies at the heart of Europe. Long has Paris been the world center of culture, arts and letters. Although surrounded by competitors - and often enemies - France has endured as a great nation.",
                civilization: .french,
                ability: .flyingSquadron,
                religion: .catholicism
            )

        case .cleopatra:
            return LeaderTypeData(
                name: "Cleopatra",
                intro: "There will be those who underestimate you, but you are cunning and full of tricks, Queen Cleopatra. Your charm will establish indestructible alliances with the strongest leaders of the world. Keep your friends close by your side and you will find yourself untouchable, with the glory of Egypt primed to win over the world.",
                civilization: .egyptian,
                ability: .mediterraneansBride,
                religion: nil
            )

        case .barbarossa:
            return LeaderTypeData(
                name: "Barbarossa",
                intro: "Heroic Frederick, king of the Germans, your task is to forge the independent states that surround you into an empire. You are blessed to be a great military leader – use those skills to bring these cities under your sway so they may develop into commercial and industrial powerhouses. Surely then the bards will sing of mighty Frederick with the red beard, the great Holy Roman Emperor.",
                civilization: .german,
                ability: .holyRomanEmperor,
                religion: .catholicism
            )

        case .peterTheGreat:
            return LeaderTypeData(
                name: "Peter the Great",
                intro: "Embrace the chill winds of the Motherland, Tsar Peter. Your fascination with science and culture is a gift, and you will learn much from your Grand Embassies to foreign lands. Under your rule, Russia will surely flourish and spread, absorbing all that lies around it, perhaps creating the greatest land empire seen on this earth.",
                civilization: .russian,
                ability: .theGrandEmbassy,
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
            return "cityState-\(type)"
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

        switch key {

        case "none":
            return LeaderType.none

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
