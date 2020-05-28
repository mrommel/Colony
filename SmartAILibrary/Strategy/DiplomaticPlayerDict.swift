//
//  DiplomaticAIPlayerDict.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class DiplomaticPlayerDict: Codable {

    enum CodingKeys: CodingKey {

        case items
    }
    
    // MARK: private properties

    private var items: [DiplomaticAIPlayerItem]

    // MARK: internal classes

    class DiplomaticAIPlayerItem: Codable {
        
        enum CodingKeys: CodingKey {

            case leader
            case opinion
            case turnOfFirstContact
            case militaryStrengthComparedToUs
            case militaryThreat
            case economicStrengthComparedToUs
            
            case approach
            case warState
            case warFace
            case targetValue
            
            // disputes
            case landDisputeLevel
            case lastTurnLandDisputeLevel
            
            // postures
            case expansionAggressivePosture
            case plotBuyingAggressivePosture

            // pacts
            case declatationOfWar
            case declarationOfFriendship
            case openBorderAgreement
            case defensivePact
            case peaceTreaty
            case alliance

            // deals
            case deals

            case hasDenounced
            case isRecklessExpander

            case proximity
        }

        let leader: LeaderType
        var opinion: PlayerOpinionType
        var turnOfFirstContact: Int
        var militaryStrengthComparedToUs: StrengthType
        var militaryThreat: MilitaryThreatType
        var economicStrengthComparedToUs: StrengthType

        var approach: PlayerApproachType
        var warState: PlayerWarStateType
        var warFace: PlayerWarFaceType
        var targetValue: PlayerTargetValueType
        
        // disputes
        var landDisputeLevel: LandDisputeLevelType
        var lastTurnLandDisputeLevel: LandDisputeLevelType
        
        // postures
        var expansionAggressivePosture: AggressivePostureType
        var plotBuyingAggressivePosture: AggressivePostureType

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

        init(by leader: LeaderType, turnOfFirstContact: Int = -1) {

            self.leader = leader
            self.opinion = .none
            self.turnOfFirstContact = turnOfFirstContact
            self.militaryStrengthComparedToUs = .average
            self.militaryThreat = .none
            self.economicStrengthComparedToUs = .average

            self.approach = .none
            self.warFace = .none
            self.warState = .none
            self.targetValue = .none
            
            self.landDisputeLevel = .none
            self.lastTurnLandDisputeLevel = .none
            
            self.expansionAggressivePosture = .none
            self.plotBuyingAggressivePosture = .none

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
        
        public required init(from decoder: Decoder) throws {
        
            let container = try decoder.container(keyedBy: CodingKeys.self)
        
            self.leader = try container.decode(LeaderType.self, forKey: .leader)
            self.opinion = try container.decode(PlayerOpinionType.self, forKey: .opinion)
            self.turnOfFirstContact = try container.decode(Int.self, forKey: .turnOfFirstContact)
            self.militaryStrengthComparedToUs = try container.decode(StrengthType.self, forKey: .militaryStrengthComparedToUs)
            self.militaryThreat = try container.decode(MilitaryThreatType.self, forKey: .militaryThreat)
            self.economicStrengthComparedToUs = try container.decode(StrengthType.self, forKey: .economicStrengthComparedToUs)
            
            self.approach = try container.decode(PlayerApproachType.self, forKey: .approach)
            self.warState = try container.decode(PlayerWarStateType.self, forKey: .warState)
            self.warFace = try container.decode(PlayerWarFaceType.self, forKey: .warFace)
            self.targetValue = try container.decode(PlayerTargetValueType.self, forKey: .targetValue)
            
            // disputes
            self.landDisputeLevel = try container.decode(LandDisputeLevelType.self, forKey: .landDisputeLevel)
            self.lastTurnLandDisputeLevel = try container.decode(LandDisputeLevelType.self, forKey: .lastTurnLandDisputeLevel)
            
            // postures
            self.expansionAggressivePosture = try container.decode(AggressivePostureType.self, forKey: .expansionAggressivePosture)
            self.plotBuyingAggressivePosture = try container.decode(AggressivePostureType.self, forKey: .plotBuyingAggressivePosture)

            // pacts
            self.declatationOfWar = try container.decode(DiplomaticPact.self, forKey: .declatationOfWar)
            self.declarationOfFriendship = try container.decode(DiplomaticPact.self, forKey: .declarationOfFriendship)
            self.openBorderAgreement = try container.decode(DiplomaticPact.self, forKey: .openBorderAgreement)
            self.defensivePact = try container.decode(DiplomaticPact.self, forKey: .defensivePact)
            self.peaceTreaty = try container.decode(DiplomaticPact.self, forKey: .peaceTreaty)
            self.alliance = try container.decode(DiplomaticPact.self, forKey: .alliance)

            // deals
            self.deals = try container.decode([DiplomaticDeal].self, forKey: .deals)

            self.hasDenounced = try container.decode(Bool.self, forKey: .hasDenounced)
            self.isRecklessExpander = try container.decode(Bool.self, forKey: .isRecklessExpander)

            self.proximity = try container.decode(PlayerProximityType.self, forKey: .proximity)
        }
        
        public func encode(to encoder: Encoder) throws {
        
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.leader, forKey: .leader)
            try container.encode(self.opinion, forKey: .opinion)
            try container.encode(self.turnOfFirstContact, forKey: .turnOfFirstContact)
            try container.encode(self.militaryStrengthComparedToUs, forKey: .militaryStrengthComparedToUs)
            try container.encode(self.militaryThreat, forKey: .militaryThreat)
            try container.encode(self.economicStrengthComparedToUs, forKey: .economicStrengthComparedToUs)
            
            try container.encode(self.approach, forKey: .approach)
            try container.encode(self.warState, forKey: .warState)
            try container.encode(self.warFace, forKey: .warFace)
            try container.encode(self.targetValue, forKey: .targetValue)
            
            // disputes
            try container.encode(self.landDisputeLevel, forKey: .landDisputeLevel)
            try container.encode(self.lastTurnLandDisputeLevel, forKey: .lastTurnLandDisputeLevel)
            
            // postures
            try container.encode(self.expansionAggressivePosture, forKey: .expansionAggressivePosture)
            try container.encode(self.plotBuyingAggressivePosture, forKey: .plotBuyingAggressivePosture)

            // pacts
            try container.encode(self.declatationOfWar, forKey: .declatationOfWar)
            try container.encode(self.declarationOfFriendship, forKey: .declarationOfFriendship)
            try container.encode(self.openBorderAgreement, forKey: .openBorderAgreement)
            try container.encode(self.defensivePact, forKey: .defensivePact)
            try container.encode(self.peaceTreaty, forKey: .peaceTreaty)
            try container.encode(self.alliance, forKey: .alliance)

            // deals
            try container.encode(self.deals, forKey: .deals)

            try container.encode(self.hasDenounced, forKey: .hasDenounced)
            try container.encode(self.isRecklessExpander, forKey: .isRecklessExpander)

            try container.encode(self.proximity, forKey: .proximity)
        }
    }

    // MARK: constructor

    init() {

        self.items = []
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.items = try container.decode([DiplomaticAIPlayerItem].self, forKey: .items)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.items, forKey: .items)
    }

    func initContact(with otherPlayer: AbstractPlayer?, in turn: Int) {

        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get leader")
        }
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.turnOfFirstContact = turn
        } else {
            self.items.append(DiplomaticAIPlayerItem(by: otherLeader, turnOfFirstContact: turn))
        }
    }
    
    // MARK: option methods

    func opinion(of otherPlayer: AbstractPlayer?) -> PlayerOpinionType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.opinion
        } else {
            fatalError("not gonna happen")
        }
    }
    
    func updateOpinion(towards otherPlayer: AbstractPlayer?, to opinionType: PlayerOpinionType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.opinion = opinionType
        } else {
            fatalError("not gonna happen")
        }
    }
    
    // MARK: strength methods

    func updateMilitaryStrengthComparedToUs(of otherPlayer: AbstractPlayer?, is strengthComparedToUs: StrengthType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.militaryStrengthComparedToUs = strengthComparedToUs
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateEconomicStrengthComparedToUs(of otherPlayer: AbstractPlayer?, is strengthComparedToUs: StrengthType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.economicStrengthComparedToUs = strengthComparedToUs
        } else {
            fatalError("not gonna happen")
        }
    }

    func militaryStrengthComparedToUs(of otherPlayer: AbstractPlayer?) -> StrengthType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.militaryStrengthComparedToUs
        }

        return .average
    }

    func economicStrengthComparedToUs(of otherPlayer: AbstractPlayer?) -> StrengthType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.economicStrengthComparedToUs
        }

        return .average
    }

    func hasMet(with otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.turnOfFirstContact != -1
        }

        return false
    }

    // MARK: methods for war handling

    func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
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

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.approach = approachType
        } else {
            fatalError("not gonna happen")
        }
    }

    func approach(towards otherPlayer: AbstractPlayer?) -> PlayerApproachType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.approach
        }

        //return .none
        fatalError("not gonna happen")
    }

    // MARK:  war state methods

    func updateWarState(towards otherPlayer: AbstractPlayer?, to warStateType: PlayerWarStateType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warState = warStateType
        } else {
            fatalError("not gonna happen")
        }
    }

    func warState(for otherPlayer: AbstractPlayer?) -> PlayerWarStateType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.warState
        }

        fatalError("not gonna happen")
        //return .stalemate
    }

    // MARK: war face methods

    func updateWarFace(towards otherPlayer: AbstractPlayer?, to warFaceType: PlayerWarFaceType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warFace = warFaceType
        } else {
            fatalError("not gonna happen")
        }
    }

    func warFace(for otherPlayer: AbstractPlayer?) -> PlayerWarFaceType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.warFace
        }

        //return .neutral
        fatalError("not gonna happen")
    }
    
    // MARK: target value methods

    func updateTargetValue(of otherPlayer: AbstractPlayer?, to targetValue: PlayerTargetValueType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.targetValue = targetValue
        } else {
            fatalError("not gonna happen")
        }
    }

    func targetValue(of otherPlayer: AbstractPlayer?) -> PlayerTargetValueType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.targetValue
        }

        fatalError("not gonna happen")
    }
    
    // MARK
    
    func declaredWar(towards otherPlayer: AbstractPlayer?, in turn: Int) {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.declatationOfWar.activate(in: turn)
            item.peaceTreaty.abandon() // just in case
        } else {
            fatalError("not gonna happen")
        }
        
        self.updateApproach(towards: otherPlayer, to: .war)
        self.updateWarState(towards: otherPlayer, to: .offensive)
    }
    
    func turnsOfWar(with otherPlayer: AbstractPlayer?, in turn: Int) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return turn - item.declatationOfWar.pactIsActiveSince()
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: pacts - declaration of friendship

    func isDeclarationOfFriendshipActive(by otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.declarationOfFriendship.isActive()
        }

        return false
    }

    func establishDeclarationOfFriendship(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.declarationOfFriendship.activate()
        } else {
            fatalError("not gonna happen")
        }
    }

    func abandonDeclarationOfFriendship(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.declarationOfFriendship.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }
    
    // MARK: pacts - open border agreement

    func isOpenBorderAgreementpActive(by otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.openBorderAgreement.isActive()
        }

        return false
    }

    func establishOpenBorderAgreement(with otherPlayer: AbstractPlayer?, in turn: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.openBorderAgreement.activate(in: turn)
        } else {
            fatalError("not gonna happen")
        }
    }

    func abandonOpenBorderAgreement(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.openBorderAgreement.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: pacts - defensive pacts

    func establishDefensivePact(with otherPlayer: AbstractPlayer?, in turn: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.defensivePact.activate(in: turn)
        } else {
            fatalError("not gonna happen")
        }
    }

    func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.defensivePact.isActive()
        } else {
            fatalError("not gonna happen")
        }
    }

    func isDefensivePactExpired(with otherPlayer: AbstractPlayer?, in turn: Int) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.defensivePact.isExpired(in: turn)
        } else {
            fatalError("not gonna happen")
        }
    }

    func cancelDefensivePact(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
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

    func allPlayersWithDefensivePacts() -> [LeaderType] {

        var defPlayers: [LeaderType] = []

        for item in self.items {

            if item.defensivePact.isActive() {
                defPlayers.append(item.leader)
            }
        }

        return defPlayers
    }

    // MARK: pacts - peace treaty

    func isPeaceTreatyActive(by otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.peaceTreaty.isActive()
        }

        return false
    }

    func establishPeaceTreaty(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.peaceTreaty.activate()
            item.declatationOfWar.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }

    func abandonPeaceTreaty(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.peaceTreaty.abandon()
        } else {
            fatalError("not gonna happen")
        }
    }
    
    // MARK: pacts - alliances
    
    func isAllianceActive(with otherPlayer: AbstractPlayer?) -> Bool {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.alliance.isActive()
        }

        return false
    }

    // MARK: deals

    func cancelDeals(with otherPlayer: AbstractPlayer?) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {

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

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.hasDenounced = true
        } else {
            fatalError("not gonna happen")
        }
    }

    func hasDenounced(player otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.hasDenounced
        }

        //return false
        fatalError("not gonna happen")
    }

    // MARK: military threat

    func updateMilitaryThreat(of otherPlayer: AbstractPlayer?, to militaryThreat: MilitaryThreatType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.militaryThreat = militaryThreat
        } else {
            fatalError("not gonna happen")
        }
    }

    func militaryThreat(of otherPlayer: AbstractPlayer?) -> MilitaryThreatType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.militaryThreat
        }

        //return .none
        fatalError("not gonna happen")
    }

    // MARK: proximity

    func updateProximity(towards otherPlayer: AbstractPlayer?, to proximity: PlayerProximityType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.proximity = proximity
        } else {
            fatalError("not gonna happen")
        }
    }

    func proximity(to otherPlayer: AbstractPlayer?) -> PlayerProximityType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.proximity
        }

        //return .none
        fatalError("not gonna happen")
    }
    
    // MARK: reckless expander
    
    func isRecklessExpander(of otherPlayer: AbstractPlayer?) -> Bool {
        
        return false // FIXME
    }
    
    // MARK: land dispute
    
    func landDisputeLevel(with otherPlayer: AbstractPlayer?) -> LandDisputeLevelType {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.landDisputeLevel
        }
        
        fatalError("not gonna happen")
    }
    
    func updateLandDisputeLevel(with otherPlayer: AbstractPlayer?, to dispute: LandDisputeLevelType) {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.landDisputeLevel = dispute
        } else {
            fatalError("not gonna happen")
        }
    }
    
    func lastTurnLandDisputeLevel(with otherPlayer: AbstractPlayer?) -> LandDisputeLevelType {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.lastTurnLandDisputeLevel
        }
        
        fatalError("not gonna happen")
    }
    
    func updateLastTurnLandDisputeLevel(with otherPlayer: AbstractPlayer?, to dispute: LandDisputeLevelType) {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.lastTurnLandDisputeLevel = dispute
        } else {
            fatalError("not gonna happen")
        }
    }
    
    // MARK: postures
    
    func expansionAggressivePosture(towards otherPlayer: AbstractPlayer?) -> AggressivePostureType {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.expansionAggressivePosture
        }
        
        fatalError("not gonna happen")
    }
    
    func updateExpansionAggressivePosture(for otherPlayer: AbstractPlayer?, posture: AggressivePostureType) {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.expansionAggressivePosture = posture
        } else {
            fatalError("not gonna happen")
        }
    }
    
    func plotBuyingAggressivePosture(towards otherPlayer: AbstractPlayer?) -> AggressivePostureType {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.plotBuyingAggressivePosture
        }
        
        fatalError("not gonna happen")
    }
    
    func updatePlotBuyingAggressivePosture(for otherPlayer: AbstractPlayer?, posture: AggressivePostureType) {
        
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.plotBuyingAggressivePosture = posture
        } else {
            fatalError("not gonna happen")
        }
    }
}
