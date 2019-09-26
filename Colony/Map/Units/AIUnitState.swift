//
//  GameObjectAIState.swift
//  Colony
//
//  Created by Michael Rommel on 13.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum AIState: String, Codable {
    
    case idle
    case wanderAround
    case following
    case battling
    case ambushed
    case fleeing
    case traveling
}

enum AIStateTransition: String, Codable {
    
    case began
    case running
    case ended
}

class AIUnitState: Decodable {
    
    var state: AIState = .idle
    var target: HexPoint? = nil // position of unit or city!
    var path: HexPath? = nil
    var transitioning: AIStateTransition = .began
    
    enum CodingKeys: String, CodingKey {
        case state
        case target
        case path
        case transitioning
    }
    
    init(state: AIState, target: HexPoint?, path: HexPath?, transitioning: AIStateTransition) {
        
        self.state = state
        self.target = target
        self.path = path
        self.transitioning = transitioning
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.state = try values.decode(AIState.self, forKey: .state)
        self.target = try values.decodeIfPresent(HexPoint.self, forKey: .target)
        self.path = try values.decodeIfPresent(HexPath.self, forKey: .path)
        self.transitioning = try values.decode(AIStateTransition.self, forKey: .transitioning)
    }
    
    static func idleState() -> AIUnitState {
        return AIUnitState(state: .idle, target: nil, path: nil, transitioning: .began)
    }
    
    static func wanderAroundState(on path: HexPath) -> AIUnitState {
        return AIUnitState(state: .wanderAround, target: nil, path: path, transitioning: .began)
    }
    
    static func followingState(target: HexPoint?) -> AIUnitState {
        return AIUnitState(state: .following, target: target, path: nil, transitioning: .began)
    }
    
    static func battlingState(with target: HexPoint?) -> AIUnitState {
        return AIUnitState(state: .battling, target: target, path: nil, transitioning: .began)
    }
    
    static func ambushedState(by attacker: HexPoint?) -> AIUnitState {
        return AIUnitState(state: .ambushed, target: attacker, path: nil, transitioning: .began)
    }
    
    static func fleeingState(from target: HexPoint?) -> AIUnitState {
        return AIUnitState(state: .fleeing, target: target, path: nil, transitioning: .began)
    }
    
    static func travelingState(to target: HexPoint?) -> AIUnitState {
        return AIUnitState(state: .traveling, target: target, path: nil, transitioning: .began)
    }
}

extension AIUnitState: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.state, forKey: .state)
        try container.encodeIfPresent(self.target, forKey: .target)
        try container.encodeIfPresent(self.path, forKey: .path)
        try container.encode(self.transitioning, forKey: .transitioning)
    }
}
