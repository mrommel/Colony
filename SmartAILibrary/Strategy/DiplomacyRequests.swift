//
//  DiplomacyRequests.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// AI greeting messages
public enum DiplomaticRequestMessage: Int, Codable {

    case messageIntro // MESSAGE_INTRO

    /* DIPLO_MESSAGE_DEFEATED,
    DIPLO_MESSAGE_GREETING_REPEAT_TOO_MUCH,
    DIPLO_MESSAGE_GREETING_REPEAT,
    DIPLO_MESSAGE_GREETING_HOSTILE_REPEAT,
    DIPLO_MESSAGE_GREETING_FRIENDLY_HELLO,
    DIPLO_MESSAGE_GREETING_NEUTRAL_HELLO,
    DIPLO_MESSAGE_GREETING_HOSTILE_HELLO,

    DIPLO_MESSAGE_GREETING_DESTRUCTION_LOOMS,
    DIPLO_MESSAGE_GREETING_AT_WAR_WANTS_PEACE,
    DIPLO_MESSAGE_GREETING_AT_WAR_HOSTILE,
    DIPLO_MESSAGE_GREETING_WILL_ACCEPT_SURRENDER,

    DIPLO_MESSAGE_GREETING_RESEARCH_AGREEMENT,
    DIPLO_MESSAGE_GREETING_BROKEN_MILITARY_PROMISE,
    DIPLO_MESSAGE_GREETING_WORKING_WITH,
    DIPLO_MESSAGE_GREETING_WORKING_AGAINST,
    DIPLO_MESSAGE_GREETING_COOP_WAR,
    DIPLO_MESSAGE_GREETING_HOSTILE_HUMAN_AT_WAR,
    DIPLO_MESSAGE_GREETING_HUMAN_AT_WAR,
    DIPLO_MESSAGE_GREETING_HOSTILE_AGGRESSIVE_MILITARY,
    DIPLO_MESSAGE_GREETING_AGGRESSIVE_MILITARY,
    DIPLO_MESSAGE_GREETING_HOSTILE_AGGRESSIVE_EXPANSION,
    DIPLO_MESSAGE_GREETING_AGGRESSIVE_EXPANSION,
    DIPLO_MESSAGE_GREETING_HOSTILE_AGGRESSIVE_PLOT_BUYING,
    DIPLO_MESSAGE_GREETING_AGGRESSIVE_PLOT_BUYING,
    DIPLO_MESSAGE_GREETING_FRIENDLY_STRONG_MILITARY,
    DIPLO_MESSAGE_GREETING_FRIENDLY_STRONG_ECONOMY,
    DIPLO_MESSAGE_GREETING_HOSTILE_HUMAN_FEW_CITIES,
    DIPLO_MESSAGE_GREETING_HOSTILE_HUMAN_SMALL_ARMY,
    DIPLO_MESSAGE_GREETING_HOSTILE_HUMAN_IS_WARMONGER,

    // AI has a trade offer for the human
    DIPLO_MESSAGE_DOT_DOT_DOT,
    DIPLO_MESSAGE_LETS_HEAR_IT,*/
    case peaceOffer // DIPLO_MESSAGE_PEACE_OFFER,
    /*DIPLO_MESSAGE_DEMAND,
    DIPLO_MESSAGE_REQUEST,
    DIPLO_MESSAGE_LUXURY_TRADE,*/
    case embassyExchange // DIPLO_MESSAGE_EMBASSY_EXCHANGE,
    case embassyOffer // DIPLO_MESSAGE_EMBASSY_OFFER,
    case openBordersExchange // DIPLO_MESSAGE_OPEN_BORDERS_EXCHANGE,
    case openBordersOffer // DIPLO_MESSAGE_OPEN_BORDERS_OFFER,
    /*DIPLO_MESSAGE_PLAN_RESEARCH_AGREEMENT,
    DIPLO_MESSAGE_RESEARCH_AGREEMENT_OFFER,
    DIPLO_MESSAGE_RENEW_DEAL,
    DIPLO_MESSAGE_WANT_MORE_RENEW_DEAL,

    // Generic AI messages to another player; some friendship, some warnings, etc.
    DIPLO_MESSAGE_HOSTILE_AGGRESSIVE_MILITARY_WARNING,
    DIPLO_MESSAGE_AGGRESSIVE_MILITARY_WARNING,
    DIPLO_MESSAGE_EXPANSION_SERIOUS_WARNING,
    DIPLO_MESSAGE_EXPANSION_WARNING,
    DIPLO_MESSAGE_EXPANSION_BROKEN_PROMISE,
    DIPLO_MESSAGE_PLOT_BUYING_SERIOUS_WARNING,
    DIPLO_MESSAGE_PLOT_BUYING_WARNING,
    DIPLO_MESSAGE_PLOT_BUYING_BROKEN_PROMISE,
    DIPLO_MESSAGE_HOSTILE_WE_ATTACKED_YOUR_MINOR,
    DIPLO_MESSAGE_WE_ATTACKED_YOUR_MINOR,
    DIPLO_MESSAGE_HOSTILE_WE_BULLIED_YOUR_MINOR,
    DIPLO_MESSAGE_WE_BULLIED_YOUR_MINOR,
    DIPLO_MESSAGE_WORK_WITH_US,
    DIPLO_MESSAGE_END_WORK_WITH_US,
    DIPLO_MESSAGE_WORK_AGAINST_SOMEONE,
    DIPLO_MESSAGE_END_WORK_AGAINST_SOMEONE, */
    case coopWarRequest // DIPLO_MESSAGE_COOP_WAR_REQUEST,
    case coopWarTime // DIPLO_MESSAGE_COOP_WAR_TIME,
    /*DIPLO_MESSAGE_NOW_UNFORGIVABLE,
    DIPLO_MESSAGE_NOW_ENEMY,
    DIPLO_MESSAGE_COMPLIMENT,
    DIPLO_MESSAGE_BOOT_KISSING,
    DIPLO_MESSAGE_WARMONGER,
    DIPLO_MESSAGE_MINOR_CIV_COMPETITION,
    DIPLO_MESSAGE_PLEASED,
    DIPLO_MESSAGE_THANKFUL,
    DIPLO_MESSAGE_DISAPPOINTED,
    DIPLO_MESSAGE_SO_BE_IT,
    DIPLO_MESSAGE_RETURNED_CIVILIAN,
    DIPLO_MESSAGE_CULTURE_BOMBED,

    // Insults
    DIPLO_MESSAGE_INSULT_ROOT,
    DIPLO_MESSAGE_INSULT_GENERIC,
    DIPLO_MESSAGE_INSULT_MILITARY,
    DIPLO_MESSAGE_INSULT_BULLY,
    DIPLO_MESSAGE_INSULT_UNHAPPINESS,
    DIPLO_MESSAGE_INSULT_CITIES,
    DIPLO_MESSAGE_INSULT_POPULATION,
    DIPLO_MESSAGE_INSULT_CULTURE,

    // AI has a public declaration to make to the world
    DIPLO_MESSAGE_DECLARATION_PROTECT_CITY_STATE,
    DIPLO_MESSAGE_DECLARATION_ABANDON_CITY_STATE,

    // Human is asking the AI for something
    DIPLO_MESSAGE_REPEAT_NO,
    DIPLO_MESSAGE_DONT_SETTLE_YES,
    DIPLO_MESSAGE_DONT_SETTLE_NO,
    DIPLO_MESSAGE_WORK_WITH_US_YES,
    DIPLO_MESSAGE_WORK_WITH_US_NO,
    DIPLO_MESSAGE_WORK_AGAINST_SOMEONE_YES,
    DIPLO_MESSAGE_WORK_AGAINST_SOMEONE_NO,
    DIPLO_MESSAGE_COOP_WAR_YES,
    DIPLO_MESSAGE_COOP_WAR_NO,
    DIPLO_MESSAGE_COOP_WAR_SOON,
    DIPLO_MESSAGE_HUMAN_DEMAND_YES,
    DIPLO_MESSAGE_HUMAN_DEMAND_REFUSE_WEAK,
    DIPLO_MESSAGE_HUMAN_DEMAND_REFUSE_HOSTILE,
    DIPLO_MESSAGE_HUMAN_DEMAND_REFUSE_TOO_MUCH,
    DIPLO_MESSAGE_HUMAN_DEMAND_REFUSE_TOO_SOON,

    // AI popped up to tell the human something, human responded and now we're responding back
    DIPLO_MESSAGE_HUMAN_HOSTILE_AGGRESSIVE_MILITARY_WARNING_BAD,
    DIPLO_MESSAGE_HUMAN_HOSTILE_AGGRESSIVE_MILITARY_WARNING_GOOD,
    DIPLO_MESSAGE_HUMAN_AGGRESSIVE_MILITARY_WARNING_BAD,
    DIPLO_MESSAGE_HUMAN_AGGRESSIVE_MILITARY_WARNING_GOOD,

    DIPLO_MESSAGE_HUMAN_HOSTILE_WE_ATTACKED_MINOR_BAD,
    DIPLO_MESSAGE_HUMAN_HOSTILE_WE_ATTACKED_MINOR_GOOD,
    DIPLO_MESSAGE_HUMAN_WE_ATTACKED_MINOR_BAD,
    DIPLO_MESSAGE_HUMAN_WE_ATTACKED_MINOR_GOOD,
    DIPLO_MESSAGE_HUMAN_HOSTILE_WE_BULLIED_MINOR_BAD,
    DIPLO_MESSAGE_HUMAN_HOSTILE_WE_BULLIED_MINOR_GOOD,
    DIPLO_MESSAGE_HUMAN_WE_BULLIED_MINOR_BAD,
    DIPLO_MESSAGE_HUMAN_WE_BULLIED_MINOR_GOOD,

    DIPLO_MESSAGE_HUMAN_ATTACKED_PROTECTED_CITY_STATE,
    DIPLO_MESSAGE_HUMAN_ATTACKED_MINOR_BAD,
    DIPLO_MESSAGE_HUMAN_ATTACKED_MINOR_GOOD,
    DIPLO_MESSAGE_HUMAN_KILLED_PROTECTED_CITY_STATE,
    DIPLO_MESSAGE_HUMAN_KILLED_MINOR_BAD,
    DIPLO_MESSAGE_HUMAN_KILLED_MINOR_GOOD,
    DIPLO_MESSAGE_HUMAN_BULLIED_PROTECTED_CITY_STATE,
    DIPLO_MESSAGE_HUMAN_BULLIED_MINOR_BAD,
    DIPLO_MESSAGE_HUMAN_BULLIED_MINOR_GOOD,

    DIPLO_MESSAGE_HUMAN_SERIOUS_EXPANSION_WARNING_BAD,
    DIPLO_MESSAGE_HUMAN_SERIOUS_EXPANSION_WARNING_GOOD,
    DIPLO_MESSAGE_HUMAN_EXPANSION_WARNING_BAD,
    DIPLO_MESSAGE_HUMAN_EXPANSION_WARNING_GOOD,

    DIPLO_MESSAGE_HUMAN_SERIOUS_PLOT_BUYING_WARNING_BAD,
    DIPLO_MESSAGE_HUMAN_SERIOUS_PLOT_BUYING_WARNING_GOOD,
    DIPLO_MESSAGE_HUMAN_PLOT_BUYING_WARNING_BAD,
    DIPLO_MESSAGE_HUMAN_PLOT_BUYING_WARNING_GOOD,

    // Peace messages
    DIPLO_MESSAGE_PEACE_WHAT_WILL_HUMAN_OFFER,
    DIPLO_MESSAGE_PEACE_MADE_BY_HUMAN_GRACIOUS,
    DIPLO_MESSAGE_NO_PEACE,
    DIPLO_MESSAGE_TOO_SOON_NO_PEACE,

    // Trade responses
    DIPLO_MESSAGE_REPEAT_TRADE_TOO_MUCH,
    DIPLO_MESSAGE_REPEAT_TRADE,
    DIPLO_MESSAGE_TRADE_ACCEPT_GENEROUS,
    DIPLO_MESSAGE_TRADE_ACCEPT_ACCEPTABLE,
    DIPLO_MESSAGE_TRADE_ACCEPT_AI_DEMAND,
    DIPLO_MESSAGE_TRADE_ACCEPT_HUMAN_CONCESSIONS,
    DIPLO_MESSAGE_TRADE_REJECT_UNACCEPTABLE,
    DIPLO_MESSAGE_TRADE_REJECT_INSULTING,
    DIPLO_MESSAGE_TRADE_DEAL_UNCHANGED,
    DIPLO_MESSAGE_TRADE_AI_MAKES_OFFER,
    DIPLO_MESSAGE_TRADE_NO_DEAL_POSSIBLE,
    DIPLO_MESSAGE_TRADE_CANT_MATCH_OFFER,

    // Human declared war on AI, what is the AI's response?
    DIPLO_MESSAGE_ATTACKED_ROOT,
    DIPLO_MESSAGE_ATTACKED_HOSTILE,
    DIPLO_MESSAGE_ATTACKED_WEAK_HOSTILE,
    DIPLO_MESSAGE_ATTACKED_STRONG_HOSTILE,
    DIPLO_MESSAGE_ATTACKED_EXCITED,
    DIPLO_MESSAGE_ATTACKED_WEAK_EXCITED,
    DIPLO_MESSAGE_ATTACKED_STRONG_EXCITED,
    DIPLO_MESSAGE_ATTACKED_SAD,
    DIPLO_MESSAGE_ATTACKED_BETRAYED,
    DIPLO_MESSAGE_ATTACKED_MILITARY_PROMISE_BROKEN,

    // AI is declaring war on human, what does he say?
    DIPLO_MESSAGE_DOW_ROOT,
    DIPLO_MESSAGE_DOW_GENERIC,
    DIPLO_MESSAGE_DOW_LAND,
    DIPLO_MESSAGE_DOW_WORLD_CONQUEST,
    DIPLO_MESSAGE_DOW_OPPORTUNITY,
    DIPLO_MESSAGE_DOW_DESPERATE,
    DIPLO_MESSAGE_DOW_BETRAYAL,
    DIPLO_MESSAGE_DOW_WEAK_BETRAYAL,
    DIPLO_MESSAGE_DOW_REGRET,
    DIPLO_MESSAGE_WAR_DEMAND_REFUSED,

    // Messages added post-Civ5 Gold
    DIPLO_MESSAGE_DOF_AI_DENOUNCE_REQUEST,
    DIPLO_MESSAGE_DOF_AI_WAR_REQUEST,
    DIPLO_MESSAGE_DOF_NOT_HONORED,
    DIPLO_MESSAGE_AI_DOF_BACKSTAB,
    DIPLO_MESSAGE_RESPONSE_TO_BEING_DENOUNCED,
    DIPLO_MESSAGE_HUMAN_DOFED_FRIEND,
    DIPLO_MESSAGE_HUMAN_DOFED_ENEMY,
    DIPLO_MESSAGE_HUMAN_DENOUNCED_FRIEND,
    DIPLO_MESSAGE_HUMAN_DENOUNCED_ENEMY,
    DIPLO_MESSAGE_HUMAN_DENOUNCE_SO_AI_DOF,
    DIPLO_MESSAGE_HUMAN_DOF_SO_AI_DENOUNCE,
    DIPLO_MESSAGE_HUMAN_DENOUNCE_SO_AI_DENOUNCE,
    DIPLO_MESSAGE_HUMAN_DOF_SO_AI_DOF,
    DIPLO_MESSAGE_GREETING_DENOUNCED_BY_AI,
    DIPLO_MESSAGE_GREETING_DENOUNCED_AI,
    DIPLO_MESSAGE_GREETING_OUR_DOF_WITH_AI_ENEMY,
    DIPLO_MESSAGE_GREETING_OUR_DOF_WITH_AI_FRIEND,
    DIPLO_MESSAGE_GREETING_DENOUNCED_AI_FRIEND,
    DIPLO_MESSAGE_GREETING_DENOUNCED_AI_ENEMY,
    DIPLO_MESSAGE_TOO_SOON_FOR_DOF,
    DIPLO_MESSAGE_INSULT_NUKE,
    DIPLO_MESSAGE_SAME_POLICIES_FREEDOM,
    DIPLO_MESSAGE_SAME_POLICIES_ORDER,
    DIPLO_MESSAGE_SAME_POLICIES_AUTOCRACY,

    // Espionage messages
    DIPLO_MESSAGE_CAUGHT_YOUR_SPY,
    DIPLO_MESSAGE_KILLED_YOUR_SPY,
    DIPLO_MESSAGE_KILLED_MY_SPY,
    DIPLO_MESSAGE_CONFRONT_YOU_KILLED_MY_SPY,

    // Espionage responses
    DIPLO_MESSAGE_HUMAN_CAUGHT_YOUR_SPY_GOOD,
    DIPLO_MESSAGE_HUMAN_CAUGHT_YOUR_SPY_BAD,

    DIPLO_MESSAGE_STOP_SPYING_YES,
    DIPLO_MESSAGE_STOP_SPYING_NO,

    DIPLO_MESSAGE_WARNED_ABOUT_INTRIGUE, // player shares intrigue with AI
    DIPLO_MESSAGE_SHARE_INTRIGUE, // AI shares intrigue to player
    DIPLO_MESSAGE_SHARE_INTRIGUE_ARMY_SNEAK_ATTACK_KNOWN_CITY,
    DIPLO_MESSAGE_SHARE_INTRIGUE_ARMY_SNEAK_ATTACK_UNKNOWN_CITY,
    DIPLO_MESSAGE_SHARE_INTRIGUE_AMPHIBIOUS_SNEAK_ATTACK_KNOWN_CITY,
    DIPLO_MESSAGE_SHARE_INTRIGUE_AMPHIBIOUS_SNEAK_ATTACK_UNKNOWN_CITY,

    DIPLO_MESSAGE_HUMAN_KILLED_MY_SPY_UNFORGIVEN,
    DIPLO_MESSAGE_HUMAN_KILLED_MY_SPY_FORGIVEN,

    // Religion messages
    DIPLO_MESSAGE_STOP_CONVERSIONS,
    DIPLO_MESSAGE_HUMAN_STOP_CONVERSIONS_GOOD,
    DIPLO_MESSAGE_HUMAN_STOP_CONVERSIONS_BAD,
    DIPLO_MESSAGE_STOP_CONVERSIONS_AGREE, // the AI's response when the player asks to stop spreading religion through missionaries and prophets
    DIPLO_MESSAGE_STOP_CONVERSIONS_DISAGREE, // the AI's response when the player asks to stop spreading religion through missionaries and prophets

    // Archeology messages
    DIPLO_MESSAGE_STOP_DIGGING,
    DIPLO_MESSAGE_HUMAN_STOP_DIGGING_GOOD,
    DIPLO_MESSAGE_HUMAN_STOP_DIGGING_BAD,
    DIPLO_MESSAGE_STOP_DIGGING_AGREE, // the AI's response when the player asks to stop looting his stuff
    DIPLO_MESSAGE_STOP_DIGGING_DISAGREE, // the AI's response when the player asks to stop looting his stuff

    // League messages
    DIPLO_MESSAGE_WE_LIKED_THEIR_PROPOSAL,
    DIPLO_MESSAGE_WE_DISLIKED_THEIR_PROPOSAL,
    DIPLO_MESSAGE_THEY_SUPPORTED_OUR_PROPOSAL,
    DIPLO_MESSAGE_THEY_FOILED_OUR_PROPOSAL,
    DIPLO_MESSAGE_THEY_SUPPORTED_OUR_HOSTING,

    // Ideological messages
    DIPLO_MESSAGE_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM,
    DIPLO_MESSAGE_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER,
    DIPLO_MESSAGE_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY,
    DIPLO_MESSAGE_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM,
    DIPLO_MESSAGE_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER,
    DIPLO_MESSAGE_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY,
    DIPLO_MESSAGE_SWITCH_OUR_IDEOLOGY_FREEDOM,
    DIPLO_MESSAGE_SWITCH_OUR_IDEOLOGY_ORDER,
    DIPLO_MESSAGE_SWITCH_OUR_IDEOLOGY_AUTOCRACY,
    DIPLO_MESSAGE_YOUR_CULTURE_INFLUENTIAL,
    DIPLO_MESSAGE_OUR_CULTURE_INFLUENTIAL, */

    // GetDiploStringForMessage
    public func diploStringForMessage(for player1: AbstractPlayer?, and player2: AbstractPlayer? = nil) -> String {

        guard let leader1 = player1?.leader else {
            fatalError("leader must be provided")
        }

        switch self {

        case .messageIntro: // RESPONSE_FIRST_GREETING
            // Intro
            if leader1 == .augustus {
                return "Hail, stranger. I am the Imperator Caesar Augustus of far-reaching Rome. Who are you and what lands can you claim as your own?"
            }

            if leader1 == .elizabeth {
                return "Greetings. We are by the Grace of God, Elizabeth, Queen of the United Kingdom of Great Britain and Ireland. And soon, dare I say, the empire."
            }

            return "Greetings traveler. You should know that you stand in the presence of greatness!"

        case .coopWarRequest: // RESPONSE_COOP_WAR_REQUEST
            // AI would like to declare war on someone with a player
            guard let leader2 = player2?.leader else {
                fatalError("leader must be provided")
            }
            
            //TXT_KEY_COOP_WAR_REQUEST%
            return "Please join us to start war on \(leader2) now. Will you?"
            
        case .coopWarTime: // RESPONSE_COOP_WAR_TIME
            // AI calls up and says it's time to declare war on someone with a player
            guard let leader2 = player2?.leader else {
                fatalError("leader must be provided")
            }
            
            //TXT_KEY_COOP_WAR_TIME%
            return "Please join us to start war on \(leader2) in 10 turns. Will you?"
            
        case .peaceOffer: // RESPONSE_PEACE_OFFER
            return "I want peace"

        case .embassyExchange:
            return "embassyExchange"
            
        case .embassyOffer:
            return "embassyOffer"
            
        case .openBordersExchange:
            return "openBordersExchange"
            
        case .openBordersOffer:
            return "openBordersOffer"
        }
    }
}

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

public enum DiplomaticRequestState: Int, Codable {

    case intro

    case warDeclaredByHuman // DIPLO_UI_STATE_WAR_DECLARED_BY_HUMAN
    case peaceMadeByHuman // DIPLO_UI_STATE_PEACE_MADE_BY_HUMAN

    case blankDiscussion // DIPLO_UI_STATE_BLANK_DISCUSSION

    case trade // DIPLO_UI_STATE_TRADE

    case discussHumanInvoked // DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED

    /*

    DIPLO_UI_STATE_TRADE,*/
    case tradeAIMakesOffer // DIPLO_UI_STATE_TRADE_AI_MAKES_OFFER,
    /*DIPLO_UI_STATE_TRADE_AI_ACCEPTS_OFFER,
    DIPLO_UI_STATE_TRADE_AI_REJECTS_OFFER,
    DIPLO_UI_STATE_TRADE_AI_MAKES_DEMAND,
    DIPLO_UI_STATE_TRADE_AI_MAKES_REQUEST,
    DIPLO_UI_STATE_TRADE_HUMAN_OFFERS_CONCESSIONS,

    DIPLO_UI_STATE_HUMAN_DEMAND,

    DIPLO_UI_STATE_BLANK_DISCUSSION_RETURN_TO_ROOT,
    ,
    DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN,
    DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI,
    DIPLO_UI_STATE_AI_DECLARED_WAR,

    DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED,

    DIPLO_UI_STATE_DISCUSS_AGGRESSIVE_MILITARY_WARNING,
    DIPLO_UI_STATE_DISCUSS_I_ATTACKED_YOUR_MINOR_CIV,
    DIPLO_UI_STATE_DISCUSS_I_BULLIED_YOUR_MINOR_CIV,
    DIPLO_UI_STATE_DISCUSS_YOU_ATTACKED_MINOR_CIV,
    DIPLO_UI_STATE_DISCUSS_YOU_KILLED_MINOR_CIV,
    DIPLO_UI_STATE_DISCUSS_YOU_BULLIED_MINOR_CIV,
    DIPLO_UI_STATE_DISCUSS_PROTECT_MINOR_CIV,
    DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_SERIOUS_WARNING,
    DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_WARNING,
    DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_SERIOUS_WARNING,
    DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_WARNING,

    DIPLO_UI_STATE_DISCUSS_WORK_WITH_US,
    DIPLO_UI_STATE_DISCUSS_WORK_AGAINST_SOMEONE,*/
    case discussCoopWar // DIPLO_UI_STATE_DISCUSS_COOP_WAR,
    case discussCoopWarTime // DIPLO_UI_STATE_DISCUSS_COOP_WAR_TIME,

    /*DIPLO_UI_STATE_DISCUSS_PLAN_RESEARCH_AGREEMENT,

    // Post Civ 5 release stuff
    DIPLO_UI_STATE_DISCUSS_AI_REQUEST_DENOUNCE,

    // Espionage
    DIPLO_UI_STATE_CAUGHT_YOUR_SPY,
    DIPLO_UI_STATE_KILLED_YOUR_SPY,
    DIPLO_UI_STATE_KILLED_MY_SPY,
    DIPLO_UI_STATE_CONFRONT_YOU_KILLED_MY_SPY,

    DIPLO_UI_STATE_STOP_CONVERSIONS,

    DIPLO_UI_STATE_STOP_DIGGING,
    */
}

public enum LeaderEmotionType: Int, Codable {

    case neutral
    case positive
    case request
}

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

    func addRequest(for otherLeader: LeaderType, state: DiplomaticRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.requests.append(DiplomacyRequest(for: otherLeader, state: state, message: message, emotion: emotion, turn: gameModel.turnsElapsed))
    }

    func sendRequest(for otherLeader: LeaderType, state: DiplomaticRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?) {

        let otherPlayer = gameModel?.player(for: otherLeader)

        self.player?.notifications()?.addDiplomaticNotification(for: self.player, other: otherPlayer, state: state, message: message, emotion: emotion)
    }
    
    //    Request for a deal
    func sendDealRequest(for otherLeader: LeaderType, deal: DiplomaticDeal, state: DiplomaticRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?)
    {
        guard let gameModel = gameModel else {
            fatalError("no gameModel found")
        }
        
        // Deals must currently happen on the active player's turn...
        if otherLeader == gameModel.activePlayer()?.leader {
            
            fatalError("transfer deal value")
            //auto_ptr<ICvDeal1> pDeal = GC.WrapDealPointer(pkDeal);
            //GC.GetEngineUserInterface()->SetScratchDeal(pDeal.get());
            self.sendRequest(for: otherLeader, state: state, message: message, emotion: emotion, in: gameModel)
        }
    }

    func hasPendingRequests() -> Bool {

        return self.requests.count == 0
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
