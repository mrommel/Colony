//
//  File.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractPolicyCardSet: AnyObject, Codable {

    func add(card: PolicyCardType)
    func remove(card: PolicyCardType)
    func has(card: PolicyCardType) -> Bool
    func valid(in slots: PolicyCardSlots) -> Bool
    func filled(in slots: PolicyCardSlots) -> Bool

    func cards() -> [PolicyCardType]
    func cards(of slotType: PolicyCardSlotType) -> [PolicyCardType]
    func cardsFilled(in slotType: PolicyCardSlotType, of slots: PolicyCardSlots) -> [PolicyCardType]
}

public class PolicyCardSet: AbstractPolicyCardSet {

    enum CodingKeys: CodingKey {

        case cards
    }

    private var cardsVal: [PolicyCardType]

    // MARK: constructors

    public init(cards: [PolicyCardType] = []) {

        self.cardsVal = cards
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.cardsVal = try container.decode([PolicyCardType].self, forKey: .cards)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.cardsVal, forKey: .cards)
    }

    public func add(card: PolicyCardType) {

        self.cardsVal.append(card)
    }

    public func remove(card: PolicyCardType) {

        self.cardsVal.removeAll(where: { $0 == card })
    }

    public func has(card: PolicyCardType) -> Bool {

        return self.cardsVal.contains(card)
    }

    public func cards() -> [PolicyCardType] {

        return self.cardsVal
    }

    public func cards(of slotType: PolicyCardSlotType) -> [PolicyCardType] {

        return self.cardsVal.filter({ $0.slot() == slotType })
    }

    public func cardsFilled(in slotType: PolicyCardSlotType, of slots: PolicyCardSlots) -> [PolicyCardType] {

        let militaryCards = self.cardsVal.count(where: { $0.slot() == .military })
        let possibleMilitaryCards = min(militaryCards, slots.military)
        let economicCards = self.cardsVal.count(where: { $0.slot() == .economic })
        let possibleEconomicCards = min(economicCards, slots.economic)
        let diplomaticCards = self.cardsVal.count(where: { $0.slot() == .diplomatic })
        let possibleDiplomaticCards = min(diplomaticCards, slots.diplomatic)

        if slotType == .military {
            let allMilitaryCards = self.cardsVal.filter({ $0.slot() == .military })
            return Array(allMilitaryCards.prefix(possibleMilitaryCards))
        } else if slotType == .economic {
            let allEconomicCards = self.cardsVal.filter({ $0.slot() == .economic })
            return Array(allEconomicCards.prefix(possibleEconomicCards))
        } else if slotType == .diplomatic {
            let allDiplomaticCards = self.cardsVal.filter({ $0.slot() == .diplomatic })
            return Array(allDiplomaticCards.prefix(possibleDiplomaticCards))
        } else {
            var tmpCards = self.cardsVal

            let tmpMilitary = self.cardsFilled(in: .military, of: slots)
            tmpCards.removeAll(where: { tmpMilitary.contains($0) })

            let tmpEconomic = self.cardsFilled(in: .economic, of: slots)
            tmpCards.removeAll(where: { tmpEconomic.contains($0) })

            let tmpDiplomatic = self.cardsFilled(in: .diplomatic, of: slots)
            tmpCards.removeAll(where: { tmpDiplomatic.contains($0) })

            return tmpCards
        }
    }

    public func valid(in slots: PolicyCardSlots) -> Bool {

        let militaryCards = self.cardsVal.count(where: { $0.slot() == .military })
        let economicCards = self.cardsVal.count(where: { $0.slot() == .economic })
        let diplomaticCards = self.cardsVal.count(where: { $0.slot() == .diplomatic })

        let remainMilitary = max(0, militaryCards - slots.military)
        let remainEconomic = max(0, economicCards - slots.economic)
        let remainDiplomatic = max(0, diplomaticCards - slots.diplomatic)

        return slots.wildcard - remainMilitary - remainEconomic - remainDiplomatic >= 0
    }

    public func filled(in slots: PolicyCardSlots) -> Bool {

        let militaryCards = self.cardsVal.count(where: { $0.slot() == .military })
        let economicCards = self.cardsVal.count(where: { $0.slot() == .economic })
        let diplomaticCards = self.cardsVal.count(where: { $0.slot() == .diplomatic })
        let wildCards = self.cardsVal.count(where: { $0.slot() == .wildcard })

        let deltaMilitary = militaryCards - slots.military
        let deltaEconomic = economicCards - slots.economic
        let deltaDiplomatic = diplomaticCards - slots.diplomatic

        // check for empty slots
        if deltaMilitary < 0 || deltaEconomic < 0 || deltaDiplomatic < 0 {
            return false
        }

        return slots.wildcard - deltaMilitary - deltaEconomic - deltaDiplomatic - wildCards == 0
    }
}

class WeightedGovernmentList: WeightedList<GovernmentType> {

}

public protocol AbstractGovernment: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func currentGovernment() -> GovernmentType?
    func set(governmentType: GovernmentType, in gameModel: GameModel?)
    func set(policyCardSet: AbstractPolicyCardSet) throws
    func policyCardSet() -> AbstractPolicyCardSet

    func add(card: PolicyCardType)
    func remove(card: PolicyCardType)
    func has(card: PolicyCardType) -> Bool

    func chooseBestGovernment(in gameModel: GameModel?)
    func possibleGovernments() -> [GovernmentType]

    func hasPolicyCardsFilled(in gameModel: GameModel?) -> Bool
    func policyCardSlots(in gameModel: GameModel?) -> PolicyCardSlots
    func possiblePolicyCards() -> [PolicyCardType]
    func fillPolicyCards(in gameModel: GameModel?)

    func verify(in gameModel: GameModel?)
}

enum GovernmentError: Error {

    case noGovernmentSelected
    case invalidPolicyCardSet
}

public class Government: AbstractGovernment {

    enum CodingKeys: CodingKey {

        case currentGovernment
        case policyCards

        case lastCheckedGovernment
    }

    public var player: AbstractPlayer?
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

    public func currentGovernment() -> GovernmentType? {

        return self.currentGovernmentVal
    }

    public func possibleGovernments() -> [GovernmentType] {

        guard let civics = self.player?.civics else {
            fatalError("cant get civics")
        }

        let governmentTypes = GovernmentType.all.filter({ civics.has(civic: $0.required()) })
        return governmentTypes
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

            // find possible governments
            let governmentTypes = allGovernmentTypes.filter({ civics.has(civic: $0.required()) })

            if !governmentTypes.isEmpty {

                // rate governments
                let governmentRating = WeightedGovernmentList()

                for governmentType in governmentTypes {

                    var value = 0
                    for flavourType in FlavorType.all {
                        value += player.personalAndGrandStrategyFlavor(for: flavourType) * governmentType.flavorValue(for: flavourType)
                    }
                    governmentRating.add(weight: value, for: governmentType)
                }

                // select government
                if let bestGovernment = governmentRating.chooseLargest() {
                    if bestGovernment != self.currentGovernmentVal {

                        self.set(governmentType: bestGovernment, in: gameModel)

                        self.fillPolicyCards(in: gameModel)
                    }
                }
            } else {
                self.set(governmentType: .chiefdom, in: gameModel)

                self.fillPolicyCards(in: gameModel)
            }

            self.lastCheckedGovernment = gameModel.currentTurn
        }
    }

    public func fillPolicyCards(in gameModel: GameModel?) {

        guard let currentGovernment = self.currentGovernmentVal else {
            fatalError("no government selected")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let civics = self.player?.civics else {
            fatalError("cant get civics")
        }

        // all cards
        let allPolicyCards = PolicyCardType.all

        // find possible cards
        var policyCards = allPolicyCards.filter {
            if let requiredCivic = $0.requiredCivic() {
                return civics.has(civic: requiredCivic)
            }

            return true
        }

        // remove obsolete cards
        policyCards = policyCards.filter {
            if let obsoleteCivic = $0.obsoleteCivic() {
                return !civics.has(civic: obsoleteCivic)
            }

            return true
        }

        // remove dark age cards
        policyCards = policyCards.filter {
            if $0.requiresDarkAge() {
                if player.currentAge() != .dark {
                    return false
                }

                if let startEra = $0.startEra() {
                    if player.currentEra() < startEra {
                        return false
                    }
                }

                if let endEra = $0.endEra() {
                    if player.currentEra() > endEra {
                        return false
                    }
                }
            }

            return true
        }

        // remove 'replaces'
        policyCards = policyCards.filter {
            for card in $0.replacePolicyCards() {
                if policyCards.contains(card) {
                    return false
                }
            }

            return true
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

        // select best policy cards for each slot
        let slots: PolicyCardSlots = self.policyCardSlots(in: gameModel)
        for slotType in slots.types() {

            let possibleCardsForSlot = policyCardRating.filter(
                where: { (key, _) in
                    slotType == .wildcard || key.slot() == slotType
                }
            )

            if let bestCard = possibleCardsForSlot.chooseLargest() {
                // .
                self.add(card: bestCard)

                policyCardRating = policyCardRating.filter(
                    where: { (key, _) in
                        key != bestCard
                    }
                )
            }
        }
    }

    public func set(governmentType: GovernmentType, in gameModel: GameModel?) {

        if self.currentGovernmentVal != governmentType {

            guard let player = self.player else {
                fatalError("cant get player to change government type")
            }

            self.currentGovernmentVal = governmentType
            self.policyCardsVal = PolicyCardSet() // reset card selection

            if player.isHuman() {
                player.notifications()?.add(notification: .policiesNeeded)
            }

            player.doUpdateTradeRouteCapacity(in: gameModel)

            // send gossip to other players
            gameModel?.sendGossip(type: .governmentChange(government: governmentType), of: player)
        }
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

    public func policyCardSlots(in gameModel: GameModel?) -> PolicyCardSlots {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if let government = self.currentGovernmentVal {

            let policyCardSlots = government.policyCardSlots()

            if player.leader.civilization().ability() == .platosRepublic {
                policyCardSlots.wildcard += 1
            }

            // alhambra: +1 Military policy slot
            if player.has(wonder: .alhambra, in: gameModel) {
                policyCardSlots.military += 1
            }

            // forbiddenCity: +1 Wildcard policy slot
            if player.has(wonder: .forbiddenCity, in: gameModel) {
                policyCardSlots.wildcard += 1
            }

            // potalaPalace: +1 Diplomatic policy slot
            if player.has(wonder: .potalaPalace, in: gameModel) {
                policyCardSlots.diplomatic += 1
            }

            return policyCardSlots
        }

        return PolicyCardSlots(military: 0, economic: 0, diplomatic: 0, wildcard: 0)
    }

    public func possiblePolicyCards() -> [PolicyCardType] {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let civics = player.civics else {
            fatalError("cant get civics")
        }

        var cards: [PolicyCardType] = []

        for cardType in PolicyCardType.all {

            var requiredCondition = true
            if let requiredCivic = cardType.requiredCivic() {
                if !civics.has(civic: requiredCivic) {
                    requiredCondition = false
                }
            }

            var obsoleteCondition = false
            if let obsoleteCivic = cardType.obsoleteCivic() {
                if civics.has(civic: obsoleteCivic) {
                    obsoleteCondition = true
                }
            }

            if cardType.requiresDarkAge() {
                if player.currentAge() != .dark {
                    continue
                }

                if let startEra = cardType.startEra() {
                    if player.currentEra() < startEra {
                        continue
                    }
                }

                if let endEra = cardType.endEra() {
                    if player.currentEra() > endEra {
                        continue
                    }
                }
            }

            if requiredCondition && !obsoleteCondition {
                cards.append(cardType)
            }
        }

        var filteredCards: [PolicyCardType] = []

        // remove 'replaced' (better) cards
        for card in cards {

            if !cards.contains(where: { $0.replacePolicyCards().contains(card) }) {

                filteredCards.append(card)
            }
        }

        return filteredCards
    }

    public func add(card: PolicyCardType) {

        self.policyCardsVal.add(card: card)
    }

    public func remove(card: PolicyCardType) {

        self.policyCardsVal.remove(card: card)
    }

    public func has(card: PolicyCardType) -> Bool {

        return self.policyCardsVal.has(card: card)
    }

    public func hasPolicyCardsFilled(in gameModel: GameModel?) -> Bool {

        return self.policyCardsVal.filled(in: self.policyCardSlots(in: gameModel))
    }

    public func verify(in gameModel: GameModel?) {

        let possibleCards = self.possiblePolicyCards()
        var cardTypesToRemove: [PolicyCardType] = []

        for cardType in self.policyCardsVal.cards() {

            if !possibleCards.contains(cardType) {
                cardTypesToRemove.append(cardType)
            }
        }

        for cardTypeToRemove in cardTypesToRemove {
            self.remove(card: cardTypeToRemove)
        }
    }
}
