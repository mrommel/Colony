//
//  DiplomaticAIPlayerDict.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length nesting
class DiplomaticPlayerDict: Codable {

    enum CodingKeys: CodingKey {

        case items
        case itemsOther
    }

    // MARK: private properties

    private var items: [DiplomaticAIPlayerItem]
    private var itemsOther: [DiplomaticAIPlayersItem]

    // MARK: internal classes

    // class that stores data that belong to/references one other player
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
            case warGoal
            case targetValue
            case warDamageLevel
            case warProjection
            case lastWarProjection
            case warValueLost
            case warWeariness

            case hasEmbassy

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

            // counter
            case turnsAtWar
            case recentTradeValue

            case turnOfLastMeeting
            case numTurnsLockedIntoWar
            case wantPeaceCounter
            case musteringForAttack

            // coop
            case coopAgreements
            case workingAgainstAgreements

            // peace treaty willingness
            case peaceTreatyWillingToOffer
            case peaceTreatyWillingToAccept
        }

        let leader: LeaderType
        var opinion: PlayerOpinionType
        var turnOfFirstContact: Int
        var militaryStrengthComparedToUs: StrengthType
        var militaryThreat: MilitaryThreatType
        var economicStrengthComparedToUs: StrengthType

        var approach: Int // 0 ... 100
        var warState: PlayerWarStateType
        var warFace: PlayerWarFaceType
        var warGoal: WarGoalType
        var targetValue: PlayerTargetValueType
        var warDamageLevel: WarDamageLevelType
        var warProjection: WarProjectionType
        var lastWarProjection: WarProjectionType
        var warValueLost: Int
        var warWeariness: Int

        var hasEmbassyValue: Bool
        // var allowsOpenBordersValue: Bool

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

        // counter
        var turnsAtWar: Int
        var recentTradeValue: Int

        var turnOfLastMeeting: Int
        var numTurnsLockedIntoWar: Int
        var wantPeaceCounter: Int
        var musteringForAttack: Bool

        // coop
        var coopAgreements: DiplomaticPlayerArray<CoopWarState>
        var workingAgainstAgreements: DiplomaticPlayerArray<Bool>

        // peace treaty willingness
        var peaceTreatyWillingToOffer: PeaceTreatyType
        var peaceTreatyWillingToAccept: PeaceTreatyType

        // MARK: constructors

        init(by leader: LeaderType, turnOfFirstContact: Int = -1) {

            self.leader = leader
            self.opinion = .none
            self.turnOfFirstContact = turnOfFirstContact
            self.militaryStrengthComparedToUs = .average
            self.militaryThreat = .none
            self.economicStrengthComparedToUs = .average

            self.approach = 50 // default
            self.warFace = .none
            self.warState = .none
            self.warGoal = .none
            self.targetValue = .none
            self.warDamageLevel = .none
            self.warProjection = .unknown
            self.lastWarProjection = .unknown
            self.warValueLost = 0
            self.warWeariness = 0

            self.hasEmbassyValue = false

            self.landDisputeLevel = .none
            self.lastTurnLandDisputeLevel = .none

            self.expansionAggressivePosture = .none
            self.plotBuyingAggressivePosture = .none

            // pacts
            self.declatationOfWar = DiplomaticPact()
            self.declarationOfFriendship = DiplomaticPact()
            self.openBorderAgreement = DiplomaticPact(with: 15) // has a runtime of 30 turns
            self.defensivePact = DiplomaticPact(with: 15) // has a runtime of 15 turns
            self.peaceTreaty = DiplomaticPact(with: 15) // has a runtime of 15 turns
            self.alliance = DiplomaticPact()

            // deals
            self.deals = []

            self.hasDenounced = false
            self.isRecklessExpander = false

            self.proximity = .none

            // counter
            self.turnsAtWar = 0
            self.recentTradeValue = 0

            self.turnOfLastMeeting = -1
            self.numTurnsLockedIntoWar = 0
            self.wantPeaceCounter = 0
            self.musteringForAttack = false

            // agreements
            self.coopAgreements = DiplomaticPlayerArray<CoopWarState>()
            self.workingAgainstAgreements = DiplomaticPlayerArray<Bool>()

            // peace treaty willingness
            self.peaceTreatyWillingToOffer = .none
            self.peaceTreatyWillingToAccept = .none
        }

        public required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.leader = try container.decode(LeaderType.self, forKey: .leader)
            self.opinion = try container.decode(PlayerOpinionType.self, forKey: .opinion)
            self.turnOfFirstContact = try container.decode(Int.self, forKey: .turnOfFirstContact)
            self.militaryStrengthComparedToUs = try container.decode(StrengthType.self, forKey: .militaryStrengthComparedToUs)
            self.militaryThreat = try container.decode(MilitaryThreatType.self, forKey: .militaryThreat)
            self.economicStrengthComparedToUs = try container.decode(StrengthType.self, forKey: .economicStrengthComparedToUs)

            self.approach = try container.decode(Int.self, forKey: .approach)
            self.warState = try container.decode(PlayerWarStateType.self, forKey: .warState)
            self.warFace = try container.decode(PlayerWarFaceType.self, forKey: .warFace)
            self.warGoal = try container.decode(WarGoalType.self, forKey: .warGoal)
            self.targetValue = try container.decode(PlayerTargetValueType.self, forKey: .targetValue)
            self.warDamageLevel = try container.decode(WarDamageLevelType.self, forKey: .warDamageLevel)
            self.warProjection = try container.decode(WarProjectionType.self, forKey: .warProjection)
            self.lastWarProjection = try container.decode(WarProjectionType.self, forKey: .lastWarProjection)
            self.warValueLost = try container.decode(Int.self, forKey: .warValueLost)
            self.warWeariness = try container.decode(Int.self, forKey: .warWeariness)

            self.hasEmbassyValue = try container.decode(Bool.self, forKey: .hasEmbassy)

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

            // counter
            self.turnsAtWar = try container.decode(Int.self, forKey: .turnsAtWar)
            self.recentTradeValue = try container.decode(Int.self, forKey: .recentTradeValue)

            self.turnOfLastMeeting = try container.decode(Int.self, forKey: .turnOfLastMeeting)
            self.numTurnsLockedIntoWar = try container.decode(Int.self, forKey: .numTurnsLockedIntoWar)
            self.wantPeaceCounter = try container.decode(Int.self, forKey: .wantPeaceCounter)
            self.musteringForAttack = try container.decode(Bool.self, forKey: .musteringForAttack)

            // agreements
            self.coopAgreements = try container.decode(DiplomaticPlayerArray<CoopWarState>.self, forKey: .coopAgreements)
            self.workingAgainstAgreements = try container.decode(DiplomaticPlayerArray<Bool>.self, forKey: .workingAgainstAgreements)

            // peace treaty willingness
            self.peaceTreatyWillingToOffer = try container.decode(PeaceTreatyType.self, forKey: .peaceTreatyWillingToOffer)
            self.peaceTreatyWillingToAccept = try container.decode(PeaceTreatyType.self, forKey: .peaceTreatyWillingToAccept)
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
            try container.encode(self.warGoal, forKey: .warGoal)
            try container.encode(self.targetValue, forKey: .targetValue)
            try container.encode(self.warDamageLevel, forKey: .warDamageLevel)
            try container.encode(self.warProjection, forKey: .warProjection)
            try container.encode(self.lastWarProjection, forKey: .lastWarProjection)
            try container.encode(self.warValueLost, forKey: .warValueLost)
            try container.encode(self.warWeariness, forKey: .warWeariness)

            try container.encode(self.hasEmbassyValue, forKey: .hasEmbassy)

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

            // counter
            try container.encode(self.turnsAtWar, forKey: .turnsAtWar)
            try container.encode(self.recentTradeValue, forKey: .recentTradeValue)

            try container.encode(self.turnOfLastMeeting, forKey: .turnOfLastMeeting)
            try container.encode(self.numTurnsLockedIntoWar, forKey: .numTurnsLockedIntoWar)
            try container.encode(self.wantPeaceCounter, forKey: .wantPeaceCounter)
            try container.encode(self.musteringForAttack, forKey: .musteringForAttack)

            try container.encode(self.coopAgreements, forKey: .coopAgreements)
            try container.encode(self.workingAgainstAgreements, forKey: .workingAgainstAgreements)

            // peace treaty willingness
            try container.encode(self.peaceTreatyWillingToOffer, forKey: .peaceTreatyWillingToOffer)
            try container.encode(self.peaceTreatyWillingToAccept, forKey: .peaceTreatyWillingToAccept)
        }
    }

    // class that stores data that belong to/references one other player
    class DiplomaticAIPlayersItem: Codable {

        enum CodingKeys: CodingKey {

            case fromLeader
            case toLeader
            case warValueLost
        }

        let fromLeader: LeaderType
        let toLeader: LeaderType

        var warValueLost: Int

        // MARK: constructors

        init(from fromLeader: LeaderType, to toLeader: LeaderType) {

            self.fromLeader = fromLeader
            self.toLeader = toLeader

            self.warValueLost = 0
        }

        public required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.fromLeader = try container.decode(LeaderType.self, forKey: .fromLeader)
            self.toLeader = try container.decode(LeaderType.self, forKey: .toLeader)

            self.warValueLost = try container.decode(Int.self, forKey: .warValueLost)
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.fromLeader, forKey: .fromLeader)
            try container.encode(self.toLeader, forKey: .toLeader)

            try container.encode(self.warValueLost, forKey: .warValueLost)
        }
    }

    enum ApproachModifierType {

        case delegation // STANDARD_DIPLOMATIC_DELEGATION
        case declaredFriend // STANDARD_DIPLOMATIC_DECLARED_FRIEND

        // MARK: public methods

        public func summary() -> String {

            return self.data().summary
        }

        public func initialValue() -> Int {

            return self.data().initialValue
        }

        public func reductionTurns() -> Int {

            return self.data().reductionTurns
        }

        public func reductionValue() -> Int {

            return self.data().reductionValue
        }

        // MARK: private methods

        private class ApproachModifierTypeData {

            let summary: String
            let initialValue: Int
            let reductionTurns: Int // how many turns is it active
            let reductionValue: Int // decay value to be substracted

            init(summary: String, initialValue: Int, reductionTurns: Int, reductionValue: Int) {

                self.summary = summary
                self.initialValue = initialValue
                self.reductionTurns = reductionTurns
                self.reductionValue = reductionValue
            }
        }

        // https://github.com/Swiftwork/civ6-explorer/blob/dbe3ca6d5468828ef0b26ef28f69555de0bcb959/src/assets/game/BaseGame/Leaders.xml
        private func data() -> ApproachModifierTypeData {

            switch self {

            case .delegation:
                return ApproachModifierTypeData(
                    summary: "LOC_DIPLO_MODIFIER_DELEGATION",
                    initialValue: 3,
                    reductionTurns: -1,
                    reductionValue: 0
                )

            case .declaredFriend:
                return ApproachModifierTypeData(
                    summary: "LOC_DIPLO_MODIFIER_DECLARED_FRIEND",
                    initialValue: -9,
                    reductionTurns: 10,
                    reductionValue: -1
                )
            }
        }
    }

    class DiplomaticAIPlayerApproachItem {

        let type: ApproachModifierType
        var remainingTurn: Int
        var value: Int
        var expiredValue: Bool

        init (type: ApproachModifierType) {

            self.type = type
            self.value = type.initialValue()
            self.remainingTurn = type.reductionTurns()
            self.expiredValue = false
        }

        func update() {

            guard self.remainingTurn != -1 else {
                return
            }

            self.value -= self.type.reductionValue()

            if self.value < 0 {
                self.expiredValue = true
            }
        }

        func expired() -> Bool {

            return self.expiredValue
        }
    }

    // MARK: constructor

    init() {

        self.items = []
        self.itemsOther = []
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.items = try container.decode([DiplomaticAIPlayerItem].self, forKey: .items)
        self.itemsOther = try container.decode([DiplomaticAIPlayersItem].self, forKey: .itemsOther)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.items, forKey: .items)
        try container.encode(self.itemsOther, forKey: .itemsOther)
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
        }

        return .neutral // needed because of coop war questions
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
            return item.warState != .none
        }

        return false
    }

    func isAtWar() -> Bool {

        for item in self.items where item.warState != .none {
            return true
        }

        return false
    }

    func atWarCount() -> Int {

        return self.items.count(where: { $0.warState != .none })
    }

    // MARK: approach methods

    func addApproach(type: ApproachModifierType, towards otherPlayer: AbstractPlayer?) {

        let approachItem = DiplomaticAIPlayerApproachItem(type: type)
        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.approachItems.append(approachItem)
        } else {
            fatalError("not gonna happen")
        }
    }

    func approachItems(towards otherPlayer: AbstractPlayer?) -> [DiplomaticAIPlayerApproachItem] {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.approachItems
        }

        fatalError("not gonna happen")
    }

    func updateApproachValue(towards otherPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.approach = value
        } else {
            fatalError("not gonna happen")
        }
    }

    func approachValue(towards otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.approach
        }

        return 50 // default
    }

    func approach(towards otherPlayer: AbstractPlayer?) -> PlayerApproachType {

        let value = self.approachValue(towards: otherPlayer)
        return PlayerApproachType.from(level: value)
    }

    // MARK: war state methods

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
        // return .stalemate
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

        // return .neutral
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

    // MARK: war methods

    func declaredWar(towards otherPlayer: AbstractPlayer?, in turn: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.declatationOfWar.activate(in: turn)
            item.peaceTreaty.abandon() // just in case
            item.warState = .offensive
        } else {
            fatalError("not gonna happen")
        }

        self.updateApproachValue(towards: otherPlayer, to: 0)
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

    func isOpenBorderAgreementActive(by otherPlayer: AbstractPlayer?) -> Bool {

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

    func establishPeaceTreaty(with otherPlayer: AbstractPlayer?, in turn: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.peaceTreaty.activate(in: turn)
            item.declatationOfWar.abandon()
            item.warState = .none
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

        // return false
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

        // return .none
        fatalError("not gonna happen")
    }

    // MARK: war damage level

    func warDamageLevel(of otherPlayer: AbstractPlayer?) -> WarDamageLevelType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.warDamageLevel
        }

        fatalError("not gonna happen")
    }

    func updateWarDamageLevel(of otherPlayer: AbstractPlayer?, to value: WarDamageLevelType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warDamageLevel = value
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: war projection

    func warProjection(against otherPlayer: AbstractPlayer?) -> WarProjectionType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.warProjection
        }

        fatalError("not gonna happen")
    }

    func updateWarProjection(of otherPlayer: AbstractPlayer?, to value: WarProjectionType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warProjection = value
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateLastWarProjection(of otherPlayer: AbstractPlayer?, to value: WarProjectionType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.lastWarProjection = value
        } else {
            fatalError("not gonna happen")
        }
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

        // return .none
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

    // MARK: last meeting 

    func turnOfLastMeeting(with otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.turnOfLastMeeting
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: counters

    // war counter

    func turnsAtWar(with otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.turnsAtWar
        } else {
            fatalError("not gonna happen")
        }
    }

    func changeTurnsAtWar(with otherPlayer: AbstractPlayer?, by delta: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.turnsAtWar += delta
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateTurnsAtWar(with otherPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.turnsAtWar = value
        } else {
            fatalError("not gonna happen")
        }
    }

    // trade value

    func recentTradeValue(with otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.recentTradeValue
        } else {
            fatalError("not gonna happen")
        }
    }

    func changeRecentTradeValue(with otherPlayer: AbstractPlayer?, by delta: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.recentTradeValue += delta
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateRecentTradeValue(with otherPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.recentTradeValue = value
        } else {
            fatalError("not gonna happen")
        }
    }

    // coop wars

    /// does this player promised any coop war against otherPlayer
    ///
    /// - Parameters
    ///     - player: player we have an agreement or not
    ///     - otherPlayer: player the agreement is against
    ///
    func coopWarAcceptedState(of player: AbstractPlayer?, towards otherPlayer: AbstractPlayer?) -> CoopWarState {

        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get other leader")
        }

        if let item = self.items.first(where: { $0.leader == player?.leader }) {

            if let agreement = item.coopAgreements.agreement(against: otherLeader) {
                return agreement.value
            }
        } else {
            fatalError("not gonna happen")
        }

        // no agreement found
        return .none
    }

    /// when does this player promised any coop war against otherPlayer?
    ///  counted in turn increments
    ///
    /// - Parameters
    ///     - player: player we have an agreement or not
    ///     - otherPlayer: player the agreement is against
    ///
    func coopWarCounter(of player: AbstractPlayer?, towards otherPlayer: AbstractPlayer?) -> Int {

        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get other leader")
        }

        if let item = self.items.first(where: { $0.leader == player?.leader }) {

            if let agreement = item.coopAgreements.agreement(against: otherLeader) {
                return agreement.counter
            }
        } else {
            fatalError("not gonna happen")
        }

        // no agreement found
        return -1
    }

    func updateCoopWarAcceptedState(of player: AbstractPlayer?, towards otherPlayer: AbstractPlayer?, to state: CoopWarState) {

        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get other leader")
        }

        if let item = self.items.first(where: { $0.leader == player?.leader }) {

            if let agreement = item.coopAgreements.agreement(against: otherLeader) {
                agreement.value = state
            } else {
                item.coopAgreements.add(agreement: DiplomaticPlayerArray<CoopWarState>.DiplomaticPlayerArrayItem<CoopWarState>(between: otherLeader, value: state))
            }
        } else {
            fatalError("not gonna happen")
        }
    }

    public func hasEmbassy(with otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.hasEmbassyValue
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: treaty

    func peaceTreatyWillingToOffer(to otherPlayer: AbstractPlayer?) -> PeaceTreatyType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.peaceTreatyWillingToOffer
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateTreatyWillingToOffer(with otherPlayer: AbstractPlayer?, to treatyWillingToOffer: PeaceTreatyType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.peaceTreatyWillingToOffer = treatyWillingToOffer
        } else {
            fatalError("not gonna happen")
        }
    }

    func peaceTreatyWillingToAccept(by otherPlayer: AbstractPlayer?) -> PeaceTreatyType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.peaceTreatyWillingToAccept
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateTreatyWillingToAccept(with otherPlayer: AbstractPlayer?, to treatyWillingToAccept: PeaceTreatyType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.peaceTreatyWillingToAccept = treatyWillingToAccept
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: locked into war counter

    func numTurnsLockedIntoWar(with otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.numTurnsLockedIntoWar
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateNumTurnsLockedIntoWar(with otherPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.numTurnsLockedIntoWar = value
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: - --

    func warValueLost(with otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.warValueLost
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateWarValueLost(with otherPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warValueLost = value
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: - --

    func warWeariness(with otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.warWeariness
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateWarWeariness(with otherPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warWeariness = value
        } else {
            fatalError("not gonna happen")
        }
    }

    func changeWarWeariness(with otherPlayer: AbstractPlayer?, by value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warWeariness = max(item.warWeariness + value, 0)
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: - --

    func otherPlayerWarValueLost(with fromPlayer: AbstractPlayer?, towards toPlayer: AbstractPlayer?) -> Int {

        if let item = self.itemsOther.first(where: { $0.fromLeader == fromPlayer?.leader && $0.toLeader == toPlayer?.leader }) {
            return item.warValueLost
        } else {
            return 0
        }
    }

    func updateOtherPlayerWarValueLost(with fromPlayer: AbstractPlayer?, towards toPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.itemsOther.first(where: { $0.fromLeader == fromPlayer?.leader && $0.toLeader == toPlayer?.leader }) {
            item.warValueLost = value
        } else {
            let newItem = DiplomaticAIPlayersItem(from: fromPlayer!.leader, to: toPlayer!.leader)
            newItem.warValueLost = value
            self.itemsOther.append(newItem)
        }
    }

    // MARK: war goal

    func warGoal(towards otherPlayer: AbstractPlayer?) -> WarGoalType {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.warGoal
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateWarGoal(towards otherPlayer: AbstractPlayer?, to warGoal: WarGoalType) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.warGoal = warGoal
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: want peace counter

    func wantPeaceCounter(with otherPlayer: AbstractPlayer?) -> Int {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.wantPeaceCounter
        } else {
            fatalError("not gonna happen")
        }
    }

    func updateWantPeaceCounter(with otherPlayer: AbstractPlayer?, to value: Int) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.wantPeaceCounter = value
        } else {
            fatalError("not gonna happen")
        }
    }

    // MARK: mustering for attack

    func isMusteringForAttack(against otherPlayer: AbstractPlayer?) -> Bool {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            return item.musteringForAttack
        } else {
            fatalError("not gonna happen")
        }
    }

    /// Sets whether or not we're building up for an attack on ePlayer
    func updateMusteringForAttack(against otherPlayer: AbstractPlayer?, to value: Bool) {

        if let item = self.items.first(where: { $0.leader == otherPlayer?.leader }) {
            item.musteringForAttack = value
        } else {
            fatalError("not gonna happen")
        }
    }
}
