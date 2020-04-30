//
//  PolicyCardType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum PolicyCardSlotType {

    case military
    case economic
    case diplomatic
    case wildcard
}

// https://civilization.fandom.com/wiki/Policy_Cards_(Civ6)
public enum PolicyCardType {

    // ancient
    case survey // FIXME Doubles experience for recon units.
    case godKing
    case discipline // FIXME +5 Combat Strength when fighting Barbarians.
    case urbanPlanning
    case ilkum // FIXME +30% Production toward Builders.
    case agoge // FIXME +50% Production towards Ancient and Classical era melee and ranged units.
    case caravansaries // FIXME  +2 additional Civ6Gold Gold from all TradeRoute6 Trade Routes.
    case maritimeIndustries // FIXME +100% Production towards all Ancient and Classical era naval units.
    case maneuver // FIXME +50% Civ6Production Production towards all Ancient and Classical era light and heavy cavalry units.
    case strategos // FIXME +2 General6 Great General points per turn.
    case conscription // FIXME Unit maintenance reduced by 1  Gold per turn per unit.
    case corvee // FIXME +15% Production towards Ancient and Classical era wonders.
    case landSurveyors // FIXME Reduces the cost to purchase a tile by 20%.
    case colonization // FIXME +50% Production towards Settlers.
    case inspiration // FIXME +2 Great Scientist points per turn.
    case revelation // FIXME +2 Great Prophet points per turn.
    case limitanei // FIXME +2 Loyalty per turn for cities with a garrisoned unit.

    // classical
    case insulae // FIXME +1 Housing in all cities with at least 2 specialty districts.
    // ...
    case bastions

    // mediaval

    static var all: [PolicyCardType] {
        return [
            // ancient
            .survey, .godKing, .discipline, .urbanPlanning, .ilkum, .agoge, .caravansaries, .maritimeIndustries, .maneuver, .strategos, .conscription, .corvee, .landSurveyors, .colonization, .inspiration, .revelation, .limitanei,

            // classical
            .insulae, /* ... */ .bastions
        ]
    }

    public func slot() -> PolicyCardSlotType {

        switch self {

        case .survey: return .military
        case .godKing: return .economic
        case .discipline: return .military
        case .urbanPlanning: return .economic
        case .ilkum: return .economic
        case .agoge: return .military
        case .caravansaries: return .economic
        case .maritimeIndustries: return .military
        case .maneuver: return .military
        case .strategos: return .wildcard
        case .conscription: return .military
        case .corvee: return .economic
        case .landSurveyors: return .economic
        case .colonization: return .economic
        case .inspiration: return .wildcard
        case .revelation: return .wildcard
        case .limitanei: return .military

            // classical
        case .insulae: return .economic
            /* ... */
        case .bastions: return .military
        }
    }

    func required() -> CivicType {

        switch self {

            // ancient
        case .survey: return .codeOfLaws
        case .godKing: return .codeOfLaws
        case .discipline: return .codeOfLaws
        case .urbanPlanning: return .codeOfLaws
        case .ilkum: return .craftsmanship
        case .agoge: return .craftsmanship
        case .caravansaries: return .foreignTrade
        case .maritimeIndustries: return .foreignTrade
        case .maneuver: return .militaryTradition
        case .strategos: return .militaryTradition
        case .conscription: return .stateWorkforce
        case .corvee: return .stateWorkforce
        case .landSurveyors: return .earlyEmpire
        case .colonization: return .earlyEmpire
        case .inspiration: return .mysticism
        case .revelation: return .mysticism
        case .limitanei: return .earlyEmpire

            // classical
        case .insulae: return .gamesAndRecreation
            /* ... */
        case .bastions: return .defensiveTactics
        }
    }

    func obsoleteCivic() -> CivicType? {

        switch self {

            // ancient
        case .survey: return .exploration
        case .godKing: return nil
        case .discipline: return .exploration
        case .urbanPlanning: return .exploration
        case .ilkum: return nil
        case .agoge: return nil
        case .caravansaries: return nil
        case .maritimeIndustries: return nil
        case .maneuver: return nil
        case .strategos: return .militaryTradition
        case .conscription: return .stateWorkforce
        case .corvee: return .stateWorkforce
        case .landSurveyors: return .earlyEmpire
        case .colonization: return .earlyEmpire
        case .inspiration: return .mysticism
        case .revelation: return .mysticism
        case .limitanei: return .earlyEmpire

            // classical
        case .insulae: return .gamesAndRecreation
            /* ... */
        case .bastions: return .civilEngineering
        }
    }

    func obsoletePolicyCard() -> PolicyCardType? {

        return nil

        // FIXME
        /*switch self {

            // ancient
        case .survey: return nil
        case .godKing: return .scripture
        case .discipline: return nil
        case .urbanPlanning: return nil
        case .ilkum: return .serfdom
         case .agoge: return
         case .caravansaries: return
         case .maritimeIndustries: return
         case .maneuver: return
         case .strategos: return
         case .conscription: return
         case .corvee: return
         case .landSurveyors: return
         case .colonization: return
         case .inspiration: return
         case .revelation: return
         case .limitanei: return

             // classical
         case .insulae: return
          ...
         case .bastions: return .military
        }*/
    }
}
