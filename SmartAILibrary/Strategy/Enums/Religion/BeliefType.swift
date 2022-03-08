//
//  BeliefType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum BeliefMainType {

    case founderBelief
    case followerBelief
    case worshipBelief
    case enhancerBelief

    public static var all: [BeliefMainType] = [

        .founderBelief,
        .followerBelief,
        .worshipBelief,
        .enhancerBelief
    ]
}

// https://civilization.fandom.com/wiki/Beliefs_(Civ6)
public enum BeliefType: Int, Codable {

    case none

    // follower beliefs - mandatory to chose one when founding a religion
    case choralMusic
    case divineInspiration
    case feedTheWorld
    case jesuitEducation
    case religiousCommunity
    case reliquaries
    case warriorMonks
    // ...

    // worship beliefs
    case allowCathedral
    // case allowDareMehr
    // case allowGurdwara
    case allowMeetingHouse
    case allowMosque
    // ...

    // founder beliefs
    case churchProperty
    case crossCulturalDialogue
    // ...
    case worldChurch

    // enhancer beliefs
    case burialGrounds
    case crusade
    // ...
    case itinerantPreachers
    case missionaryZeal
    // ...

    public static var all: [BeliefType] = [

        // follower beliefs
        .choralMusic,
        .divineInspiration,
        .feedTheWorld,
        .jesuitEducation,
        .religiousCommunity,
        .reliquaries,
        .warriorMonks,
        // ...

        // worship beliefs
        .allowCathedral,
        .allowMeetingHouse,
        .allowMosque,
        // ...

        // founder beliefs
        .churchProperty,
        .crossCulturalDialogue,
        // ...
        .worldChurch,

        // enhancer beliefs
        .burialGrounds,
        .crusade,
        // ...
        .itinerantPreachers,
        .missionaryZeal
    ]

    public func name() -> String {

        return self.data().name
    }

    public func type() -> BeliefMainType {

        return self.data().mainType
    }

    public func effect() -> String {

        return self.data().effect
    }

    // MARK: internal classes

    private struct BeliefData {

        let name: String
        let mainType: BeliefMainType
        let effect: String
    }

    // MARK: private methods

    // swiftlint:disable line_length
    private func data() -> BeliefData {

        switch self {

        case .none:
            return BeliefData(name: "None",
                              mainType: .enhancerBelief,
                              effect: "")

        // follower beliefs
        case .choralMusic:
            return BeliefData(name: "Choral Music",
                              mainType: .followerBelief,
                              effect: "Shrines and Temples provide [Culture] Culture equal to their intrinsic [Faith] Faith output.")
        case .divineInspiration:
            return BeliefData(name: "Divine Inspiration",
                              mainType: .followerBelief,
                              effect: "Wonders provide +4 [Faith] Faith.")
        case .feedTheWorld:
            return BeliefData(name: "Feed the World",
                              mainType: .followerBelief,
                              effect: "Shrines and Temples provide +3 [Food] Food and +2 [Housing] Housing ")
        case .jesuitEducation:
            return BeliefData(name: "Jesuit Education",
                              mainType: .followerBelief,
                              effect: "May purchase Campus and Theater Square district buildings with [Faith] Faith.")
        case .religiousCommunity:
            return BeliefData(name: "Religious Community",
                              mainType: .followerBelief,
                              effect: "International [TradeRoute] Trade Route gain +2 Gold when sent to cities with Holy Sites and an additional 2 Gold for every building in the Holy Site.")
        case .reliquaries:
            return BeliefData(name: "Reliquaries",
                              mainType: .followerBelief,
                              effect: "Triple [Faith] Faith and [Tourism] Tourism yields from [Relic] Relics.")
        case .warriorMonks:
            return BeliefData(name: "Warrior Monks",
                              mainType: .followerBelief,
                              effect: "Allows spending [Faith] Faith to train Warrior Monks in cities with a Temple. Building a Holy Site triggers a Culture Bomb, claiming surrounding tiles.")

        // worship
        case .allowCathedral:
            return BeliefData(name: "Cathedral", mainType: .worshipBelief, effect: "Allows Cathedral")
        case .allowMeetingHouse:
            return BeliefData(name: "Meeting House", mainType: .worshipBelief, effect: "Allows Meeting House")
        case .allowMosque:
            return BeliefData(name: "Mosque", mainType: .worshipBelief, effect: "Allows Mosque")

        // founder
        case .churchProperty:
            return BeliefData(name: "Church Property",
                              mainType: .founderBelief,
                              effect: "+2 [Gold] Gold for each city following this Religion.")
        case .crossCulturalDialogue:
            return BeliefData(name: "Cross-Cultural Dialogue",
                              mainType: .founderBelief,
                              effect: "+1 [Science] Science for every 4 followers of this Religion.")
        // ...
        case .worldChurch:
            return BeliefData(name: "World Church",
                              mainType: .founderBelief,
                              effect: "+1 [Culture] Culture for every 4 followers of this Religion.")

        // enhancer
        case .burialGrounds:
            return BeliefData(name: "Burial Grounds",
                              mainType: .enhancerBelief,
                              effect: "Culture Bomb adjacent tiles when completing a Holy Site.")
        case .crusade:
            return BeliefData(name: "Crusade",
                              mainType: .enhancerBelief,
                              effect: "Combat units gain +10 [Strength] Combat Strength near foreign cities that follow this Religion.")
        // ...
        case .itinerantPreachers:
            return BeliefData(name: "Itinerant Preachers",
                              mainType: .enhancerBelief,
                              effect: "Religion spreads to cities 30% further away.")
        case .missionaryZeal:
            return BeliefData(name: "Missionary Zeal    ",
                              mainType: .enhancerBelief,
                              effect: "Religious units ignore movement costs of terrain and features.")
        // ...
        }
    }
}
