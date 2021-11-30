//
//  DiplomacyAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 24.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum CoopWarState: Int, Codable, Comparable {

    case none

    case rejected // COOP_WAR_STATE_REJECTED,
    case soon // COOP_WAR_STATE_SOON,
    case accepted // COOP_WAR_STATE_ACCEPTED,

    static func < (lhs: CoopWarState, rhs: CoopWarState) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum WarGoalType: Int, Codable {

    case none

    case demand // WAR_GOAL_DEMAND
    case prepare // WAR_GOAL_PREPARE
    case conquest // WAR_GOAL_CONQUEST
    case damage // WAR_GOAL_DAMAGE
    case peace // WAR_GOAL_PEACE
}

enum DiplomaticStatementType {

    case none // NO_DIPLO_STATEMENT_TYPE = -1,

    case requestPeace // DIPLO_STATEMENT_REQUEST_PEACE,

    /*DIPLO_STATEMENT_AGGRESSIVE_MILITARY_WARNING,
    DIPLO_STATEMENT_KILLED_PROTECTED_CITY_STATE,
    DIPLO_STATEMENT_ATTACKED_PROTECTED_CITY_STATE,
    DIPLO_STATEMENT_BULLIED_PROTECTED_CITY_STATE,
    DIPLO_STATEMENT_EXPANSION_SERIOUS_WARNING,
    DIPLO_STATEMENT_EXPANSION_WARNING,
    DIPLO_STATEMENT_EXPANSION_BROKEN_PROMISE,
    DIPLO_STATEMENT_PLOT_BUYING_SERIOUS_WARNING,
    DIPLO_STATEMENT_PLOT_BUYING_WARNING,
    DIPLO_STATEMENT_PLOT_BUYING_BROKEN_PROMISE,
    DIPLO_STATEMENT_WE_ATTACKED_YOUR_MINOR,
    DIPLO_STATEMENT_WE_BULLIED_YOUR_MINOR,
    DIPLO_STATEMENT_WORK_WITH_US,
    DIPLO_STATEMENT_WORK_WITH_US_RANDFAILED,
    DIPLO_STATEMENT_END_WORK_WITH_US,
    DIPLO_STATEMENT_DENOUNCE,
    DIPLO_STATEMENT_DENOUNCE_RANDFAILED,
    DIPLO_STATEMENT_END_WORK_AGAINST_SOMEONE,*/
    case coopWarRequest // DIPLO_STATEMENT_COOP_WAR_REQUEST,
    case coopWarTime    // DIPLO_STATEMENT_COOP_WAR_TIME,
    /*DIPLO_STATEMENT_NOW_UNFORGIVABLE,
    DIPLO_STATEMENT_NOW_ENEMY,

    DIPLO_STATEMENT_CAUGHT_YOUR_SPY,
    DIPLO_STATEMENT_KILLED_YOUR_SPY,
    DIPLO_STATEMENT_KILLED_MY_SPY,
    DIPLO_STATEMENT_SHARE_INTRIGUE,

    DIPLO_STATEMENT_STOP_CONVERSIONS,

    DIPLO_STATEMENT_DEMAND,

    DIPLO_STATEMENT_REQUEST,
    DIPLO_STATEMENT_REQUEST_RANDFAILED,

    DIPLO_STATEMENT_GIFT,
    DIPLO_STATEMENT_GIFT_RANDFAILED,

    DIPLO_STATEMENT_LUXURY_TRADE,*/
    case embassyExchange // DIPLO_STATEMENT_EMBASSY_EXCHANGE,
    case embassyOffer // DIPLO_STATEMENT_EMBASSY_OFFER,
    case openBorderExchange // DIPLO_STATEMENT_OPEN_BORDERS_EXCHANGE,
    case openBorderOffer // DIPLO_STATEMENT_OPEN_BORDERS_OFFER,
    /*DIPLO_STATEMENT_PLAN_RESEARCH_AGREEMENT,
    DIPLO_STATEMENT_RESEARCH_AGREEMENT_OFFER,
    DIPLO_STATEMENT_RENEW_DEAL,

    DIPLO_STATEMENT_INSULT,
    DIPLO_STATEMENT_COMPLIMENT,
    DIPLO_STATEMENT_BOOT_KISSING,
    DIPLO_STATEMENT_WARMONGER,
    DIPLO_STATEMENT_MINOR_CIV_COMPETITION,

    DIPLO_STATEMENT_DENOUNCE_FRIEND,
    DIPLO_STATEMENT_REQUEST_FRIEND_DENOUNCE,
    DIPLO_STATEMENT_REQUEST_FRIEND_DENOUNCE_RANDFAILED,
    DIPLO_STATEMENT_REQUEST_FRIEND_WAR,

    DIPLO_STATEMENT_ANGRY_BEFRIEND_ENEMY,
    DIPLO_STATEMENT_ANGRY_BEFRIEND_ENEMY_RANDFAILED,
    DIPLO_STATEMENT_ANGRY_DENOUNCED_FRIEND,
    DIPLO_STATEMENT_ANGRY_DENOUNCED_FRIEND_RANDFAILED,
    DIPLO_STATEMENT_HAPPY_DENOUNCED_ENEMY,
    DIPLO_STATEMENT_HAPPY_DENOUNCED_ENEMY_RANDFAILED,
    DIPLO_STATEMENT_HAPPY_BEFRIENDED_FRIEND,
    DIPLO_STATEMENT_HAPPY_BEFRIENDED_FRIEND_RANDFAILED,
    DIPLO_STATEMENT_FYI_BEFRIEND_HUMAN_ENEMY,
    DIPLO_STATEMENT_FYI_BEFRIEND_HUMAN_ENEMY_RANDFAILED,
    DIPLO_STATEMENT_FYI_DENOUNCED_HUMAN_FRIEND,
    DIPLO_STATEMENT_FYI_DENOUNCED_HUMAN_FRIEND_RANDFAILED,
    DIPLO_STATEMENT_FYI_DENOUNCED_HUMAN_ENEMY,
    DIPLO_STATEMENT_FYI_DENOUNCED_HUMAN_ENEMY_RANDFAILED,
    DIPLO_STATEMENT_FYI_BEFRIEND_HUMAN_FRIEND,
    DIPLO_STATEMENT_FYI_BEFRIEND_HUMAN_FRIEND_RANDFAILED,

    DIPLO_STATEMENT_SAME_POLICIES_FREEDOM,
    DIPLO_STATEMENT_SAME_POLICIES_ORDER,
    DIPLO_STATEMENT_SAME_POLICIES_AUTOCRACY,

    DIPLO_STATEMENT_STOP_DIGGING,

    // League statements
    DIPLO_STATEMENT_WE_LIKED_THEIR_PROPOSAL,
    DIPLO_STATEMENT_WE_DISLIKED_THEIR_PROPOSAL,
    DIPLO_STATEMENT_THEY_SUPPORTED_OUR_PROPOSAL,
    DIPLO_STATEMENT_THEY_FOILED_OUR_PROPOSAL,
    DIPLO_STATEMENT_THEY_SUPPORTED_OUR_HOSTING,

    // Ideological statements
    DIPLO_STATEMENT_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM,
    DIPLO_STATEMENT_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER,
    DIPLO_STATEMENT_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY,
    DIPLO_STATEMENT_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM,
    DIPLO_STATEMENT_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER,
    DIPLO_STATEMENT_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY,
    DIPLO_STATEMENT_SWITCH_OUR_IDEOLOGY_FREEDOM,
    DIPLO_STATEMENT_SWITCH_OUR_IDEOLOGY_ORDER,
    DIPLO_STATEMENT_SWITCH_OUR_IDEOLOGY_AUTOCRACY,
    DIPLO_STATEMENT_YOUR_CULTURE_INFLUENTIAL,
    DIPLO_STATEMENT_OUR_CULTURE_INFLUENTIAL,*/
}

// swiftlint:disable type_body_length
public class DiplomaticAI: Codable {

    enum CodingKeys: CodingKey {

        case playerDict
        case stateOfAllWars

        case hasBrokenPeaceTreaty
    }

    var player: AbstractPlayer?

    private var playerDict: DiplomaticPlayerDict
    internal var stateOfAllWars: PlayerStateAllWars

    private var greetPlayers: [AbstractPlayer?] = []

    private var hasBrokenPeaceTreatyValue: Bool

    // MARK: constructors

    init(player: AbstractPlayer?) {

        self.player = player

        self.playerDict = DiplomaticPlayerDict()
        self.stateOfAllWars = .neutral
        self.hasBrokenPeaceTreatyValue = false
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.playerDict = try container.decode(DiplomaticPlayerDict.self, forKey: .playerDict)
        self.stateOfAllWars = try container.decode(PlayerStateAllWars.self, forKey: .stateOfAllWars)
        self.hasBrokenPeaceTreatyValue = try container.decode(Bool.self, forKey: .hasBrokenPeaceTreaty)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.playerDict, forKey: .playerDict)
        try container.encode(self.stateOfAllWars, forKey: .stateOfAllWars)
        try container.encode(self.hasBrokenPeaceTreatyValue, forKey: .hasBrokenPeaceTreaty)
    }

    func turn(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        // Military Stuff
        self.doLockedIntoWarDecay(in: gameModel)
        self.doWarDamageDecay(in: gameModel)
        self.doUpdateWarDamageLevel(in: gameModel)
        self.updateMilitaryStrengths(in: gameModel)
        self.updateEconomicStrengths(in: gameModel)

        //DoUpdateWarmongerThreats();
        self.updateMilitaryThreats(in: gameModel)
        self.updateTargetValue(in: gameModel) // DoUpdatePlayerTargetValues
        self.updateWarStates(in: gameModel)
        self.doUpdateWarProjections(in: gameModel)
        self.doUpdateWarGoals(in: gameModel)

        self.doUpdatePeaceTreatyWillingness(in: gameModel)

        // Issues of Dispute
        self.doUpdateLandDisputeLevels(in: gameModel)
        //DoUpdateVictoryDisputeLevels();
        //DoUpdateWonderDisputeLevels();
        //DoUpdateMinorCivDisputeLevels();

        // Has any player gone back on any promises he made?
        //DoTestPromises();

        // What we think other Players are up to
        //self.doUpdateOtherPlayerWarDamageLevel(in: gameModel)
        //DoUpdateEstimateOtherPlayerLandDisputeLevels();
        //DoUpdateEstimateOtherPlayerVictoryDisputeLevels();
        //DoUpdateEstimateOtherPlayerMilitaryThreats();
        //DoEstimateOtherPlayerOpinions();
        //LogOtherPlayerGuessStatus();

        // Look at the situation
        //DoUpdateMilitaryAggressivePostures();
        self.doUpdateExpansionAggressivePostures(in: gameModel)
        self.doUpdatePlotBuyingAggressivePosture(in: gameModel)

        // Player Opinion & Approach
        //DoUpdateApproachTowardsUsGuesses();

        self.updateOpinions(in: gameModel)
        self.updateApproaches(in: gameModel)
        //DoUpdateMinorCivApproaches();

        self.updateProximities(in: gameModel)

        // These functions actually DO things, and we don't want the shadow AI behind a human player doing things for him
        if !player.isHuman() {

            //MakeWar();
            //DoMakePeaceWithMinors();

            //DoUpdateDemands();

            //DoUpdatePlanningExchanges();
            //DoContactMinorCivs();
            self.doContactMajorCivs(in: gameModel)
        }

        // Update Counters
        self.doCounters(in: gameModel)
    }

    func doLockedIntoWarDecay(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for loopPlayer in gameModel.players {

            if loopPlayer.isAlive() && !loopPlayer.isEqual(to: self.player) && loopPlayer.hasMet(with: self.player) {
                // decay
                if self.numTurnsLockedIntoWar(with: loopPlayer) > 0 {
                    self.changeNumTurnsLockedIntoWar(with: loopPlayer, by: -1)
                }
            }
        }
    }

    /// Every turn we're at peace war damage goes down a bit
    func doWarDamageDecay(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            if loopPlayer.isAlive() && !loopPlayer.isEqual(to: self.player) && loopPlayer.hasMet(with: self.player) {

                // Update war damage we've suffered
                if !self.isAtWar(with: loopPlayer) {

                    var value = self.warValueLost(with: loopPlayer)

                    if value > 0 {
                        // Go down by 1/20th every turn at peace
                        value /= 20

                        // Make sure it's changing by at least 1
                        value = max(1, value)

                        self.changeWarValueLost(with: loopPlayer, by: -value)
                    }
                }

                // Update war damage other players have suffered from our viewpoint
                /*for(iThirdPlayerLoop = 0; iThirdPlayerLoop < MAX_CIV_PLAYERS; iThirdPlayerLoop++)
                {
                    eLoopThirdPlayer = (PlayerTypes) iThirdPlayerLoop;
                    eLoopThirdTeam = GET_PLAYER(eLoopThirdPlayer).getTeam();

                    // These two players not at war?
                    if(!GET_TEAM(eLoopThirdTeam).isAtWar(eLoopTeam))
                    {
                        iValue = GetOtherPlayerWarValueLost(eLoopPlayer, eLoopThirdPlayer);

                        if(iValue > 0)
                        {
                            // Go down by 1/20th every turn at peace
                            iValue /= 20;

                            // Make sure it's changing by at least 1
                            iValue = max(1, iValue);

                            ChangeOtherPlayerWarValueLost(eLoopPlayer, eLoopThirdPlayer, -iValue);
                        }
                    }
                }*/
            }
        }
    }

    // Increment our turn counters
    func doCounters(in gameModel: GameModel?) {

        // Loop through all (known) Players
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        // Loop through AI Players
        for otherPlayer in gameModel.players {

            if player.isEqual(to: otherPlayer) || !otherPlayer.isAlive() || otherPlayer.isBarbarian() {
                continue
            }

            if !player.hasMet(with: otherPlayer) {
                continue
            }

            // War Counter
            if self.isAtWar(with: otherPlayer) {
                // increments if at war
                self.playerDict.changeTurnsAtWar(with: otherPlayer, by: 1)
            } else if self.playerDict.turnsAtWar(with: otherPlayer) > 0 {
                // Reset Counter if not at war
                self.playerDict.updateTurnsAtWar(with: otherPlayer, to: 0)
            }

            // /////////////////////////////
            // Major Civs only!
            // /////////////////////////////

            // Trade value counter
            self.changeRecentTradeValue(with: otherPlayer, by: -3 /* DEAL_VALUE_PER_TURN_DECAY */)

            /*ChangeCommonFoeValue(eLoopPlayer, -GC.getCOMMON_FOE_VALUE_PER_TURN_DECAY());
             
            if (GetRecentAssistValue(eLoopPlayer) > 0)
            {
                int iMin = MIN(GetRecentAssistValue(eLoopPlayer), GC.getDEAL_VALUE_PER_TURN_DECAY());
                ChangeRecentAssistValue(eLoopPlayer, -iMin);
            }
            else if (GetRecentAssistValue(eLoopPlayer) < 0)
            {
                int iMin = MIN(-GetRecentAssistValue(eLoopPlayer), GC.getDEAL_VALUE_PER_TURN_DECAY());
                ChangeRecentAssistValue(eLoopPlayer, iMin);
            }
            
            int iBrokenPromisePreValue = GetBrokenExpansionPromiseValue(eLoopPlayer);
            ChangeBrokenExpansionPromiseValue(eLoopPlayer, -GC.getEXPANSION_PROMISE_BROKEN_PER_TURN_DECAY());
            int iIgnoredPromisePreValue = GetIgnoredExpansionPromiseValue(eLoopPlayer);
            ChangeIgnoredExpansionPromiseValue(eLoopPlayer, -GC.getEXPANSION_PROMISE_IGNORED_PER_TURN_DECAY());

            // if the promise penalty of breaking a promise has expired, reset the ability to ask the promise again
            if ((iBrokenPromisePreValue != 0 && GetBrokenExpansionPromiseValue(eLoopPlayer) == 0 && GetIgnoredExpansionPromiseValue(eLoopPlayer) == 0) ||
                (iIgnoredPromisePreValue != 0 && GetIgnoredExpansionPromiseValue(eLoopPlayer) == 0 && GetBrokenExpansionPromiseValue(eLoopPlayer) == 0))
            {
                SetPlayerMadeExpansionPromise(eLoopPlayer, false);
                SetPlayerBrokenExpansionPromise(eLoopPlayer, false);
                SetPlayerIgnoredExpansionPromise(eLoopPlayer, false);
            }

            iBrokenPromisePreValue = GetBrokenBorderPromiseValue(eLoopPlayer);
            ChangeBrokenBorderPromiseValue(eLoopPlayer, -GC.getBORDER_PROMISE_BROKEN_PER_TURN_DECAY());
            iIgnoredPromisePreValue = GetIgnoredBorderPromiseValue(eLoopPlayer);
            ChangeIgnoredBorderPromiseValue(eLoopPlayer, -GC.getBORDER_PROMISE_IGNORED_PER_TURN_DECAY());

            // if the promise penalty of breaking a promise has expired, reset the ability to ask the promise again
            if ((iBrokenPromisePreValue != 0 && GetBrokenBorderPromiseValue(eLoopPlayer) == 0 && GetIgnoredBorderPromiseValue(eLoopPlayer) == 0) ||
                (iIgnoredPromisePreValue != 0 && GetIgnoredBorderPromiseValue(eLoopPlayer) == 0 && GetBrokenBorderPromiseValue(eLoopPlayer) == 0))
            {
                SetPlayerMadeBorderPromise(eLoopPlayer, false);
                SetPlayerBrokenBorderPromise(eLoopPlayer, false);
                SetPlayerIgnoredBorderPromise(eLoopPlayer, false);
            }

            ChangeDeclaredWarOnFriendValue(eLoopPlayer, -GC.getDECLARED_WAR_ON_FRIEND_PER_TURN_DECAY());

            // Diplo Statement Log Counter
            for(iItem = 0; iItem < MAX_DIPLO_LOG_STATEMENTS; iItem++)
            {
                eStatement = GetDiploLogStatementTypeForIndex(eLoopPlayer, iItem);

                if(eStatement != NO_DIPLO_STATEMENT_TYPE)
                    ChangeDiploLogStatementTurnForIndex(eLoopPlayer, iItem, 1);
                else
                    SetDiploLogStatementTurnForIndex(eLoopPlayer, iItem, 0);
            }

            // Attacked Protected Minor Counter
            if(GetOtherPlayerProtectedMinorAttacked(eLoopPlayer) != NO_PLAYER)
                ChangeOtherPlayerTurnsSinceAttackedProtectedMinor(eLoopPlayer, 1);

            // Killed Protected Minor Counter
            if(GetOtherPlayerProtectedMinorKilled(eLoopPlayer) != NO_PLAYER)
                ChangeOtherPlayerTurnsSinceKilledProtectedMinor(eLoopPlayer, 1);

            // They sided with their Protected Minor Counter
            if(IsOtherPlayerSidedWithProtectedMinor(eLoopPlayer))
                ChangeOtherPlayerTurnsSinceSidedWithProtectedMinor(eLoopPlayer, 1);

            // Did this player ask us not to settle near them?
            if(GetPlayerNoSettleRequestCounter(eLoopPlayer) > -1)
            {
                ChangePlayerNoSettleRequestCounter(eLoopPlayer, 1);

                if(GetPlayerNoSettleRequestCounter(eLoopPlayer) >= /*50*/ GC.getIC_MEMORY_TURN_EXPIRATION())
                {
                    SetPlayerNoSettleRequestAccepted(eLoopPlayer, false);
                    SetPlayerNoSettleRequestCounter(eLoopPlayer, -666);
                }
            }

            // Did this player ask us to stop spying on them?
            if(GetPlayerStopSpyingRequestCounter(eLoopPlayer) > -1)
            {
                ChangePlayerStopSpyingRequestCounter(eLoopPlayer, 1);

                if(GetPlayerStopSpyingRequestCounter(eLoopPlayer) >= /*50*/ GC.getSTOP_SPYING_MEMORY_TURN_EXPIRATION())
                {
                    SetPlayerStopSpyingRequestAccepted(eLoopPlayer, false);
                    SetPlayerStopSpyingRequestCounter(eLoopPlayer, -666);
                }
            }

            // World Congress mood counters
            if (GetTurnsSinceWeLikedTheirProposal(eLoopPlayer) > -1)
            {
                ChangeTurnsSinceWeLikedTheirProposal(eLoopPlayer, 1);
            }
            if (GetTurnsSinceWeDislikedTheirProposal(eLoopPlayer) > -1)
            {
                ChangeTurnsSinceWeDislikedTheirProposal(eLoopPlayer, 1);
            }
            if (GetTurnsSinceTheySupportedOurProposal(eLoopPlayer) > -1)
            {
                ChangeTurnsSinceTheySupportedOurProposal(eLoopPlayer, 1);
            }
            if (GetTurnsSinceTheyFoiledOurProposal(eLoopPlayer) > -1)
            {
                ChangeTurnsSinceTheyFoiledOurProposal(eLoopPlayer, 1);
            }
            if (GetTurnsSinceTheySupportedOurHosting(eLoopPlayer) > -1)
            {
                ChangeTurnsSinceTheySupportedOurHosting(eLoopPlayer, 1);
            }

            // Did this player make a demand of us?
            if(GetDemandCounter(eLoopPlayer) > -1)
                ChangeDemandCounter(eLoopPlayer, 1);

            // DoF?
            if(GetDoFCounter(eLoopPlayer) > -1)
                ChangeDoFCounter(eLoopPlayer, 1);

            // Denounced?
            if(GetDenouncedPlayerCounter(eLoopPlayer) > -1)
                ChangeDenouncedPlayerCounter(eLoopPlayer, 1);

            // Are we ready to forget our denunciation?
            if(IsDenouncedPlayer(eLoopPlayer) && GetDenouncedPlayerCounter(eLoopPlayer) >= GC.getGame().getGameSpeedInfo().getRelationshipDuration())
            {
                SetDenouncedPlayer(eLoopPlayer, false);
                SetDenouncedPlayerCounter(eLoopPlayer, -1);
                // Let's become open to becoming friends again
                SetDoFCounter(eLoopPlayer, -1);

                // They no longer hate us either
                GET_PLAYER(eLoopPlayer).GetDiplomacyAI()->SetDoFCounter(GetPlayer()->GetID(), -1);
                GET_PLAYER(eLoopPlayer).GetDiplomacyAI()->SetFriendDenouncedUs(GetPlayer()->GetID(), false);

                for(iThirdPlayerLoop = 0; iThirdPlayerLoop < MAX_MAJOR_CIVS; iThirdPlayerLoop++){
                    eThirdPlayer = (PlayerTypes) iThirdPlayerLoop;

                    // We may even do co-op wars in the future
                    if(GetCoopWarCounter(eLoopPlayer, eThirdPlayer) < -1)
                        SetCoopWarCounter(eLoopPlayer, eThirdPlayer, -1);
                    GET_PLAYER(eLoopPlayer).GetDiplomacyAI()->SetCoopWarCounter(GetPlayer()->GetID(), eThirdPlayer, -1);
                }

                //Notify the target of the denouncement that it has expired.
                CvNotifications* pNotifications = GET_PLAYER(eLoopPlayer).GetNotifications();
                if(pNotifications){
                    CvString                            strSummary = GetLocalizedText("TXT_KEY_NOTIFICATION_THEIR_DENUNCIATION_EXPIRED_S");
                    Localization::String    strInfo = Localization::Lookup("TXT_KEY_NOTIFICATION_THEIR_DENUNCIATION_EXPIRED");
                    Localization::String strTemp = strInfo;
                    strTemp << GET_PLAYER(GetPlayer()->GetID()).getCivilizationShortDescriptionKey();
                    pNotifications->Add(NOTIFICATION_DENUNCIATION_EXPIRED, strTemp.toUTF8(), strSummary, -1, -1, GetPlayer()->GetID(), eLoopPlayer);
                }
            }

            // Has our Friendship expired?
            if(IsDoFAccepted(eLoopPlayer) && GetDoFCounter(eLoopPlayer) >= GC.getGame().getGameSpeedInfo().getRelationshipDuration())
            {
                SetDoFCounter(eLoopPlayer, -1);
                SetDoFAccepted(eLoopPlayer, false);

                GET_PLAYER(eLoopPlayer).GetDiplomacyAI()->SetDoFCounter(GetPlayer()->GetID(), -1);
                GET_PLAYER(eLoopPlayer).GetDiplomacyAI()->SetDoFAccepted(GetPlayer()->GetID(), false);

                //Notify both parties that our friendship has expired.
                CvNotifications* pNotifications = GET_PLAYER(eLoopPlayer).GetNotifications();
                if (pNotifications){
                    CvString strBuffer = GetLocalizedText("TXT_KEY_NOTIFICATION_FRIENDSHIP_EXPIRED", GET_PLAYER(GetPlayer()->GetID()).getCivilizationShortDescriptionKey());
                    CvString strSummary = GetLocalizedText("TXT_KEY_NOTIFICATION_FRIENDSHIP_EXPIRED_S");
                    pNotifications->Add(NOTIFICATION_FRIENDSHIP_EXPIRED, strBuffer, strSummary, -1, -1, GetPlayer()->GetID(), eLoopPlayer);
                }

                pNotifications = GET_PLAYER(GetPlayer()->GetID()).GetNotifications();
                if (pNotifications){
                    CvString strBuffer = GetLocalizedText("TXT_KEY_NOTIFICATION_FRIENDSHIP_EXPIRED", GET_PLAYER(eLoopPlayer).getCivilizationShortDescriptionKey());
                    CvString strSummary = GetLocalizedText("TXT_KEY_NOTIFICATION_FRIENDSHIP_EXPIRED_S");
                    pNotifications->Add(NOTIFICATION_FRIENDSHIP_EXPIRED, strBuffer, strSummary, -1, -1, eLoopPlayer, GetPlayer()->GetID());
                }
            } */
        }

        ///////////////////////////////
        // Declaration Log Counter
        ///////////////////////////////

        /*for(iItem = 0; iItem < MAX_DIPLO_LOG_STATEMENTS; iItem++)
        {
            eDeclaration = GetDeclarationLogTypeForIndex(iItem);

            if(eDeclaration != NO_PUBLIC_DECLARATION_TYPE)
            {
                ChangeDeclarationLogTurnForIndex(iItem, 1);
            }
            else
            {
                SetDeclarationLogTurnForIndex(iItem, 0);
            }
        }*/
    }

    func changeRecentTradeValue(with otherPlayer: AbstractPlayer?, by change: Int) {

        if change != 0 {

            self.playerDict.changeRecentTradeValue(with: otherPlayer, by: change)
            let maxOpinionValue = 10 /* DEAL_VALUE_PER_OPINION_WEIGHT */ * 30 /* OPINION_WEIGHT_TRADE_MAX*/

            // Must be between 0 and maximum possible boost to opinion
            if self.playerDict.recentTradeValue(with: otherPlayer) < 0 {
                self.playerDict.updateRecentTradeValue(with: otherPlayer, to: 0)
            } else if self.playerDict.recentTradeValue(with: otherPlayer) > maxOpinionValue {
                self.playerDict.updateRecentTradeValue(with: otherPlayer, to: maxOpinionValue)
            }
        }
    }

    // Anyone we want to chat with?
    func doContactMajorCivs(in gameModel: GameModel?) {

        // NOTE: This function is broken up into two sections: AI contact opportunities, and then human contact opportunities
        // This is to prevent a nasty bug where the AI will continue making decisions as the diplo screen is firing up. Making humans
        // handled at the end prevents the Diplo AI from having this problem

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        // Loop through AI Players
        for otherPlayer in gameModel.players {

            if player.isEqual(to: otherPlayer) || !otherPlayer.isAlive() || otherPlayer.isBarbarian() {
                continue
            }

            if !player.hasMet(with: otherPlayer) {
                continue
            }

            // No humans
            if otherPlayer.isHuman() {
                continue
            }

            self.doContact(player: otherPlayer, in: gameModel)
        }

        // Loop through HUMAN Players

        for otherPlayer in gameModel.players {

            if player.isEqual(to: otherPlayer) || !otherPlayer.isAlive() || otherPlayer.isBarbarian() {
                continue
            }

            if !player.hasMet(with: otherPlayer) {
                continue
            }

            // No AI
            if !otherPlayer.isHuman() {
                continue
            }

            self.doContact(player: otherPlayer, in: gameModel)
        }
    }

    //    Returns true if the target is valid to show a UI to immediately.
    //    This will return true if the source and destination are both AI.
    func isValidUIDiplomacyTarget(player otherPlayer: AbstractPlayer?) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if let otherPlayer = otherPlayer {

            if otherPlayer.leader != player.leader /* && !otherPlayer.isHuman() && !player.isHuman() */ {
                return true
            }
        }

        return false
    }

    /// Individual contact opportunity
    ///  player will evaluate, if he wants to contact otherPlayer in the end (by checking all possible topics)
    ///
    /// - Parameters
    ///     - otherPlayer:  player to check, if contact is wanted in the end
    ///     - gameModel: the game
    func doContact(player otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        print("\(player.leader) tries to contact \(otherPlayer.leader)")

        if !self.isValidUIDiplomacyTarget(player: otherPlayer) {
            return        // Can't contact the this player at the moment.
        }

        // int iDiploLogStatement;
        var statement: DiplomaticStatementType = .none

        // We can use this deal pointer to form a trade offer
        var deal: DiplomaticDeal = DiplomaticDeal(from: player.leader, to: otherPlayer.leader)

        // These can be used for info about deal items, e.g. what Minor Civ we're telling the guy to stay away from, etc.
        var leader: LeaderType = .none
        // int iData2;

        // If this is the same turn we've met a player, don't send anything his way quite yet - wait until we've said hello at least
        let turnsSinceMeeting = self.turnsSinceMeeting(with: otherPlayer, in: gameModel)
        if turnsSinceMeeting <= 0 {
            return
        }

        // Clear out the scratch pad
        /* for(int iLoop = 0; iLoop < NUM_DIPLO_LOG_STATEMENT_TYPES; iLoop++) {
            m_paDiploLogStatementTurnCountScratchPad[iLoop] = MAX_TURNS_SAFE_ESTIMATE;
        }*/

        // Make a scratch pad keeping track of the last time we sent each message.  This way we can know what we've said in the past already - this member array will be used in the function calls below
        /*for(iDiploLogStatement = 0; iDiploLogStatement < MAX_DIPLO_LOG_STATEMENTS; iDiploLogStatement++)
        {
            eStatement = GetDiploLogStatementTypeForIndex(ePlayer, iDiploLogStatement);

            if(eStatement != NO_DIPLO_STATEMENT_TYPE)
            {
                CvAssert(eStatement < NUM_DIPLO_LOG_STATEMENT_TYPES);

                m_paDiploLogStatementTurnCountScratchPad[eStatement] = GetDiploLogStatementTurnForIndex(ePlayer, iDiploLogStatement);
            }
        }

        eStatement = NO_DIPLO_STATEMENT_TYPE;

        iData1 = -1;
        iData2 = -1;

        pDeal->ClearItems();*/

        // JON: Add in some randomization here?
        // How predictable do we want the AI to be with regards to what state they're in?

        // Note that the order in which the following functions are called is very important to how the AI behaves - first come, first served

        // AT PEACE
        if !self.isAtWar(with: otherPlayer) {

            self.doCoopWarTimeStatement(with: otherPlayer, statement: &statement, data: &leader, in: gameModel)
            self.doCoopWarStatement(with: otherPlayer, statement: &statement, data: &leader, in: gameModel)

            // Some things we don't say to teammates
            /* if(GetPlayer()->getTeam() != GET_PLAYER(ePlayer).getTeam()) {
                
                DoMakeDemand(ePlayer, eStatement, pDeal);

                // STATEMENTS - all members but ePlayer passed by address
                DoAggressiveMilitaryStatement(ePlayer, eStatement);
                DoKilledCityStateStatement(ePlayer, eStatement, iData1);
                DoAttackedCityStateStatement(ePlayer, eStatement, iData1);
                DoBulliedCityStateStatement(ePlayer, eStatement, iData1);
                DoExpansionWarningStatement(ePlayer, eStatement);
                DoExpansionBrokenPromiseStatement(ePlayer, eStatement);
                DoPlotBuyingWarningStatement(ePlayer, eStatement);
                DoPlotBuyingBrokenPromiseStatement(ePlayer, eStatement);

                DoWeAttackedYourMinorStatement(ePlayer, eStatement, iData1);
                DoWeBulliedYourMinorStatement(ePlayer, eStatement, iData1);

                DoKilledYourSpyStatement(ePlayer, eStatement);
                DoKilledMySpyStatement(ePlayer, eStatement);
                DoCaughtYourSpyStatement(ePlayer, eStatement);

                DoTheySupportedOurHosting(ePlayer, eStatement);
                DoWeLikedTheirProposal(ePlayer, eStatement);
                DoWeDislikedTheirProposal(ePlayer, eStatement);
                DoTheySupportedOurProposal(ePlayer, eStatement);
                DoTheyFoiledOurProposal(ePlayer, eStatement);

                DoConvertedMyCityStatement(ePlayer, eStatement);

                DoDugUpMyYardStatement(ePlayer, eStatement);

                DoDoFStatement(ePlayer, eStatement);
                DoDenounceFriendStatement(ePlayer, eStatement);
                DoDenounceStatement(ePlayer, eStatement);
                DoRequestFriendDenounceStatement(ePlayer, eStatement, iData1);
            } */

            //    OFFERS - all members but ePlayer passed by address
            //self.doLuxuryTrade(ePlayer, statement, pDeal);
            self.doEmbassyExchange(with: otherPlayer, statement: &statement, deal: &deal, in: gameModel)
            self.doEmbassyOffer(with: otherPlayer, statement: &statement, deal: &deal, in: gameModel)
            self.doOpenBordersExchange(with: otherPlayer, statement: &statement, deal: &deal, in: gameModel)
            self.doOpenBordersOffer(with: otherPlayer, statement: &statement, deal: &deal, in: gameModel)
            /*self.doResearchAgreementOffer(ePlayer, eStatement, pDeal);
            self.doRenewExpiredDeal(ePlayer, eStatement, pDeal);
            self.doShareIntrigueStatement(ePlayer, eStatement);*/

            //self.doRequest(ePlayer, statement, deal)

            // Second set of things we don't say to teammates
            /*if(GetPlayer()->getTeam() != GET_PLAYER(ePlayer).getTeam())
            {
                DoHostileStatement(ePlayer, eStatement);
                DoAfraidStatement(ePlayer, eStatement);
                DoWarmongerStatement(ePlayer, eStatement);
                DoMinorCivCompetitionStatement(ePlayer, eStatement, iData1);

                // Don't bother with this fluff stuff it's just AI on AI stuff
                if(GET_PLAYER(ePlayer).isHuman())
                {
                    DoAngryBefriendedEnemy(ePlayer, eStatement, iData1);
                    DoAngryDenouncedFriend(ePlayer, eStatement, iData1);
                    DoHappyDenouncedEnemy(ePlayer, eStatement, iData1);
                    DoHappyBefriendedFriend(ePlayer, eStatement, iData1);
                    DoFYIBefriendedHumanEnemy(ePlayer, eStatement, iData1);
                    DoFYIDenouncedHumanFriend(ePlayer, eStatement, iData1);
                    DoFYIDenouncedHumanEnemy(ePlayer, eStatement, iData1);
                    DoFYIBefriendedHumanFriend(ePlayer, eStatement, iData1);
                    DoHappySamePolicyTree(ePlayer, eStatement);
                    DoIdeologicalStatement(ePlayer, eStatement);
                }
            }*/
        } else {
            // AT WAR
            //    OFFERS - all members but ePlayer passed by address
            //self.doPeaceOffer(with: otherPlayer, statement: &statement, deal: &deal, in: gameModel)
        }

        // Now see if it's a valid time to send this message (we may have already sent it)
        if statement != .none {

            //LogStatementToPlayer(ePlayer, eStatement);
            self.doSendStatement(to: otherPlayer, statement: statement, leader: leader, deal: deal, in: gameModel)
            //self.doAddNewStatementToLog(for: otherPlayer, statement: statement)
        }
    }

    // Say hi to someone else
    func doSendStatement(to otherPlayer: AbstractPlayer?, statement: DiplomaticStatementType, leader: LeaderType, deal: DiplomaticDeal, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        let otherLeader = otherPlayer.leader

        let human = otherPlayer.isHuman()
        let shouldShowLeaderScene = human

        /*if statement == .aggressiveMilitaryWarning {
            
            // Aggressive Military warning
            if shouldShowLeaderScene {
                if(IsActHostileTowardsHuman(ePlayer))
                    szText = GetDiploStringForMessage(DIPLO_MESSAGE_HOSTILE_AGGRESSIVE_MILITARY_WARNING);
                else
                    szText = GetDiploStringForMessage(DIPLO_MESSAGE_AGGRESSIVE_MILITARY_WARNING);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_AGGRESSIVE_MILITARY_WARNING, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        } else if statement == .killedProtectedCityState {
 
            // Player Killed a City State we're protecting
            if shouldShowLeaderScene {
                PlayerTypes eMinorCiv = (PlayerTypes) iData1;
                CvAssert(eMinorCiv != NO_PLAYER);
                if(eMinorCiv != NO_PLAYER)
                {
                    const char* strMinorCivKey = GET_PLAYER(eMinorCiv).getNameKey();

                    szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_KILLED_PROTECTED_CITY_STATE, NO_PLAYER, strMinorCivKey);
                    CvDiplomacyRequests::    (GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
                }
            }
        } else if statement == DIPLO_STATEMENT_ATTACKED_PROTECTED_CITY_STATE {
            
            // Player Attacked a City State we're protecting
            if shouldShowLeaderScene {
                PlayerTypes eMinorCiv = (PlayerTypes) iData1;
                CvAssert(eMinorCiv != NO_PLAYER);
                if(eMinorCiv != NO_PLAYER)
                {
                    const char* strMinorCivKey = GET_PLAYER(eMinorCiv).getNameKey();

                    szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_ATTACKED_PROTECTED_CITY_STATE, NO_PLAYER, strMinorCivKey);
                    self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_YOU_ATTACKED_MINOR_CIV, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
                }
            }
        } else if statement == DIPLO_STATEMENT_BULLIED_PROTECTED_CITY_STATE {
 
            // Player Bullied a City State we're protecting
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eMinorCiv = (PlayerTypes) iData1;
                CvAssert(eMinorCiv != NO_PLAYER);
                if(eMinorCiv != NO_PLAYER)
                {
                    const char* strMinorCivKey = GET_PLAYER(eMinorCiv).getNameKey();

                    szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_BULLIED_PROTECTED_CITY_STATE, NO_PLAYER, strMinorCivKey);
                    self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_YOU_BULLIED_MINOR_CIV, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
                }
            }
        } else if statement == DIPLO_STATEMENT_EXPANSION_SERIOUS_WARNING {
            
            // Serious Expansion warning
            if shouldShowLeaderScene {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_EXPANSION_SERIOUS_WARNING);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_SERIOUS_WARNING, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_EXPANSION_WARNING {
 
            // Expansion warning
            if shouldShowLeaderScene {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_EXPANSION_WARNING);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_WARNING, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_EXPANSION_BROKEN_PROMISE {
 
            // Expansion Broken Promise
            if shouldShowLeaderScene {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_EXPANSION_BROKEN_PROMISE);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_PLOT_BUYING_SERIOUS_WARNING {
 
            // Serious Plot Buying warning
            if shouldShowLeaderScene {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_PLOT_BUYING_SERIOUS_WARNING);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_SERIOUS_WARNING, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_PLOT_BUYING_WARNING {
 
            // Plot Buying warning
            if shouldShowLeaderScene {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_PLOT_BUYING_WARNING);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_WARNING, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_PLOT_BUYING_BROKEN_PROMISE {
 
            // Plot Buying broken promise
            if shouldShowLeaderScene {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_PLOT_BUYING_BROKEN_PROMISE);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_WE_ATTACKED_YOUR_MINOR {
 
            // We attacked a Minor someone has a PtP with
            if shouldShowLeaderScene {
                PlayerTypes eMinorCiv = (PlayerTypes) iData1;
                CvAssert(eMinorCiv != NO_PLAYER);
                if(eMinorCiv != NO_PLAYER)
                {
                    const char* strMinorCivKey = GET_PLAYER(eMinorCiv).getNameKey();
                    if(IsActHostileTowardsHuman(ePlayer))
                        szText = GetDiploStringForMessage(DIPLO_MESSAGE_HOSTILE_WE_ATTACKED_YOUR_MINOR, NO_PLAYER, strMinorCivKey);
                    else
                        szText = GetDiploStringForMessage(DIPLO_MESSAGE_WE_ATTACKED_YOUR_MINOR, NO_PLAYER, strMinorCivKey);

                    self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_I_ATTACKED_YOUR_MINOR_CIV, szText, LEADERHEAD_ANIM_POSITIVE, eMinorCiv);

                    // Extra flag, since diplo log does not save which minor civ the message was about
                    SetSentAttackProtectedMinorTaunt(ePlayer, eMinorCiv, true);
                }
            }
        } else if(eStatement == DIPLO_STATEMENT_WE_BULLIED_YOUR_MINOR {
 
            // We bullied a Minor someone has a PtP with
            if shouldShowLeaderScene {
                PlayerTypes eMinorCiv = (PlayerTypes) iData1;
                CvAssert(eMinorCiv != NO_PLAYER);
                if (eMinorCiv != NO_PLAYER)
                {
                    const char* strMinorCivKey = GET_PLAYER(eMinorCiv).getNameKey();
                    if(IsActHostileTowardsHuman(ePlayer))
                        szText = GetDiploStringForMessage(DIPLO_MESSAGE_HOSTILE_WE_BULLIED_YOUR_MINOR, NO_PLAYER, strMinorCivKey);
                    else
                        szText = GetDiploStringForMessage(DIPLO_MESSAGE_WE_BULLIED_YOUR_MINOR, NO_PLAYER, strMinorCivKey);

                    self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_I_BULLIED_YOUR_MINOR_CIV, szText, LEADERHEAD_ANIM_POSITIVE, eMinorCiv);
                }
            }
        } else if statement == DIPLO_STATEMENT_WORK_WITH_US {
 
            // We'd like to work with a player
            // Send message to human
            if shouldShowLeaderScene {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_WORK_WITH_US);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_WORK_WITH_US, szText, LEADERHEAD_ANIM_REQUEST);
            } else if !bHuman {
                // AI resolution
                SetDoFCounter(ePlayer, 0);
                GET_PLAYER(ePlayer).GetDiplomacyAI()->SetDoFCounter(GetPlayer()->GetID(), 0);

                // Accept - reject is assumed from the counter
                if(GET_PLAYER(ePlayer).GetDiplomacyAI()->IsDoFAcceptable(GetPlayer()->GetID()))
                {
                    SetDoFAccepted(ePlayer, true);
                    GET_PLAYER(ePlayer).GetDiplomacyAI()->SetDoFAccepted(GetPlayer()->GetID(), true);

                    LogDoF(ePlayer);
                }
            }
        } else if statement == DIPLO_STATEMENT_END_WORK_WITH_US {
 
            // We no longer want to work with a player
            SetDoFAccepted(ePlayer, false);
            SetDoFCounter(ePlayer, -666);

            // If we had agreed to not settle near the player, break that off
            SetPlayerNoSettleRequestAccepted(ePlayer, false);
            SetPlayerNoSettleRequestCounter(ePlayer, -666);

            // If we had agreed to not spy on the player, break that off
            SetPlayerStopSpyingRequestAccepted(ePlayer, false);
            SetPlayerStopSpyingRequestCounter(ePlayer, -666);

            // Send message to human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_END_WORK_WITH_US, ePlayer);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
            else if(!bHuman)
            {
                GET_PLAYER(ePlayer).GetDiplomacyAI()->SetDoFAccepted(GetPlayer()->GetID(), false);
                GET_PLAYER(ePlayer).GetDiplomacyAI()->SetDoFCounter(GetPlayer()->GetID(), -666);
            }
        } else if statement == DIPLO_STATEMENT_DENOUNCE {
 
            // Denounce
            DoDenouncePlayer(ePlayer);
            LogDenounce(ePlayer);

            // Send message to human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_WORK_AGAINST_SOMEONE, ePlayer);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_DENOUNCE_FRIEND {
 
            // Denounce Friend (backstab)
            DoDenouncePlayer(ePlayer);
            LogDenounce(ePlayer, /*bBackstab*/ true);

            // Send message to human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_AI_DOF_BACKSTAB, ePlayer);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        } else if statement == DIPLO_STATEMENT_REQUEST_FRIEND_DENOUNCE {
 
            // Request Friend Denounce Someone
            PlayerTypes eTarget = (PlayerTypes) iData1;
            CvAssert(eTarget != NO_PLAYER);
            if(eTarget != NO_PLAYER)
            {
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();

                // Send message to human
                if(bShouldShowLeaderScene)
                {
                    szText = GetDiploStringForMessage(DIPLO_MESSAGE_DOF_AI_DENOUNCE_REQUEST, ePlayer, strTargetCivKey);

                    self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_AI_REQUEST_DENOUNCE, szText, LEADERHEAD_ANIM_POSITIVE, eTarget);
                }
                else if(!bHuman)
                {
                    bool bAgree = IsDenounceAcceptable(eTarget, /*bBias*/ true);

                    LogFriendRequestDenounce(ePlayer, eTarget, bAgree);

                    if(bAgree)
                    {
                        GET_PLAYER(ePlayer).GetDiplomacyAI()->DoDenouncePlayer(eTarget);
                        GET_PLAYER(ePlayer).GetDiplomacyAI()->LogDenounce(eTarget);

                        // Denounced a human?
                        if(eTarget == GC.getGame().getActivePlayer())
                        {
                            szText = GetDiploStringForMessage(DIPLO_MESSAGE_WORK_AGAINST_SOMEONE, eTarget);
                            self.player?.diplomacyRequests?.sendRequest(for:ePlayer, eTarget, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
                        }
                    }
                    else
                    {
                        // Oh, you're gonna say no, are you?
                        if(IsFriendDenounceRefusalUnacceptable(ePlayer, eTarget))
                        {
                            DoDenouncePlayer(ePlayer);
                            LogDenounce(ePlayer, /*bBackstab*/ false, /*bRefusal*/ true);
                        }
                    }
                }
            }
         } else */ if statement == .coopWarRequest {

            // We'd like to declare war on someone
            if let againstPlayer = gameModel.player(for: leader) {

                if shouldShowLeaderScene {

                    // Send message to human
                    //let szText = DiplomaticRequestMessage.coopWarRequest.diploStringForMessage(for: self.player, and: againstPlayer)
                    self.player?.diplomacyRequests?.sendRequest(for: otherLeader, state: .discussCoopWar, message: .coopWarRequest, emotion: .positive, in: gameModel)

                } else if !human {

                    // AI resolution
                    /*SetCoopWarCounter(ePlayer, eAgainstPlayer, 0);
                    GET_PLAYER(ePlayer).GetDiplomacyAI()->SetCoopWarCounter(GetPlayer()->GetID(), eAgainstPlayer, 0);

                    // Will they agree?
                    CoopWarStates eAcceptedState = GET_PLAYER(ePlayer).GetDiplomacyAI()->GetWillingToAgreeToCoopWarState(GetPlayer()->GetID(), eAgainstPlayer);
                    GET_PLAYER(ePlayer).GetDiplomacyAI()->SetCoopWarAcceptedState(GetPlayer()->GetID(), eAgainstPlayer, eAcceptedState);

                    if(eAcceptedState == COOP_WAR_STATE_ACCEPTED)
                    {
                        DeclareWar(eAgainstPlayer);
                        GetPlayer()->GetMilitaryAI()->RequestBasicAttack(eAgainstPlayer, 1);

                        GET_PLAYER(ePlayer).GetDiplomacyAI()->DeclareWar(eAgainstPlayer);
                        GET_PLAYER(ePlayer).GetMilitaryAI()->RequestBasicAttack(eAgainstPlayer, 1);

                        int iLockedTurns = /*15*/ GC.getCOOP_WAR_LOCKED_LENGTH();
                        GET_TEAM(GetPlayer()->getTeam()).ChangeNumTurnsLockedIntoWar(GET_PLAYER(eAgainstPlayer).getTeam(), iLockedTurns);
                        GET_TEAM(GET_PLAYER(ePlayer).getTeam()).ChangeNumTurnsLockedIntoWar(GET_PLAYER(eAgainstPlayer).getTeam(), iLockedTurns);
                    }

                    LogCoopWar(ePlayer, eAgainstPlayer, eAcceptedState);

                    // If the other player didn't agree then we don't need to change our state from what it was (NO_STATE)
                    if(eAcceptedState != COOP_WAR_STATE_REJECTED) {
                        SetCoopWarAcceptedState(ePlayer, eAgainstPlayer, eAcceptedState);
                    } */
                }
            }
        } else if statement == .coopWarTime {

            // We'd like to declare war on someone (not us, not other)
            if let againstPlayer = gameModel.player(for: leader) {

                // Send message to human
                if shouldShowLeaderScene {
                    //let szText = DiplomaticRequestMessage.coopWarTime.diploStringForMessage(for: self.player, and: againstPlayer)

                    self.player?.diplomacyRequests?.sendRequest(for: otherLeader, state: .discussCoopWarTime, message: .coopWarTime, emotion: .positive, in: gameModel)

                    //self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_COOP_WAR_TIME, szText, LEADERHEAD_ANIM_POSITIVE, eAgainstPlayer);
                }
            }

            // No AI resolution! This is handled automatically in DoCounters() - no need for diplo exchange
        }

        // We're making a demand of Player
        /*else if(eStatement == DIPLO_STATEMENT_DEMAND)
        {
            // Active human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_DEMAND);
                CvDiplomacyRequests::SendDealRequest(GetPlayer()->GetID(), ePlayer, pDeal, DIPLO_UI_STATE_TRADE_AI_MAKES_DEMAND, szText, LEADERHEAD_ANIM_DEMAND);
            }
            // AI player
            else if(!bHuman)
            {
                // For now the AI will always give in

                CvDeal kDeal = *pDeal;

                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);
            }
        }

        // We're making a request of Player
        else if(eStatement == DIPLO_STATEMENT_REQUEST)
        {
            // Active human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_REQUEST);
                CvDiplomacyRequests::SendDealRequest(GetPlayer()->GetID(), ePlayer, pDeal, DIPLO_UI_STATE_TRADE_AI_MAKES_REQUEST, szText, LEADERHEAD_ANIM_REQUEST);
            }
            // AI player
            else if(!bHuman)
            {
                // For now the AI will always give in - may eventually write additional logic here

                CvDeal kDeal = *pDeal;

                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);
            }
        }

        // Player has a Luxury we'd like
        else if(eStatement == DIPLO_STATEMENT_LUXURY_TRADE)
        {
            // Active human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_LUXURY_TRADE);
                CvDiplomacyRequests::SendDealRequest(GetPlayer()->GetID(), ePlayer, pDeal, DIPLO_UI_STATE_TRADE_AI_MAKES_OFFER, szText, LEADERHEAD_ANIM_REQUEST);
            }
            // Offer to an AI player
            else if(!bHuman)
            {
                CvDeal kDeal = *pDeal;

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);
            }
        }

        
         else*/ if statement == .embassyExchange /* DIPLO_STATEMENT_EMBASSY_EXCHANGE*/ {
            // Offer Embassy Exchange
            if shouldShowLeaderScene {
                //let szText = DiplomaticRequestMessage.embassyExchange.diploStringForMessage(for: self.player)
                self.player?.diplomacyRequests?.sendDealRequest(for: otherLeader, deal: deal, state: .tradeAIMakesOffer, message: .embassyExchange, emotion: .request, in: gameModel)
            } else if !human {

                fatalError("not handled")
                //CvDeal kDeal = *pDeal;

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                //GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                //GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);
            }
        } else if statement == .embassyOffer {

            // Offer Embassy
            if shouldShowLeaderScene {
                //let szText = DiplomaticRequestMessage.embassyOffer.diploStringForMessage(for: self.player)
                self.player?.diplomacyRequests?.sendDealRequest(for: otherLeader, deal: deal, state: .tradeAIMakesOffer, message: .embassyOffer, emotion: .request, in: gameModel)
            } else if !human {
                fatalError("not handled")
                /*CvDeal kDeal = *pDeal;

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);*/
            }
        } else if statement == .openBorderExchange {

            // Offer Open Borders Exchange
            if shouldShowLeaderScene {
                // Active human
                //let szText = DiplomaticRequestMessage.openBordersExchange.diploStringForMessage(for: self.player)
                self.player?.diplomacyRequests?.sendDealRequest(for: otherLeader, deal: deal, state: .tradeAIMakesOffer, message: .openBordersExchange, emotion: .request, in: gameModel)
            } else if !human {
                fatalError("not handled")
                // Offer to an AI player
                /*CvDeal kDeal = *pDeal;

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal)
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true)*/
            }
         } else if statement == .openBorderOffer {

            // Offer Open Borders
            if shouldShowLeaderScene {
                // Active human
                //let szText = DiplomaticRequestMessage.openBordersOffer.diploStringForMessage(for: self.player)
                self.player?.diplomacyRequests?.sendDealRequest(for: otherLeader, deal: deal, state: .tradeAIMakesOffer, message: .openBordersOffer, emotion: .request, in: gameModel)

            } else if !human {
                // Offer to an AI player
                fatalError("not handled")
                /*CvDeal kDeal = *pDeal;

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);*/
            }
        }

        // Offer plans to make Research Agreement
        /*else if(eStatement == DIPLO_STATEMENT_PLAN_RESEARCH_AGREEMENT)
        {
            // Active human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_PLAN_RESEARCH_AGREEMENT);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_DISCUSS_PLAN_RESEARCH_AGREEMENT, szText, LEADERHEAD_ANIM_REQUEST);
            }
            // Offer to an AI player
            else if(!bHuman)
            {
                if(!GET_PLAYER(ePlayer).GetDiplomacyAI()->IsWantsResearchAgreementWithPlayer(GetPlayer()->GetID()))
                    GET_PLAYER(ePlayer).GetDiplomacyAI()->DoAddWantsResearchAgreementWithPlayer(GetPlayer()->GetID());    // just auto-reciprocate right now
            }
        }

        // Offer Research Agreement
        else if(eStatement == DIPLO_STATEMENT_RESEARCH_AGREEMENT_OFFER)
        {
            // Active human
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_RESEARCH_AGREEMENT_OFFER);
                CvDiplomacyRequests::SendDealRequest(GetPlayer()->GetID(), ePlayer, pDeal, DIPLO_UI_STATE_TRADE_AI_MAKES_OFFER, szText, LEADERHEAD_ANIM_REQUEST);
            }
            // Offer to an AI player
            else if(!bHuman)
            {
                CvDeal kDeal = *pDeal;

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);
            }
        }

        // Offer to renew deal
        else if(eStatement == DIPLO_STATEMENT_RENEW_DEAL)
        {
            // Active human
            if(bShouldShowLeaderScene)
            {
                int iDealValueToMe, iValueImOffering, iValueTheyreOffering, iAmountOverWeWillRequest, iAmountUnderWeWillOffer;
                DiploMessageTypes eMessageType = NUM_DIPLO_MESSAGE_TYPES;
                bool bCantMatchOffer;
                bool bDealAcceptable = m_pPlayer->GetDealAI()->IsDealWithHumanAcceptable(pDeal, ePlayer, iDealValueToMe, iValueImOffering, iValueTheyreOffering, iAmountOverWeWillRequest, iAmountUnderWeWillOffer, bCantMatchOffer);

                if(!bDealAcceptable)
                {
                    if(iValueTheyreOffering > iValueImOffering)
                    {
                        bDealAcceptable = true;
                    }
                }

                if(bDealAcceptable)
                {
                    eMessageType = DIPLO_MESSAGE_RENEW_DEAL;
                }
                // We want more from this Deal
                else if(iDealValueToMe > -75 &&
                        iValueImOffering < (iValueTheyreOffering * 5))    // The total value of the deal might not be that bad, but if he's asking for WAY more than he's offering (e.g. something for nothing) then it's not unacceptable, but insulting
                {
                    eMessageType = DIPLO_MESSAGE_WANT_MORE_RENEW_DEAL;
                }
                else
                {
                    CvDeal* pRenewDeal = GetDealToRenew();
                    if (pRenewDeal)
                    {
                        pRenewDeal->m_bCheckedForRenewal = true;
                    }
                    ClearDealToRenew();
                }

                if(eMessageType != NUM_DIPLO_MESSAGE_TYPES)
                {
                    CvDeal* pRenewDeal = GetDealToRenew();
                    if (pRenewDeal)
                    {
                        pRenewDeal->m_bCheckedForRenewal = true;
                    }
                    szText = GetDiploStringForMessage(eMessageType);
                    CvDiplomacyRequests::SendDealRequest(GetPlayer()->GetID(), ePlayer, pDeal, DIPLO_UI_STATE_TRADE_AI_MAKES_OFFER, szText, LEADERHEAD_ANIM_REQUEST);
                }
            }
            // Offer to an AI player
            else if(!bHuman)
            {
                CvDeal kDeal = *pDeal;
                int iDealType = -1;
                CvDeal* pRenewedDeal = m_pPlayer->GetDiplomacyAI()->GetDealToRenew(&iDealType);
                if(pRenewedDeal)
                {
                    if (iDealType != 0) // this is not a historic deal, so don't change the resource allocations
                    {
                        CvGameDeals::PrepareRenewDeal(m_pPlayer->GetDiplomacyAI()->GetDealToRenew(), &kDeal);
                    }
                    pRenewedDeal->m_bCheckedForRenewal = true;
                    m_pPlayer->GetDiplomacyAI()->ClearDealToRenew();
                }

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);
            }
        }

        // They're now unforgivable
        else if(eStatement == DIPLO_STATEMENT_NOW_UNFORGIVABLE)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_NOW_UNFORGIVABLE);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // They're now an enemy
        else if(eStatement == DIPLO_STATEMENT_NOW_ENEMY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_NOW_ENEMY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // They caught one of our spies
        else if(eStatement == DIPLO_STATEMENT_CAUGHT_YOUR_SPY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_CAUGHT_YOUR_SPY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_CAUGHT_YOUR_SPY, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // They killed one of our spies
        else if(eStatement == DIPLO_STATEMENT_KILLED_YOUR_SPY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_KILLED_YOUR_SPY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_KILLED_YOUR_SPY, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }

        // We killed one of their spies
        else if(eStatement == DIPLO_STATEMENT_KILLED_MY_SPY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_KILLED_MY_SPY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_KILLED_MY_SPY, szText, LEADERHEAD_ANIM_DEFEATED);
            }
        }

        // We (the AI) have intrigue information to share with them
        else if(eStatement == DIPLO_STATEMENT_SHARE_INTRIGUE)
        {
            IntrigueNotificationMessage* pNotificationMessage = GetPlayer()->GetEspionage()->GetRecentIntrigueInfo(ePlayer);
            CvAssertMsg(pNotificationMessage, "pNotificationMessage is null. Whut?");
            if (pNotificationMessage)
            {
                CvAssertMsg(pNotificationMessage->m_eSourcePlayer != NO_PLAYER, "There is no plotter! What's going on");
                PlayerTypes ePlotterPlayer = pNotificationMessage->m_eSourcePlayer;
                CvIntrigueType eIntrigueType = (CvIntrigueType)pNotificationMessage->m_iIntrigueType;
                // don't share intrigue about two parties if they are already at war
                if (!GET_TEAM(GET_PLAYER(ePlayer).getTeam()).isAtWar(GET_PLAYER(ePlotterPlayer).getTeam()))
                {
                    CvCity* pCity = NULL;
                    if(pNotificationMessage->m_iCityX != -1 && pNotificationMessage->m_iCityY != -1)
                    {
                        CvPlot* pPlot = GC.getMap().plot(pNotificationMessage->m_iCityX, pNotificationMessage->m_iCityY);
                        if(pPlot)
                        {
                            pCity = pPlot->getPlotCity();
                        }
                    }

                    // add the notification to the
                    GET_PLAYER(ePlayer).GetEspionage()->AddIntrigueMessage(m_pPlayer->GetID(), ePlotterPlayer, ePlayer, NO_BUILDING, NO_PROJECT, eIntrigueType, 0, pCity, false);

                    if(bShouldShowLeaderScene)
                    {
                        const char* szPlayerName;
                        if(GC.getGame().isGameMultiPlayer() && GET_PLAYER(ePlotterPlayer).isHuman())
                        {
                            szPlayerName = GET_PLAYER(ePlotterPlayer).getNickName();
                        }
                        else
                        {
                            szPlayerName = GET_PLAYER(ePlotterPlayer).getNameKey();
                        }

                        szText = "";

                        switch(eIntrigueType)
                        {
                        case INTRIGUE_TYPE_ARMY_SNEAK_ATTACK:
                            if(pCity)
                            {
                                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SHARE_INTRIGUE_ARMY_SNEAK_ATTACK_KNOWN_CITY, NO_PLAYER, szPlayerName, pCity->getNameKey());
                            }
                            else
                            {
                                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SHARE_INTRIGUE_ARMY_SNEAK_ATTACK_UNKNOWN_CITY, NO_PLAYER, szPlayerName);
                            }
                            break;
                        case INTRIGUE_TYPE_AMPHIBIOUS_SNEAK_ATTACK:
                            if(pCity)
                            {
                                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SHARE_INTRIGUE_AMPHIBIOUS_SNEAK_ATTACK_KNOWN_CITY, NO_PLAYER, szPlayerName, pCity->getNameKey());
                            }
                            else
                            {
                                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SHARE_INTRIGUE_AMPHIBIOUS_SNEAK_ATTACK_UNKNOWN_CITY, NO_PLAYER, szPlayerName);
                            }
                            break;
                        case INTRIGUE_TYPE_DECEPTION:
                            szText = GetDiploStringForMessage(DIPLO_MESSAGE_SHARE_INTRIGUE, NO_PLAYER, szPlayerName);
                            break;
                        default:
                            CvAssertMsg(false, "Unknown intrigue type");
                            break;
                        }

                        self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
                    }

                }

                // mark the messages as shared so the player isn't told the same thing repeatedly
                for(uint ui = 0; ui < MAX_MAJOR_CIVS; ui++)
                {
                    PlayerTypes eLoopPlayer = (PlayerTypes)ui;
                    GET_PLAYER(eLoopPlayer).GetEspionage()->MarkRecentIntrigueAsShared(ePlayer, ePlotterPlayer, eIntrigueType);
                }
            }
        }

        // Stop converting our cities
        else if(eStatement == DIPLO_STATEMENT_STOP_CONVERSIONS)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_STOP_CONVERSIONS);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_STOP_CONVERSIONS, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }

        // Stop digging up our yard
        else if(eStatement == DIPLO_STATEMENT_STOP_DIGGING)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_STOP_DIGGING);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_STOP_DIGGING, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }

        // Insult
        else if(eStatement == DIPLO_STATEMENT_INSULT)
        {
            // Change other players' guess as to our Approach (right now it falls in line exactly with the Approach...)
            GET_PLAYER(ePlayer).GetDiplomacyAI()->SetApproachTowardsUsGuess(GetPlayer()->GetID(), MAJOR_CIV_APPROACH_HOSTILE);
            GET_PLAYER(ePlayer).GetDiplomacyAI()->SetApproachTowardsUsGuessCounter(GetPlayer()->GetID(), 0);

            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_INSULT_ROOT);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // Compliment
        else if(eStatement == DIPLO_STATEMENT_COMPLIMENT)
        {
            // Change other players' guess as to our Approach (right now it falls in line exactly with the Approach...)
            GET_PLAYER(ePlayer).GetDiplomacyAI()->SetApproachTowardsUsGuess(GetPlayer()->GetID(), MAJOR_CIV_APPROACH_FRIENDLY);
            GET_PLAYER(ePlayer).GetDiplomacyAI()->SetApproachTowardsUsGuessCounter(GetPlayer()->GetID(), 0);

            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_COMPLIMENT);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        // Boot-kissing of a stronger power
        else if(eStatement == DIPLO_STATEMENT_BOOT_KISSING)
        {
            // Change other players' guess as to our Approach (right now it falls in line exactly with the Approach...)
            GET_PLAYER(ePlayer).GetDiplomacyAI()->SetApproachTowardsUsGuess(GetPlayer()->GetID(), MAJOR_CIV_APPROACH_AFRAID);
            GET_PLAYER(ePlayer).GetDiplomacyAI()->SetApproachTowardsUsGuessCounter(GetPlayer()->GetID(), 0);

            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_BOOT_KISSING);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        // We're warning a player his warmongering behavior is attracting attention
        else if(eStatement == DIPLO_STATEMENT_WARMONGER)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_WARMONGER);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // We're warning a player his interactions with city states is not to our liking
        else if(eStatement == DIPLO_STATEMENT_MINOR_CIV_COMPETITION)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eMinorCiv = (PlayerTypes) iData1;
                const char* strMinorCivKey = GET_PLAYER(eMinorCiv).getNameKey();

                szText = GetDiploStringForMessage(DIPLO_MESSAGE_MINOR_CIV_COMPETITION, NO_PLAYER, strMinorCivKey);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }

        // Human befriended an enemy of this AI!
        else if(eStatement == DIPLO_STATEMENT_ANGRY_BEFRIEND_ENEMY)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DOFED_ENEMY, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // Human denounced a friend of this AI!
        else if(eStatement == DIPLO_STATEMENT_ANGRY_DENOUNCED_FRIEND)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DENOUNCED_FRIEND, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // Human denounced an enemy of this AI!
        else if(eStatement == DIPLO_STATEMENT_HAPPY_DENOUNCED_ENEMY)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DENOUNCED_ENEMY, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        // Human befriended a friend of this AI!
        else if(eStatement == DIPLO_STATEMENT_HAPPY_BEFRIENDED_FRIEND)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DOFED_FRIEND, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        // AI befriended an enemy of the human!
        else if(eStatement == DIPLO_STATEMENT_FYI_BEFRIEND_HUMAN_ENEMY)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DENOUNCE_SO_AI_DOF, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // AI denounced a friend of the human!
        else if(eStatement == DIPLO_STATEMENT_FYI_DENOUNCED_HUMAN_FRIEND)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DOF_SO_AI_DENOUNCE, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI, szText, LEADERHEAD_ANIM_HATE_NEGATIVE);
            }
        }

        // AI denounced an enemy of the human!
        else if(eStatement == DIPLO_STATEMENT_FYI_DENOUNCED_HUMAN_ENEMY)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DENOUNCE_SO_AI_DENOUNCE, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        // AI befriended a friend of the human!
        else if(eStatement == DIPLO_STATEMENT_FYI_BEFRIEND_HUMAN_FRIEND)
        {
            if(bShouldShowLeaderScene)
            {
                PlayerTypes eTarget = (PlayerTypes) iData1;
                const char* strTargetCivKey = GET_PLAYER(eTarget).getCivilizationShortDescriptionKey();
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_HUMAN_DOF_SO_AI_DOF, ePlayer, strTargetCivKey);

                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        // AI chose same late game policy tree!
        else if(eStatement == DIPLO_STATEMENT_SAME_POLICIES_FREEDOM)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SAME_POLICIES_FREEDOM);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        else if(eStatement == DIPLO_STATEMENT_SAME_POLICIES_ORDER)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SAME_POLICIES_ORDER);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        else if(eStatement == DIPLO_STATEMENT_SAME_POLICIES_AUTOCRACY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SAME_POLICIES_AUTOCRACY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        else if(eStatement == DIPLO_STATEMENT_WE_LIKED_THEIR_PROPOSAL)
        {
            if(bShouldShowLeaderScene)
            {
                Localization::String sLeagueName = Localization::Lookup("TXT_KEY_LEAGUE_WORLD_CONGRESS_GENERIC");
                CvLeague* pLeague = GC.getGame().GetGameLeagues()->GetActiveLeague();
                if (pLeague != NULL)
                {
                    sLeagueName = pLeague->GetName();
                }
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_WE_LIKED_THEIR_PROPOSAL, ePlayer, sLeagueName);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        else if(eStatement == DIPLO_STATEMENT_WE_DISLIKED_THEIR_PROPOSAL)
        {
            if(bShouldShowLeaderScene)
            {
                Localization::String sLeagueName = Localization::Lookup("TXT_KEY_LEAGUE_WORLD_CONGRESS_GENERIC");
                CvLeague* pLeague = GC.getGame().GetGameLeagues()->GetActiveLeague();
                if (pLeague != NULL)
                {
                    sLeagueName = pLeague->GetName();
                }
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_WE_DISLIKED_THEIR_PROPOSAL, ePlayer, sLeagueName);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }

        else if(eStatement == DIPLO_STATEMENT_THEY_SUPPORTED_OUR_PROPOSAL)
        {
            if(bShouldShowLeaderScene)
            {
                Localization::String sLeagueName = Localization::Lookup("TXT_KEY_LEAGUE_WORLD_CONGRESS_GENERIC");
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_THEY_SUPPORTED_OUR_PROPOSAL, ePlayer, sLeagueName);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        else if(eStatement == DIPLO_STATEMENT_THEY_FOILED_OUR_PROPOSAL)
        {
            if(bShouldShowLeaderScene)
            {
                Localization::String sLeagueName = Localization::Lookup("TXT_KEY_LEAGUE_WORLD_CONGRESS_GENERIC");
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_THEY_FOILED_OUR_PROPOSAL, ePlayer, sLeagueName);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }

        else if(eStatement == DIPLO_STATEMENT_THEY_SUPPORTED_OUR_HOSTING)
        {
            if(bShouldShowLeaderScene)
            {
                Localization::String sLeagueName = Localization::Lookup("TXT_KEY_LEAGUE_WORLD_CONGRESS_GENERIC");
                CvLeague* pLeague = GC.getGame().GetGameLeagues()->GetActiveLeague();
                if (pLeague != NULL)
                {
                    sLeagueName = pLeague->GetName();
                }
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_THEY_SUPPORTED_OUR_HOSTING, ePlayer, sLeagueName);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }

        // Ideological statements
        else if(eStatement == DIPLO_STATEMENT_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_YOUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_FREEDOM);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_ORDER);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_OUR_IDEOLOGY_CAUSING_CIVIL_UNREST_AUTOCRACY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_SWITCH_OUR_IDEOLOGY_FREEDOM)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SWITCH_OUR_IDEOLOGY_FREEDOM);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_SWITCH_OUR_IDEOLOGY_ORDER)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SWITCH_OUR_IDEOLOGY_ORDER);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_SWITCH_OUR_IDEOLOGY_AUTOCRACY)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_SWITCH_OUR_IDEOLOGY_AUTOCRACY);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_YOUR_CULTURE_INFLUENTIAL)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_YOUR_CULTURE_INFLUENTIAL);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_NEGATIVE);
            }
        }
        else if(eStatement == DIPLO_STATEMENT_OUR_CULTURE_INFLUENTIAL)
        {
            if(bShouldShowLeaderScene)
            {
                szText = GetDiploStringForMessage(DIPLO_MESSAGE_OUR_CULTURE_INFLUENTIAL);
                self.player?.diplomacyRequests?.sendRequest(for:GetPlayer()->GetID(), ePlayer, DIPLO_UI_STATE_BLANK_DISCUSSION, szText, LEADERHEAD_ANIM_POSITIVE);
            }
        } else*/
        if statement == .requestPeace {

            // Do we want peace with ePlayer?
            if shouldShowLeaderScene {

                // Active human
                //let szText = DiplomaticRequestMessage.peaceOffer.diploStringForMessage(for: nil)
                self.player?.diplomacyRequests?.sendDealRequest(for: otherLeader, deal: deal, state: .tradeAIMakesOffer, message: .peaceOffer, emotion: .positive, in: gameModel)
            } else if !human {

                // Offer to an AI player
                fatalError("not handled")
                /*CvDeal kDeal = *pDeal;

                // Don't need to call DoOffer because we check to see if the deal works for both sides BEFORE sending
                GC.getGame().GetGameDeals()->AddProposedDeal(kDeal);
                GC.getGame().GetGameDeals()->FinalizeDeal(GetPlayer()->GetID(), ePlayer, true);*/

                //LogPeaceMade(ePlayer);
            }
        }
    }

    // Possible Contact Statement
    func doCoopWarTimeStatement(with otherPlayer: AbstractPlayer?, statement: inout DiplomaticStatementType, data: inout LeaderType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if statement == .none {

            // Don't send this to AI players - coop war timer is automatically handled in DoCounters()
            if !otherPlayer.isHuman() {
                return
            }

            for loopPlayer in gameModel.players {

                // Agreed to go to war soon ... what's the counter at?
                if self.coopWarAcceptedState(of: otherPlayer, towards: loopPlayer) == .soon {

                    if self.coopWarCounter(of: otherPlayer, towards: loopPlayer) == 10 /* COOP_WAR_SOON_COUNTER */ {

                        if !diplomacyAI.isAtWar(with: loopPlayer) && loopPlayer.isAlive() {

                            // If we're already at war, don't bother
                            statement = .coopWarTime
                            data = loopPlayer.leader

                            // Don't evaluate other players
                            break
                        } else {
                            // Human is already at war - process what we would have if he'd agreed at this point
                            self.updateCoopWarAcceptedState(of: otherPlayer, towards: loopPlayer, to: .accepted)

                            // AI declaration
                            if !self.isAtWar(with: loopPlayer) && loopPlayer.isAlive() {

                                self.doDeclareWar(to: loopPlayer, in: gameModel)
                                self.player?.militaryAI?.requestBasicAttack(towards: loopPlayer, numUnitsWillingBuild: 1, in: gameModel)
                            }
                        }
                    }
                }
            }
        }
    }

    func doCoopWarStatement(with otherPlayer: AbstractPlayer?, statement: inout DiplomaticStatementType, data: inout LeaderType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get other player")
        }

        if statement == .none {
            // slewis - added so that a player already at war wouldn't try to start another war with another player. The AI should try to only have one war going at a time, if possible.
            if player.atWarCount() == 0 {

                if let targetPlayer = self.doTestCoopWarDesire(of: otherPlayer, in: gameModel) {

                    let tempStatement: DiplomaticStatementType = .coopWarTime
                    let turnsBetweenStatements = 10

                    if self.numTurnsSinceStatementSent(to: otherPlayer, statement: tempStatement) >= turnsBetweenStatements {

                        var sendStatement = true

                        //// 1 in 2 chance we don't actually send the message (don't want full predictability)
                        //if (50 < GC.getGame().getJonRandNum(100, "Diplomacy AI: rand roll to see if we ask to work with a player"))
                        //    bSendStatement = false;

                        if sendStatement {
                            statement = tempStatement
                            data = targetPlayer.leader
                        } else {
                            // Add this statement to the log so we don't evaluate it again until time has passed
                            //self.doAddNewStatementToLog(for: otherPlayer, statement: tempStatement)
                        }
                    }
                }
            }
        }
    }

    /// Do we want to declare war on anyone with ePlayer?
    func doTestCoopWarDesire(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> AbstractPlayer? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        let duration = 30 // based on game speed

        let approach = self.approach(towards: otherPlayer)

        if approach == .war {
            // If player is planning War, always say no
            return nil
        } else if approach == .hostile {
            // If player is Hostile, always say no
            return nil
        }

        let opinion = self.opinion(of: otherPlayer)

        // If player is unforgivable, always say no
        if opinion == .unforgivable {
            return nil
        }

        var bestPlayer: AbstractPlayer?
        var bestPlayerScore: Int = 0

        // Loop through all players to see if we can find a good target
        for targetPlayerLoop in gameModel.players {

            // Player must be valid
            if !targetPlayerLoop.isAlive() {
                continue
            }

            // Don't test player Target himself
            if targetPlayerLoop.leader == otherPlayer.leader {
                continue
            }

            // Have we already made the agreement?
            if self.coopWarAcceptedState(of: otherPlayer, towards: targetPlayerLoop) != .none {
                continue
            }

            // 30 turn buffer if we've been rejected before
            if self.coopWarCounter(of: otherPlayer, towards: targetPlayerLoop) >= 0 && self.coopWarCounter(of: otherPlayer, towards: targetPlayerLoop) < duration {

                continue
            }

            let tempScore = self.coopWarScore(of: otherPlayer, towards: targetPlayerLoop, askedByPlayer: false)

            if tempScore > bestPlayerScore {
                bestPlayerScore = tempScore
                bestPlayer = targetPlayerLoop
            }
        }

        // Found someone? might be nil
        return bestPlayer
    }

    /// Does this AI want to ask ePlayer to go to war with eTargetPlayer?
    func coopWarScore(of otherPlayer: AbstractPlayer?, towards targetPlayer: AbstractPlayer?, askedByPlayer: Bool) -> Int {

        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let otherPlayerDiplomacyAI = otherPlayer?.diplomacyAI else {
            fatalError("cant get otherPlayerDiplomacyAI")
        }

        guard let targetPlayer = targetPlayer else {
            fatalError("cant get targetPlayer")
        }

        let approachTowardsPlayer = self.approach(towards: otherPlayer)
        let opinionTowardsPlayer = self.opinion(of: otherPlayer)
        let approachTowardsTarget = self.approach(towards: targetPlayer)
        let opinionTowardsTarget = self.opinion(of: targetPlayer)

        // Both players must be able to declare war
        if !diplomacyAI.canDeclareWar(to: targetPlayer) {
            return 0
        }

        if !otherPlayerDiplomacyAI.canDeclareWar(to: targetPlayer) {
            return 0
        }

        // If player is inquiring, he has to be planning a war already
        if !askedByPlayer {
            if approachTowardsTarget != .war && approachTowardsTarget != .deceptive {
                return 0
            }
        }

        if approachTowardsPlayer == .war { // If player is planning War, always say no
            return 0
        } else if approachTowardsPlayer == .hostile { // If player is Hostile, always say no
            return 0
        }

        // If player is unforgivable, always say no
        if opinionTowardsPlayer == .unforgivable {
            return 0
        }

        // Only players we've met, are alive, etc.
        if !targetPlayer.isAlive() || !self.hasMet(with: targetPlayer) {
            return 0
        }

        // Don't work Target people we're working WITH!
        if self.isDeclarationOfFriendshipActive(by: targetPlayer) {
            return 0
        }

        var weight = 0

        // ePlayer asked us, so if we like him we're more likely to accept
        if askedByPlayer {

            if approachTowardsPlayer == .friendly || approachTowardsPlayer == .deceptive {
                weight += 2
            } else if opinionTowardsPlayer >= .favorable {
                weight += 2
            }
        }

        // Weight for Approach
        if approachTowardsTarget == .war {
            weight += 5
        }

        if approachTowardsTarget == .hostile {
            weight += 2
        }

        if self.isGoingForWorldConquest() {
            weight += 3
            if approachTowardsTarget == .deceptive {
                weight += 2
            }
        } else if self.isGoingForDiploVictory() {
            weight -= 2
        }

        // Weight for Opinion
        if opinionTowardsTarget == .unforgivable {
            weight += 12
        } else if opinionTowardsTarget == .enemy {
            weight += 8
        } else if opinionTowardsTarget == .competitor {
            weight += 4
        } else if opinionTowardsTarget == .favorable {
            weight += -1
        } else if opinionTowardsTarget == .friend {
            weight += -5
        } else if opinionTowardsTarget == .ally {
            weight += -10
        }

        // Are we getting money from trade with them
        /*let currentTradeValue = GetPlayer()->GetTrade()->GetAllTradeValueFromPlayerTimes100(YIELD_GOLD, ePlayer) / 100;
        if(iCurrentTradeValue > 0)
        {
            weight -= 2

            // sanity check - if we will go negative from war with this player, don't go to war
            int iGPT = GetPlayer()->calculateGoldRate();
            if (iGPT >= 0 && (iGPT-iCurrentTradeValue < 0))
            {
                iWeight -= 5;
            }
        }*/

        // Weight for expanding too fast
        if self.playerDict.isRecklessExpander(of: targetPlayer) {
            weight += 4
        }

        // Weight for warmonger threat
        /*switch(GetWarmongerThreat(eTargetPlayer))
        {
        case THREAT_MINOR:
            iWeight += 1;
            break;
        case THREAT_MAJOR:
            iWeight += 3;
            break;
        case THREAT_SEVERE:
            iWeight += 5;
            break;
        case THREAT_CRITICAL:
            iWeight += 7;
            break;
        }*/

        // If we're working with ePlayer then increase weight (if we're already willing to work Target this guy)
        if weight > 0 && self.isDeclarationOfFriendshipActive(by: otherPlayer) {
            weight += 5
        }

        // Weight mod for target value
        switch self.targetValue(of: targetPlayer) {

        case .impossible:
            weight *= 66
            weight /= 100
        case .bad:
            weight *= 75
            weight /= 100
        case .average:
            weight *= 100
            weight /= 100
        case .favorable:
            weight *= 110
            weight /= 100
        case .soft:
            weight *= 120
            weight /= 100
        case .none:
            // NOOP
            break
        }

        // Rand - Diplomacy AI: Rand for whether AI wants to enter a coop war.
        weight += Int.random(number: 5)

        // Weight must be high enough for us to return a true desire
        if weight >= 15 {
            return weight
        }

        return 0
    }

    /// Possibile Contact Statement - Embassy Exchange
    func doEmbassyExchange(with otherPlayer: AbstractPlayer?, statement: inout DiplomaticStatementType, deal: inout DiplomaticDeal, in gameModel: GameModel?) {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get player")
        }

        guard let otherPlayerDiplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get otherPlayerDiplomacyAI")
        }

        if statement == .none {

            // Can both sides open an embassy
            if deal.isPossibleToTradeItem(from: self.player, to: otherPlayer, item: .allowEmbassy, in: gameModel) &&
                deal.isPossibleToTradeItem(from: otherPlayer, to: self.player, item: .allowEmbassy, in: gameModel) {

                // Does this guy want to exchange embassies?
                if self.isEmbassyExchangeAcceptable(with: otherPlayer) {

                    let tempStatement: DiplomaticStatementType = .embassyExchange
                    let turnsBetweenStatements = 20

                    if self.numTurnsSinceStatementSent(to: otherPlayer, statement: .embassyExchange) >= turnsBetweenStatements &&
                        self.numTurnsSinceStatementSent(to: otherPlayer, statement: .embassyOffer) >= 10 {

                        var sendStatement = false

                        if !otherPlayer.isHuman() {
                            // AI
                            if otherPlayerDiplomacyAI.isEmbassyExchangeAcceptable(with: self.player) {
                                sendStatement = true
                            }
                        } else {
                            // Human
                            sendStatement = true
                        }

                        // 1 in 2 chance we don't actually send the message (don't want full predictability)
                        if 50 < Int.random(number: 100) {
                            sendStatement = false
                        }

                        if sendStatement {
                            deal.addAllowEmbassy(with: self.player)
                            deal.addAllowEmbassy(with: otherPlayer)

                            statement = tempStatement
                        } else {
                            // Add this statement to the log so we don't evaluate it again until 20 turns has come back around
                            self.sendStatement(to: otherPlayer, statement: tempStatement)
                        }
                    }
                }
            }
        }
    }

    /// Possible Contact Statement - Embassy
    func doEmbassyOffer(with otherPlayer: AbstractPlayer?, statement: inout DiplomaticStatementType, deal: inout DiplomaticDeal, in gameModel: GameModel?) {

        guard let diplomacyDealAI = self.player?.diplomacyDealAI else {
            fatalError("cant get diplomacyDealAI")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get player")
        }

        guard let otherPlayerDiplomacyAI = otherPlayer.diplomacyAI else {
            fatalError("cant get otherPlayerDiplomacyAI")
        }

        if statement == .none {

            if diplomacyDealAI.makeOfferForEmbassy(to: otherPlayer, deal: &deal, in: gameModel) {

                let tempStatement: DiplomaticStatementType = .embassyOffer
                let turnsBetweenStatements = 20

                if self.numTurnsSinceStatementSent(to: otherPlayer, statement: tempStatement) >= turnsBetweenStatements &&
                    self.numTurnsSinceStatementSent(to: otherPlayer, statement: .embassyExchange) >= 10 {
                    statement = tempStatement
                }
            } else {
                // Clear out the deal if we don't want to offer it so that it's not tainted for the next trade possibility we look at
                deal.clearItems()
            }
        }
    }

    /// Do we want to have an embassy in the player's capital?
    func wantsEmbassy(with otherPlayer: AbstractPlayer?) -> Bool {

        // May want to make this logic more sophisticated eventually.  This will do for now
        let approach = self.approachWithoutTrueFeelings(towards: otherPlayer)
        if approach == .hostile || approach == .war {
            return false
        }

        return true
    }

    /// Possible Contact Statement - Open Borders Exchange
    func doOpenBordersExchange(with otherPlayer: AbstractPlayer?, statement: inout DiplomaticStatementType, deal: inout DiplomaticDeal, in gameModel: GameModel?) {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get player")
        }

        if statement == .none {

            let duration = 30 // based on game speed

            // Can both sides trade OB?
            if deal.isPossibleToTradeItem(
                from: self.player,
                to: otherPlayer,
                item: .openBorders,
                value: duration,
                resource: .none,
                checkOtherPlayerValidity: false,
                finalizing: false,
                in: gameModel
            ) &&
                deal.isPossibleToTradeItem(
                    from: otherPlayer,
                    to: self.player,
                    item: .openBorders,
                    value: duration,
                    resource: .none,
                    checkOtherPlayerValidity: false,
                    finalizing: false,
                    in: gameModel) {

                // Does this guy want to exchange OB?
                if self.isOpenBordersExchangeAcceptable(with: otherPlayer) {

                    let tempStatement: DiplomaticStatementType = .openBorderExchange
                    let turnsBetweenStatements = 20

                    if self.numTurnsSinceStatementSent(to: otherPlayer, statement: tempStatement) >= turnsBetweenStatements {

                        var sendStatement = false

                        // AI
                        if !otherPlayer.isHuman() {
                            if otherPlayer.diplomacyAI?.isOpenBordersExchangeAcceptable(with: self.player) ?? false {
                                sendStatement = true
                            }
                        } else {
                            // Human
                            sendStatement = true
                        }

                        // 1 in 2 chance we don't actually send the message (don't want full predictability)
                        if 50 < Int.random(number: 100) {
                            sendStatement = false
                        }

                        if sendStatement {
                            // OB on each side
                            deal.addOpenBorders(with: self.player, duration: duration)
                            deal.addOpenBorders(with: otherPlayer, duration: duration)

                            statement = tempStatement
                        } else {
                            // Add this statement to the log so we don't evaluate it again until 20 turns has come back around
                            self.sendStatement(to: otherPlayer, statement: tempStatement)
                        }
                    }
                }
            }
        }
    }

    /// Are we willing to swap embassies with ePlayer?
    func isEmbassyExchangeAcceptable(with otherPlayer: AbstractPlayer?) -> Bool {

        let approach = self.approachWithoutTrueFeelings(towards: otherPlayer)

        switch approach {

        case .war, .hostile, .guarded:
            return false

        case .deceptive, .afraid, .friendly, .neutrally:
            return true

        case .none:
            return false
        }
    }

    // Possible Contact Statement - Open Borders
    func doOpenBordersOffer(with otherPlayer: AbstractPlayer?, statement: inout DiplomaticStatementType, deal: inout DiplomaticDeal, in gameModel: GameModel?) {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get player")
        }

        guard let diplomacyDealAI = self.player?.diplomacyDealAI else {
            fatalError("cant get diplomacyDealAI")
        }

        if statement == .none {

            if diplomacyDealAI.shouldMakeOfferForOpenBorders(to: otherPlayer, deal: &deal, in: gameModel) {

                let tempStatement: DiplomaticStatementType = .openBorderOffer
                let turnsBetweenStatements = 20

                if self.numTurnsSinceStatementSent(to: otherPlayer, statement: tempStatement) >= turnsBetweenStatements {
                    statement = tempStatement
                }
            } else {
                // Clear out the deal if we don't want to offer it so that it's not tainted for the next trade possibility we look at
                deal.clearItems()
            }
        }
    }

    func numTurnsSinceStatementSent(to otherPlayer: AbstractPlayer?, statement: DiplomaticStatementType) -> Int {

        print("not implemented")
        return 100
    }

    func sendStatement(to otherPlayer: AbstractPlayer?, statement: DiplomaticStatementType) {

        print("not implemented")
    }

    // MARK: open borders

    // Do we want Open Borders with eOtherPlayer? - this is only used for when to trigger an AI request, not whether or not the AI will accept a deal period
    func isWantsOpenBorders(with otherPlayer: AbstractPlayer?) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let grandStrategyAI = self.player?.grandStrategyAI else {
            fatalError("cant get grandStrategyAI")
        }

        // If going for culture win always want open borders against civs we need influence on
        if grandStrategyAI.activeStrategy == .culture /* && m_pPlayer->GetCulture()->GetTourism() > 0*/ {

            // The civ we need influence on the most should ALWAYS be included
            /*if (m_pPlayer->GetCulture()->GetCivLowestInfluence(false /*bCheckOpenBorders*/) == ePlayer) {
                return true;
            }*/

            // If have influence over half the civs, want OB with the other half
            /*if (m_pPlayer->GetCulture()->GetNumCivsToBeInfluentialOn() <= m_pPlayer->GetCulture()->GetNumCivsInfluentialOn())
            {
                if (m_pPlayer->GetCulture()->GetInfluenceLevel(ePlayer) < INFLUENCE_LEVEL_INFLUENTIAL)
                {
                    return true;
                }
            }*/
        }

        if player.proximity(to: otherPlayer) != .neighbors {
            return false
        }

        let approach = self.approachWithoutTrueFeelings(towards: otherPlayer)
        if approach == .hostile || approach == .guarded || approach == .afraid {
            return false
        }

        switch self.militaryStrength(of: otherPlayer) {
        case .immense, .powerful, .strong:
            return false
        default:
            return true
        }
    }

    // Are we willing to swap Open Borders with ePlayer?
    func isOpenBordersExchangeAcceptable(with otherPlayer: AbstractPlayer?) -> Bool {

        let approach = self.approach(towards: otherPlayer)

        if approach == .friendly {
            return true
        } else if approach == .afraid {
            return true
        }

        return false
    }

    public func hasEmbassy(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.hasEmbassy(with: otherPlayer)
    }

    func coopWarAcceptedState(of player: AbstractPlayer?, towards otherPlayer: AbstractPlayer?) -> CoopWarState {

        return self.playerDict.coopWarAcceptedState(of: player, towards: otherPlayer)
    }

    func coopWarCounter(of player: AbstractPlayer?, towards otherPlayer: AbstractPlayer?) -> Int {

        return self.playerDict.coopWarCounter(of: player, towards: otherPlayer)
    }

    func updateCoopWarAcceptedState(of player: AbstractPlayer?, towards otherPlayer: AbstractPlayer?, to state: CoopWarState) {

        self.playerDict.updateCoopWarAcceptedState(of: player, towards: otherPlayer, to: state)
    }

    func update(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        if let activePlayer = gameModel?.activePlayer() {

            if self.greetPlayers.contains(where: { activePlayer.isEqual(to: $0) }) {

                //let szText = DiplomaticRequestMessage.messageIntro.diploStringForMessage(for: self.player)
                player.diplomacyRequests?.sendRequest(for: activePlayer.leader, state: .intro, message: .messageIntro, emotion: .neutral, in: gameModel)

                self.greetPlayers.removeAll(where: { activePlayer.isEqual(to: $0) })
            }
        }
    }

    func doFirstContact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get current player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        if player.isBarbarian() || otherPlayer.isBarbarian() {
            return
        }

        self.playerDict.initContact(with: otherPlayer, in: gameModel.currentTurn)
        self.updateMilitaryStrength(of: otherPlayer, in: gameModel)

        // Humans don't say hi to ai player automatically
        if !player.isHuman() {

            // Should fire off a diplo message, when we meet a human
            if otherPlayer.isHuman() {

                // Put in the list of people to greet human, when the human turn comes up.
                //if !self.hasMet(with: otherPlayer) {
                    self.greetPlayers.append(otherPlayer)
                //}
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

                    /*let playerAName = metA ? player.leader.name() : "An Unmet Player"
                    let playerBName = metB ? otherPlayer.leader.name() : "An Unmet Player"

                    let text = "\(playerAName) and \(playerBName) have made a public Trade Alliance, forging a strong bond between the two empires."*/

                    self.player?.notifications()?.add(notification: .diplomaticDeclaration)
                }
            }
        }
    }

    func isDeclarationOfFriendshipActive(by otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isDeclarationOfFriendshipActive(by: otherPlayer)
    }

    // cancel
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

                    /*let playerAName = metA ? player.leader.name() : "An Unmet Player"
                    let playerBName = metB ? otherPlayer.leader.name() : "An Unmet Player"

                    let text = "\(playerAName) has denounced \(playerBName)."*/

                    self.player?.notifications()?.add(notification: .diplomaticDeclaration)
                    fatalError("not handled")
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

    func allPlayersWithDefensivePacts() -> [LeaderType] {

        return self.playerDict.allPlayersWithDefensivePacts()
    }

    func activateDefensivePacts(against otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        for friendLeader in self.allPlayersWithDefensivePacts() {

            guard let friendPlayer = gameModel?.player(for: friendLeader) else {
                fatalError("cant get player")
            }

            friendPlayer.diplomacyAI?.doDeclareWarFromDefensivePact(to: otherPlayer)
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

    //    --------------------------------------------------------------------------------
    func canDeclareWar(to otherPlayer: AbstractPlayer?) -> Bool {

        guard let player = self.player else {
            fatalError("catn get player")
        }

        if player.isEqual(to: otherPlayer) {
            return false
        }

        if !player.isAlive() {
            return false
        }

        if self.isAtWar(with: otherPlayer) {
            return false
        }

        if !self.hasMet(with: otherPlayer) {
            return false
        }

        /*if(isForcePeace(eTeam))
        {
            return false;
        }

        if(!canChangeWarPeace(eTeam))
        {
            return false;
        }

        if(GC.getGame().isOption(GAMEOPTION_ALWAYS_PEACE))
        {
            return false;
        }*/

        return true
    }

    func doDefensivePact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        self.playerDict.establishDefensivePact(with: otherPlayer, in: gameModel.currentTurn)
    }

    func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isDefensivePactActive(with: otherPlayer)
    }

    // MARK: open borders

    func isOpenBorderAgreementActive(by otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isOpenBorderAgreementActive(by: otherPlayer)
    }

    // MARK: alliances

    func isAllianceActive(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isAllianceActive(with: otherPlayer)
    }

    // MARK: war

    public func doDeclareWar(to otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

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
        otherPlayer.diplomacyAI?.doHaveBeenDeclaredWar(by: self.player, in: gameModel)

        // If we've made a peace treaty before, this is bad news
        if self.isPeaceTreatyActive(with: otherPlayer) {
            self.updateHasBrokenPeaceTreaty(to: true)
            // FIXME: => update counter of everyone who knows us
        }

        // Update what every Major Civ sees
        // FIXME: let everyone know, we have attacked

        self.playerDict.declaredWar(towards: otherPlayer, in: gameModel.currentTurn)

        // inform player that some declared war
        if otherPlayer.isHuman() {

            self.player?.notifications()?.add(notification: .war(leader: player.leader))
        }
    }

    func doHaveBeenDeclaredWar(by otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        // Auto War for Defensive Pacts of other player
        self.activateDefensivePacts(against: otherPlayer, in: gameModel)

        self.playerDict.updateApproach(towards: otherPlayer, to: .war)
        self.playerDict.updateWarState(towards: otherPlayer, to: .defensive)
    }

    func doCancelDeals(with otherPlayer: AbstractPlayer?) {

        self.playerDict.cancelDeals(with: otherPlayer)
        otherPlayer?.diplomacyAI?.playerDict.cancelDeals(with: self.player)
    }

    func isPeaceTreatyActive(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isPeaceTreatyActive(by: otherPlayer)
    }

    public func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool {

        if otherPlayer == nil {
            return false
        }

        return self.playerDict.isAtWar(with: otherPlayer)
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

    /// Updates how much damage have we taken in a war against all Players
    private func doUpdateWarDamageLevel(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let militaryAI = self.player?.militaryAI else {
            fatalError("cant get militaryAI")
        }

        /*int iValueLost;
        int iCurrentValue;
        int iValueLostRatio;

        CvCity* pLoopCity;
        CvUnit* pLoopUnit;
        int iValueLoop;*/

        // Calculate the value of what we have currently
        // This is invariant so we will just do it once
        var currentValue = 0

        let typicalPower = militaryAI.powerOfStrongestBuildableUnit(in: .land)

        // City value
        for loopCityRef in gameModel.cities(of: player) {

            guard let loopCity = loopCityRef else {
                continue
            }

            currentValue += loopCity.population() * 150 /* WAR_DAMAGE_LEVEL_INVOLVED_CITY_POP_MULTIPLIER() */
            if loopCity.isCapital() {
                currentValue *= 3
                currentValue /= 2
            }
        }

        // Unit value
        for loopUnitRef in gameModel.units(of: player) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            var unitValue = loopUnit.type.power()
            if typicalPower > 0 {
                unitValue = unitValue * 100 /* DEFAULT_WAR_VALUE_FOR_UNIT */ / typicalPower
            } else {
                unitValue = 100 /* DEFAULT_WAR_VALUE_FOR_UNIT */
            }

            currentValue += unitValue
        }

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            if !loopPlayer.isEqual(to: self.player) && player.hasMet(with: loopPlayer) && loopPlayer.isAlive() {

                var warDamageLevel: WarDamageLevelType = .none

                let valueLost = self.warValueLost(with: loopPlayer)

                if valueLost > 0 {

                    // Total original value is the current value plus the amount lost, so compute the percentage on that
                    var valueLostRatio: Int = 0
                    if currentValue > 0 {
                        valueLostRatio = valueLost * 100 / (currentValue + valueLost)
                    } else {
                        valueLostRatio = valueLost
                    }

                    if valueLostRatio >= 67 /* WAR_DAMAGE_LEVEL_THRESHOLD_CRIPPLED */ {
                        warDamageLevel = .crippled
                    } else if valueLostRatio >= 50 /* WAR_DAMAGE_LEVEL_THRESHOLD_SERIOUS */ {
                        warDamageLevel = .serious
                    } else if valueLostRatio >= 25 /* WAR_DAMAGE_LEVEL_THRESHOLD_MAJOR */ {
                        warDamageLevel = .major
                    } else if valueLostRatio >= 10 /*WAR_DAMAGE_LEVEL_THRESHOLD_MINOR */ {
                        warDamageLevel = .minor
                    }
                }

                self.updateWarDamageLevel(of: loopPlayer, to: warDamageLevel)
            }
        }
    }

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
        if (warState == .none || warState > .defensive) {
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
        guard let bestApproach = weights.chooseLargest() else {
            fatalError("cant get best approach")
        }

        if bestApproach == .war {

            let currentWarFace = self.playerDict.warFace(for: otherPlayer)

            // If we haven't set WarFace on a previous turn, figure out what it should be
            if currentWarFace == .none {

                // Use index of 1 since we already know element 0 is war; that will give us the most reasonable approach
                let secondBestApproach = weights.chooseSecondLargest()

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

    func isGoingForDiploVictory() -> Bool {

        guard let activeStrategy = self.player?.grandStrategyAI?.activeStrategy else {
            fatalError("cant get active strategy")
        }

        return activeStrategy == .council
    }

    func approach(towards player: AbstractPlayer?) -> PlayerApproachType {

        return self.playerDict.approach(towards: player)
    }

    func approach(towards leader: LeaderType) -> PlayerApproachType {

        return self.playerDict.approach(towards: player)
    }

    func approachWithoutTrueFeelings(towards otherlayer: AbstractPlayer?) -> PlayerApproachType {

        let trueApproach = self.approach(towards: otherlayer)
        var approachWithoutTrueFeelings = trueApproach

        // Deceptive => Friendly
        if trueApproach == .deceptive {
            approachWithoutTrueFeelings = .friendly
        } else if trueApproach == .war {

            let warFace = self.warFace(for: otherlayer)

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

    func warFace(for player: AbstractPlayer?) -> PlayerWarFaceType {

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
                            myLocalMilitaryStrength += city.power(in: gameModel) * percentHealthLeft / 100 / 100
                        }
                    }

                    // Loop through our Enemy's Cities
                    for cityRef in gameModel.cities(of: otherPlayer) {

                        if let city = cityRef {
                            let percentHealthLeft = (25 /*MAX_CITY_HIT_POINTS*/ - city.damage()) * 100 / 25 /*MAX_CITY_HIT_POINTS*/
                            enemyInHisLandsMilitaryStrength += city.power(in: gameModel) * percentHealthLeft / 100 / 100
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
                        } else if warStateValue >= 42 /*WAR_STATE_THRESHOLD_STALEMATE*/ {
                            warState = .stalemate
                        } else if warStateValue >= 25 /*WAR_STATE_THRESHOLD_DEFENSIVE*/ {
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

        for loopPlayer in gameModel.players {

            if !loopPlayer.isEqual(to: self.player) && player.hasMet(with: loopPlayer) && loopPlayer.isAlive() {

                self.updateTargetValue(of: loopPlayer, in: gameModel)
            }
        }
    }

    /// Updates what the Projection of war is with all Players
    private func doUpdateWarProjections(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            if !loopPlayer.isEqual(to: self.player) && player.hasMet(with: loopPlayer) && loopPlayer.isAlive() {

                var warProjection: WarProjectionType = .unknown

                let warScore = self.warScore(with: loopPlayer, in: gameModel)

                // Do the final math
                if warScore >= 100 /* WAR_PROJECTION_THRESHOLD_VERY_GOOD */ {
                    warProjection = .veryGood
                } else if warScore >= 25 /* WAR_PROJECTION_THRESHOLD_GOOD */ {
                    warProjection = .good
                } else if warScore <= -100 /* WAR_PROJECTION_THRESHOLD_DESTRUCTION */ {
                    warProjection = .destruction
                } else if warScore <= -25 /* WAR_PROJECTION_THRESHOLD_DEFEAT */ {
                    warProjection = .defeat
                } else if warScore <= 0 /* WAR_PROJECTION_THRESHOLD_STALEMATE */ {
                    warProjection = .stalemate
                } else {
                    warProjection = .unknown
                }

                // If they're a bad target then the best we can do is a stalemate
                if self.targetValue(of: loopPlayer) <= .bad {
                    if warProjection >= .good {
                        warProjection = .stalemate
                    }
                }

                let lastWarProjection = self.warProjection(against: loopPlayer)
                if lastWarProjection != .unknown {
                    self.updateLastWarProjection(of: loopPlayer, to: lastWarProjection)
                } else {
                    // for now, set it to be unknown because we can't set it to NO_WAR_PROJECTION_TYPE
                    self.updateLastWarProjection(of: loopPlayer, to: .unknown)
                }

                self.updateWarProjection(of: loopPlayer, to: warProjection)
            }
        }
    }

    /// Updates what the Goal of war is with all Players
    private func doUpdateWarGoals(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        // Are we going for World conquest?  If so, then we want to fight our wars to the death
        var worldConquest = false

        if self.isGoingForWorldConquest() {
            worldConquest = true
        }

        var warGoalValue = 0
        var warGoal: WarGoalType = .none

        //PlayerTypes eLoopOtherPlayer;
        //int iOtherPlayerLoop;
        //bool bHigherUpsWantWar;

        //bool bIsMinor;

        //WarProjectionTypes eProjection;

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            if !loopPlayer.isEqual(to: self.player) && player.hasMet(with: loopPlayer) && loopPlayer.isAlive() {

                warGoal = .none

                if self.isAtWar(with: loopPlayer) {

                    warGoalValue = 0

                    // Higher ups want war with this
                    let higherUpsWantWar = self.approach(towards: loopPlayer) == .war
                    let projection = self.warProjection(against: loopPlayer)

                    //////////////////////////////
                    // Higher ups want war, figure out what kind we're waging
                    if higherUpsWantWar {

                        // Default goal is Damage
                        warGoal = .damage

                        // If we're locked into a coop war, we're out for conquest
                        if self.isLockedIntoCoopWar(with: loopPlayer, in: gameModel) {
                            warGoal = .conquest
                        }

                        // If we think the war will go well, we can aim for conquest, which means we will not make peace
                        if projection >= .unknown {
                            // If they're unforgivable we're out to destroy them, no less
                            if self.opinion(of: loopPlayer) == .unforgivable {
                                warGoal = .conquest
                            } else if worldConquest {
                                // Out for world conquest?
                                warGoal = .conquest
                            }
                        }

                    }

                    //////////////////////////////
                    // Higher ups don't want to be at war, figure out how bad things are
                    else {
                        // If we're about to cause some mayhem then hold off on the peace stuff for a bit - not against Minors though
                        if self.warState(towards: loopPlayer) == .nearlyWon && self.stateOfAllWars != .losing {
                            warGoal = .damage
                        } else {
                            // War isn't decisively in our favor, so we'll make peace if possible
                            warGoal = .peace
                        }
                    }
                }
                // Getting ready to attack
                else if self.warGoal(towards: loopPlayer) == .prepare {
                    warGoal = .prepare
                }
                // Getting ready to make a forceful demand
                else if self.warGoal(towards: loopPlayer) == .demand {
                    warGoal = .demand
                }

                // Update the counter for how long we've wanted peace for (used to determine, when to ask for peace)
                if warGoal == .peace {
                    self.changeWantPeaceCounter(with: loopPlayer, by: 1)
                } else {
                    self.updateWantPeaceCounter(with: loopPlayer, to: 0)
                }

                // Set the War Goal
                self.updateWarGoal(towards: loopPlayer, to: warGoal)
            }
        }
    }

    /// Are we locked into a war with otherPlayer?
    private func isLockedIntoCoopWar(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        let coopWarState = self.globalCoopWarAcceptedState(against: otherPlayer, in: gameModel) //self.coopWarAcceptedState(of: self.player, towards: otherPlayer)

        if coopWarState == .accepted || coopWarState == .soon {
            if self.coopWarCounter(of: self.player, towards: otherPlayer) <= 20 /* COOP_WAR_LOCKED_TURNS */ {
                return true
            }
        }

        return false
    }

    /// Check everyone we know to see if we're planning a coop war against them
    private func globalCoopWarAcceptedState(against otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> CoopWarState {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var bestState: CoopWarState = .none

        for loopPlayer in gameModel.players {

            if !loopPlayer.isEqual(to: self.player) && loopPlayer.hasMet(with: otherPlayer) && loopPlayer.isAlive() {
                if self.coopWarAcceptedState(of: loopPlayer, towards: otherPlayer) > bestState {
                    bestState = self.coopWarAcceptedState(of: loopPlayer, towards: otherPlayer)
                }
            }
        }

        return bestState
    }

    /// What is the integer value of how well we think the war with ePlayer is going?
    private func warScore(with otherPlayer: AbstractPlayer?, in gameModel: GameModel) -> Int {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        var warScore = 0

        // Military Strength compared to us
        switch self.playerDict.militaryStrengthComparedToUs(of: otherPlayer) {
        case .pathetic:
            warScore += 100 /* WAR_PROJECTION_THEIR_MILITARY_STRENGTH_PATHETIC */
        case .weak:
            warScore += 60 /* WAR_PROJECTION_THEIR_MILITARY_STRENGTH_WEAK */
        case .poor:
            warScore += 25 /* WAR_PROJECTION_THEIR_MILITARY_STRENGTH_POOR */
        case .average:
            warScore += 0 /* WAR_PROJECTION_THEIR_MILITARY_STRENGTH_AVERAGE */
        case .strong:
            warScore += -25 /* WAR_PROJECTION_THEIR_MILITARY_STRENGTH_STRONG */
        case .powerful:
            warScore += -60 /* WAR_PROJECTION_THEIR_MILITARY_STRENGTH_POWERFUL */
        case .immense:
            warScore += -100 /* WAR_PROJECTION_THEIR_MILITARY_STRENGTH_IMMENSE */
        }

        // Economic Strength compared to us
        switch self.playerDict.economicStrengthComparedToUs(of: otherPlayer) {
        case .pathetic:
            warScore += 50 /* WAR_PROJECTION_THEIR_ECONOMIC_STRENGTH_PATHETIC */
        case .weak:
            warScore += 30 /* WAR_PROJECTION_THEIR_ECONOMIC_STRENGTH_WEAK */
        case .poor:
            warScore += 12 /* WAR_PROJECTION_THEIR_ECONOMIC_STRENGTH_POOR */
        case .average:
            warScore += 0 /* WAR_PROJECTION_THEIR_ECONOMIC_STRENGTH_AVERAGE */
        case .strong:
            warScore += -12 /* WAR_PROJECTION_THEIR_ECONOMIC_STRENGTH_STRONG */
        case .powerful:
            warScore += -30 /* WAR_PROJECTION_THEIR_ECONOMIC_STRENGTH_POWERFUL */
        case .immense:
            warScore += -50 /* WAR_PROJECTION_THEIR_ECONOMIC_STRENGTH_IMMENSE */
        }

        // War Damage inflicted on US
        switch self.warDamageLevel(of: otherPlayer) {
        case .none:
            warScore += 0 /* WAR_PROJECTION_WAR_DAMAGE_US_NONE */

            // If they're aggressively expanding, it makes them a better target to go after, If they've hurt us, this no longer applies
            if self.isRecklessExpander(otherPlayer, in: gameModel) {
                warScore += 25 /* WAR_PROJECTION_RECKLESS_EXPANDER */
            }

        case .minor:
            warScore += -10 /* WAR_PROJECTION_WAR_DAMAGE_US_MINOR */
        case .major:
            warScore += -20 /* WAR_PROJECTION_WAR_DAMAGE_US_MAJOR */
        case .serious:
            warScore += -30 /* WAR_PROJECTION_WAR_DAMAGE_US_SERIOUS */
        case .crippled:
            warScore += -40 /* WAR_PROJECTION_WAR_DAMAGE_US_CRIPPLED */
        }

        // War Damage inflicted on THEM (less than what's been inflicted on us for the same amount of damage)
        /*switch(GetOtherPlayerWarDamageLevel(ePlayer, GetPlayer()->GetID()))
        {
        case WAR_DAMAGE_LEVEL_NONE:
            iWarScore += /*0*/ GC.getWAR_PROJECTION_WAR_DAMAGE_THEM_NONE();
            break;
        case WAR_DAMAGE_LEVEL_MINOR:
            iWarScore += /*5*/ GC.getWAR_PROJECTION_WAR_DAMAGE_THEM_MINOR();
            break;
        case WAR_DAMAGE_LEVEL_MAJOR:
            iWarScore += /*10*/ GC.getWAR_PROJECTION_WAR_DAMAGE_THEM_MAJOR();
            break;
        case WAR_DAMAGE_LEVEL_SERIOUS:
            iWarScore += /*15*/ GC.getWAR_PROJECTION_WAR_DAMAGE_THEM_SERIOUS();
            break;
        case WAR_DAMAGE_LEVEL_CRIPPLED:
            iWarScore += /*20*/ GC.getWAR_PROJECTION_WAR_DAMAGE_THEM_CRIPPLED();
            break;
        }*/

        // the intangibles - our score vs their score
        var ourScore = player.score(for: gameModel)
        ourScore = ourScore > 100 ? ourScore : 100
        var theirScore = otherPlayer.score(for: gameModel)
        theirScore = theirScore > 100 ? theirScore : 100
        var ratio = ((ourScore-theirScore) * 100) / (ourScore > theirScore ? theirScore : ourScore)
        ratio = ratio >= -50 ? (ratio <= 50 ? ratio : 50) : -50
        warScore += ratio

        // Decrease war score if we've been fighting for a long time - after 60 turns the effect is -20 on the WarScore
        var turnsAtWar = self.playerDict.turnsAtWar(with: otherPlayer)
        turnsAtWar /= 3
        warScore -= min(turnsAtWar, 20 /* WAR_PROJECTION_WAR_DURATION_SCORE_CAP*/ )

        return warScore
    }

    /// Is ePlayer expanding recklessly?
    private func isRecklessExpander(_ otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        // If the player is too far away from us, we don't care
        if self.proximity(to: otherPlayer) == .far || self.proximity(to: otherPlayer) == .distant {
            return false
        }

        // If the player has too few cities, don't worry about it
        let numCities = gameModel.cities(of: otherPlayer).count
        if numCities < 4 {
            return false
        }

        var averageNumCities = 0.0
        var numPlayers = 0.0

        // Find out what the average is (minus the player we're looking at)
        for loopPlayer in gameModel.players {

            // Not alive
            if !loopPlayer.isAlive() {
                continue
            }

            // Not the guy we're looking at
            if loopPlayer.isEqual(to: otherPlayer) {
                continue
            }

            numPlayers += 1.0
            averageNumCities += Double(gameModel.cities(of: loopPlayer).count)
        }

        // Not sure how this would happen, but we'll be safe anyways since we'll be dividing by this value
        guard numPlayers > 0 else {
            return false
        }

        averageNumCities /= numPlayers

        // Must have way more cities than the average player in the game
        if numPlayers < averageNumCities * 1.5 {
            return false
        }

        // If this guy's military is as big as ours, then it probably means he's just stronger than us
        if self.playerDict.militaryStrengthComparedToUs(of: otherPlayer) >= .average {
            return false
        }

        return true
    }

    /// Updates what peace treaties we're willing to offer and accept
    private func doUpdatePeaceTreatyWillingness(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            guard let loopDiplomacyAI = loopPlayer.diplomacyAI else {
                fatalError("cant get loopDiplomacyAI")
            }

            if !player.isEqual(to: loopPlayer) && self.hasMet(with: loopPlayer) && loopPlayer.isAlive() {

                var treatyWillingToOffer: PeaceTreatyType = .none
                var treatyWillingToAccept: PeaceTreatyType = .none
                var willingToOfferScore: Int = 0
                var willingToAcceptScore: Int = 0

                if self.isAtWar(with: loopPlayer) {

                    // Have to be at war with the human for a certain amount of time before the AI will agree to peace
                    if loopPlayer.isHuman() {

                        if !self.isWillingToMakePeaceWith(human: loopPlayer) {

                            self.updateTreatyWillingToOffer(with: loopPlayer, to: .none)
                            self.updateTreatyWillingToAccept(with: loopPlayer, to: .none)

                            continue
                        }
                    }

                    // If we're out for conquest, then no peace!
                    if self.warGoal(towards: loopPlayer) != .conquest {

                        let warProjection: WarProjectionType = self.warProjection(against: loopPlayer)

                        // What we're willing to give up.  The higher the number the more we're willing to part with

                        // How is the war going?
                        switch warProjection {

                        case .destruction:
                            willingToOfferScore += 100 /* PEACE_WILLINGNESS_OFFER_PROJECTION_DESTRUCTION */
                        case .defeat:
                            willingToOfferScore += 60 /* PEACE_WILLINGNESS_OFFER_PROJECTION_DEFEAT */
                        case .stalemate:
                            willingToOfferScore += 20 /* PEACE_WILLINGNESS_OFFER_PROJECTION_STALEMATE */
                        case .unknown:
                            willingToOfferScore += 0 /* PEACE_WILLINGNESS_OFFER_PROJECTION_UNKNOWN */
                        case .good:
                            willingToOfferScore += -20 /* PEACE_WILLINGNESS_OFFER_PROJECTION_GOOD */
                        case .veryGood:
                            willingToOfferScore += -50 /* PEACE_WILLINGNESS_OFFER_PROJECTION_VERY_GOOD */
                        }

                        // How much damage have we taken?
                        switch self.warDamageLevel(of: loopPlayer) {

                        case .none:
                            willingToOfferScore += 0 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_NONE */
                        case .minor:
                            willingToOfferScore += 10 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_MINOR */
                        case .major:
                            willingToOfferScore += 20 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_MAJOR */
                        case .serious:
                            willingToOfferScore += 50 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_SERIOUS */
                        case .crippled:
                            willingToOfferScore += 80 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_CRIPPLED */
                        }

                        // How much damage have we dished out?
                        switch loopDiplomacyAI.warDamageLevel(of: self.player) {

                        case .none:
                            willingToOfferScore -= 0 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_NONE */
                        case .minor:
                            willingToOfferScore -= 10 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_MINOR */
                        case .major:
                            willingToOfferScore -= 20 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_MAJOR */
                        case .serious:
                            willingToOfferScore -= 50 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_SERIOUS */
                        case .crippled:
                            willingToOfferScore -= 80 /* PEACE_WILLINGNESS_OFFER_WAR_DAMAGE_CRIPPLED */
                        }

                        // Do the final assessment
                        if willingToOfferScore >= 180 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_UN_SURRENDER */ {
                            treatyWillingToOffer = .unconditionalSurrender
                        } else if willingToOfferScore >= 150 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_CAPITULATION */ {
                            treatyWillingToOffer = .capitulation
                        } else if willingToOfferScore >= 120 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_CESSION */ {
                            treatyWillingToOffer = .cession
                        } else if willingToOfferScore >= 95 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_SURRENDER */ {
                            treatyWillingToOffer = .surrender
                        } else if willingToOfferScore >= 70 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_SUBMISSION */ {
                            treatyWillingToOffer = .submission
                        } else if willingToOfferScore >= 55 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_BACKDOWN */ {
                            treatyWillingToOffer = .backDown
                        } else if willingToOfferScore >= 40 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_SETTLEMENT */ {
                            treatyWillingToOffer = .settlement
                        } else if willingToOfferScore >= 20 /* PEACE_WILLINGNESS_OFFER_THRESHOLD_ARMISTICE */ {
                            treatyWillingToOffer = .armistice
                        } else {
                            // War Score could be negative here, but we're already assuming this player wants peace.  But he's not willing to give up anything for it
                            treatyWillingToOffer = .whitePeace
                        }

                        // If they've broken a peace deal before then we're not going to give them anything
                        if loopDiplomacyAI.hasBrokenPeaceTreaty() {
                            if treatyWillingToOffer > .whitePeace {
                                treatyWillingToOffer = .whitePeace
                            }
                        }

                        // What we're willing to accept from eLoopPlayer.  The higher the number the more we want

                        // How is the war going?
                        switch warProjection {

                        case .destruction:
                            willingToAcceptScore += -50 /* PEACE_WILLINGNESS_ACCEPT_PROJECTION_DESTRUCTION */
                        case .defeat:
                            willingToAcceptScore += -20 /* PEACE_WILLINGNESS_ACCEPT_PROJECTION_DEFEAT */
                        case .stalemate:
                            willingToAcceptScore += -10 /* PEACE_WILLINGNESS_ACCEPT_PROJECTION_STALEMATE */
                        case .unknown:
                            willingToAcceptScore += 0 /* PEACE_WILLINGNESS_ACCEPT_PROJECTION_UNKNOWN */
                        case .good:
                            willingToAcceptScore += 50 /* PEACE_WILLINGNESS_ACCEPT_PROJECTION_GOOD */
                        case .veryGood:
                            willingToAcceptScore += 100 /* PEACE_WILLINGNESS_ACCEPT_PROJECTION_VERY_GOOD*/
                        }

                        // How easy would it be for us to squash them?
                        switch self.targetValue(of: loopPlayer) {
                        case .impossible:
                            willingToAcceptScore += -50 /* PEACE_WILLINGNESS_ACCEPT_TARGET_IMPOSSIBLE */
                        case .bad:
                            willingToAcceptScore += -20 /* PEACE_WILLINGNESS_ACCEPT_TARGET_BAD */
                        case .average:
                            willingToAcceptScore += 0 /* PEACE_WILLINGNESS_ACCEPT_TARGET_AVERAGE */
                        case .favorable:
                            willingToAcceptScore += 20 /* PEACE_WILLINGNESS_ACCEPT_TARGET_FAVORABLE */
                        case .soft:
                            willingToAcceptScore += 50 /* PEACE_WILLINGNESS_ACCEPT_TARGET_SOFT */
                        default:
                            break
                        }

                        // Do the final assessment
                        if willingToAcceptScore >= 150 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_UN_SURRENDER */ {
                            treatyWillingToAccept = .unconditionalSurrender
                        } else if willingToAcceptScore >= 115 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_CAPITULATION*/ {
                            treatyWillingToAccept = .capitulation
                        } else if willingToAcceptScore >= 80 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_CESSION */ {
                            treatyWillingToAccept = .cession
                        } else if willingToAcceptScore >= 65 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_SURRENDER */ {
                            treatyWillingToAccept = .surrender
                        } else if willingToAcceptScore >= 50 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_SUBMISSION */ {
                            treatyWillingToAccept = .submission
                        } else if willingToAcceptScore >= 35 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_BACKDOWN */ {
                            treatyWillingToAccept = .backDown
                        } else if willingToAcceptScore >= 20 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_SETTLEMENT */ {
                            treatyWillingToAccept = .settlement
                        } else if willingToAcceptScore >= 10 /* PEACE_WILLINGNESS_ACCEPT_THRESHOLD_ARMISTICE */ {
                            treatyWillingToAccept = .armistice
                        } else {
                            treatyWillingToAccept = .whitePeace
                        }

                        // If we're losing all wars then let's go ahead and accept a white peace
                        if self.stateOfAllWars == .losing {
                            treatyWillingToAccept = .whitePeace
                        }
                    }
                }

                self.updateTreatyWillingToOffer(with: loopPlayer, to: treatyWillingToOffer)
                self.updateTreatyWillingToAccept(with: loopPlayer, to: treatyWillingToAccept)
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

                var cityStrengthMod = otherCity.power(in: gameModel)
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
        if targetValue > .impossible && self.playerDict.turnsOfWar(with: otherPlayer, in: gameModel.currentTurn) > 50 /*TARGET_INCREASE_WAR_TURNS */ {
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

    // MARK: turns of meeting

    func turnsSinceMeeting(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        return gameModel.currentTurn - self.playerDict.turnOfLastMeeting(with: otherPlayer)
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

    public func hasMet(with other: AbstractPlayer?) -> Bool {

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
                var cityStrengthModifier = Int(Double(city.power(in: gameModel)) * damageFactor)
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

    public func militaryStrength(of other: AbstractPlayer?) -> StrengthType {

        return self.playerDict.militaryStrengthComparedToUs(of: other)
    }

    func warGoal(towards otherPlayer: AbstractPlayer?) -> WarGoalType {

        return self.playerDict.warGoal(towards: otherPlayer)
    }

    func updateWarGoal(towards otherPlayer: AbstractPlayer?, to warGoal: WarGoalType) {

        self.playerDict.updateWarGoal(towards: otherPlayer, to: warGoal)
    }

    /// Returns an integer that increases as the number and severity of land disputes rises
    func totalLandDisputeLevel(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var rtnValue = 0 // slewis added, to fix a compile error. I'm guessing zero is correct.

        for otherPlayer in gameModel.players {

            if otherPlayer.isAlive() && !otherPlayer.isEqual(to: self.player) && self.hasMet(with: otherPlayer) {

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

        var landDisputeWeight = 0
        var expansionFlavor = 0

        // Loop through all (known) Players
        for loopPlayer in gameModel.players {

            if loopPlayer.isAlive() && !player.isEqual(to: loopPlayer) && player.hasMet(with: loopPlayer) {

                // Update last turn's values
                let lastTurnLandDisputeLevel = self.landDisputeLevel(with: loopPlayer)
                self.playerDict.updateLastTurnLandDisputeLevel(with: loopPlayer, to: lastTurnLandDisputeLevel)

                landDisputeWeight = 0

                // Expansion aggression
                var aggression = self.expansionAggressivePosture(towards: loopPlayer)

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
                aggression = self.plotBuyingAggressivePosture(towards: loopPlayer)

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
                let proximity = self.proximity(to: loopPlayer)

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
                var disputeLevel: LandDisputeLevelType = .none
                if landDisputeWeight >= 400 { /*LAND_DISPUTE_FIERCE_THRESHOLD */
                    disputeLevel = .fierce
                } else if landDisputeWeight >= 230 { /* LAND_DISPUTE_STRONG_THRESHOLD */
                    disputeLevel = .strong
                } else if landDisputeWeight >= 100 { /* LAND_DISPUTE_WEAK_THRESHOLD */
                    disputeLevel = .weak
                }

                // Actually set the Level
                self.playerDict.updateLandDisputeLevel(with: loopPlayer, to: disputeLevel)
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

    // MARK: willingness of peace treaty

    func treatyWillingToOffer(with otherPlayer: AbstractPlayer?) -> PeaceTreatyType {

        return self.playerDict.peaceTreatyWillingToOffer(to: otherPlayer)
    }

    func updateTreatyWillingToOffer(with otherPlayer: AbstractPlayer?, to treatyWillingToOffer: PeaceTreatyType) {

        return self.playerDict.updateTreatyWillingToOffer(with: otherPlayer, to: treatyWillingToOffer)
    }

    func treatyWillingToAccept(with otherPlayer: AbstractPlayer?) -> PeaceTreatyType {

        return self.playerDict.peaceTreatyWillingToAccept(by: otherPlayer)
    }

    func updateTreatyWillingToAccept(with otherPlayer: AbstractPlayer?, to treatyWillingToAccept: PeaceTreatyType) {

        return self.playerDict.updateTreatyWillingToAccept(with: otherPlayer, to: treatyWillingToAccept)
    }

    /// Need some special rules for humans so that the AI isn't exploited
    func isWillingToMakePeaceWith(human humanPlayer: AbstractPlayer?) -> Bool {

        guard let humanPlayer = humanPlayer else {
            fatalError("cant get humanPlayer")
        }

        guard let humanDiplomacyAI = humanPlayer.diplomacyAI else {
            fatalError("cant get humanDiplomacyAI")
        }

        guard let playerDiplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get playerDiplomacyAI")
        }

        if humanPlayer.isHuman() {
            let willMakePeace = self.playerDict.turnsAtWar(with: humanPlayer) >= 5

            /*if !self.canChangeWarPeace(with: humanPlayer) {
                return false
            }*/

            // If either of us are locked in, then we're not willing to make peace (this prevents weird greetings and stuff) - we use > 1 because it'll get decremented after it appears the human make peace again
            if playerDiplomacyAI.numTurnsLockedIntoWar(with: humanPlayer) > 1 {
                return false
            }

            if humanDiplomacyAI.numTurnsLockedIntoWar(with: self.player) > 1 {
                return false
            }

            return willMakePeace
        }

        return true
    }

    // MARK: has broekn peace treaty?

    func hasBrokenPeaceTreaty() -> Bool {

        return self.hasBrokenPeaceTreatyValue
    }

    func updateHasBrokenPeaceTreaty(to value: Bool) {

        self.hasBrokenPeaceTreatyValue = value
    }

    // MARK: war projection / war damage level

    func warProjection(against otherPlayer: AbstractPlayer?) -> WarProjectionType {

        self.playerDict.warProjection(against: otherPlayer)
    }

    func updateWarProjection(of otherPlayer: AbstractPlayer?, to value: WarProjectionType) {

        self.playerDict.updateWarProjection(of: otherPlayer, to: value)
    }

    func updateLastWarProjection(of otherPlayer: AbstractPlayer?, to value: WarProjectionType) {

        self.playerDict.updateLastWarProjection(of: otherPlayer, to: value)
    }

    func warDamageLevel(of otherPlayer: AbstractPlayer?) -> WarDamageLevelType {

        self.playerDict.warDamageLevel(of: otherPlayer)
    }

    func updateWarDamageLevel(of otherPlayer: AbstractPlayer?, to value: WarDamageLevelType) {

        self.playerDict.updateWarDamageLevel(of: otherPlayer, to: value)
    }

    // MARK: - --

    func numTurnsLockedIntoWar(with otherPlayer: AbstractPlayer?) -> Int {

        return self.playerDict.numTurnsLockedIntoWar(with: otherPlayer)
    }

    func changeNumTurnsLockedIntoWar(with otherPlayer: AbstractPlayer?, by delta: Int) {

        let value = self.playerDict.numTurnsLockedIntoWar(with: otherPlayer)
        self.playerDict.updateNumTurnsLockedIntoWar(with: otherPlayer, to: value + delta)
    }

    func updateNumTurnsLockedIntoWar(with otherPlayer: AbstractPlayer?, to value: Int) {

        self.playerDict.updateNumTurnsLockedIntoWar(with: otherPlayer, to: value)
    }

    // MARK: - --

    func warValueLost(with otherPlayer: AbstractPlayer?) -> Int {

        return self.playerDict.warValueLost(with: otherPlayer)
    }

    func changeWarValueLost(with otherPlayer: AbstractPlayer?, by delta: Int) {

        let value = self.playerDict.warValueLost(with: otherPlayer)
        self.playerDict.updateWarValueLost(with: otherPlayer, to: value + delta)
    }

    func updateWarValueLost(with otherPlayer: AbstractPlayer?, to value: Int) {

        self.playerDict.updateWarValueLost(with: otherPlayer, to: value)
    }

    // MARK: - --

    func otherPlayerWarValueLost(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?) -> Int {

        return self.playerDict.otherPlayerWarValueLost(with: fromPlayer, towards: toPlayer)
    }

    func changeOtherPlayerWarValueLost(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, by delta: Int) {

        let value = self.playerDict.otherPlayerWarValueLost(with: fromPlayer, towards: toPlayer)
        self.playerDict.updateOtherPlayerWarValueLost(with: fromPlayer, towards: toPlayer, to: value + delta)
    }

    func updateOtherPlayerWarValueLost(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, to value: Int) {

        self.playerDict.updateOtherPlayerWarValueLost(with: fromPlayer, towards: toPlayer, to: value)
    }

    // MARK: want peace counter

    func wantPeaceCounter(with otherPlayer: AbstractPlayer?) -> Int {

        return self.playerDict.wantPeaceCounter(with: otherPlayer)
    }

    func changeWantPeaceCounter(with otherPlayer: AbstractPlayer?, by delta: Int) {

        let value = self.playerDict.wantPeaceCounter(with: otherPlayer)
        self.playerDict.updateWantPeaceCounter(with: otherPlayer, to: value + delta)
    }

    func updateWantPeaceCounter(with otherPlayer: AbstractPlayer?, to value: Int) {

        self.playerDict.updateWantPeaceCounter(with: otherPlayer, to: value)
    }

    // ---------

    /// Are we building up for an attack on ePlayer?
    func isMusteringForAttack(against otherPlayer: AbstractPlayer?) -> Bool {

        return self.playerDict.isMusteringForAttack(against: otherPlayer)
    }

    /// Sets whether or not we're building up for an attack on ePlayer
    func updateMusteringForAttack(against otherPlayer: AbstractPlayer?, to value: Bool) {

        self.playerDict.updateMusteringForAttack(against: otherPlayer, to: value)
    }
}
