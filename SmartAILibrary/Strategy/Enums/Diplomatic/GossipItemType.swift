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

    func sourceString() -> String {

        switch self {

        case .none: return ""

        case .delegate: return "Your delegate, %@, learned that"
        case .trader: return "Your trader, %@, overheard that"
        case .tech: return "A recent news article revealed that"
        case .trait: return "Your lady-in-waiting, %@, heard at the court ball that"
        case .ally: return "An allied friend reports that"
        case .spy: return "Your Spy, %@, uncovered news that"
        }
    }
}

public enum GossipItemType: Codable {

    // none
    case cityConquests
    case pantheonCreated
    case religionsFounded
    case declarationsOfWar
    case weaponsOfMassDestructionStrikes
    case spaceRaceProjectsCompleted

    // limited
    case alliances
    case friendships
    case governmentChanges
    case denunciations
    case citiesFounded
    case citiesLiberated
    case citiesRazed
    case citiesBesieged
    case tradeDealsEnacted
    case tradeDealsReneged

    // open
    case buildingsConstructed
    case districtsConstructed
    case greatPeopleRecruited
    case wondersStarted
    case artifactsExtracted
    case inquisitionLaunched

    // secret
    case cityStatesInfluenced
    case civicsCompleted
    case technologiesResearched
    case settlersTrained

    // top secret
    case weaponOfMassDestructionBuilt
    case attacksLaunched
    case projectsStarted
    case victoryStrategyChanged
    case warPreparations

    // MARK: private methods

    /*private class GossipItemTypeData {

        let
    }*/
}
