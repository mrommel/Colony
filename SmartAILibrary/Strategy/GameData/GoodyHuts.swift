//
//  GoodyHuts.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 08.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GoodyHuts: Codable {
    
    enum CodingKeys: CodingKey {

        case recentGoody
    }
    
    var player: AbstractPlayer?
    var recentGoody: [GoodyType] = []
    
    init(player: AbstractPlayer?) {
        
        self.player = player
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.player = nil
        self.recentGoody = try container.decode([GoodyType].self, forKey: .recentGoody)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.recentGoody, forKey: .recentGoody)
    }
    
    /// Are we allowed to get this Goody right now?
    /// Have we gotten this type of Goody lately? (in the last 3 Goodies, defined by NUM_GOODIES_REMEMBERED)
    func canReceive(goody: GoodyType) -> Bool {
        
        if self.recentGoody.contains(goody) {
            return false
        }
        
        return true
    }
}
