//
//  DiplomaticAIPlayerDict.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class DiplomaticPlayerDict {

    // MARK: private properties

    private var items: [DiplomaticAIPlayerItem]

    // MARK: internal classes

    class DiplomaticAIPlayerItem {

        let player: AbstractPlayer?
        var opinion: PlayerOpinionType
        var turnOfFirstContact: Int
        var militaryStrengthComparedToUs: StrengthType
        var militaryThreat: MilitaryThreatType
        var economicStrengthComparedToUs: StrengthType

        var approach: PlayerApproachType
        var warState: PlayerWarStateType
        var warFace: PlayerWarFaceType
        var targetValue: PlayerTargetValueType

        // pacts
        var declatationOfWar: DiplomaticPact
        var declarationOfFriendship: DiplomaticPact
        var openBorderAgreement: DiplomaticPact
        var defensivePact: DiplomaticPact
        var peaceTreaty: DiplomaticPact
        var alliance: DiplomaticPact

        // deals
        var deals: [DiplomaticDeal]

        var hasDenounced: Bool
        var isRecklessExpander: Bool

        var proximity: PlayerProximityType

        init(by player: AbstractPlayer?, turnOfFirstContact: Int = -1) {

            self.player = player
            self.opinion = .none
            self.turnOfFirstContact = turnOfFirstContact
            self.militaryStrengthComparedToUs = .average
            self.militaryThreat = .none
            self.economicStrengthComparedToUs = .average

            self.approach = .none
            self.warFace = .none
            self.warState = .none
            self.targetValue = .none

            // pacts
            self.declatationOfWar = DiplomaticPact()
            self.declarationOfFriendship = DiplomaticPact()
            self.openBorderAgreement = DiplomaticPact() // no runtime
            self.defensivePact = DiplomaticPact(with: 15) // has a runtime of 15 turns
            self.peaceTreaty = DiplomaticPact(with: 15) // has a runtime of 15 turns
            self.alliance = DiplomaticPact()

            // deals
            self.deals = []

            self.hasDenounced = false
            self.isRecklessExpander = false

            self.proximity = .none
        }
    }

    // MARK: constructor

    init() {

        self.items = []
    }

    func initContact(with otherPlayer: AbstractPlayer?, in turn: Int) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.turnOfFirstContact = turn
        } else {
            self.items.append(DiplomaticAIPlayerItem(by: otherPlayer, turnOfFirstContact: turn))
        }
    }
    
    // MARK: option methods

    func opinion(of otherPlayer: AbstractPlayer?) -> PlayerOpinionType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.opinion
        } else {
            fatalError("not gonna happen")
        }
    }
    
    func updateOpinion(towards otherPlayer: AbstractPlayer?, to opinionType: PlayerOpinionType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.opinion = opinionType
        } else {
            fatalError("not gonna happen")
        }
    }
    
    // MARK: strength methods

    func updateMilitaryStrengthComparedToUs(of otherPlayer: AbstractPlayer?, is strengthComparedToUs: StrengthType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.militaryStrengthComparedToUs = strengthComparedToUs
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateEconomicStrengthComparedToUs(of otherPlayer: AbstractPlayer?, is strengthComparedToUs: StrengthType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.economicStrengthComparedToUs = strengthComparedToUs
        } else {
            fatalError("not gonna happen")
        }
    }

    func militaryStrengthComparedToUs(of otherPlayer: AbstractPlayer?) -> StrengthType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.militaryStrengthComparedToUs
        }

        return .average
    }

    func economicStrengthComparedToUs(of otherPlayer: AbstractPlayer?) -> StrengthType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.economicStrengthComparedToUs
        }

        return .average
    }

    func hasMet(with otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.turnOfFirstContact != -1
        }

        return false
    }

    // MARK: methods for war handling

    func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.approach == .war
        }

        return false
    }

    func isAtWar() -> Bool {

        for item in self.items {

            if item.approach == .war {
                return true
            }
        }

        return false
    }
    
    func atWarCount() -> Int {

        return self.items.count(where: { $0.approach == .war })
    }

    // MARK: approach methods

    func updateApproach(towards otherPlayer: AbstractPlayer?, to approachType: PlayerApproachType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.approach = approachType
        } else {
            fatalError("not gonna happen")
        }
    }

    func approach(towards otherPlayer: AbstractPlayer?) -> PlayerApproachType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.approach
        }

        //return .none
        fatalError("not gonna happen")
    }

    // MARK:  war state methods

    func updateWarState(towards otherPlayer: AbstractPlayer?, to warStateType: PlayerWarStateType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.warState = warStateType
        } else {
            fatalError("not gonna happen")
        }
    }

    func warState(for otherPlayer: AbstractPlayer?) -> PlayerWarStateType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.warState
        }

        fatalError("not gonna happen")
        //return .stalemate
    }

    // MARK: war face methods

    func updateWarFace(towards otherPlayer: AbstractPlayer?, to warFaceType: PlayerWarFaceType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.warFace = warFaceType
        } else {
            fatalError("not gonna happen")
        }
    }

    func warFace(for otherPlayer: AbstractPlayer?) -> PlayerWarFaceType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.warFace
        }

        //return .neutral
        fatalError("not gonna happen")
    }
    
    // MARK: target value methods

    func updateTargetValue(of otherPlayer: AbstractPlayer?, to targetValue: PlayerTargetValueType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.targetValue = targetValue
        } else {
            fatalError("not gonna happen")
        }
    }

    func targetValue(of otherPlayer: AbstractPlayer?) -> PlayerTargetValueType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.targetValue
        }

        fatalError("not gonna happen")
    }
    
    // MARK
    
    func declaredWar(towards otherPlayer: AbstractPlayer?, in turn: Int) {
        
        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.declatationOfWar.activate(in: turn)
            item.peaceTreaty.abandon() // just in case
        } else {
            fatalError("not gonna happen")
        }
        
        self.updateApproach(towards: otherPlayer, to: .war)
        self.updateWarState(towards: otherPlayer, to: .offensive)
    }
    
    func turnsOfWar(with otherPlayer: AbstractPlayer?, in turn: Int) -> Int {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return turn - item.declatationOfWar.pactIsActiveSince()
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: pacts - declaration of friendship

    func isDeclarationOfFriendshipActive(by otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.declarationOfFriendship.isActive()
        }

        return false
    }

    func establishDeclarationOfFriendship(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.declarationOfFriendship.activate()
        } else {
            fatalError("not gonna happen")
        }
    }

    func abandonDeclarationOfFriendship(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.declarationOfFriendship.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }
    
    // MARK: pacts - open border agreement

    func isOpenBorderAgreementpActive(by otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.openBorderAgreement.isActive()
        }

        return false
    }

    func establishOpenBorderAgreement(with otherPlayer: AbstractPlayer?, in turn: Int) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.openBorderAgreement.activate(in: turn)
        } else {
            fatalError("not gonna happen")
        }
    }

    func abandonOpenBorderAgreement(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.openBorderAgreement.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: pacts - defensive pacts

    func establishDefensivePact(with otherPlayer: AbstractPlayer?, in turn: Int) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.defensivePact.activate(in: turn)
        } else {
            fatalError("not gonna happen")
        }
    }

    func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.defensivePact.isActive()
        } else {
            fatalError("not gonna happen")
        }
    }

    func isDefensivePactExpired(with otherPlayer: AbstractPlayer?, in turn: Int) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.defensivePact.isExpired(in: turn)
        } else {
            fatalError("not gonna happen")
        }
    }

    func cancelDefensivePact(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.defensivePact.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }

    func cancelAllDefensivePacts() {

        for item in self.items {

            if item.defensivePact.isActive() {
                item.defensivePact.abandon()
            }
        }
    }

    func allPlayersWithDefensivePacts() -> [AbstractPlayer?] {

        var defPlayers: [AbstractPlayer?] = []

        for item in self.items {

            if item.defensivePact.isActive() {
                defPlayers.append(item.player)
            }
        }

        return defPlayers
    }

    // MARK: pacts - peace treaty

    func isPeaceTreatyActive(by otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.peaceTreaty.isActive()
        }

        return false
    }

    func establishPeaceTreaty(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.peaceTreaty.activate()
            item.declatationOfWar.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }

    func abandonPeaceTreaty(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.peaceTreaty.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }
    
    // MARK: pacts - alliances
    
    func isAllianceActive(with otherPlayer: AbstractPlayer?) -> Bool {
        
        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.alliance.isActive()
        }

        return false
    }

    // MARK: deals

    func cancelDeals(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {

            // FIXME: inform someone?
            item.deals.removeAll()

        } else {
            fatalError("not gonna happen")
        }
    }

    func allDeals() -> [DiplomaticDeal] {

        return self.items.map({ $0.deals }).reduce([], +)
    }

    // MARK: denouncement

    func denounce(player otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.hasDenounced = true
        } else {
            fatalError("not gonna happen")
        }
    }

    func hasDenounced(player otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.hasDenounced
        }

        //return false
        fatalError("not gonna happen")
    }

    // MARK: military threat

    func updateMilitaryThreat(of otherPlayer: AbstractPlayer?, to militaryThreat: MilitaryThreatType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.militaryThreat = militaryThreat
        } else {
            fatalError("not gonna happen")
        }
    }

    func militaryThreat(of otherPlayer: AbstractPlayer?) -> MilitaryThreatType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.militaryThreat
        }

        //return .none
        fatalError("not gonna happen")
    }

    // MARK: proximity

    func updateProximity(towards otherPlayer: AbstractPlayer?, to proximity: PlayerProximityType) {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            item.proximity = proximity
        } else {
            fatalError("not gonna happen")
        }
    }

    func proximity(to otherPlayer: AbstractPlayer?) -> PlayerProximityType {

        if let item = self.items.first(where: { $0.player?.leader == otherPlayer?.leader }) {
            return item.proximity
        }

        //return .none
        fatalError("not gonna happen")
    }
    
    // MARK: reckless expander
    
    func isRecklessExpander(of otherPlayer: AbstractPlayer?) -> Bool {
        
        return false // FIXME
    }
}
