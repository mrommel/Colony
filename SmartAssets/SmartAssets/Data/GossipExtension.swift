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

        case .delegate: return "Your delegate learned that " // todo: localize
        case .trader: return "Your trader overheard that "
        case .tech: return "A recent news article revealed that "
        case .trait: return "Your lady-in-waiting heard at the court ball that "
        case .ally: return "An allied friend reports that "
        case .spy: return "Your Spy uncovered news that "
        }
    }
}

// https://github.com/Swiftwork/civ6-explorer/blob/dbe3ca6d5468828ef0b26ef28f69555de0bcb959/src/assets/game/BaseGame/Locale/en_US/Gossip_Text.xml
// https://github.com/Whitebern/civ6-modpack/blob/653859829df0454206258648a6f41911f9a48855/CQUI%202021-09-24/Assets/Text/Gossip_Text_de.xml
extension GossipItemType {

    public func text(for civilization: CivilizationType) -> String {

        let civilizationName = civilization.name().localized()

        switch self {

        case .cityConquests(cityName: let cityName):
            return "%@ has conquered %@.".localizedWithFormat(with: [civilizationName, cityName])
        case .pantheonCreated(pantheonName: let pantheonName):
            return "%@ is worshipping a Pantheon of the gods focused on the %@ Belief.".localizedWithFormat(with: [civilizationName, pantheonName.localized()])
        case .religionsFounded(religionName: let religionName):
            return "%@ has founded a new Religion: %@.".localizedWithFormat(with: [civilizationName, religionName.localized()])
        case .declarationsOfWar(leader: let leaderName):
            return "%@ has just declared war on %@!".localizedWithFormat(with: [civilizationName, leaderName.name().localized()])
        // case weaponsOfMassDestructionStrikes // #
        // case spaceRaceProjectsCompleted // #

        default:
            return "---"
        }
    }
}
