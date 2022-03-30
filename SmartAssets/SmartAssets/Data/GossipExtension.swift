//
//  GossipExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 21.03.22.
//

import SmartAILibrary

extension GossipSourceType {

    public func text() -> String {

        switch self {

        case .none: return ""

        case .delegate: return "TXT_KEY_DIPLOMACY_GOSSIP_SOURCE_DELEGATE"
        case .trader: return "TXT_KEY_DIPLOMACY_GOSSIP_SOURCE_TRADER"
        case .tech: return "TXT_KEY_DIPLOMACY_GOSSIP_SOURCE_NEWS"
        case .trait: return "TXT_KEY_DIPLOMACY_GOSSIP_SOURCE_LADY"
        case .ally: return "TXT_KEY_DIPLOMACY_GOSSIP_SOURCE_ALLIED"
        case .spy: return "TXT_KEY_DIPLOMACY_GOSSIP_SOURCE_SPY"
        }
    }
}

// https://github.com/Swiftwork/civ6-explorer/blob/dbe3ca6d5468828ef0b26ef28f69555de0bcb959/src/assets/game/BaseGame/Locale/en_US/Gossip_Text.xml
// https://github.com/Whitebern/civ6-modpack/blob/653859829df0454206258648a6f41911f9a48855/CQUI%202021-09-24/Assets/Text/Gossip_Text_de.xml
extension GossipItemType {

    public func localizedText(for civilization: CivilizationType) -> String {

        let civilizationName = civilization.name().localized()

        switch self {

            // none
        case .cityConquests(cityName: let cityName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_CITY_CONQUEST"
                .localizedWithFormat(with: [civilizationName, cityName])
        case .pantheonCreated(pantheonName: let pantheonName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_PANTHEON_CREATED"
                .localizedWithFormat(with: [civilizationName, pantheonName.localized()])
        case .religionsFounded(religionName: let religionName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_RELIGION_FOUNDED"
                .localizedWithFormat(with: [civilizationName, religionName.localized()])
        case .declarationsOfWar(leader: let leaderName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_DECLARATION_OF_WAR"
                .localizedWithFormat(with: [civilizationName, leaderName.name().localized()])
        // case .weaponsOfMassDestructionStrikes // #
        // case .spaceRaceProjectsCompleted // #

            // limited
        case .alliance(leader: let leader):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_ALLIANCE"
                .localizedWithFormat(with: [civilizationName, leader.name().localized()])
        case .friendship(leader: let leader):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_FRIENDSHIP"
                .localizedWithFormat(with: [civilizationName, leader.name().localized()])
        case .governmentChange(government: let government):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_GOVERNMENT_CHANGE"
                .localizedWithFormat(with: [civilizationName, government.name().localized()])
        case .denunciation(leader: let leader):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_DENUNCIATION"
                .localizedWithFormat(with: [civilizationName, leader.name().localized()])
        case .cityFounded(cityName: let cityName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_CITY_FOUNDED"
                .localizedWithFormat(with: [civilizationName, cityName])
        case .cityLiberated(cityName: let cityName, originalOwner: let leader):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_CITY_LIBERATED"
                .localizedWithFormat(with: [civilizationName, cityName, leader.name().localized()])
        case .cityRazed(cityName: let cityName, originalOwner: let leader):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_CITY_RAZED"
                .localizedWithFormat(with: [civilizationName, cityName, leader.name().localized()])
        // case .cityBesieged(cityName: let cityName):
            // return "{1_CityName} is facing a siege."
        // case .tradeDealEnacted // #
        // case .tradeDealReneged // #
        case .barbarianCampCleared(unit: let unitType):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_CAMP_CLEARED"
                .localizedWithFormat(with: [civilizationName, unitType.name().localized()])

            // open
        case .buildingConstructed(building: let building):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_BUILDING_CONSTRUCTED"
                .localizedWithFormat(with: [civilizationName, building.name().localized()])
        case .districtConstructed(district: let district):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_DISTRICT_CONSTRUCTED"
                .localizedWithFormat(with: [civilizationName, district.name().localized()])
        case .greatPeopleRecruited(greatPeople: let greatPerson):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_GREAT_PEOPLE_RECRUITED"
                .localizedWithFormat(with: [civilizationName, greatPerson.type().name().localized(), greatPerson.name().localized()])
        case .wonderStarted(wonder: let wonder, cityName: let cityName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_WONDER_STARTED"
                .localizedWithFormat(with: [civilizationName, cityName, wonder.name().localized()])
        // case .artifactsExtracted // #
        // case .inquisitionLaunched // #

            // secret
        // case cityStatesInfluenced // #
        case .civicCompleted(civic: let civic):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_CIVIC_COMPLETED"
                .localizedWithFormat(with: [civilizationName, civic.name().localized()])
        case .technologyResearched(tech: let tech):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_TECH_RESEARCHED"
                .localizedWithFormat(with: [civilizationName, tech.name().localized()])
        case .settlerTrained(cityName: let cityName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_TEXT_SETTLER_TRAINED"
                .localizedWithFormat(with: [civilizationName, cityName])

            // top secret
        // case weaponOfMassDestructionBuilt // #
        // case attacksLaunched // #
        // case projectsStarted // #
        // case victoryStrategyChanged // #
        // case warPreparations // #

        default:
            return "---"
        }
    }
}
