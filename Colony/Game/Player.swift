//
//  Player.swift
//  Colony
//
//  Created by Michael Rommel on 23.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Player: Codable {
    
    let name: String
    let civilization: Civilization
    var zoneOfControl: HexArea? = nil
    let isUser: Bool
    
    init(name: String, civilization: Civilization, isUser: Bool) {
        self.name = name
        self.civilization = civilization
        self.isUser = isUser
    }
    
    func addZoneOfControl(at point: HexPoint) {
        
        if self.zoneOfControl == nil {
            self.zoneOfControl = HexArea(points: [point])
        } else {
            self.zoneOfControl?.add(point: point)
        }
    }
}

extension Player: Equatable {
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        
        return lhs.name == rhs.name
    }
}

extension Player: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
