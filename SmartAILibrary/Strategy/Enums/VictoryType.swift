//
//  VictoryType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum VictoryType {
    
    case domination
    case cultural
    case science
    case diplomatic
    
    static var all: [VictoryType] {
        return [.domination, .cultural, .science, .diplomatic]
    }
}
