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

    func valid(in slots: PolicyCardSlots) -> Bool {

        let militaryCards = cards.count(where: { $0.slot() == .military })
        let economicCards = cards.count(where: { $0.slot() == .economic })
        let diplomaticCards = cards.count(where: { $0.slot() == .diplomatic })

        let remainMilitary = max(0, militaryCards - slots.military)
        let remainEconomic = max(0, economicCards - slots.economic)
        let remainDiplomatic = max(0, diplomaticCards - slots.diplomatic)

        return slots.wildcard - remainMilitary - remainEconomic - remainDiplomatic >= 0
    }
}

class WeightedGovernmentList: WeightedList<GovernmentType> {

}

public protocol AbstractGovernment: class, Codable {

    var player: AbstractPlayer? { get set }
    
    func currentGovernment() -> GovernmentType?
    func set(governmentType: GovernmentType)
    func set(policyCards: AbstractPolicyCardSet) throws

    func add(card: PolicyCardType)
    func has(card: PolicyCardType) -> Bool
    
    func chooseBestGovernment(in gameModel: GameModel?)
}

enum GovernmentError: Error {

    case noGovernmentSelected
    case invalidPolicyCardSet
}

class Government: AbstractGovernment {

    enum CodingKeys: CodingKey {

        case currentGovernment
        case policyCards

        case lastCheckedGovernment
    }

    var player: AbstractPlayer?
    private var currentGovernmentVal: GovernmentType?
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
        self.policyCardsVal = try container.decode(PolicyCardSet.self, forKey: .policyCards)

        self.lastCheckedGovernment = try container.decode(Int.self, forKey: .lastCheckedGovernment)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.currentGovernmentVal, forKey: .currentGovernment)
        try container.encode(self.policyCardsVal as! PolicyCardSet, forKey: .policyCards)

        try container.encode(self.lastCheckedGovernment, forKey: .lastCheckedGovernment)
    }

    func currentGovernment() -> GovernmentType? {

        return self.currentGovernmentVal
    }

    func chooseBestGovernment(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let civics = self.player?.civics else {
            fatalError("cant get civics")
        }

        if self.currentGovernmentVal == nil || self.lastCheckedGovernment + 10 > gameModel.turnsElapsed {

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

                        self.set(governmentType: bestGovernment)

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

            self.lastCheckedGovernment = gameModel.turnsElapsed
        }
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
