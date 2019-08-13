//
//  GameObjectAIState.swift
//  Colony
//
//  Created by Michael Rommel on 13.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum GameObjectState: String, Codable {
    
    case idle
    case wanderAround
    case following
    case battling
    case fleeing
}

enum GameObjectStateTransition: String, Codable {
    
    case began
    case running
    case ended
}

class GameObjectAIState: Decodable {
    
    var state: GameObjectState = .idle
    var targetIdentifier: String? = nil
    var path: HexPath? = nil
    var transitioning: GameObjectStateTransition = .began
    
    enum CodingKeys: String, CodingKey {
        case state
        case target
        case path
        case transitioning
    }
    
    init(state: GameObjectState, targetIdentifier: String?, path: HexPath?, transitioning: GameObjectStateTransition) {
        
        self.state = state
        self.targetIdentifier = targetIdentifier
        self.path = path
        self.transitioning = transitioning
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.state = try values.decode(GameObjectState.self, forKey: .state)
        self.targetIdentifier = try values.decodeIfPresent(String.self, forKey: .target)
        self.path = try values.decodeIfPresent(HexPath.self, forKey: .path)
        self.transitioning = try values.decode(GameObjectStateTransition.self, forKey: .transitioning)
    }
    
    static func idleState() -> GameObjectAIState {
        return GameObjectAIState(state: .idle, targetIdentifier: nil, path: nil, transitioning: .began)
    }
    
    static func wanderAroundState(on path: HexPath) -> GameObjectAIState {
        return GameObjectAIState(state: .wanderAround, targetIdentifier: nil, path: path, transitioning: .began)
    }
    
    static func followingState(targetIdentifier: String?) -> GameObjectAIState {
        return GameObjectAIState(state: .following, targetIdentifier: targetIdentifier, path: nil, transitioning: .began)
    }
    
    static func battlingState(with targetIdentifier: String?) -> GameObjectAIState {
        return GameObjectAIState(state: .battling, targetIdentifier: targetIdentifier, path: nil, transitioning: .began)
    }
    
    static func fleeingState(enemy targetIdentifier: String?) -> GameObjectAIState {
        return GameObjectAIState(state: .fleeing, targetIdentifier: targetIdentifier, path: nil, transitioning: .began)
    }
}

extension GameObjectAIState: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.state, forKey: .state)
        try container.encodeIfPresent(self.targetIdentifier, forKey: .target)
        try container.encodeIfPresent(self.path, forKey: .path)
        try container.encode(self.transitioning, forKey: .transitioning)
    }
}
