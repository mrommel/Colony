//
//  DiplomacyRequests.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum DiplomacyRequestState: Int, Codable {
    
    case intro
    case blankDiscussion
    case warDeclaredByHuman // DIPLO_UI_STATE_WAR_DECLARED_BY_HUMAN
    case trade // DIPLO_UI_STATE_TRADE
    case discussHumanInvoked // DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED
}

enum LeaderEmotionType: Int, Codable {
    
    case neutral
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
    let state: DiplomacyRequestState
    let message: String
    let emotion: LeaderEmotionType
    
    //let index: Int
    let turn: Int
    
    init(for otherLeader: LeaderType, state: DiplomacyRequestState, message: String, emotion: LeaderEmotionType, turn: Int) {
        
        self.otherLeader = otherLeader
        self.state = state
        self.message = message
        self.emotion = emotion
        self.turn = turn
    }
    
    required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.otherLeader = try container.decode(LeaderType.self, forKey: .otherLeader)
        self.state = try container.decode(DiplomacyRequestState.self, forKey: .state)
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
    
    func addRequest(for otherLeader: LeaderType, state: DiplomacyRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        self.requests.append(DiplomacyRequest(for: otherLeader, state: state, message: message, emotion: emotion, turn: gameModel.turnsElapsed))
    }
    
    func sendRequest(for otherLeader: LeaderType, state: DiplomacyRequestState, message: String, emotion: LeaderEmotionType, in gameModel: GameModel?) {
        
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
