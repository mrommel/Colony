//
//  City.swift
//  Colony
//
//  Created by Michael Rommel on 14.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class City: Codable {
    
    let name: String
    let position: HexPoint
    let player: Player
    let population: Float = 1.0
    
    init(named name: String, at position: HexPoint, player: Player) {
        
        self.name = name
        self.position = position
        self.player = player
    }
}
