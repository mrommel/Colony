//
//  File.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractPolicyCardSet: class, Codable {

    func add(card: PolicyCardType)
    func has(card: PolicyCardType) -> Bool
    func valid(in slots: PolicyCardSlots) -> Bool
    func filled(in slots: PolicyCardSlots) -> Bool
    
    func cards(of slotType: PolicyCardSlotType) -> [PolicyCardType]
    func cardsFilled(in slotType: PolicyCardSlotType, of slots: PolicyCardSlots) -> [PolicyCardType]
}

class PolicyCardSet: AbstractPolicyCardSet {

    enum CodingKeys: CodingKey {

        case cards
    }

    private var cards: [PolicyCardType]

    // MARK: constructors

    init(cards: [PolicyCardType] = []) {

        self.cards = cards
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.cards = try container.decode([PolicyCardType].self, forKey: .cards)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.cards, forKey: .cards)
    }

    func add(card: PolicyCardType) {

        self.cards.append(card)
    }

    func has(card: PolicyCardType) -> Bool {

        return self.cards.contains(card)
    }
    
    func cards(of slotType: PolicyCardSlotType) -> [PolicyCardType] {
        
        return cards.filter({ $0.slot() == slotType })
    }
    
    func cardsFilled(in slotType: PolicyCardSlotType, of slots: PolicyCardSlots) -> [PolicyCardType] {
        
        let militaryCards = self.cards.count(where: { $0.slot() == .military })
        let possibleMilitaryCards = min(militaryCards, slots.military)
        let economicCards = self.cards.count(where: { $0.slot() == .economic })
        let possibleEconomicCards = min(economicCards, slots.economic)
        let diplomaticCards = self.cards.count(where: { $0.slot() == .diplomatic })
        let possibleDiplomaticCards = min(diplomaticCards, slots.diplomatic)
        
        if slotType == .military {
            let allMilitaryCards = self.cards.filter({ $0.slot() == .military })
            return Array(allMilitaryCards.prefix(possibleMilitaryCards))
        } else if slotType == .economic {
            let allEconomicCards = self.cards.filter({ $0.slot() == .economic })
            return Array(allEconomicCards.prefix(possibleEconomicCards))
        } else if slotType == .diplomatic {
            let allDiplomaticCards = self.cards.filter({ $0.slot() == .diplomatic })
            return Array(allDiplomaticCards.prefix(possibleDiplomaticCards))
        } else {
            var tmpCards = self.cards
            
            let tmpMilitary = self.cardsFilled(in: .military, of: slots)
            tmpCards.removeAll(where: { tmpMilitary.contains($0) })
            
            let tmpEconomic = self.cardsFilled(in: .economic, of: slots)
            tmpCards.removeAll(where: { tmpEconomic.contains($0) })
            
            let tmpDiplomatic = self.cardsFilled(in: .diplomatic, of: slots)
            tmpCards.removeAll(where: { tmpDiplomatic.contains($0) })
            
            return tmpCards
        }
    }

    func valid(in slots: PolicyCardSlots) -> Bool {

        let militaryCards = cards.count(where: { $0.slot() == .military })
        let economicCards = cards.count(where: { $0.slot() == .economic })
        let diplomaticCards = cards.count(where: { $0.slot() == .diplomatic })

        let remainMilitary = max(0, militaryCards - slots.military)
        let remainEconomic = max(0, economicCards - slots.economic)
        let remainDiplomatic = max(0, diplomaticCards - slots.diplomatic)

        return slots.wildcard - remainMilitary - remainEconomic - remainDiplomatic >= 0
    }
    
    func filled(in slots: PolicyCardSlots) -> Bool {

        let militaryCards = cards.count(where: { $0.slot() == .military })
        let economicCards = cards.count(where: { $0.slot() == .economic })
        let diplomaticCards = cards.count(where: { $0.slot() == .diplomatic })

        let remainMilitary = max(0, militaryCards - slots.military)
        let remainEconomic = max(0, economicCards - slots.economic)
        let remainDiplomatic = max(0, diplomaticCards - slots.diplomatic)

        return slots.wildcard - remainMilitary - remainEconomic - remainDiplomatic == 0
    }
}

class WeightedGovernmentList: WeightedList<GovernmentType> {

}

public protocol AbstractGovernment: class, Codable {

    var player: AbstractPlayer? { get set }
    
    func currentGovernment() -> GovernmentType?
    func set(governmentType: GovernmentType, in turn: Int)
    func set(policyCardSet: AbstractPolicyCardSet) throws
    func policyCardSet() -> AbstractPolicyCardSet

    func add(card: PolicyCardType)
    func has(card: PolicyCardType) -> Bool
    
    func chooseBestGovernment(in gameModel: GameModel?)
    
    func hasPolicyCardsFilled() -> Bool
    func policyCardSlots() -> PolicyCardSlots
}

enum GovernmentError: Error {

    case noGovernmentSelected
    case invalidPolicyCardSet
}

public class Government: AbstractGovernment {

    enum CodingKeys: CodingKey {

        case currentGovernment
        case currentGovernmentSetInTurn
        case policyCards

        case lastCheckedGovernment
    }

    public var player: AbstractPlayer?
    private var currentGovernmentVal: GovernmentType?
    private var currentGovernmentSetInTurn: Int = 0
    private var policyCardsVal: AbstractPolicyCardSet

    // AI value
    private var lastCheckedGovernment: Int = -1

    // MARK: constructor

    init(player: AbstractPlayer?) {

        self.player = player

        self.currentGovernmentVal = nil
        self.policyCardsVal = PolicyCardSet()
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.player = nil

        self.currentGovernmentVal = try container.decodeIfPresent(GovernmentType.self, forKey: .currentGovernment)
        self.currentGovernmentSetInTurn = try container.decode(Int.self, forKey: .currentGovernmentSetInTurn)
        self.policyCardsVal = try container.decode(PolicyCardSet.self, forKey: .policyCards)

        self.lastCheckedGovernment = try container.decode(Int.self, forKey: .lastCheckedGovernment)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.currentGovernmentVal, forKey: .currentGovernment)
        try container.encode(self.currentGovernmentSetInTurn, forKey: .currentGovernmentSetInTurn)
        try container.encode(self.policyCardsVal as! PolicyCardSet, forKey: .policyCards)

        try container.encode(self.lastCheckedGovernment, forKey: .lastCheckedGovernment)
    }

    public func currentGovernment() -> GovernmentType? {

        return self.currentGovernmentVal
    }

    public func chooseBestGovernment(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let civics = self.player?.civics else {
            fatalError("cant get civics")
        }

        if self.currentGovernmentVal == nil || self.lastCheckedGovernment + 10 > gameModel.currentTurn {

            // all governments
            let allGovernmentTypes = GovernmentType.all
            
            // all cards
            let allPolicyCards = PolicyCardType.all

            // find possible governments
            let governmentTypes = allGovernmentTypes.filter({ civics.has(civic: $0.required()) })
            
            // find possible cards
            let policyCards = allPolicyCards.filter({ civics.has(civic: $0.required()) })

            if governmentTypes.count > 0 {

                // rate governments
                let governmentRating = WeightedGovernmentList()

                for governmentType in governmentTypes {

                    var value = 0
                    for flavourType in FlavorType.all {
                        value += player.personalAndGrandStrategyFlavor(for: flavourType) * governmentType.flavorValue(for: flavourType)
                    }
                    governmentRating.add(weight: value, for: governmentType)
                }
                
                // rate cards
                var policyCardRating = WeightedList<PolicyCardType>()
                
                for policyCard in policyCards {

                    var value = 0
                    for flavourType in FlavorType.all {
                        value += player.personalAndGrandStrategyFlavor(for: flavourType) * policyCard.flavorValue(for: flavourType)
                    }
                    policyCardRating.add(weight: value, for: policyCard)
                }

                // select
                if let bestGovernment = governmentRating.chooseBest() {
                    if bestGovernment != self.currentGovernmentVal {

                        self.set(governmentType: bestGovernment, in: gameModel.currentTurn)

                        // select best policy cards for each slot
                        for slotType in bestGovernment.policyCardSlots().types() {
                            
                            let possibleCardsForSlot = policyCardRating.filter({ slotType == .wildcard || $0.itemType.slot() == slotType })
                            
                            if let bestCard = possibleCardsForSlot.chooseBest() {
                                //.
                                self.add(card: bestCard)
                            
                                //slotType.
                                //possibleCardsForSlot.remove bestCard
                                policyCardRating = policyCardRating.filter({ $0.itemType != bestCard })
                            }
                        }
                    }
                }
            }

            self.lastCheckedGovernment = gameModel.currentTurn
        }
    }

    public func set(governmentType: GovernmentType, in turn: Int) {

        self.currentGovernmentVal = governmentType
        self.currentGovernmentSetInTurn = turn
        self.policyCardsVal = PolicyCardSet() // reset card selection
        
        self.player?.notifications()?.addNotification(of: .policiesNeeded, for: self.player, message: "Please choose policy cards", summary: "Choose policy cards")
    }

    public func set(policyCardSet: AbstractPolicyCardSet) throws {

        guard let government = self.currentGovernmentVal else {
            throw GovernmentError.noGovernmentSelected
        }

        if !policyCardSet.valid(in: government.policyCardSlots()) {
            throw GovernmentError.invalidPolicyCardSet
        }

        self.policyCardsVal = policyCardSet
    }
    
    public func policyCardSet() -> AbstractPolicyCardSet {
        
        return self.policyCardsVal
    }

    public func policyCardSlots() -> PolicyCardSlots {

        if let government = self.currentGovernmentVal {
            return government.policyCardSlots()
        }

        return PolicyCardSlots(military: 0, economic: 0, diplomatic: 0, wildcard: 0)
    }

    public func add(card: PolicyCardType) {

        self.policyCardsVal.add(card: card)
    }

    public func has(card: PolicyCardType) -> Bool {

        return self.policyCardsVal.has(card: card)
    }
    
    public func hasPolicyCardsFilled() -> Bool {
        
        return self.policyCardsVal.filled(in: self.policyCardSlots())
    }
}
