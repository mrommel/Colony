//
//  DiplomacyAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 24.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation


enum PlayerWarGoalType {

    case none
    case prepare
}

public class DiplomaticAI {

    var player: AbstractPlayer?

    private var playerDict: DiplomaticPlayerDict
    internal var stateOfAllWars: PlayerStateAllWars

    // MARK: constructors

    init(player: AbstractPlayer?) {

        self.player = player

        self.playerDict = DiplomaticPlayerDict()

        self.stateOfAllWars = .neutral
    }

    func turn(in gameModel: GameModel?) {

        self.updateMilitaryStrengths(in: gameModel)
        self.updateEconomicStrengths(in: gameModel)
        self.updateMilitaryThreats(in: gameModel)
        self.updateProximities(in: gameModel)
        self.updateWarStates(in: gameModel)
        self.updateTargetValue(in: gameModel) // DoUpdatePlayerTargetValues

        self.updateOpinions(in: gameModel)
        self.updateApproaches(in: gameModel)
        
        self.doUpdateExpansionAggressivePostures(in: gameModel)
        self.doUpdatePlotBuyingAggressivePosture(in: gameModel)
    }

    func doFirstContact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        self.playerDict.initContact(with: otherPlayer, in: gameModel.turnsElapsed)
        self.updateMilitaryStrength(of: otherPlayer, in: gameModel)

        // Humans don't say hi to ai player automatically
        if !player.isHuman() {

            // Should fire off a diplo message, when we meet a human
            if otherPlayer.isHuman() {

                // Put in the list of people to greet human when the human turn comes up.
                //gameModel.add(message: FirstContactMessage(with: player))
            }
        }
    }

    func doDeclarationOfFriendship(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        self.playerDict.establishDeclarationOfFriendship(with: otherPlayer)

        // inform human player only, if he is not involved
        if !player.isHuman() && !otherPlayer.isHuman() {

            if let humanPlayer = gameModel.players.first(where: { $0.isHuman() }) {

                let metA = humanPlayer.hasMet(with: player)
                let metB = humanPlayer.hasMet(with: otherPlayer)

                if metA || metB {

                    let playerAName = metA ? player.leader.name() : "An Unmet Player"
                    let playerBName = metB ? otherPlayer.leader.name() : "An Unmet Player"

                    let text = "\(playerAName) and \(playerBName) have made a public Trade Alliance, forging a strong bond between the two empires."
                    //gameModel.add(message: DeclarationOfFriendshipMessage(text: text))
                    self.player?.notifications()?.add(type: .diplomaticDeclaration, message: text, summary: "declaration of friendship", at: HexPoint.zero)
                }
            }
        }
    }

    func isDeclarationOfFriendshipActive(by otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isDeclarationOfFriendshipActive(by: otherPlayer)
    }

    func doDenounce(player otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        self.playerDict.denounce(player: otherPlayer)

        // inform human player only, if he is not involved
        if !player.isHuman() && !otherPlayer.isHuman() {

            if let humanPlayer = gameModel.players.first(where: { $0.isHuman() }) {

                let metA = humanPlayer.hasMet(with: player)
                let metB = humanPlayer.hasMet(with: otherPlayer)

                if metA || metB {

                    let playerAName = metA ? player.leader.name() : "An Unmet Player"
                    let playerBName = metB ? otherPlayer.leader.name() : "An Unmet Player"

                    let text = "\(playerAName) has denounced \(playerBName)."
                    //gameModel.add(message: DenouncementMessage(text: text))
                    self.player?.notifications()?.add(type: .diplomaticDeclaration, message: text, summary: "Denounced", at: HexPoint.zero)
                }
            }
        }
    }

    func hasDenounced(player otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.hasDenounced(player: otherPlayer)
    }

    // MARK: pacts - defensive pacts

    func doCancelDefensivePacts() {

        self.playerDict.cancelAllDefensivePacts()
    }

    func allPlayersWithDefensivePacts() -> [AbstractPlayer?] {

        return self.playerDict.allPlayersWithDefensivePacts()
    }

    func activateDefensivePacts(to otherPlayer: AbstractPlayer?) {

        for friendPlayer in self.allPlayersWithDefensivePacts() {

            friendPlayer?.diplomacyAI?.doDeclareWarFromDefensivePact(to: otherPlayer)
        }
    }

    func doDeclareWarFromDefensivePact(to otherPlayer: AbstractPlayer?) {

        // Only do it if we are not already at war.
        if self.isAtWar(with: otherPlayer) {
            return
        }

        // Cancel Trade Deals
        self.doCancelDeals(with: otherPlayer)

        self.playerDict.updateApproach(towards: otherPlayer, to: .war)
        self.playerDict.updateWarState(towards: otherPlayer, to: .defensive)

        otherPlayer?.diplomacyAI?.playerDict.updateApproach(towards: self.player, to: .war)
        otherPlayer?.diplomacyAI?.playerDict.updateWarState(towards: self.player, to: .defensive)
    }

    func doDefensivePact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        self.playerDict.establishDefensivePact(with: otherPlayer, in: gameModel.turnsElapsed)
    }

    func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isDefensivePactActive(with: otherPlayer)
    }
    
    // MARK: open borders
    
    func isOpenBorderAgreementActive(by otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isOpenBorderAgreementpActive(by: otherPlayer)
    }

    // MARK: alliances

    func isAllianceActive(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isAllianceActive(with: otherPlayer)
    }

    // MARK: war

    func doDeclareWar(to otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        // Only do it if we are not already at war.
        if self.isAtWar(with: otherPlayer) {
            return
        }

        // Since we declared war, all of OUR Defensive Pacts are nullified
        self.doCancelDefensivePacts()

        // Cancel Trade Deals
        self.doCancelDeals(with: otherPlayer)

        // Update the ATTACKED players' Diplo AI
        otherPlayer.diplomacyAI?.doHaveBeenDeclaredWar(by: self.player)

        // If we've made a peace treaty before, this is bad news
        if self.isPeaceTreatyActive(with: otherPlayer) {
            //self.hasBrokenPeaceTreaty(to: true)
            // FIXME: => update counter of everyone who knows us
        }

        // Update what every Major Civ sees
        // FIXME: let everyone know, we have attacked

        self.playerDict.declaredWar(towards: otherPlayer, in: gameModel.turnsElapsed)

        // inform player that some declared war
        if otherPlayer.isHuman() {
            //gameModel.add(message: DeclarationOfWarMessage(by: player))
            
            // TXT_KEY_MISC_DECLARED_WAR_ON_YOU
            self.player?.notifications()?.add(type: .war, message: "\(player.leader.name()) has declared war on you!", summary: "declaration of war", at: HexPoint.zero)
        }
    }

    func doHaveBeenDeclaredWar(by otherPlayer: AbstractPlayer?) {

        // Auto War for Defensive Pacts of other player
        self.activateDefensivePacts(to: otherPlayer)

        self.playerDict.updateApproach(towards: otherPlayer, to: .war)
        self.playerDict.updateWarState(towards: otherPlayer, to: .offensive)
    }

    func doCancelDeals(with otherPlayer: AbstractPlayer?) {

        self.playerDict.cancelDeals(with: otherPlayer)
        otherPlayer?.diplomacyAI?.playerDict.cancelDeals(with: self.player)
    }

    func isPeaceTreatyActive(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isPeaceTreatyActive(by: otherPlayer)
    }

    func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool {

        if otherPlayer == nil {
            return false
        }
        
        return self.playerDict.isAtWar(with: player)
    }

    func isAtWar() -> Bool {

        return self.playerDict.isAtWar()
    }

    func atWarCount() -> Int {

        self.playerDict.atWarCount()
    }

    func updateWarState(towards otherPlayer: AbstractPlayer?, to warState: PlayerWarStateType) {

        self.playerDict.updateWarState(towards: otherPlayer, to: warState)
    }

    func warState(towards otherPlayer: AbstractPlayer?) -> PlayerWarStateType {

        return self.playerDict.warState(for: otherPlayer)
    }

    // MARK: private methods

    private func updateMilitaryStrengths(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != player.leader && player.hasMet(with: otherPlayer) {

                self.updateMilitaryStrength(of: otherPlayer, in: gameModel)
            }
        }
    }

    private func updateMilitaryStrength(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        let ownMilitaryStrength = player.militaryMight(in: gameModel) + 30
        let otherMilitaryStrength = otherPlayer.militaryMight(in: gameModel) + 30
        let militaryRatio = otherMilitaryStrength * 100 / ownMilitaryStrength

        if militaryRatio >= 250 {
            self.playerDict.updateMilitaryStrengthComparedToUs(of: otherPlayer, is: .immense)
        } else if militaryRatio >= 165 {
            self.playerDict.updateMilitaryStrengthComparedToUs(of: otherPlayer, is: .powerful)
        } else if militaryRatio >= 115 {
            self.playerDict.updateMilitaryStrengthComparedToUs(of: otherPlayer, is: .strong)
        } else if militaryRatio >= 85 {
            self.playerDict.updateMilitaryStrengthComparedToUs(of: otherPlayer, is: .average)
        } else if militaryRatio >= 60 {
            self.playerDict.updateMilitaryStrengthComparedToUs(of: otherPlayer, is: .poor)
        } else if militaryRatio >= 40 {
            self.playerDict.updateMilitaryStrengthComparedToUs(of: otherPlayer, is: .weak)
        } else {
            self.playerDict.updateMilitaryStrengthComparedToUs(of: otherPlayer, is: .pathetic)
        }
    }

    private func updateApproaches(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != self.player?.leader && player.hasMet(with: otherPlayer) {

                self.updateApproach(towards: otherPlayer)
            }
        }
    }

    private func updateApproach(towards otherPlayer: AbstractPlayer?) {

        guard let otherPlayerDiplomacyAI = otherPlayer?.diplomacyAI else {
            fatalError("cant get diplomacy of other player")
        }

        let weights: DiplomaticApproachWeights = DiplomaticApproachWeights()

        ////////////////////////////////////
        // NEUTRAL DEFAULT WEIGHT
        ////////////////////////////////////

        weights.set(weight: 3, for: .neutrally) // APPROACH_NEUTRAL_DEFAULT

        ////////////////////////////////////
        // CURRENT APPROACH BIASES
        ////////////////////////////////////

        var oldApproach = self.approach(towards: otherPlayer)
        if oldApproach == .none {
            oldApproach = .neutrally
        }

        // Bias for our current Approach.  This should prevent it from jumping around from turn-to-turn as much
        weights.add(weight: 3, for: oldApproach) // APPROACH_BIAS_FOR_CURRENT

        // If our previous Approach was deceptive, this gives us a bonus for war
        if oldApproach == .deceptive {
            weights.add(weight: 2, for: .war) // APPROACH_WAR_CURRENTLY_DECEPTIVE
        }

        // If our previous Approach was Hostile, boost the strength (so we're unlikely to switch out of it)
        if oldApproach == .hostile {
            weights.add(weight: 5, for: .hostile) // APPROACH_HOSTILE_CURRENTLY_HOSTILE
        }

        // Wanted war last turn bias: war must be calm or better to apply
        let warState = self.warState(towards: otherPlayer)
        if warState > .stalemate {
            // If we're planning a war then give it a bias so that we don't get away from it too easily
            if oldApproach == .war {
                weights.add(weight: 3, for: .war) // APPROACH_WAR_CURRENTLY_WAR
            }
        }

        // Conquest bias: must be a stalemate or better to apply (or not at war yet)
        if (warState == .none || warState > .defensive)
        {
            if self.isGoingForWorldConquest() {
                weights.add(weight: 3, for: .war) // APPROACH_WAR_CONQUEST_GRAND_STRATEGY
            }
        }

        ////////////////////////////////////
        // PERSONALITY
        ////////////////////////////////////

        for approach in PlayerApproachType.all {

            if let personalApproachBias = self.player?.valueOfStrategyAndPersonalityApproach(of: approach) {
                weights.add(weight: Double(personalApproachBias), for: approach)
            }
        }

        ////////////////////////////////////
        // OPINION
        ////////////////////////////////////

        let opinion = self.opinion(of: otherPlayer)
        switch opinion {
        case .none:
            // NOOP
            break
        case .ally:
            weights.add(weight: 10, for: .friendly) // APPROACH_OPINION_ALLY_FRIENDLY
        case .friend:
            weights.add(weight: -5, for: .hostile) // APPROACH_OPINION_FRIEND_HOSTILE
            weights.add(weight: 10, for: .friendly) // APPROACH_OPINION_FRIEND_FRIENDLY
        case .favorable:
            weights.add(weight: -5, for: .hostile) // APPROACH_OPINION_FAVORABLE_HOSTILE
            weights.add(weight: 0, for: .deceptive) // APPROACH_OPINION_FAVORABLE_DECEPTIVE
            weights.add(weight: 4, for: .friendly) // APPROACH_OPINION_FAVORABLE_FRIENDLY
        case .neutral:
            weights.add(weight: 0, for: .deceptive) // APPROACH_OPINION_NEUTRAL_DECEPTIVE
            weights.add(weight: 2, for: .friendly) // APPROACH_OPINION_NEUTRAL_FRIENDLY
        case .competitor:
            weights.add(weight: 4, for: .war) // APPROACH_OPINION_COMPETITOR_WAR
            weights.add(weight: 4, for: .hostile) // APPROACH_OPINION_COMPETITOR_HOSTILE
            weights.add(weight: 2, for: .deceptive) // APPROACH_OPINION_COMPETITOR_DECEPTIVE
            weights.add(weight: 2, for: .guarded) // APPROACH_OPINION_COMPETITOR_GUARDED
        case .enemy:
            weights.add(weight: 8, for: .war) // APPROACH_OPINION_ENEMY_WAR
            weights.add(weight: 4, for: .hostile) // APPROACH_OPINION_ENEMY_HOSTILE
            weights.add(weight: 1, for: .deceptive) // APPROACH_OPINION_ENEMY_DECEPTIVE
            weights.add(weight: 4, for: .guarded) // APPROACH_OPINION_ENEMY_GUARDED
        case .unforgivable:
            weights.add(weight: 10, for: .war) // APPROACH_OPINION_UNFORGIVABLE_WAR
            weights.add(weight: 4, for: .hostile) // APPROACH_OPINION_UNFORGIVABLE_HOSTILE
            weights.add(weight: 0, for: .deceptive) // APPROACH_OPINION_UNFORGIVABLE_DECEPTIVE
            weights.add(weight: 4, for: .guarded) // APPROACH_OPINION_UNFORGIVABLE_GUARDED
        }

        ////////////////////////////////////
        // DECLARATION OF FRIENDSHIP
        ////////////////////////////////////

        if self.isDeclarationOfFriendshipActive(by: otherPlayer) {

            weights.add(weight: 3, for: .deceptive) // APPROACH_DECEPTIVE_WORKING_WITH_PLAYER
            weights.add(weight: 15, for: .friendly) // APPROACH_FRIENDLY_WORKING_WITH_PLAYER
            weights.add(weight: -100, for: .hostile) // APPROACH_HOSTILE_WORKING_WITH_PLAYER
            weights.add(weight: -100, for: .guarded) // APPROACH_GUARDED_WORKING_WITH_PLAYER
        }

        ////////////////////////////////////
        // DENOUNCE
        ////////////////////////////////////

        if self.hasDenounced(player: otherPlayer) {

            weights.add(weight: 7, for: .war) // APPROACH_WAR_DENOUNCED
            weights.add(weight: 10, for: .hostile) // APPROACH_HOSTILE_DENOUNCED
            weights.add(weight: 5, for: .guarded) // APPROACH_GUARDED_DENOUNCED
            weights.add(weight: -100, for: .friendly) // APPROACH_FRIENDLY_DENOUNCED
            weights.add(weight: -100, for: .deceptive) // APPROACH_DECEPTIVE_DENOUNCED
        }

        if otherPlayerDiplomacyAI.hasDenounced(player: self.player) {

            weights.add(weight: 7, for: .war) // APPROACH_WAR_DENOUNCED
            weights.add(weight: 10, for: .hostile) // APPROACH_HOSTILE_DENOUNCED
            weights.add(weight: 5, for: .guarded) // APPROACH_GUARDED_DENOUNCED
            weights.add(weight: -100, for: .friendly) // APPROACH_FRIENDLY_DENOUNCED
            weights.add(weight: -100, for: .deceptive) // APPROACH_DECEPTIVE_DENOUNCED
        }

        ////////////////////////////////////
        // They made a demand
        ////////////////////////////////////

        // FIXME

        ////////////////////////////////////
        // BROKEN PROMISES ;_;
        ////////////////////////////////////

        // FIXME

        ////////////////////////////////////
        // MILITARY THREAT
        ////////////////////////////////////

        switch self.militaryThreat(of: otherPlayer) {

        case .critical:
            weights.add(weight: 0, for: .deceptive) // APPROACH_DECEPTIVE_MILITARY_THREAT_CRITICAL
            weights.add(weight: 4, for: .guarded) // APPROACH_GUARDED_MILITARY_THREAT_CRITICAL
            weights.add(weight: 4, for: .afraid) // APPROACH_AFRAID_MILITARY_THREAT_CRITICAL
            weights.add(weight: 0, for: .friendly) // APPROACH_FRIENDLY_MILITARY_THREAT_CRITICAL
        case .severe:
            weights.add(weight: 0, for: .deceptive) // APPROACH_DECEPTIVE_MILITARY_THREAT_SEVERE
            weights.add(weight: 3, for: .guarded) // APPROACH_GUARDED_MILITARY_THREAT_SEVERE
            weights.add(weight: 2, for: .afraid) // APPROACH_AFRAID_MILITARY_THREAT_SEVER
            weights.add(weight: 0, for: .friendly) // APPROACH_FRIENDLY_MILITARY_THREAT_SEVERE
        case .major:
            weights.add(weight: 0, for: .deceptive) // APPROACH_DECEPTIVE_MILITARY_THREAT_MAJOR
            weights.add(weight: 2, for: .guarded) // APPROACH_GUARDED_MILITARY_THREAT_MAJOR
            weights.add(weight: 1, for: .afraid) // APPROACH_AFRAID_MILITARY_THREAT_MAJOR
            weights.add(weight: 0, for: .friendly) // APPROACH_FRIENDLY_MILITARY_THREAT_MAJOR
        case .minor:
            weights.add(weight: 0, for: .deceptive) // APPROACH_DECEPTIVE_MILITARY_THREAT_MINOR
            weights.add(weight: 0, for: .guarded) // APPROACH_GUARDED_MILITARY_THREAT_MINOR
            weights.add(weight: 1, for: .afraid) // APPROACH_AFRAID_MILITARY_THREAT_MINOR
            weights.add(weight: 0, for: .friendly) // APPROACH_FRIENDLY_MILITARY_THREAT_MINOR
        case .none:
            weights.add(weight: 2, for: .hostile) // APPROACH_HOSTILE_MILITARY_THREAT_NONE
        }

        ////////////////////////////////////
        // DISTANCE - the farther away a player is the less likely we are to want to attack them!
        ////////////////////////////////////

        // Factor in distance
        switch self.proximity(to: otherPlayer) {

        case .none:
            // NOOP
            break

        case .neighbors:
            let warWeight = weights.weight(of: .war) * 115 / 100 // APPROACH_WAR_PROXIMITY_NEIGHBORS
            weights.set(weight: warWeight, for: .war)
        case .close:
            let warWeight = weights.weight(of: .war) * 100 / 100 // APPROACH_WAR_PROXIMITY_CLOSE
            weights.set(weight: warWeight, for: .war)
        case .far:
            let warWeight = weights.weight(of: .war) * 60 / 100 // APPROACH_WAR_PROXIMITY_FAR
            weights.set(weight: warWeight, for: .war)
        case .distant:
            let warWeight = weights.weight(of: .war) * 50 / 100 // APPROACH_WAR_PROXIMITY_DISTANT
            weights.set(weight: warWeight, for: .war)
        }

        ////////////////////////////////////
        // PEACE TREATY - have we made peace with this player before?  If so, reduce war weight
        ////////////////////////////////////

        // FIXME

        ////////////////////////////////////
        // DUEL - If there's only 2 players in this game, no friendly or deceptive
        ////////////////////////////////////

        // FIXME

        ////////////////////////////////////
        // COOP WAR - agreed to go to war with someone?
        ////////////////////////////////////

        // FIXME

        ////////////////////////////////////
        // RANDOM FACTOR
        ////////////////////////////////////

        for approach in PlayerApproachType.all {

            let approachWeight = weights.weight(of: approach) * 15

            // only add random value when positiv
            if approachWeight > 0 {
                let delta = Double.random(minimum: -approachWeight, maximum: approachWeight)
                weights.add(weight: delta / 100.0, for: approach)
            }
        }

        ////////////////////////////////////
        // CAN WE DECLARE WAR?
        ////////////////////////////////////

        // FIXME

        ////////////////////////////////////
        // On the same team?
        ////////////////////////////////////

        // FIXME

        ////////////////////////////////////
        // MODIFY WAR BASED ON HUMAN DIFFICULTY LEVEL
        ////////////////////////////////////

        // FIXME

        // get best approach
        weights.sort()
        guard let bestApproach = weights.chooseBest() else {
            fatalError("cant get best approach")
        }

        if bestApproach == .war {

            let currentWarFace = self.playerDict.warFace(for: otherPlayer)

            // If we haven't set WarFace on a previous turn, figure out what it should be
            if currentWarFace == .none {

                // Use index of 1 since we already know element 0 is war; that will give us the most reasonable approach
                let secondBestApproach = weights.chooseSecondBest()

                if secondBestApproach == .hostile {
                    self.playerDict.updateWarFace(towards: otherPlayer, to: .hostile)
                } else if secondBestApproach == .deceptive || secondBestApproach == .afraid || secondBestApproach == .friendly {

                    // FIXME
                    // Denounced them?  If so, let's not be too friendly
                    self.playerDict.updateWarFace(towards: otherPlayer, to: .friendly)
                } else {
                    self.playerDict.updateWarFace(towards: otherPlayer, to: .neutral)
                }
            }

        } else {

            self.playerDict.updateWarFace(towards: otherPlayer, to: .neutral)
        }

        self.playerDict.updateApproach(towards: otherPlayer, to: bestApproach)
    }

    func isGoingForWorldConquest() -> Bool {

        guard let activeStrategy = self.player?.grandStrategyAI?.activeStrategy else {
            fatalError("cant get active strategy")
        }

        return activeStrategy == .conquest
    }

    func approach(towards player: AbstractPlayer?) -> PlayerApproachType {

        return self.playerDict.approach(towards: player)
    }

    func approachWithoutTrueFeelings(towards player: AbstractPlayer) -> PlayerApproachType {

        let trueApproach = self.approach(towards: player)
        var approachWithoutTrueFeelings = trueApproach

        // Deceptive => Friendly
        if trueApproach == .deceptive {
            approachWithoutTrueFeelings = .friendly
        } else if trueApproach == .war {

            let warFace = self.warFace(for: player)

            switch warFace {

            case .none:
                // NOOP
                break

            case .hostile:
                return .hostile

            case .friendly:
                return .friendly

            case .neutral:
                return .neutrally
            }
        }

        return approachWithoutTrueFeelings
    }

    func warFace(for player: AbstractPlayer) -> PlayerWarFaceType {

        return self.playerDict.warFace(for: player)
    }

    private func updateEconomicStrengths(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != player.leader && player.hasMet(with: otherPlayer) {

                self.updateEconomicStrength(of: otherPlayer, in: gameModel)
            }
        }
    }

    private func updateEconomicStrength(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        let ownEconomicStrength = player.economicMight(in: gameModel)
        let otherEconomicStrength = otherPlayer.economicMight(in: gameModel)
        var economicRatio = otherEconomicStrength * 100 / ownEconomicStrength

        if ownEconomicStrength < 0 {
            economicRatio = 500
        }

        // Now do the final assessment
        if economicRatio >= 250 {
            self.playerDict.updateEconomicStrengthComparedToUs(of: otherPlayer, is: .immense)
        } else if economicRatio >= 153 {
            self.playerDict.updateEconomicStrengthComparedToUs(of: otherPlayer, is: .powerful)
        } else if economicRatio >= 120 {
            self.playerDict.updateEconomicStrengthComparedToUs(of: otherPlayer, is: .strong)
        } else if economicRatio >= 83 {
            self.playerDict.updateEconomicStrengthComparedToUs(of: otherPlayer, is: .average)
        } else if economicRatio >= 65 {
            self.playerDict.updateEconomicStrengthComparedToUs(of: otherPlayer, is: .poor)
        } else if economicRatio >= 40 {
            self.playerDict.updateEconomicStrengthComparedToUs(of: otherPlayer, is: .weak)
        } else {
            self.playerDict.updateEconomicStrengthComparedToUs(of: otherPlayer, is: .pathetic)
        }
    }

    private func updateOpinions(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        for player in gameModel.players {

            updateOpinion(of: player, in: gameModel)
        }
    }

    private func updateOpinion(of otherPlayer: AbstractPlayer, in gameModel: GameModel?) {

        if self.isAllianceActive(with: otherPlayer) {
            self.playerDict.updateOpinion(towards: otherPlayer, to: .ally)
            return
        }


    }

    private func updateWarStates(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        // vars
        var myLocalMilitaryStrength = 0
        var enemyInHisLandsMilitaryStrength = 0

        var myForeignMilitaryStrength = 0
        var enemyInMyLandsMilitaryStrength = 0

        var myPercentLocal = 0
        var enemyPercentInHisLands = 0

        // Reset overall war state
        var stateAllWars = 0 // Used to assess overall war state in this function
        self.stateOfAllWars = .neutral
        var warState: PlayerWarStateType = .none

        // Loop through all (known) Players
        for otherPlayer in gameModel.players {

            if player.leader != otherPlayer.leader && player.hasMet(with: otherPlayer) {

                // War?
                if self.isAtWar(with: otherPlayer) {

                    myLocalMilitaryStrength = 0
                    enemyInHisLandsMilitaryStrength = 0

                    myForeignMilitaryStrength = 0
                    enemyInMyLandsMilitaryStrength = 0

                    // Loop through our units
                    for unitRef in gameModel.units(of: player) {

                        if let unit = unitRef {

                            // On our home front
                            if gameModel.homeFront(at: unit.location, for: player) {
                                myLocalMilitaryStrength += unit.power()
                            }

                            // Enemy's home front
                            if gameModel.homeFront(at: unit.location, for: otherPlayer) {
                                myForeignMilitaryStrength += unit.power()
                            }
                        }
                    }

                    // Loop through our Enemy's units
                    for unitRef in gameModel.units(of: otherPlayer) {

                        if let unit = unitRef {

                            // On our home front
                            if gameModel.homeFront(at: unit.location, for: player) {
                                enemyInMyLandsMilitaryStrength += unit.power()
                            }
                            // Enemy's home front
                            if gameModel.homeFront(at: unit.location, for: otherPlayer) {
                                enemyInHisLandsMilitaryStrength += unit.power()
                            }
                        }
                    }

                    // Loop through our Cities
                    for cityRef in gameModel.cities(of: player) {

                        if let city = cityRef {
                            let percentHealthLeft = (25 /*MAX_CITY_HIT_POINTS*/ - city.damage()) * 100 / 25 /*MAX_CITY_HIT_POINTS*/
                            myLocalMilitaryStrength += city.power() * percentHealthLeft / 100 / 100
                        }
                    }

                    // Loop through our Enemy's Cities
                    for cityRef in gameModel.cities(of: otherPlayer) {

                        if let city = cityRef {
                            let percentHealthLeft = (25 /*MAX_CITY_HIT_POINTS*/ - city.damage()) * 100 / 25 /*MAX_CITY_HIT_POINTS*/
                            enemyInHisLandsMilitaryStrength += city.power() * percentHealthLeft / 100 / 100
                        }
                    }

                    // Percentage of our forces in our locales & each other's locales

                    // No Units!
                    if myLocalMilitaryStrength + myForeignMilitaryStrength == 0 {
                        myPercentLocal = 100
                    } else {
                        myPercentLocal = myLocalMilitaryStrength * 100 / (myLocalMilitaryStrength + myForeignMilitaryStrength)
                    }

                    // No Units!
                    if enemyInHisLandsMilitaryStrength + enemyInMyLandsMilitaryStrength == 0 {
                        enemyPercentInHisLands = 100
                    } else {
                        enemyPercentInHisLands = enemyInHisLandsMilitaryStrength * 100 / (enemyInHisLandsMilitaryStrength + enemyInMyLandsMilitaryStrength)
                    }

                    // Ratio of Me VS Him in our two locales
                    if myLocalMilitaryStrength == 0 {
                        myLocalMilitaryStrength = 1
                    }
                    let localRatio = myLocalMilitaryStrength * 100 / (myLocalMilitaryStrength + enemyInMyLandsMilitaryStrength)

                    if enemyInHisLandsMilitaryStrength == 0 {
                        enemyInHisLandsMilitaryStrength = 1
                    }
                    let foreignRatio = myForeignMilitaryStrength * 100 / (myForeignMilitaryStrength + enemyInHisLandsMilitaryStrength)

                    // Calm: Not much happening on either front
                    if foreignRatio < 25 /*WAR_STATE_CALM_THRESHOLD_FOREIGN_FORCES*/ && localRatio > 100 - 25 /*WAR_STATE_CALM_THRESHOLD_FOREIGN_FORCES*/ {
                        warState = .calm
                    } else { // SOMETHING is happening

                        var warStateValue = 0

                        warStateValue += localRatio // Will be between 0 and 100.  Anything less than 75 is bad news though!  We want a very high percentage in our own lands.
                        warStateValue += foreignRatio // Will be between 0 and 100.  Will vary wildly though, depending on the status of an offensive.  A number of 50 is very good.

                        warStateValue /= 2

                        // Some Example WarStateValues:
                        // Local        Foreign    WarStateValue
                        // 100%        70%            85
                        // 100%        40%            70
                        // 80%         30% :        55
                        // 100%         0% :            50
                        // 60%         40% :        50
                        // 60%         10% :        35
                        // 40%         0% :            20

                        if warStateValue >= 75 /*WAR_STATE_THRESHOLD_NEARLY_WON()*/ {
                            warState = .nearlyWon
                        } else if warStateValue >= 57 /*WAR_STATE_THRESHOLD_OFFENSIVE*/ {
                            warState = .offensive
                        }
                        else if warStateValue >= 42 /*WAR_STATE_THRESHOLD_STALEMATE*/ {
                            warState = .stalemate
                        }
                        else if warStateValue >= 25 /*WAR_STATE_THRESHOLD_DEFENSIVE*/ {
                            warState = .defensive
                        } else {
                            warState = .nearlyDefeated
                        }
                    }

                    //////////////////////////////////////////////////////////
                    // WAR STATE MODIFICATIONS - We crunched the numbers above, but are there any special cases to consider?
                    //////////////////////////////////////////////////////////

                    // If the war is calm, but they're an easy target consider us on Offense
                    if (warState == .calm) {
                        if self.playerDict.targetValue(of: otherPlayer) >= .favorable {
                            warState = .offensive
                        }
                    }

                    // If the other guy happens to have a guy or two near us but we vastly outnumber him overall, we're not really on the defensive
                    if warState <= .defensive {
                        if myLocalMilitaryStrength >= enemyInMyLandsMilitaryStrength + enemyInMyLandsMilitaryStrength {
                            warState = .stalemate
                        }
                    }

                    // Determine what the impact of this war is on our global situation
                    if warState == .nearlyWon {
                        stateAllWars += 2
                    } else if warState == .offensive {
                        stateAllWars += 1
                    } else if warState == .defensive {
                        stateAllWars -= 1
                    } else if warState == .nearlyDefeated {
                        // If nearly defeated in any war, overall state should be defensive
                        self.stateOfAllWars = .losing
                    }
                } else {
                    warState = .none
                }

                self.playerDict.updateWarState(towards: otherPlayer, to: warState)
            }
        }
        
        // Finalize overall assessment
        if stateAllWars < 0 || self.stateOfAllWars == .losing {
            self.stateOfAllWars = .losing
        } else if stateAllWars > 0 {
            self.stateOfAllWars = .winning
        }
    }

    // MARK: ???

    private func updateTargetValue(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != self.player?.leader && player.hasMet(with: otherPlayer) {

                self.updateTargetValue(of: otherPlayer, in: gameModel)
            }
        }
    }

    // DoUpdateOnePlayerTargetValue
    /// Updates what our assessment is of all players' value as a military target
    private func updateTargetValue(of otherPlayer: AbstractPlayer, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        if !player.isAlive() {
            return
        }

        var targetIntValue: Int = 0
        var targetValue: PlayerTargetValueType = .none

        var otherPlayerMilitaryStrength = otherPlayer.militaryMight(in: gameModel)

        var myMilitaryStrength = player.militaryMight(in: gameModel)

        // Prevent divide by 0
        if myMilitaryStrength == 0 {
            myMilitaryStrength = 1
        }

        var cityDamage = 0
        var numCities = 0

        // City Defensive Strength
        for otherCityRef in gameModel.cities(of: otherPlayer) {

            if let otherCity = otherCityRef {

                var cityStrengthMod = otherCity.power()
                cityStrengthMod *= 33
                cityStrengthMod /= 100

                otherPlayerMilitaryStrength += cityStrengthMod

                cityDamage += otherCity.damage()
                numCities += 1
            }
        }

        // Depending on how damaged a player's Cities are, he can become a much more attractive target
        if numCities > 0 {
            cityDamage /= numCities
            cityDamage *= 100
            cityDamage /= 25 /* MAX_CITY_HIT_POINTS */

            // iCityDamage is now a percentage of global City damage
            cityDamage *= otherPlayerMilitaryStrength
            cityDamage /= 200 // divide by 200 instead of 100 so that if all Cities have no health it only HALVES our strength instead of taking it all the way to 0

            otherPlayerMilitaryStrength -= cityDamage
        }

        let militaryRatio = otherPlayerMilitaryStrength * 100 /*MILITARY_STRENGTH_RATIO_MULTIPLIER */ / myMilitaryStrength
        // Example: If another player has double the Military strength of us, the Ratio will be 200

        targetIntValue += militaryRatio

        // Increase target value if the player is already at war with other players
        var warCount = otherPlayer.atWarCount()

        // Reduce by 1 if WE'RE already at war with him
        if self.isAtWar(with: otherPlayer) {
            warCount -= 1
        }

        targetIntValue += (warCount * 30 /* TARGET_ALREADY_WAR_EACH_PLAYER */)

        // Factor in distance
        switch self.proximity(to: otherPlayer) {
        case .neighbors:
            targetIntValue += -10 /*TARGET_NEIGHBORS */
        case .close:
            targetIntValue += 0 /*TARGET_CLOSE */
        case .far:
            targetIntValue += 20 /* TARGET_FAR */
        case .distant:
            targetIntValue += 60 /* TARGET_DISTANT */
        case .none:
            // NOOP
            break
        }

        // Now do the final assessment
        if targetIntValue >= 200 { /* TARGET_IMPOSSIBLE_THRESHOLD*/
            targetValue = .impossible
        } else if targetIntValue >= 125 { /* TARGET_BAD_THRESHOLD*/
            targetValue = .bad
        } else if targetIntValue >= 80 { /* TARGET_AVERAGE_THRESHOLD*/
            targetValue = .average
        } else if targetIntValue >= 50 { /* TARGET_FAVORABLE_THRESHOLD*/
            targetValue = .favorable
        } else {
            targetValue = .soft
        }

        // If the player is expanding aggressively, bump things down a level
        if targetValue < .soft && self.playerDict.isRecklessExpander(of: otherPlayer) {
            targetValue.increase()
        }

        // If it's a city-state and we've been at war for a LONG time, bump things up
        if targetValue > .impossible && self.playerDict.turnsOfWar(with: otherPlayer, in: gameModel.turnsElapsed) > 50 /*TARGET_INCREASE_WAR_TURNS */ {
            targetValue.decrease()
        }

        // If the player is too far from us then we can't consider them Soft
        if targetValue == .soft {
            if self.proximity(to: otherPlayer) < .far {
                targetValue = .favorable
            }
        }

        // Set the value
        self.playerDict.updateTargetValue(of: otherPlayer, to: targetValue)
    }
    
    func targetValue(of otherPlayer: AbstractPlayer?) -> PlayerTargetValueType {
        
        return self.playerDict.targetValue(of: otherPlayer)
    }

    // MARK: proximity

    private func updateProximities(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != player.leader && player.hasMet(with: otherPlayer) {
                self.updateProximity(to: otherPlayer, in: gameModel)
            }
        }
    }

    func updateProximity(to otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        var smallestDistanceBetweenCities = Int.max
        var averageDistanceBetweenCities = 0
        var numCityConnections = 0

        // Loop through all of MY Cities
        for myCityRef in gameModel.cities(of: player) {

            if let myCity = myCityRef {

                // Loop through all of THEIR Cities
                for otherCityRef in gameModel.cities(of: otherPlayer) {

                    if let otherCity = otherCityRef {

                        numCityConnections += 1
                        let distance = myCity.location.distance(to: otherCity.location)

                        if distance < smallestDistanceBetweenCities {

                            smallestDistanceBetweenCities = distance
                        }

                        averageDistanceBetweenCities += distance
                    }
                }
            }
        }

        // Seed this value with something reasonable to start.  This will be the value assigned if one player has 0 Cities.
        var proximity: PlayerProximityType = .none

        if numCityConnections > 0 {

            averageDistanceBetweenCities /= numCityConnections

            // Closest Cities must be within a certain range
            if smallestDistanceBetweenCities <= 7 { // PROXIMITY_NEIGHBORS_CLOSEST_CITY_REQUIREMENT

                proximity = .neighbors
            } else
            // If our closest Cities are pretty near one another  and our average is less than the max then we can be considered CLOSE (will also look at City average below)
            if smallestDistanceBetweenCities <= 11 {

                proximity = .close
            }

            if proximity == .none {

                let mapFactor = (gameModel.mapSize().width() + gameModel.mapSize().height()) / 2

                // Normally base distance on map size, but cap it at a certain point
                var closeDistance = mapFactor * 25 / 100 // PROXIMITY_CLOSE_DISTANCE_MAP_MULTIPLIER

                // Close can't be so big that it sits on Far's turf
                if closeDistance > 20 { // PROXIMITY_CLOSE_DISTANCE_MAX
                    closeDistance = 20 // PROXIMITY_CLOSE_DISTANCE_MAX
                } else
                // Close also can't be so small that it sits on Neighbor's turf
                if closeDistance < 10 { // PROXIMITY_CLOSE_DISTANCE_MIN
                    closeDistance = 10 // PROXIMITY_CLOSE_DISTANCE_MIN
                }

                // Far can't be so big that it sits on Distant's turf
                var farDistance = mapFactor * 45 / 100 // PROXIMITY_FAR_DISTANCE_MAP_MULTIPLIER

                if farDistance > 50 { // PROXIMITY_CLOSE_DISTANCE_MAX
                    farDistance = 50 // PROXIMITY_CLOSE_DISTANCE_MAX
                } else
                // Close also can't be so small that it sits on Neighbor's turf
                if farDistance < 20 { // PROXIMITY_CLOSE_DISTANCE_MIN
                    farDistance = 20 // PROXIMITY_CLOSE_DISTANCE_MIN
                }

                if averageDistanceBetweenCities <= closeDistance {
                    proximity = .close
                } else if averageDistanceBetweenCities <= farDistance {
                    proximity = .far
                } else {
                    proximity = .distant
                }
            }

            // Players NOT on the same landmass - bump up PROXIMITY by one level (unless we're already distant)
            if proximity != .distant {

                // FIXME
            }
        }

        let numPlayerLeft = gameModel.players.count(where: { $0.isAlive() })
        if numPlayerLeft == 2 {
            proximity = proximity > .close ? proximity : .close
        } else if numPlayerLeft <= 4 {
            proximity = proximity > .far ? proximity : .far
        }

        self.playerDict.updateProximity(towards: otherPlayer, to: proximity)
    }

    func proximity(to otherPlayer: AbstractPlayer?) -> PlayerProximityType {

        return self.playerDict.proximity(to: otherPlayer)
    }

    func hasMet(with other: AbstractPlayer?) -> Bool {

        return self.playerDict.hasMet(with: other)
    }

    func opinion(of otherPlayer: AbstractPlayer?) -> PlayerOpinionType {

        return self.playerDict.opinion(of: otherPlayer)
    }

    // MARK: military threats

    func updateMilitaryThreats(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        var ownMilitaryMight = player.militaryMight(in: gameModel)

        if ownMilitaryMight == 0 {
            ownMilitaryMight = 1
        }

        // Add in City Defensive Strength per city
        for cityRef in gameModel.cities(of: player) {

            if let city = cityRef {

                let damageFactor = (25.0 - Double(city.damage())) / 25.0
                var cityStrengthModifier = Int(Double(city.power()) * damageFactor)
                cityStrengthModifier *= 33
                cityStrengthModifier /= 100
                cityStrengthModifier /= 10

                ownMilitaryMight += cityStrengthModifier
            }
        }

        // Loop through all (known) Players
        for otherPlayer in gameModel.players {

            if otherPlayer.leader != player.leader && player.hasMet(with: otherPlayer) {

                let otherMilitaryMight = otherPlayer.militaryMight(in: gameModel)

                // If another player has double the Military strength of us, the Ratio will be 200
                let militaryRatio = otherMilitaryMight * 100 / ownMilitaryMight
                var militaryThreat = militaryRatio

                // At war: what is the current status of things?
                if self.isAtWar(with: otherPlayer) {

                    switch self.warState(towards: otherPlayer) {

                    case .none:
                        // NOOP
                        break
                    case .nearlyDefeated:
                        militaryThreat += 150 // MILITARY_THREAT_WAR_STATE_NEARLY_DEFEATED
                    case .defensive:
                        militaryThreat += 80 // MILITARY_THREAT_WAR_STATE_DEFENSIVE
                    case .stalemate:
                        militaryThreat += 30 // MILITARY_THREAT_WAR_STATE_STALEMATE
                    case .calm:
                        militaryThreat += 0 // MILITARY_THREAT_WAR_STATE_CALM
                    case .offensive:
                        militaryThreat += -40 // MILITARY_THREAT_WAR_STATE_OFFENSIVE
                    case .nearlyWon:
                        militaryThreat += -100 // MILITARY_THREAT_WAR_STATE_NEARLY_WON
                    }
                }

                // Factor in Friends this player has

                // TBD

                // Factor in distance
                switch self.proximity(to: otherPlayer) {

                case .none:
                    // NOOP
                    break
                case .neighbors:
                    militaryThreat += 100 // MILITARY_THREAT_NEIGHBORS
                case .close:
                    militaryThreat += 40 // MILITARY_THREAT_CLOSE
                case .far:
                    militaryThreat += -40 // MILITARY_THREAT_FAR
                case .distant:
                    militaryThreat += -100 // MILITARY_THREAT_DISTANT
                }

                // Don't factor in # of players attacked or at war with now if we ARE at war with this guy already

                // FIXME

                // Now do the final assessment
                if militaryThreat >= 300 { // MILITARY_THREAT_CRITICAL_THRESHOLD
                    self.playerDict.updateMilitaryThreat(of: otherPlayer, to: .critical)
                } else if militaryThreat >= 220 { // MILITARY_THREAT_SEVERE_THRESHOLD
                    self.playerDict.updateMilitaryThreat(of: otherPlayer, to: .severe)
                } else if militaryThreat >= 170 { // MILITARY_THREAT_MAJOR_THRESHOLD
                    self.playerDict.updateMilitaryThreat(of: otherPlayer, to: .major)
                } else if militaryThreat >= 100 { // MILITARY_THREAT_MINOR_THRESHOLD
                    self.playerDict.updateMilitaryThreat(of: otherPlayer, to: .minor)
                } else {
                    self.playerDict.updateMilitaryThreat(of: otherPlayer, to: .none)
                }
            }
        }
    }

    func militaryThreat(of otherPlayer: AbstractPlayer?) -> MilitaryThreatType {

        return self.playerDict.militaryThreat(of: otherPlayer)
    }

    func militaryStrength(of other: AbstractPlayer?) -> StrengthType {

        return self.playerDict.militaryStrengthComparedToUs(of: other)
    }

    func warGoal(towards other: AbstractPlayer?) -> PlayerWarGoalType {

        return .none // FIXME
    }
    
    /// Returns an integer that increases as the number and severity of land disputes rises
    func totalLandDisputeLevel(in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var rtnValue = 0 // slewis added, to fix a compile error. I'm guessing zero is correct.

        for otherPlayer in gameModel.players {
            
            if otherPlayer.isAlive() && otherPlayer.isEqual(to: self.player) {
                
                switch self.landDisputeLevel(with: otherPlayer) {
                    
                case .fierce:
                    rtnValue += 5 /*AI_DIPLO_LAND_DISPUTE_WEIGHT_FIERCE */
                case .strong:
                    rtnValue += 3 /* AI_DIPLO_LAND_DISPUTE_WEIGHT_STRONG */
                case .weak:
                    rtnValue += 1 /* AI_DIPLO_LAND_DISPUTE_WEIGHT_WEAK */
                
                default:
                    // NOOP
                    break
                }
            }
        }
        
        return rtnValue
    }
    
    func landDisputeLevel(with otherPlayer: AbstractPlayer?) -> LandDisputeLevelType {
        
        return self.playerDict.landDisputeLevel(with: otherPlayer)
    }
    
    func lastTurnLandDisputeLevel(with otherPlayer: AbstractPlayer?) -> LandDisputeLevelType {
    
        return self.playerDict.lastTurnLandDisputeLevel(with: otherPlayer)
    }
    
    /// Updates what is our level of Dispute with a player is over Land
    func doUpdateLandDisputeLevels(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var disputeLevel: LandDisputeLevelType = .none

        var landDisputeWeight = 0
        var expansionFlavor = 0

        // Loop through all (known) Players
        for otherPlayer in gameModel.players {

            // Update last turn's values
            self.playerDict.updateLastTurnLandDisputeLevel(with: otherPlayer, to: self.landDisputeLevel(with: otherPlayer))

            if otherPlayer.isAlive() && otherPlayer.leader != player.leader {
                
                disputeLevel = .none
                landDisputeWeight = 0

                // Expansion aggression
                var aggression = self.expansionAggressivePosture(towards: otherPlayer)

                if aggression == .none {
                    landDisputeWeight += 0 /*LAND_DISPUTE_EXP_AGGRESSIVE_POSTURE_NONE*/
                } else if aggression == .low {
                    landDisputeWeight += 10 /*LAND_DISPUTE_EXP_AGGRESSIVE_POSTURE_LOW */
                } else if aggression == .medium {
                    landDisputeWeight += 32 /*LAND_DISPUTE_EXP_AGGRESSIVE_POSTURE_MEDIUM */
                } else if aggression == .high {
                    landDisputeWeight += 50 /*LAND_DISPUTE_EXP_AGGRESSIVE_POSTURE_HIGH */
                } else if aggression == .incredible {
                    landDisputeWeight += 60 /*LAND_DISPUTE_EXP_AGGRESSIVE_POSTURE_INCREDIBLE */
                }

                // Plot Buying aggression
                aggression = self.plotBuyingAggressivePosture(towards: otherPlayer)

                if aggression == .none {
                    landDisputeWeight += 0 /* LAND_DISPUTE_PLOT_BUY_AGGRESSIVE_POSTURE_NONE */
                } else if aggression == .low {
                    landDisputeWeight += 5 /* LAND_DISPUTE_PLOT_BUY_AGGRESSIVE_POSTURE_LOW */
                } else if aggression == .medium {
                    landDisputeWeight += 12 /* LAND_DISPUTE_PLOT_BUY_AGGRESSIVE_POSTURE_MEDIUM */
                } else if aggression == .high {
                    landDisputeWeight += 20 /* LAND_DISPUTE_PLOT_BUY_AGGRESSIVE_POSTURE_HIGH */
                } else if aggression == .incredible {
                    landDisputeWeight += 30 /* LAND_DISPUTE_PLOT_BUY_AGGRESSIVE_POSTURE_INCREDIBLE */
                }

                // Look at our Proximity to the other Player
                let proximity = self.proximity(to: otherPlayer)

                if proximity == .distant {
                    landDisputeWeight += 0 /* LAND_DISPUTE_DISTANT */
                } else if proximity == .far {
                    landDisputeWeight += 10 /* LAND_DISPUTE_FAR */
                } else if proximity == .close {
                    landDisputeWeight += 18 /* LAND_DISPUTE_CLOSE */
                } else if proximity == .neighbors {
                    landDisputeWeight += 30 /* LAND_DISPUTE_NEIGHBORS */
                }

                // JON: Turned off to counter-balance the lack of the next block functioning
                // Is the player already cramped?
                /*if (GetPlayer()->IsCramped())
                {
                    iLandDisputeWeight += /*0*/ GC.getLAND_DISPUTE_CRAMPED_MULTIPLIER();
                }*/

                // If the player has deleted the EXPANSION Flavor we have to account for that
                expansionFlavor = 5 /* DEFAULT_FLAVOR_VALUE */
                expansionFlavor = player.personalAndGrandStrategyFlavor(for: .expansion)

                // Add weight for Player's natural EXPANSION preference
                landDisputeWeight *= expansionFlavor

                // Now See what our new Dispute Level should be
                if landDisputeWeight >= 400 { /*LAND_DISPUTE_FIERCE_THRESHOLD */
                    disputeLevel = .fierce
                } else if landDisputeWeight >= 230 { /* LAND_DISPUTE_STRONG_THRESHOLD */
                    disputeLevel = .strong
                } else if landDisputeWeight >= 100 { /* LAND_DISPUTE_WEAK_THRESHOLD */
                    disputeLevel = .weak
                }

                // Actually set the Level
                self.playerDict.updateLandDisputeLevel(with: otherPlayer, to: disputeLevel)
            }
        }
    }
    
    /// Updates how aggressively this player's Units are positioned in relation to us
    func doUpdateExpansionAggressivePostures(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if gameModel.capital(of: player) != nil {
            return
        }

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            self.doUpdateOnePlayerExpansionAggressivePosture(of: loopPlayer, in: gameModel)
        }
    }
    
    /// Updates how aggressively this player's Units are positioned in relation to us
    func doUpdateOnePlayerExpansionAggressivePosture(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        guard let myCapital = gameModel.capital(of: player) else {
            return
        }

        if otherPlayer.isAlive() {
            return
        }

        var aggressivePosture: AggressivePostureType = .none
        var mostAggressiveCityPosture: AggressivePostureType = .none
        var numMostAggressiveCities: Int = 0

        // If they have no capital then, uh... just stop I guess
        guard let otherCapital = gameModel.capital(of: otherPlayer) else {
            return
        }

        let distanceCapitals = otherCapital.location.distance(to: myCapital.location)

        // Loop through all of this player's Cities
        for loopCityRef in gameModel.cities(of: otherPlayer) {
            
            guard let loopCity = loopCityRef else {
                continue
            }
            
            // Don't look at their capital
            if loopCity.isCapital() {
                continue
            }

            // Don't look at Cities they've captured
            //if (pLoopCity->getOriginalOwner() != pLoopCity->getOwner())  continue;

            aggressivePosture = .none

            // First calculate distances
            let distanceUsToThem = myCapital.location.distance(to: loopCity.location)
            let distanceThemToTheirCapital = otherCapital.location.distance(to: loopCity.location)

            if distanceUsToThem <= 3 { /*EXPANSION_CAPITAL_DISTANCE_AGGRESSIVE_POSTURE_HIGH */
                aggressivePosture = .high
            } else if distanceUsToThem <= 5 { /* EXPANSION_CAPITAL_DISTANCE_AGGRESSIVE_POSTURE_MEDIUM */
                aggressivePosture = .medium
            } else if distanceUsToThem <= 9 { /* EXPANSION_CAPITAL_DISTANCE_AGGRESSIVE_POSTURE_LOW */
                aggressivePosture = .low
            }

            // If this City is closer to our capital than the other player's then it's immediately at least Mediumly aggressive
            if aggressivePosture == .low {
                if distanceUsToThem < distanceThemToTheirCapital {
                    aggressivePosture = .medium
                }
            }

            // If this City is further from their capital then our capitals are then it's super-aggressive
            if aggressivePosture >= .medium {
                if distanceCapitals < distanceThemToTheirCapital {
                    aggressivePosture = .incredible
                }
            }

            // Increase number of Cities at this Aggressiveness level
            if aggressivePosture == mostAggressiveCityPosture {
                numMostAggressiveCities += 1
            } else if aggressivePosture > mostAggressiveCityPosture {
                // If this City is the most aggressive one yet, replace the old record
                mostAggressiveCityPosture = aggressivePosture
                numMostAggressiveCities = 0
            }

            // If we're already at the max aggression level we don't need to look at more Cities
            if mostAggressiveCityPosture == .incredible {
                break
            }
        }

        // If we have multiple Cities that tie for being the highest then bump us up a level
        if numMostAggressiveCities > 1 {
            // If every City is low then we don't care that much, and if we're already at the highest level we can't go higher
            if mostAggressiveCityPosture > .low && mostAggressiveCityPosture < .incredible {
                mostAggressiveCityPosture = mostAggressiveCityPosture.increased()
            }
        }

        self.playerDict.updateExpansionAggressivePosture(for: otherPlayer, posture: mostAggressiveCityPosture)
    }
    
    func expansionAggressivePosture(towards otherPlayer: AbstractPlayer?) -> AggressivePostureType {
        
        return self.playerDict.expansionAggressivePosture(towards: otherPlayer)
    }
    
    /// Updates how aggressively ePlayer is buying land near us
    func doUpdatePlotBuyingAggressivePosture(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        var posture: AggressivePostureType = .none

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            if loopPlayer.isAlive() && loopPlayer.leader != player.leader && diplomacyAI.hasMet(with: loopPlayer) {
                
                var aggressionScore = 0

                // Loop through all of our Cities to see if this player has bought land near them
                for loopCityRef in gameModel.cities(of: loopPlayer) {
                    
                    guard let loopCity = loopCityRef else {
                        continue
                    }
                    
                    aggressionScore += loopCity.numPlotsAcquired(by: loopPlayer)
                }

                // Now See what our new Dispute Level should be
                if aggressionScore >= 10 { /*PLOT_BUYING_POSTURE_INCREDIBLE_THRESHOLD */
                    posture = .incredible
                } else if aggressionScore >= 7 { /* PLOT_BUYING_POSTURE_HIGH_THRESHOLD */
                    posture = .high
                } else if aggressionScore >= 4 { /* PLOT_BUYING_POSTURE_MEDIUM_THRESHOLD */
                    posture = .medium
                } else if aggressionScore >= 2 { /* PLOT_BUYING_POSTURE_LOW_THRESHOLD */
                    posture = .low
                } else {
                    posture = .none
                }

                //self.updatePlotBuyingAggressivePosture(eLoopPlayer, ePosture);
                self.playerDict.updatePlotBuyingAggressivePosture(for: loopPlayer, posture: posture)
            }
        }
    }
    
    func plotBuyingAggressivePosture(towards otherPlayer: AbstractPlayer?) -> AggressivePostureType {
        
        return self.playerDict.plotBuyingAggressivePosture(towards: otherPlayer)
    }
}
