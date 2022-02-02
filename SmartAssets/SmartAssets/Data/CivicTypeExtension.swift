//
//  CivicTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension CivicType {

    public func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let eureka = NSAttributedString(
            string: "\n\n" + self.inspirationSummary().localized(),
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(eureka)

        return toolTipText
    }

    // swiftlint:disable cyclomatic_complexity
    public func iconTexture() -> String {

        switch self {

        case .none: return "civic-default"

            // ancient
        case .stateWorkforce: return "civic-stateWorkforce"
        case .craftsmanship: return "civic-craftsmanship"
        case .codeOfLaws: return "civic-codeOfLaws"
        case .earlyEmpire: return "civic-earlyEmpire"
        case .foreignTrade: return "civic-foreignTrade"
        case .mysticism:return "civic-mysticism"

            // classical
        case .militaryTradition: return "civic-militaryTradition"
        case .defensiveTactics: return "civic-defensiveTactics"
        case .gamesAndRecreation: return "civic-gamesAndRecreation"
        case .politicalPhilosophy: return "civic-politicalPhilosophy"
        case .recordedHistory: return "civic-recordedHistory"
        case .dramaAndPoetry: return "civic-dramaAndPoetry"
        case .theology: return "civic-theology"
        case .militaryTraining: return "civic-militaryTraining"

            // medieval
        case .navalTradition: return "civic-navalTradition"
        case .feudalism: return "civic-feudalism"
        case .medievalFaires: return "civic-medievalFaires"
        case .civilService: return "civic-civilService"
        case .guilds: return "civic-guilds"
        case .mercenaries: return "civic-mercenaries"
        case .divineRight: return "civic-divineRight"

            // renaissance
        case .enlightenment: return "civic-enlightenment"
        case .humanism: return "civic-humanism"
        case .mercantilism: return "civic-mercantilism"
        case .diplomaticService: return "civic-diplomaticService"
        case .exploration: return "civic-exploration"
        case .reformedChurch: return "civic-reformedChurch"

            // industrial
        case .civilEngineering: return "civic-civilEngineering"
        case .colonialism: return "civic-colonialism"
        case .nationalism: return "civic-nationalism"
        case .operaAndBallet: return "civic-operaAndBallet"
        case .naturalHistory: return "civic-naturalHistory"
        case .urbanization: return "civic-urbanization"
        case .scorchedEarth: return "civic-scorchedEarth"

            // modern
        case .conservation: return "civic-conservation"
        case .massMedia: return "civic-massMedia"
        case .mobilization: return "civic-mobilization"
        case .capitalism: return "civic-capitalism"
        case .ideology: return "civic-ideology"
        case .nuclearProgram: return "civic-nuclearProgram"
        case .suffrage: return "civic-suffrage"
        case .totalitarianism: return "civic-totalitarianism"
        case .classStruggle: return "civic-classStruggle"

            // atomic
        case .culturalHeritage: return "civic-culturalHeritage"
        case .coldWar: return "civic-coldWar"
        case .professionalSports: return "civic-professionalSports"
        case .rapidDeployment: return "civic-rapidDeployment"
        case .spaceRace: return "civic-spaceRace"

            // information
        case .globalization: return "civic-globalization"
        case .socialMedia: return "civic-socialMedia"
        case .environmentalism: return "civic-environmentalism"
        }
    }
}

extension CivicType {

    // swiftlint:disable cyclomatic_complexity
    public func indexPath() -> IndexPath {

        switch self {

        case .none:                 return IndexPath(item: -1, section: -1)

            // ancient - 0
        case .codeOfLaws:           return IndexPath(item: 3, section: 0) // -110, 25 => 3
            // ancient - 1
        case .craftsmanship:        return IndexPath(item: 1, section: 1) // 40, 115 => 1
        case .foreignTrade:         return IndexPath(item: 5, section: 1) // 40, -65 => 5
            // ancient - 2
        case .militaryTradition:    return IndexPath(item: 0, section: 2) // 190, 160 => 0
        case .stateWorkforce:       return IndexPath(item: 3, section: 2) // 190, 25 => 3
        case .earlyEmpire:          return IndexPath(item: 4, section: 2) // 190, -20 => 4
        case .mysticism:            return IndexPath(item: 6, section: 2) // 190, -110 => 6

            // classical - 0
        case .gamesAndRecreation:   return IndexPath(item: 1, section: 3) // 340, 115 => 1
        case .politicalPhilosophy:  return IndexPath(item: 3, section: 3) // 340, 25 => 3
        case .dramaAndPoetry:       return IndexPath(item: 5, section: 3) // 340, -65 => 5
            // classical -1
        case .militaryTraining:     return IndexPath(item: 0, section: 4) // 510, 160 => 0
        case .defensiveTactics:     return IndexPath(item: 2, section: 4) // 510, 70 => 2
        case .recordedHistory:      return IndexPath(item: 4, section: 4) // 510, -20 => 4
        case .theology:             return IndexPath(item: 6, section: 4) // 510, -110 => 6

            // medieval - 0
        case .navalTradition:       return IndexPath(item: 1, section: 5) // 680, 115 => 1
        case .feudalism:            return IndexPath(item: 2, section: 5) // 680, 70 => 2
        case .civilService:         return IndexPath(item: 4, section: 5) // 680, -20 => 4
            // medieval - 1
        case .mercenaries:          return IndexPath(item: 0, section: 6) // 830, 160 => 0
        case .medievalFaires:       return IndexPath(item: 2, section: 6) // 830, 70 => 2
        case .guilds:               return IndexPath(item: 4, section: 6) // 830, -20 => 4
        case .divineRight:          return IndexPath(item: 6, section: 6) // 830, -110 => 6

            // renaissance - 0
        case .exploration:          return IndexPath(item: 0, section: 7) // 1000, 160 => 0
        case .humanism:             return IndexPath(item: 2, section: 7) // 1000, 70 => 2
        case .diplomaticService:    return IndexPath(item: 4, section: 7) // 1000, -20 => 4
        case .reformedChurch:       return IndexPath(item: 6, section: 7) // 1000, -110 => 6
            // renaissance - 1
        case .mercantilism:         return IndexPath(item: 2, section: 8) // 1150, 70 => 2
        case .enlightenment:        return IndexPath(item: 4, section: 8) // 1150, -20 => 4

            // ???
        case .civilEngineering:     return IndexPath(item: -1, section: -1)
        case .colonialism:          return IndexPath(item: -1, section: -1)
        case .nationalism:          return IndexPath(item: -1, section: -1)
        case .operaAndBallet:       return IndexPath(item: -1, section: -1)
        case .naturalHistory:       return IndexPath(item: -1, section: -1)
        case .urbanization:         return IndexPath(item: -1, section: -1)
        case .scorchedEarth:        return IndexPath(item: -1, section: -1)
        case .conservation:         return IndexPath(item: -1, section: -1)
        case .massMedia:            return IndexPath(item: -1, section: -1)
        case .mobilization:         return IndexPath(item: -1, section: -1)
        case .capitalism:           return IndexPath(item: -1, section: -1)
        case .ideology:             return IndexPath(item: -1, section: -1)
        case .nuclearProgram:       return IndexPath(item: -1, section: -1)
        case .suffrage:             return IndexPath(item: -1, section: -1)
        case .totalitarianism:      return IndexPath(item: -1, section: -1)
        case .classStruggle:        return IndexPath(item: -1, section: -1)
        case .culturalHeritage:     return IndexPath(item: -1, section: -1)
        case .coldWar:              return IndexPath(item: -1, section: -1)
        case .professionalSports:   return IndexPath(item: -1, section: -1)
        case .rapidDeployment:      return IndexPath(item: -1, section: -1)
        case .spaceRace:            return IndexPath(item: -1, section: -1)

            // information
        case .globalization:        return IndexPath(item: -1, section: -1)
        case .socialMedia:          return IndexPath(item: -1, section: -1)
        case .environmentalism:     return IndexPath(item: -1, section: -1)
        }
    }
}
