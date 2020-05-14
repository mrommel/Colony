//
//  DiplomacyRequests.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum DiplomacyRequestState {
    
    case intro
    case blankDiscussion
    case warDeclaredByHuman // DIPLO_UI_STATE_WAR_DECLARED_BY_HUMAN
    case trade // DIPLO_UI_STATE_TRADE
    case discussHumanInvoked // DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED
}

enum LeaderEmotionType {
    
    case neutral
}

class DiplomacyRequest {
    
    let otherPlayer: AbstractPlayer?
    let state: DiplomacyRequestState
    let message: String
    let emotion: LeaderEmotionType
    
    //let index: Int
    let turn: Int
    
    init(for otherPlayer: AbstractPlayer?, state: DiplomacyRequestState, message: String, emotion: LeaderEmotionType, turn: Int) {
        
        self.otherPlayer = otherPlayer
        self.state = state
        self.message = message
        self.emotion = emotion
        self.turn = turn
    }
}

public class DiplomacyRequests {
    
    var player: AbstractPlayer?
    var requests: [DiplomacyRequest]
    
    // MARK: constructors

    init(player: AbstractPlayer?) {

        self.player = player
        
        self.requests = []
    }
    
    func addRequest(for otherPlayer: AbstractPlayer?, state: DiplomacyRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        self.requests.append(DiplomacyRequest(for: otherPlayer, state: state, message: message, emotion: emotion, turn: gameModel.turnsElapsed))
    }
    
    func sendRequest(for otherPlayer: AbstractPlayer?, state: DiplomacyRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?) {
        
        //gameModel?.in
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
}
