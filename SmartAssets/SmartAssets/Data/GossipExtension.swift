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

        case .cityConquests(cityName: let cityName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_CITY_CONQUEST"
                .localizedWithFormat(with: [civilizationName, cityName])
        case .pantheonCreated(pantheonName: let pantheonName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_PANTHEON_CREATED"
                .localizedWithFormat(with: [civilizationName, pantheonName.localized()])
        case .religionsFounded(religionName: let religionName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_RELIGION_FOUNDED"
                .localizedWithFormat(with: [civilizationName, religionName.localized()])
        case .declarationsOfWar(leader: let leaderName):
            return "TXT_KEY_DIPLOMACY_GOSSIP_DECLARATION_OF_WAR"
                .localizedWithFormat(with: [civilizationName, leaderName.name().localized()])
        // case weaponsOfMassDestructionStrikes // #
        // case spaceRaceProjectsCompleted // #

        default:
            return "---"
        }
    }
}
