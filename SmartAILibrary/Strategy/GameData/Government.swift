//
//  File.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

protocol AbstractPolicyCardSet {
    
    func add(card: PolicyCardType)
    func has(card: PolicyCardType) -> Bool
    func valid(in slots: PolicyCardSlots) -> Bool
}

class PolicyCardSet: AbstractPolicyCardSet {
    
    private var cards: [PolicyCardType]
    
    init(cards: [PolicyCardType] = []) {
        
        self.cards = cards
    }
    
    func add(card: PolicyCardType) {
        
        self.cards.append(card)
    }
    
    func has(card: PolicyCardType) -> Bool {
        
        return self.cards.contains(card)
    }
    
    func valid(in slots: PolicyCardSlots) -> Bool {
        
        let militaryCards = cards.count(where: { $0.slot() == .military })
        let economicCards = cards.count(where: { $0.slot() == .economic })
        let diplomaticCards = cards.count(where: { $0.slot() == .diplomatic })
        
        let remainMilitary = max(0, militaryCards - slots.military)
        let remainEconomic =  max(0, economicCards - slots.economic)
        let remainDiplomatic =  max(0, diplomaticCards - slots.diplomatic)
        
        return slots.wildcard - remainMilitary - remainEconomic - remainDiplomatic >= 0
    }
}

protocol AbstractGovernment {
    
    func currentGovernment() -> GovernmentType?
    func set(governmentType: GovernmentType)
    func set(policyCards: AbstractPolicyCardSet) throws
    
    func add(card: PolicyCardType)
    func has(card: PolicyCardType) -> Bool
}

enum GovernmentError: Error {
    
    case noGovernmentSelected
    case invalidPolicyCardSet
}

class Government: AbstractGovernment {
    
    private var currentGovernmentVal: GovernmentType?
    private var policyCardsVal: AbstractPolicyCardSet
    
    // MARK: constructor
    
    init() {
        
        self.currentGovernmentVal = nil
        self.policyCardsVal = PolicyCardSet()
    }
    
    func currentGovernment() -> GovernmentType? {
        
        return self.currentGovernmentVal
    }
    
    func set(governmentType: GovernmentType) {
        
        self.currentGovernmentVal = governmentType
        self.policyCardsVal = PolicyCardSet() // reset card selection
    }
    
    func set(policyCards: AbstractPolicyCardSet) throws {
        
        guard let government = self.currentGovernmentVal else {
            throw GovernmentError.noGovernmentSelected
        }
        
        if !policyCards.valid(in: government.policyCardSlots()) {
            throw GovernmentError.invalidPolicyCardSet
        }
        
        self.policyCardsVal = policyCards
    }
    
    func policyCardSlots() -> PolicyCardSlots {
        
        if let government = self.currentGovernmentVal {
            return government.policyCardSlots()
        }
        
        return PolicyCardSlots(military: 0, economic: 0, diplomatic: 0, wildcard: 0)
    }
    
    func add(card: PolicyCardType) {
        
        self.policyCardsVal.add(card: card)
    }
    
    func has(card: PolicyCardType) -> Bool {
        
        return self.policyCardsVal.has(card: card)
    }
}
