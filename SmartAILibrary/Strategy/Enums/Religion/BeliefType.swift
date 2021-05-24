//
//  BeliefType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum BeliefMainType {
    
    case followerBelief
    case worshipBelief
    case founderBelief
    case enhancerBelief
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
    
    // worship
    case allowCathedral
    //case allowDareMehr
    //case allowGurdwara
    case allowMeetingHouse
    case allowMosque
    // ...
    
    // founder
    case churchProperty
    case crossCulturalDialogue
    // ...
    case worldChurch
    
    // enhancer
    case burialGrounds
    case crusade
    
    // MARK: internal classes
    
    private struct BeliefData {
        
        let name: String
        let mainType: BeliefMainType
        let bonus: String
    }
    
    // MARK: private methods
    
    private func data() -> BeliefData {
        
        switch self {
        
        case .none:
            return BeliefData(name: "None",
                              mainType: .enhancerBelief,
                              bonus: "")
        
        // follower beliefs
        case .choralMusic:
            return BeliefData(name: "Choral Music",
                              mainType: .followerBelief,
                              bonus: "Shrines and Temples provide Culture Culture equal to their intrinsic Faith Faith output.")
        case .divineInspiration:
            return BeliefData(name: "Divine Inspiration",
                              mainType: .followerBelief,
                              bonus: "Wonders provide +4 Faith Faith.")
        case .feedTheWorld:
            return BeliefData(name: "Feed the World",
                              mainType: .followerBelief,
                              bonus: "Shrines and Temples provide +3 Food Food and +2 Housing Housing.")
        case .jesuitEducation:
            return BeliefData(name: "Jesuit Education",
                              mainType: .followerBelief,
                              bonus: "May purchase Campus and Theater Square district buildings with Faith Faith.")
        case .religiousCommunity:
            return BeliefData(name: "Religious Community",
                              mainType: .followerBelief,
                              bonus: "International Trade Route Trade Route gain +2 Gold Gold when sent to cities with Holy Sites and an additional 2 Gold Gold for every building in the Holy Site.")
        case .reliquaries:
            return BeliefData(name: "Reliquaries",
                              mainType: .followerBelief,
                              bonus: "Triple Faith Faith and Tourism Tourism yields from Relic Relics.")
        case .warriorMonks:
            return BeliefData(name: "Warrior Monks",
                              mainType: .followerBelief,
                              bonus: "Allows spending Faith Faith to train Warrior Monks in cities with a Temple. Building a Holy Site triggers a Culture Bomb, claiming surrounding tiles.")
            
        // worship
        case .allowCathedral:
            return BeliefData(name: "Cathedral", mainType: .worshipBelief, bonus: "Allows Cathedral")
        case .allowMeetingHouse:
            return BeliefData(name: "Meeting House", mainType: .worshipBelief, bonus: "Allows Meeting House")
        case .allowMosque:
            return BeliefData(name: "Mosque", mainType: .worshipBelief, bonus: "Allows Mosque")
            
        // founder
        case .churchProperty:
            return BeliefData(name: "Church Property",
                              mainType: .founderBelief,
                              bonus: "+2 Gold Gold for each city following this Religion.")
        case .crossCulturalDialogue:
            return BeliefData(name: "Cross-Cultural Dialogue",
                              mainType: .founderBelief,
                              bonus: "+1 Science Science for every 4 followers of this Religion.")
        // ...
        case .worldChurch:
            return BeliefData(name: "World Church",
                              mainType: .founderBelief,
                              bonus: "+1 Culture Culture for every 4 followers of this Religion.")
            
        // enhancer
        case .burialGrounds:
            return BeliefData(name: "Burial Grounds",
                              mainType: .enhancerBelief,
                              bonus: "Culture Bomb adjacent tiles when completing a Holy Site.")
        case .crusade:
            return BeliefData(name: "Crusade",
                              mainType: .enhancerBelief,
                              bonus: "Combat units gain +10 Strength Combat Strength near foreign cities that follow this Religion.")
        }
    }
}
