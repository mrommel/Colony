//
//  GameObjectMoveType.swift
//  Colony
//
//  Created by Michael Rommel on 13.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum GameObjectMoveType {
    
    static let impassible: Float = -1.0
    
    /// possible values
    case immobile // such as cities, coins etc
    //case swimShore
    case swimOcean
    case walk
    //case ride
    //case fly
}
