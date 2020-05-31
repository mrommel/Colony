//
//  Religion.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractReligion: class, Codable {
    
    var player: AbstractPlayer? { get set }
    
    func add(faith faithDelta: Double)
}
 
class Religion: AbstractReligion {
    
    enum CodingKeys: CodingKey {

        case faith
    }
    
    // user properties / values
    var player: AbstractPlayer?
    var faith: Double
    
    // MARK: constructor
    
    init(player: Player?) {
        
        self.player = player
        self.faith = 0.0
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.faith = try container.decode(Double.self, forKey: .faith)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.faith, forKey: .faith)
    }
    
    func add(faith faithDelta: Double) {
        
        self.faith += faithDelta
    }
}
