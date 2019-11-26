//
//  AttackEvent.swift
//  Colony
//
//  Created by Michael Rommel on 07.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

struct AttackEvent {

    let unit: Unit?
    let turn: Int // attack happend in turn
}

extension AttackEvent: Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.unit)
        hasher.combine(self.turn)
    }
}
