//
//  Armies.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class Armies: Codable {
    
    enum CodingKeys: CodingKey {

        case armies
    }
    
    private var armies: [Army]
    
    // MARK: constructors
    
    init() {
        
        self.armies = []
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.armies = try container.decode([Army].self, forKey: .armies)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.armies, forKey: .armies)
    }
    
    func turn(in gameModel: GameModel?) {
        
        for army in self.armies {
            army.turn(in: gameModel)
        }
    }
    
    func remove(army armyRef: Army?) {
        
        self.armies.removeAll(where: { $0 == armyRef })
    }
    
    func doDelayedDeath() {
        
        for army in self.armies {
            army.doDelayedDeath()
        }
    }
}
