//
//  AccessLevel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Diplomatic_Visibility_and_Gossip_(Civ6)
public enum AccessLevel: Int, Codable {

    case none = 0
    case limited = 1
    case open = 2
    case secret = 3
    case topSecret = 4

    public static var all: [AccessLevel] = [
        .none, .limited, .open, .secret, .topSecret
    ]

    public func decreased() -> AccessLevel {

        switch self {

        case .none: return .none
        case .limited: return .none
        case .open: return .limited
        case .secret: return .open
        case .topSecret: return .secret
        }
    }

    public func increased() -> AccessLevel {

        switch self {

        case .none: return .limited
        case .limited: return .open
        case .open: return .secret
        case .secret: return .topSecret
        case .topSecret: return .topSecret
        }
    }

    public func gossipItems() -> [GossipItemType] {

        switch self {

        case .none:
            return [
                .cityConquests(cityName: ""),
                .pantheonCreated(pantheonName: ""),
                .religionsFounded(religionName: ""),
                .declarationsOfWar(leader: .none),
                .weaponsOfMassDestructionStrikes,
                .spaceRaceProjectsCompleted
            ]

        case .limited:
            return [
                .alliances,
                .friendship(leader: .none),
                .governmentChanges,
                .denunciation(leader: .none),
                .citiesFounded,
                .citiesLiberated,
                .citiesRazed,
                .citiesBesieged,
                .tradeDealsEnacted,
                .tradeDealsReneged
            ]

        case .open:
            return [
                .buildingsConstructed, .districtsConstructed, .greatPeopleRecruited,
                .wondersStarted, .artifactsExtracted, .inquisitionLaunched
            ]

        case .secret:
            return [
                .cityStatesInfluenced, .civicsCompleted, .technologiesResearched, .settlersTrained
            ]

        case .topSecret:
            return [
                .weaponOfMassDestructionBuilt, .attacksLaunched, .projectsStarted,
                .victoryStrategyChanged, .warPreparations
            ]
        }
    }
}

extension AccessLevel: Comparable {

    public static func < (lhs: AccessLevel, rhs: AccessLevel) -> Bool {

        return lhs.rawValue < rhs.rawValue
    }
}
