//
//  Mission.swift
//  Colony
//
//  Created by Michael Rommel on 14.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum MissionResult {
    
    case failed
    case success
    case abort
}

// abstract
class Mission {
    
    weak var unit: Unit? = nil
    
    init(unit: Unit?) {
        
        self.unit = unit
    }
    
    func follow(in game: Game?) {
        fatalError("sub class must implement this method")
    }
}
