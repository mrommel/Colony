//
//  Religion.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractReligion: AnyObject, Codable {
    
    var player: AbstractPlayer? { get set }
    
    func add(faith faithDelta: Double)
    func value() -> Double
    
    func checkFaithProgress(in gameModel: GameModel?)
    
    func pantheon() -> PantheonType
}
 
class Religion: AbstractReligion {

    enum CodingKeys: CodingKey {

        case faith
        case pantheon
        case religionFounded
        case belief0
        case belief1
        case belief2
        case belief3
    }
    
    // user properties / values
    var player: AbstractPlayer?
    var faith: Double
    var pantheonVal: PantheonType
    var beliefVal0: BeliefType
    var beliefVal1: BeliefType
    var beliefVal2: BeliefType
    var beliefVal3: BeliefType
    
    // MARK: constructor
    
    init(player: Player?) {
        
        self.player = player
        self.faith = 0.0
        self.pantheonVal = .none
        self.beliefVal0 = .none
        self.beliefVal1 = .none
        self.beliefVal2 = .none
        self.beliefVal3 = .none
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.faith = try container.decode(Double.self, forKey: .faith)
        self.pantheonVal = try container.decode(PantheonType.self, forKey: .pantheon)
        self.beliefVal0 = try container.decode(BeliefType.self, forKey: .belief0)
        self.beliefVal1 = try container.decode(BeliefType.self, forKey: .belief1)
        self.beliefVal2 = try container.decode(BeliefType.self, forKey: .belief2)
        self.beliefVal3 = try container.decode(BeliefType.self, forKey: .belief3)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.faith, forKey: .faith)
        try container.encode(self.pantheonVal, forKey: .pantheon)
        try container.encode(self.beliefVal0, forKey: .belief0)
        try container.encode(self.beliefVal1, forKey: .belief1)
        try container.encode(self.beliefVal2, forKey: .belief2)
        try container.encode(self.beliefVal3, forKey: .belief3)
    }
    
    func add(faith faithDelta: Double) {
        
        self.faith += faithDelta
    }
    
    public func value() -> Double {
        
        return self.faith
    }
    
    func checkFaithProgress(in gameModel: GameModel?) {
        
        if self.faith >= 25.0 && self.pantheonVal == .none {
            
            // todo: select pantheon
            
            self.faith = 0.0
        }
    }
    
    func pantheon() -> PantheonType {
        
        return self.pantheonVal
    }
}
