//
//  GossipItemType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum GossipSourceType: Codable {

    case none
    case delegate
    case trader
    case tech
    case trait
    case ally
    case spy
    // case
}

// texts: https://github.com/Swiftwork/civ6-explorer/blob/dbe3ca6d5468828ef0b26ef28f69555de0bcb959/src/assets/game/BaseGame/Locale/en_US/Gossip_Text.xml
public enum GossipItemType: Codable {

    // none
    case cityConquests(cityName: String)
    case pantheonCreated(pantheonName: String)
    case religionsFounded(religionName: String)
    case declarationsOfWar(leader: LeaderType)
    case weaponsOfMassDestructionStrikes // #
    case spaceRaceProjectsCompleted // #

    // limited
    case alliances // #
    case friendships // #
    case governmentChanges // #
    case denunciations // #
    case citiesFounded // #
    case citiesLiberated // #
    case citiesRazed // #
    case citiesBesieged // #
    case tradeDealsEnacted // #
    case tradeDealsReneged // #

    // open
    case buildingsConstructed // #
    case districtsConstructed // #
    case greatPeopleRecruited // #
    case wondersStarted // #
    case artifactsExtracted // #
    case inquisitionLaunched // #

    // secret
    case cityStatesInfluenced // #
    case civicsCompleted // #
    case technologiesResearched // #
    case settlersTrained // #

    // top secret
    case weaponOfMassDestructionBuilt // #
    case attacksLaunched // #
    case projectsStarted // #
    case victoryStrategyChanged // #
    case warPreparations // #

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func accessLevel() -> AccessLevel {

        return self.data().accessLevel
    }

    // MARK: private methods

    private class GossipItemTypeData {

        let name: String
        let accessLevel: AccessLevel

        init(name: String, accessLevel: AccessLevel) {

            self.name = name
            self.accessLevel = accessLevel
        }
    }

    private func data() -> GossipItemTypeData {

        switch self {

            // none
        case .cityConquests:
            return GossipItemTypeData(name: "City conquests", accessLevel: .none)
        case .pantheonCreated:
            return GossipItemTypeData(name: "Pantheon created", accessLevel: .none)
        case .religionsFounded:
            return GossipItemTypeData(name: "Religions founded", accessLevel: .none)
        case .declarationsOfWar:
            return GossipItemTypeData(name: "Declarations of war", accessLevel: .none)
        case .weaponsOfMassDestructionStrikes:
            return GossipItemTypeData(name: "Weapons of mass destruction strikes", accessLevel: .none)
        case .spaceRaceProjectsCompleted:
            return GossipItemTypeData(name: "Space race projects completed", accessLevel: .none)

            // limited
        case .alliances:
            return GossipItemTypeData(name: "Alliances", accessLevel: .limited)
        case .friendships:
            return GossipItemTypeData(name: "Friendships", accessLevel: .limited)
        case .governmentChanges:
            return GossipItemTypeData(name: "Government changes", accessLevel: .limited)
        case .denunciations:
            return GossipItemTypeData(name: "Denunciations", accessLevel: .limited)
        case .citiesFounded:
            return GossipItemTypeData(name: "Cities founded", accessLevel: .limited)
        case .citiesLiberated:
            return GossipItemTypeData(name: "Cities liberated", accessLevel: .limited)
        case .citiesRazed:
            return GossipItemTypeData(name: "Cities razed", accessLevel: .limited)
        case .citiesBesieged:
            return GossipItemTypeData(name: "Cities besieged", accessLevel: .limited)
        case .tradeDealsEnacted:
            return GossipItemTypeData(name: "Trade deals enacted", accessLevel: .limited)
        case .tradeDealsReneged:
            return GossipItemTypeData(name: "Trade deals reneged", accessLevel: .limited)

            // open
        case .buildingsConstructed:
            return GossipItemTypeData(name: "Buildings constructed", accessLevel: .open)
        case .districtsConstructed:
            return GossipItemTypeData(name: "Districts constructed", accessLevel: .open)
        case .greatPeopleRecruited:
            return GossipItemTypeData(name: "Great people recruited", accessLevel: .open)
        case .wondersStarted:
            return GossipItemTypeData(name: "Wonders started", accessLevel: .open)
        case .artifactsExtracted:
            return GossipItemTypeData(name: "Artifacts extracted", accessLevel: .open)
        case .inquisitionLaunched:
            return GossipItemTypeData(name: "Inquisition launched", accessLevel: .open)

            // secret
        case .cityStatesInfluenced:
            return GossipItemTypeData(name: "City-states influenced", accessLevel: .secret)
        case .civicsCompleted:
            return GossipItemTypeData(name: "Civics completed", accessLevel: .secret)
        case .technologiesResearched:
            return GossipItemTypeData(name: "Technologies researched", accessLevel: .secret)
        case .settlersTrained:
            return GossipItemTypeData(name: "Settlers trained", accessLevel: .secret)

            // top secret
        case .weaponOfMassDestructionBuilt:
            return GossipItemTypeData(name: "Weapon of mass destruction built", accessLevel: .topSecret)
        case .attacksLaunched:
            return GossipItemTypeData(name: "Attacks launched", accessLevel: .topSecret)
        case .projectsStarted:
            return GossipItemTypeData(name: "Projects started", accessLevel: .topSecret)
        case .victoryStrategyChanged:
            return GossipItemTypeData(name: "Victory strategy changed", accessLevel: .topSecret)
        case .warPreparations:
            return GossipItemTypeData(name: "War preparations", accessLevel: .topSecret)
        }
    }
}
