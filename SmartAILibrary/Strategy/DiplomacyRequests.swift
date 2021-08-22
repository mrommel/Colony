//
//  DiplomacyRequests.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

/*
 FROM_UI_DIPLO_EVENT_HUMAN_DECLARES_WAR,
 FROM_UI_DIPLO_EVENT_HUMAN_NEGOTIATE_PEACE,

 FROM_UI_DIPLO_EVENT_HUMAN_WANTS_DISCUSSION,
 FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_DONT_SETTLE,
 FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_WORK_WITH_US,
 FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_END_WORK_WITH_US,

 FROM_UI_DIPLO_EVENT_DEMAND_HUMAN_REFUSAL,
 FROM_UI_DIPLO_EVENT_REQUEST_HUMAN_REFUSAL,

 FROM_UI_DIPLO_EVENT_AGGRESSIVE_MILITARY_WARNING_RESPONSE,

 FROM_UI_DIPLO_EVENT_I_ATTACKED_YOUR_MINOR_CIV_RESPONSE,
 FROM_UI_DIPLO_EVENT_I_BULLIED_YOUR_MINOR_CIV_RESPONSE,

 FROM_UI_DIPLO_EVENT_ATTACKED_MINOR_RESPONSE,
 FROM_UI_DIPLO_EVENT_KILLED_MINOR_RESPONSE,
 FROM_UI_DIPLO_EVENT_BULLIED_MINOR_RESPONSE,

 FROM_UI_DIPLO_EVENT_EXPANSION_SERIOUS_WARNING_RESPONSE,
 FROM_UI_DIPLO_EVENT_EXPANSION_WARNING_RESPONSE,

 FROM_UI_DIPLO_EVENT_PLOT_BUYING_SERIOUS_WARNING_RESPONSE,
 FROM_UI_DIPLO_EVENT_PLOT_BUYING_WARNING_RESPONSE,

 FROM_UI_DIPLO_EVENT_WORK_WITH_US_RESPONSE,
 FROM_UI_DIPLO_EVENT_WORK_AGAINST_SOMEONE_RESPONSE,
 FROM_UI_DIPLO_EVENT_DENOUNCE,
 FROM_UI_DIPLO_EVENT_COOP_WAR_OFFER,
 FROM_UI_DIPLO_EVENT_COOP_WAR_RESPONSE,
 FROM_UI_DIPLO_EVENT_COOP_WAR_NOW_RESPONSE,

 FROM_UI_DIPLO_EVENT_HUMAN_DEMAND,

 FROM_UI_DIPLO_EVENT_PLAN_RA_RESPONSE,

 // Post Civ 5 release
 FROM_UI_DIPLO_EVENT_AI_REQUEST_DENOUNCE_RESPONSE,
 FROM_UI_DIPLO_EVENT_CAUGHT_YOUR_SPY_RESPONSE,
 FROM_UI_DIPLO_EVENT_KILLED_MY_SPY_RESPONSE, // We killed one of their spies and they're apologizing
 FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_STOP_SPYING,
 FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_SHARE_INTRIGUE,
 FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_STOP_SPREADING_RELIGION,

 FROM_UI_DIPLO_EVENT_STOP_CONVERSIONS,

 FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_STOP_DIGGING,
 FROM_UI_DIPLO_EVENT_STOP_DIGGING,
 */

class DiplomacyRequest: Codable {

    enum CodingKeys: String, CodingKey {

        case otherLeader
        case state
        case message
        case emotion
        case turn
    }

    let otherLeader: LeaderType
    let state: DiplomaticRequestState
    let message: String
    let emotion: LeaderEmotionType

    //let index: Int
    let turn: Int

    init(for otherLeader: LeaderType, state: DiplomaticRequestState, message: String, emotion: LeaderEmotionType, turn: Int) {

        self.otherLeader = otherLeader
        self.state = state
        self.message = message
        self.emotion = emotion
        self.turn = turn
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.otherLeader = try container.decode(LeaderType.self, forKey: .otherLeader)
        self.state = try container.decode(DiplomaticRequestState.self, forKey: .state)
        self.message = try container.decode(String.self, forKey: .message)
        self.emotion = try container.decode(LeaderEmotionType.self, forKey: .emotion)
        self.turn = try container.decode(Int.self, forKey: .turn)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.otherLeader, forKey: .otherLeader)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.emotion, forKey: .emotion)
        try container.encode(self.turn, forKey: .turn)
    }
}

public class DiplomacyRequests: Codable {

    enum CodingKeys: String, CodingKey {

        case requests
    }

    var player: AbstractPlayer?
    var requests: [DiplomacyRequest]

    // MARK: constructors

    init(player: AbstractPlayer?) {

        self.player = player

        self.requests = []
    }

    private func addRequest(for otherLeader: LeaderType, state: DiplomaticRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.requests.append(DiplomacyRequest(for: otherLeader, state: state, message: message, emotion: emotion, turn: gameModel.currentTurn))
    }

    //    Send a request from a player to another player.
    //    If the toPlayer is the active human player, it will be sent right away, else
    //    it will be queued.
    func sendRequest(for otherLeader: LeaderType, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel found")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let otherPlayer = gameModel.player(for: otherLeader)

        gameModel.userInterface?.showLeaderMessage(from: player, to: otherPlayer, deal: nil, state: state, message: message, emotion: emotion)
    }

    //    Request for a deal
    func sendDealRequest(for otherLeader: LeaderType, deal: DiplomaticDeal, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType, in gameModel: GameModel?) {
        guard let gameModel = gameModel else {
            fatalError("no gameModel found")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let otherPlayer = gameModel.player(for: otherLeader)

        // Deals must currently happen on the active player's turn...
        if player.isEqual(to: gameModel.activePlayer()) {
            //self.sendRequest(for: otherLeader, state: state, message: message, emotion: emotion, with: deal, in: gameModel)
            gameModel.userInterface?.showLeaderMessage(from: player, to: otherPlayer, deal: deal, state: state, message: message, emotion: emotion)
        }
    }

    func hasPendingRequests() -> Bool {

        return !self.requests.isEmpty
    }

    //    Have all the AIs do a diplomacy evaluation with the supplied player.
    //    Please note that the destination player may not be the active player.
    func doAIDiplomacy(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let userInterface = gameModel.userInterface else {
            fatalError("cant get userInterface")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if userInterface.isShown(screen: .city) || userInterface.isShown(screen: .diplomatic) {
            return
        }

        if self.hasPendingRequests() {
            return
        }

        for otherPlayer in gameModel.players {

            if !player.isEqual(to: otherPlayer) && otherPlayer.isAlive() && !otherPlayer.isHuman() && !otherPlayer.isBarbarian() {

                otherPlayer.diplomacyAI?.turn(in: gameModel) //.doTurn(player)
            }
        }
    }

    func endTurn() {

    }
}
