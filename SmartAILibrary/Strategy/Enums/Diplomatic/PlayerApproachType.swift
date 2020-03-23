//
//  PlayerApproachType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PlayerApproachType {

    case none
    
    case war
    case hostile
    case guarded
    case deceptive
    case afraid
    case friendly
    case neutrally
    
    static var all: [PlayerApproachType] {
        return [
            .war, .hostile, .guarded, .deceptive, .afraid, .friendly, .neutrally
        ]
    }
}