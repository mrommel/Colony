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
public enum GossipItemType: Codable, Equatable {

    // none
    case cityConquests(cityName: String)
    case pantheonCreated(pantheonName: String)
    case religionsFounded(religionName: String)
    case declarationsOfWar(leader: LeaderType)
    case weaponsOfMassDestructionStrikes // #
    case spaceRaceProjectsCompleted // #

    // limited
    case alliance(leader: LeaderType) // #
    case friendship(leader: LeaderType)
    case governmentChange(government: GovernmentType)
    case denunciation(leader: LeaderType)
    case cityFounded(cityName: String)
    case cityLiberated(cityName: String, originalOwner: LeaderType)
    case cityRazed(cityName: String, originalOwner: LeaderType)
    case cityBesieged(cityName: String) // #
    case tradeDealEnacted // #
    case tradeDealReneged // #
    case barbarianCampCleared(unit: UnitType)

    // open
    case buildingConstructed(building: BuildingType)
    case districtConstructed(district: DistrictType)
    case greatPeopleRecruited(greatPeople: GreatPerson)
    case wonderStarted(wonder: WonderType, cityName: String)
    case artifactsExtracted // #
    case inquisitionLaunched // #

    // secret
    case cityStatesInfluenced // #
    case civicCompleted(civic: CivicType)
    case technologyResearched(tech: TechType)
    case settlerTrained(cityName: String)

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
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_CITY_CONQUEST",
                accessLevel: .none
            )
        case .pantheonCreated:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_PATHEON_CREATED",
                accessLevel: .none
            )
        case .religionsFounded:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_RELIGIONS_FOUNDED",
                accessLevel: .none
            )
        case .declarationsOfWar:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_DECLARATIONS_OF_WAR",
                accessLevel: .none
            )
        case .weaponsOfMassDestructionStrikes:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_WEAPONS_OF_MASS_DESTRUCTION_STRIKES",
                accessLevel: .none
            )
        case .spaceRaceProjectsCompleted:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_SPACE_RACE_PROJECTS_COMPLETED",
                accessLevel: .none
            )

            // limited
        case .alliance:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_ALLIANCES",
                accessLevel: .limited
            )
        case .friendship:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_FRIENDSHIPS",
                accessLevel: .limited
            )
        case .governmentChange:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_GOVERNMENT_CHANGES",
                accessLevel: .limited
            )
        case .denunciation:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_DENOUNCIATIONS",
                accessLevel: .limited
            )
        case .cityFounded:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_CITIES_FOUNDED",
                accessLevel: .limited
            )
        case .cityLiberated:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_CITIES_LIBERTATED",
                accessLevel: .limited
            )
        case .cityRazed:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_CITIES_RAZED",
                accessLevel: .limited
            )
        case .cityBesieged:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_CITIES_BESIEGED",
                accessLevel: .limited
            )
        case .tradeDealEnacted:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_TRADE_DEALS_ENACTED",
                accessLevel: .limited
            )
        case .tradeDealReneged:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_TRADE_DEALS_RENEGED",
                accessLevel: .limited
            )
        case .barbarianCampCleared:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_BARBARIAN_CAMP_CLEARED",
                accessLevel: .limited
            )

            // open
        case .buildingConstructed:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_BUILDINGS_CONSTRUCTED",
                accessLevel: .open
            )
        case .districtConstructed:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_DISTRICTS_CONSTRUCTED",
                accessLevel: .open
            )
        case .greatPeopleRecruited:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_GREAT_PEOPE_RECRUITED",
                accessLevel: .open
            )
        case .wonderStarted:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_WONDERS_STARTED",
                accessLevel: .open
            )
        case .artifactsExtracted:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_ARTIFACTS_EXTRACTED",
                accessLevel: .open
            )
        case .inquisitionLaunched:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_INQUISITION_LAUNCHED",
                accessLevel: .open
            )

            // secret
        case .cityStatesInfluenced:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_CITY_STATE_INFLUENCED",
                accessLevel: .secret
            )
        case .civicCompleted:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_CIVICS_COMPLETED",
                accessLevel: .secret
            )
        case .technologyResearched:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_TECHNOLOGIES_RESEARCHED",
                accessLevel: .secret
            )
        case .settlerTrained:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_SETTLERS_TRAINED",
                accessLevel: .secret
            )

            // top secret
        case .weaponOfMassDestructionBuilt:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_WEAPON_OF_MASS_DESTRUCTION_BUILT",
                accessLevel: .topSecret
            )
        case .attacksLaunched:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_ATTACKS_LAUNCHED",
                accessLevel: .topSecret
            )
        case .projectsStarted:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_PROJECTS_STARTED",
                accessLevel: .topSecret
            )
        case .victoryStrategyChanged:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_VICTORY_STRATEGY_CHANGED",
                accessLevel: .topSecret
            )
        case .warPreparations:
            return GossipItemTypeData(
                name: "TXT_KEY_DIPLOMACY_GOSSIP_NAME_WAR_PREPARATIONS",
                accessLevel: .topSecret
            )
        }
    }
}
